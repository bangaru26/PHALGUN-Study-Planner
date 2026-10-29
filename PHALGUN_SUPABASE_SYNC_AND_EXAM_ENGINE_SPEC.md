# PHALGUN Cloud Sync & Professional Exam Simulation — Technical Design

**Status:** Design specification; cloud provisioning and end-to-end tests are not yet complete.  
**Owner scope:** PHALGUN learning experience; GFPA curriculum; Fintech Kalp pathway; AAROH stays a lightweight orchestration layer.

## 1. Product goals

1. A learner signs in on phone or computer and sees the same lessons, notes, saved answers, exam attempts, practical files, capstones, bookmarks, and progress.
2. Learning remains usable offline. Local changes queue safely and sync when a connection returns.
3. Every lesson has a lesson check; every chapter/pathway has a configurable assessment; each qualification/skill area can have a full mock exam.
4. Exam simulations support objective questions, numeric calculations, multi-select, matching/order, caselets, short answers, essays, spreadsheet tasks, and practical workflow evidence where appropriate.
5. Show exam-mode timer, instructions, section navigation, flag-for-review, unanswered-item warnings, autosave, submit confirmation, scoring, feedback, and a detailed post-exam review.
6. Preserve every submitted attempt as immutable history. Draft answers can change; submitted attempts cannot be silently overwritten.
7. Support source provenance, syllabus versioning, and review dates for regulatory/professional content.

## 2. Supabase architecture

- **Identity:** Supabase Auth (email/password or magic link; optional providers later). Never store passwords in application tables.
- **Authoritative cloud state:** Postgres with row-level security (RLS), keyed to the authenticated user ID.
- **Offline local state:** SQLite for native Flutter targets; IndexedDB/local persistence for web/PWA. Use a repository interface so UI code does not depend directly on the storage engine.
- **Sync engine:** local-first writes; create a local operation/outbox entry in the same local transaction; sync pending records when online and on app resume; apply remote changes using stable UUIDs and version metadata.
- **Files:** Supabase Storage private buckets for learner-owned capstone attachments, with per-user path policies, file size/type limits, and signed URLs when needed. Text drafts belong in Postgres/local DB, not only in files.
- **Server-only exam delivery:** Edge Functions or a trusted backend fetch exam items and grade answers. Keep answer keys, scoring rubrics, and unreleased questions out of client-readable tables and API responses. Never ship a service-role key in Flutter/web code.
- **Observability:** sync error queue with retry/backoff, last successful sync timestamp, conflict indicator, and privacy-conscious logs. Never log essay bodies, credentials, or sensitive learner content unnecessarily.

### Sync flow

1. Sign-in obtains a Supabase user ID.
2. Local database loads immediately; cloud pull merges newer server records.
3. Every learner edit is saved locally first and queued for upload.
4. A sync worker sends idempotent upserts using a stable user/record key.
5. Server changes since the last cursor are pulled and merged.
6. Conflicts are surfaced instead of silently overwriting meaningful work.
7. On sign-out, offer to retain local cache on this device or clear it; never expose one account's cached records to another account on a shared device.

### Conflict policy

- Progress flags/bookmarks: merge sets or use last-write-wins with timestamps.
- Notes and drafts: preserve both versions when concurrent edits conflict; let learner compare/choose.
- Capstone files: immutable version records; never overwrite a prior uploaded version.
- Exam attempt answers: each answer revision is timestamped during an active attempt; final submission is immutable. A reconnect must not create a second submission.
- Content/curriculum: published content is versioned centrally; learner records reference stable content IDs plus content version.
- Deletions: tombstones with deleted timestamps, synced before eventual cleanup. Do not physically erase immediately where that could resurrect records on another device.

## 3. Core data model

The accompanying SQL migration creates learner profiles, typed/versioned learner records, immutable capstone versions, published exam blueprint metadata, exam attempts, exam response history, and sync tombstones.

Exam content and answer keys must be placed in a private schema or delivered/graded only by trusted server-side code. The migration deliberately does not expose question banks to ordinary client roles. Build secure Edge Functions for start attempt, save response, submit attempt, and get attempt review; validate ownership, status, deadline, allowed item IDs, and idempotency on every call.

### Access-control invariants

- Learner-owned rows require authenticated user ID equals row user ID in RLS.
- Client can read/write only its own learner data.
- Published exam blueprint metadata can be visible, but answer keys, grading rubrics, and unreleased questions must not be.
- Grading and final submission run server-side. A client cannot set its own score, pass status, grade, or exam completion timestamp.
- Storage paths are scoped to the authenticated user and checked with policies.
- Use database migrations under version control; apply to a staging project first.

## 4. Exam engine: one engine, multiple assessment profiles

Each blueprint is data-driven, not hard-coded per subject. It stores assessment profile/version, duration, sections, item counts, item-type mix, marks, negative marking policy, pass threshold (if appropriate), permitted tools, randomisation rules, feedback policy, and provenance to the official public blueprint. Do not invent a pass mark or exam rule when an authority does not specify one; clearly label our practice threshold.

