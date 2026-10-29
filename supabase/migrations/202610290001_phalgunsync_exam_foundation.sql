-- PHALGUN / GFPA learner sync and exam-attempt foundation
-- Apply only to a dedicated Supabase STAGING project after review.
-- This migration intentionally stores learner data and exam attempt metadata only.
-- Do NOT put answer keys/unreleased exam items in client-readable tables.
-- Exam delivery/grading should be implemented in trusted Edge Functions.

create extension if not exists pgcrypto;

create table if not exists public.learner_profiles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  display_name text,
  preferred_locale text not null default 'en',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.learner_records (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  record_type text not null check (record_type in (
    'lesson_progress','note','bookmark','flashcard_state','lesson_answer',
    'capstone_draft','study_plan','preference','imported_legacy_state'
  )),
  content_key text not null,
  content_version text,
  payload jsonb not null default '{}'::jsonb,
  client_updated_at timestamptz,
  server_version bigint not null default 1,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  unique (user_id, record_type, content_key)
);

create index if not exists learner_records_user_updated_idx
  on public.learner_records(user_id, updated_at desc);
create index if not exists learner_records_user_type_idx
  on public.learner_records(user_id, record_type);

create table if not exists public.capstone_versions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  project_key text not null,
  version_number integer not null check (version_number > 0),
  title text not null,
  body jsonb not null default '{}'::jsonb,
  attachment_paths text[] not null default '{}',
  change_summary text,
  created_at timestamptz not null default now(),
  unique (user_id, project_key, version_number)
);
create index if not exists capstone_versions_user_project_idx
  on public.capstone_versions(user_id, project_key, version_number desc);

create table if not exists public.exam_blueprints (
  id uuid primary key default gen_random_uuid(),
  blueprint_key text not null unique,
  title text not null,
  subject_area text not null,
  profile_version text not null,
  assessment_level text not null check (assessment_level in (
    'lesson','chapter','pathway_mock','credential_style_mock','capstone_review'
  )),
  duration_seconds integer check (duration_seconds is null or duration_seconds > 0),
  configuration jsonb not null default '{}'::jsonb,
  official_source_url text,
  source_checked_at date,
  official_blueprint_version text,
  is_published boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
-- Client access is intentionally read-only to published blueprint metadata.
-- Keep this table limited to public configuration; no questions or answer keys.

create table if not exists public.exam_attempts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  blueprint_id uuid not null references public.exam_blueprints(id),
  attempt_number integer not null check (attempt_number > 0),
  status text not null default 'in_progress' check (status in (
    'in_progress','submitted','auto_scored','manual_review_pending','reviewed','expired','cancelled'
  )),
  blueprint_snapshot jsonb not null default '{}'::jsonb,
  selected_item_ids uuid[] not null default '{}',
  started_at timestamptz not null default now(),
  deadline_at timestamptz,
  submitted_at timestamptz,
  auto_score numeric(8,2),
  max_score numeric(8,2),
  final_score numeric(8,2),
  scoring_version text,
  result_summary jsonb not null default '{}'::jsonb,
  idempotency_key text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id, blueprint_id, attempt_number),
  unique (user_id, idempotency_key)
);
create index if not exists exam_attempts_user_started_idx
  on public.exam_attempts(user_id, started_at desc);

create table if not exists public.exam_responses (
  id uuid primary key default gen_random_uuid(),
  attempt_id uuid not null references public.exam_attempts(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  item_id uuid not null,
  response jsonb not null default '{}'::jsonb,
  is_flagged boolean not null default false,
  response_version integer not null default 1 check (response_version > 0),
  saved_at timestamptz not null default now(),
  submitted_response boolean not null default false,
  points_awarded numeric(8,2),
  grader_feedback jsonb,
  unique (attempt_id, item_id, response_version)
);
create index if not exists exam_responses_attempt_item_idx
  on public.exam_responses(attempt_id, item_id, response_version desc);
create index if not exists exam_responses_user_saved_idx
  on public.exam_responses(user_id, saved_at desc);

create table if not exists public.sync_tombstones (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  entity_type text not null,
  entity_id uuid not null,
  deleted_at timestamptz not null default now(),
  synced_at timestamptz,
  unique (user_id, entity_type, entity_id)
);
create index if not exists sync_tombstones_user_pending_idx
  on public.sync_tombstones(user_id, deleted_at) where synced_at is null;

-- RLS: deny by default; explicit policies grant only the owner's learner data.
alter table public.learner_profiles enable row level security;
alter table public.learner_records enable row level security;
alter table public.capstone_versions enable row level security;
alter table public.exam_blueprints enable row level security;
alter table public.exam_attempts enable row level security;
alter table public.exam_responses enable row level security;
alter table public.sync_tombstones enable row level security;

create policy "learner reads own profile" on public.learner_profiles
  for select to authenticated using (auth.uid() = user_id);
create policy "learner inserts own profile" on public.learner_profiles
  for insert to authenticated with check (auth.uid() = user_id);
create policy "learner updates own profile" on public.learner_profiles
  for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "learner reads own records" on public.learner_records
  for select to authenticated using (auth.uid() = user_id);
create policy "learner inserts own records" on public.learner_records
  for insert to authenticated with check (auth.uid() = user_id);
create policy "learner updates own records" on public.learner_records
  for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "learner reads own capstone versions" on public.capstone_versions
  for select to authenticated using (auth.uid() = user_id);
create policy "learner inserts own capstone versions" on public.capstone_versions
  for insert to authenticated with check (auth.uid() = user_id);
-- No UPDATE/DELETE policy: preserve prior capstone versions.

create policy "learner reads own attempts" on public.exam_attempts
  for select to authenticated using (auth.uid() = user_id);
-- Do not grant direct client insert/update policies for exam_attempts.
-- Trusted server-side functions validate start, deadline, score and submission.

create policy "learner reads own responses" on public.exam_responses
  for select to authenticated using (auth.uid() = user_id);
-- Do not grant direct client write policies for exam_responses.
-- Trusted server-side functions validate attempt ownership/status and grade securely.

create policy "learner reads own tombstones" on public.sync_tombstones
  for select to authenticated using (auth.uid() = user_id);
create policy "learner inserts own tombstones" on public.sync_tombstones
  for insert to authenticated with check (auth.uid() = user_id);

create policy "authenticated reads published blueprint metadata" on public.exam_blueprints
  for select to authenticated using (is_published = true);

-- No anon policies. Keep all exam item banks and answer keys outside these tables
-- and outside any API schema exposed to client roles. Use Edge Functions for delivery.
