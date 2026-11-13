# AAROH — Zero-Budget Delivery Plan

**Decision date:** 13 November 2026  
**Applies to:** Fintech Kalp and PAL within AAROH  
**Budget ceiling:** ₹0 until the Founder explicitly approves otherwise.

## Non-negotiable spending rule

Do not purchase or activate any paid hosting, domain, API, AI subscription, SMS service, email service, software licence, or recurring plan. Do not start a paid trial that can convert to a charge. Do not enter payment details to unlock a free tier. If a free service requires a payment method or carries a credible risk of automatic billing, stop and present the limitation before proceeding.

## Delivery principles

1. Prefer existing GitHub repository, GitHub Actions and GitHub Pages where suitable and available at no charge.
2. Prefer free and open-source software that can run on the Founder's existing laptop.
3. Keep learning usable without an account or internet connection wherever practical.
4. Save learner work locally first. Provide clear export and restore options.
5. Do not describe local browser storage as cloud backup or cross-device sync.
6. Do not call an app authenticated until sign-in, identity restriction, session handling and access rules have passed end-to-end tests.
7. Do not expose passwords, authentication secrets, private learner records or exam answer keys in browser code or public repository files.
8. Verify free-tier limits and terms before relying on an external service. A free tier may pause, impose quotas or change; it is not a permanent availability guarantee.
9. Never claim an installation, integration, test, deployment or agent task succeeded without direct verification.
10. No Hatchable service or project is to be used.

## Fintech Kalp — delivery order

### Stage 1: dependable offline learning
- Preserve the current local-first learning experience.
- Expand each chapter into a complete learning unit: objectives, prerequisites, plain-language notes, worked examples, cross-functional links, practice, MCQs with explanations, flashcards, assignments, model answers, mini-capstone, interview prompts and revision.
- Make chapter completion depend on the agreed assessment rule; do not mark a chapter complete merely because it was opened.
- Improve local save reliability, visible save status, backup and restore.
- Add chapter content to the app itself, not only to separate Markdown files.
- Keep practice datasets fictional and clearly labelled.

### Stage 2: zero-cost identity and sync assessment
- First test whether an appropriate free option is usable without payment details or automatic billing.
- Restrict the intended learner account to `mylearnings.bnk@gmail.com` only if the chosen provider can enforce that restriction securely on the server.
- Keep all secrets outside the Flutter web bundle and public repository.
- If a secure no-cost service cannot be verified, retain local-only learning and portable backups. Do not fake authentication with a client-side email check.
- Treat cross-device sync as incomplete until two-device tests prove that the same account sees its own records and cannot read another account's records.

### Stage 3: assessment engine
- Build lesson checks, chapter assessments and pathway practice in sequence.
- Preserve submitted attempts and review history.
- Keep unreleased answers and grading rules out of public client files if/when a trusted server becomes available.
- Label all internally created exam simulations as practice, not official certification exams.

## PAL — zero-cost delivery order

1. Build and test a usable local-first family scheduler before adding integrations.
2. Include family members, private rooms, reminders, snooze/edit, offline viewing and export/restore.
3. Assess Telegram integration before WhatsApp if it can meet the requirements without paid services.
4. Never claim a bot knows a phone number unless the member has explicitly shared and the application has securely verified it.
5. Treat SMS delivery, public always-on hosting and smartwatch integrations as unavailable until a genuinely free, secure path is verified.
6. Do not weaken privacy or security to preserve a zero-cost feature.

## Current verified starting point

- The repository contains a Flutter Fintech Kalp app and existing learning pathways.
- The current app uses local browser/device storage through SharedPreferences.
- The repository documentation states that third-party authentication and cloud synchronisation are not yet implemented.
- Existing GitHub Actions workflows have previously completed successful builds, but every new change must pass the current workflow before being described as verified.
- PAL still requires a separately verified implementation and test pass.

## Release reporting format

Every update must state, in ordinary language:
- What was actually completed.
- What was tested and the result.
- What is still missing.
- Any blocker and the no-cost alternative.
- Whether anything requires the Founder to do something on the laptop or phone.

**No paid fallback is to be activated without explicit approval.**