### Supported item types

- Single-select and multi-select MCQs
- Numeric/calculation response with tolerance and units
- Matching, ordering, and classification
- Short written response
- Essay/case analysis with rubric-based scoring
- Scenario/caselet with several linked questions
- Spreadsheet task: learner uploads workbook or completes a sandboxed task; assess formulas, outputs, data cleaning, pivot/report design, and explanation
- System/process simulation: SAP FICO-style end-to-end workflow and configuration decisions in a safe mock environment, not a live SAP tenant
- KPI/dashboard case: define metric, formula, grain, source, owner, target, thresholds, interpretation, and action
- Oral/presentation evidence can be a future optional mode; do not require microphone/camera by default.

### Exam lifecycle

not started -> in progress -> submitted -> auto scored -> (manual review pending) -> reviewed

- Generate attempt server-side; freeze blueprint/content version, item selection, time limit, start/deadline.
- Autosave each answer locally and to cloud when connected; local queue survives temporary outages.
- Timer uses server-issued start/deadline. On reconnect, server deadline wins; define grace/recovery rules explicitly rather than letting client clock edits extend time.
- Warn before final submission; submission is idempotent and immutable.
- Auto-grade objective items; numeric answers use configured tolerance; essays and open responses use a transparent rubric and require human/approved rubric-assisted review. AI suggestions must be marked provisional and not represented as an official examiner's grade.
- Feedback can be delayed until submission or manual review, depending on blueprint.
- Post-exam report: score, time, unanswered/flagged items, topic/domain strengths, error patterns, rubric feedback, references, recommended revision, and attempt-to-attempt trend.
- Retakes create new attempt IDs. Preserve all attempts and their original content versions.

## 5. Assessment profiles by subject

These are proposed training profiles, not claims about current official live-exam specifications. Before publishing any credential-specific mock, confirm the current official candidate guide/blueprint and record source URL, checked date, version, jurisdiction, and deviations.

| Area | Training simulation design |
|---|---|
| US CMA | Objective-question section plus essay/scenario section; calculations, management accounting, planning, performance, cost, controls, decision support. Configurable timing and weights based on the current official guide. |
| Microsoft Excel / Microsoft Office Specialist | Hands-on workbook tasks: formulas/functions, formatting, tables, charts, data management, pivots and task-specific objectives. Score workbook state/output, not only MCQs. Use a local sandbox or downloadable workbook where direct Office integration is unavailable. |
| SAP FICO | Business-process cases: master data, GL/AP/AR, asset accounting, controlling/cost centres, postings, reconciliation, period close, configuration choices, error diagnosis, and controls. Distinguish conceptual practice from hands-on SAP-system certification. |
| IRM / risk management | Scenario-based risk identification, analysis, treatment, governance, risk appetite, controls, reporting, and rationale. Map to the chosen IRM qualification and its current syllabus before assigning credential labels. |
| CRMA / internal audit | Risk-based assurance, governance, risk management, controls, engagement planning, evidence, findings, recommendations, and case analysis. Verify current IIA CRMA blueprint; avoid implying practice is an official IIA exam. |
| KPI / performance management | Applied case: calculate KPIs, define numerator/denominator, unit, grain, data lineage, owner, target, tolerance, leading/lagging status, visualise results, diagnose variance, recommend action. |
| Excel/Power BI/SQL/Python | Practical outputs plus interpretation and data-quality checks; not just memorisation questions. |
| Agile/Scrum | Scenario questions, prioritisation, facilitation, flow/metrics, role/accountability judgement, and a small practical artefact. Verify relevant current credential blueprint when one is selected. |
| Finance operations / controls | End-to-end case with documents/data, reconciliations, exception handling, segregation of duties, root-cause analysis, and evidence trail. |
| AI / RPA / fintech | Design-and-risk case, prompt/output evaluation, human oversight, data/privacy, failure modes, business value, and a practical workflow design. |

## 6. Lesson-level and full mock ladder

- **Lesson check (5–15 min):** 5–12 items; immediate feedback after submit; one applied task for practical lessons.
- **Chapter assessment (20–45 min):** mixed items, cumulative recall plus applied scenario.
- **Pathway mock (45–120 min):** multiple sections, time pressure, randomised equivalent item pools.
- **Credential-style full mock:** length and section mix set only after verifying the current official blueprint; include appropriate essays/practical tasks.
- **Capstone defence/review:** score a portfolio against a rubric; distinct from a timed exam.

Every lesson assessment should test the lesson's learning objectives, not merely repeat the lesson text. Build question banks tagged by domain, topic, objective, difficulty, cognitive skill, item type, source, author/reviewer, and review date. Use original scenarios and datasets. Never scrape or copy protected exam questions, paid courseware, or proprietary Microsoft/SAP/IIA/IRM content.

## 7. Scoring and quality

- Store raw points, possible points, rubric dimensions, and calculation version.
- Do not equate an internal practice score to official credential passing unless the official rules explicitly support that conversion.
- Essays: rubric dimensions can include correctness, reasoning, calculations, structure, evidence, practical recommendation, and professional communication.
- Practical tasks: test correctness, robustness, clarity, control awareness, and reproducibility.
- Accessibility: keyboard navigation, screen-reader labels, visible timer and warnings, scalable text, and an accommodations setting where feasible.
- Item quality review: check ambiguity, answer key, difficulty, objective mapping, bias, source validity, and freshness.
- Regulatory/standards questions carry jurisdiction and effective-date metadata; flag outdated questions when a rule changes.

## 8. Delivery stages and gates

**Stage A — design (this document):** agree data boundaries, sync semantics, exam profiles, security invariants.

**Stage B — Supabase staging:** create project; configure Auth; apply versioned SQL migrations; set RLS and private storage; create Edge Functions; test least privilege. This requires a Supabase project and authorized credentials; none are embedded in the repository or client.

**Stage C — local-first repository:** replace direct SharedPreferences state writes with repositories and a local database/outbox. Migrate old saved state without losing completion, quiz answers, or capstone draft.

**Stage D — sync:** implement pull/push, idempotency, conflict UI, retry/backoff, account switching, and status indicator.

**Stage E — exam engine vertical slice:** deliver one fully working lesson exam with MCQ + short written response, timer, autosave, submission, scoring and review; then add a practical Excel task. Validate before broadening to credential-specific profiles.

**Stage F — expansion:** add the remaining subject profiles, question banks, capstone rubric, admin/content authoring, analytics, and export.

**Stage G — verification:** test phone and computer on same account, airplane mode, reconnect, concurrent edits, storage eviction, app restart, expired session, account switch, deadline crossing, duplicate submission, RLS denial, and backup/export. Report actual test results; do not call a design or code commit a deployed system.

## 9. Definition of done

- A lesson progress update made offline on device A appears on device B after sync, without duplicate records.
- Notes and capstone drafts survive restart and offline edits; conflicts preserve both versions.
- Every exam attempt has frozen version, server deadline, immutable submission, auditable scoring, and durable response history.
- Client cannot read answer keys early or set its own score.
- One end-to-end test passes on staging and results are recorded.
- Export of learner-owned data is available; account deletion/retention policy is documented.
- Build, migration, security-policy, and cross-device tests pass before calling it deployed.


## 10. Official-format checks recorded 29 October 2026

These references were checked while drafting this design. Re-check the specific credential and region before publishing any live-aligned blueprint; official formats can change.

- **US CMA (IMA):** the current IMA handbook says that from the September/October 2026 testing window onward, case-based questions become the standard format for the English exam in the Americas, Europe, Middle East, Asia Pacific and Africa. Essays continue in specified regions including Mainland China, Taiwan (China) and Japan. The case-based section includes a short business case followed by a mix such as drag-and-drop, fill-in, select-from-list and calculation questions. The simulator must therefore support both a legacy/region-specific essay profile and a current case-based profile; do not make essays the only default. Official references: https://prodcm.imanet.org/cma-case-based-questions and https://prodcm.imanet.org/-/media/IMA/Files/Home/IMA-Certifications/CMA-Certification/CMA-Handbook-3252026.ashx
- **Microsoft Office Specialist Excel Associate (Microsoft 365 Apps):** Microsoft's certification page lists a 50-minute assessment and says interactive components may be included. Design the practice profile around hands-on workbook tasks and the current skills measured, but re-check the exact exam and product version before fixing the blueprint. Official reference: https://learn.microsoft.com/en-us/credentials/certifications/mos-excel-associate-m365-apps/
- **SAP Certification:** SAP currently has a transition across its portfolio. Official guidance describes both proctored multiple-choice exams and newer practical, open-book, performance-based system/scenario assessments; the applicable format is determined by the individual certification. Do not assume every SAP FICO-related certification has the same format. Where no licensed SAP practice system is available, clearly label our exercise as a mock process simulation, not a live SAP system exam. Official references: https://learning.sap.com/helpcenter/certification-support/certification-practical-exam and https://learning.sap.com/helpcenter/certification-support/exam-essentials
- **IRM:** exam/assessment structure varies by qualification level. IRM India describes, for example, a combination of MCQ and assignment-based essay questions for one qualification path, and case-study/project assessment for another. Blueprint selection must ask which IRM qualification/level the learner is preparing for. Official reference: https://www.theirmindia.org/certification-track
- **CRMA / IIA:** select the exact credential and current IIA candidate guide as a prerequisite for a credential-style mock. Until that guide has been verified, offer a clearly labelled CRMA-topic practice assessment, not a claim of exact current exam simulation.

These source links are provenance only; no official questions are copied. Our question bank must use original scenarios and be clearly marked as independent practice material.
