# Study Desk — PHALGUN

A free, mobile-friendly study desk for GFPA / PHALGUN learning.

## Fintech Kalp — chapter-by-chapter study packs

The first complete chapter pack is now available: [Chapter 1 — Accounting Foundations](./FINTECH_KALP_CHAPTER_01_ACCOUNTING_FOUNDATIONS.md). It includes plain-language notes, worked examples, a practical assignment with model answers, 15 MCQs with explanations, 20 flashcards and interview prompts. Further chapter packs should follow the same learning standard.

## Fintech Kalp — learner coursebook
**Start the job-ready learning course:** [Fintech Kalp Learner Coursebook](./FINTECH_KALP_LEARNER_COURSEBOOK.md). It includes teachable foundations and practical labs across accounting, P2P/O2C/R2R, Excel formula dictionary and VBA, Power Query, FP&A, SQL, Power BI/DAX, Python, ERP/SAP FICO, IFRS awareness, treasury, controls, AI safety, capstone and job readiness. Save your work in a portfolio and verify current standards/rules against authoritative sources.

## PHALGUN lifelong-learning master catalogue
Open the [PHALGUN Lifelong Learning Library](./phalgun-curriculum.html). It consolidates the agreed curriculum into searchable domains and course pathways, with GFPA retained as the dedicated Finance Academy. It includes finance and career relaunch; CMA USA; IFRS; Advanced Excel; Data Analytics; Power BI; SQL; Python; SAP FICO; ERP; RPA; AI for Finance; placement and job readiness; mathematics, abacus and Vedic mathematics; science; languages and Teeline; computing and AI literacy; creativity; practical life skills; personal finance; Indic scriptures and cultural literacy; nature; research; critical thinking; and teaching/mentoring.

## GFPA professional risk, assurance and information-security pathways
See [IRM progressive risk-management learning, CIA, CRMA and CISM knowledge pathways](./gfpa-risk-assurance-cyber-certifications.md). These are curriculum specifications, not official certification courses; syllabus versions and eligibility must be checked against the awarding bodies.

## Fintech Kalp software readiness
See the [Software & System Requirements tab specification](./FINTECH_KALP_SOFTWARE_SYSTEM_REQUIREMENTS.md) for hardware/software readiness, vendor-source verification, tool coverage, compatibility, licensing, data-handling and release acceptance criteria.

### Software & System Requirements
Open the [interactive learner readiness guide](./software-system-requirements.html) for hardware recommendations, official software prerequisites, Android/Windows/PWA compatibility, installation references, privacy and license cautions, and a locally saved readiness checklist. The Flutter Fintech Kalp app now includes a native Requirements navigation screen with a locally saved readiness checklist.

## Flutter build and handover

See the [Flutter build and handover notes](./FINTECH_KALP_FLUTTER_HANDOVER.md) for the CI build workflow, APK artifact retrieval, local build commands and explicit verification gates. The Android release APK must only be distributed after the GitHub Actions analyze, test and build steps pass.

## Fintech Kalp practical lab pack 01 — AP exception analytics

Practice an end-to-end finance analytics workflow with fictional INR invoice records. The [practical lab pack](./FINTECH_KALP_PRACTICAL_LAB_PACK_01.md) covers Excel ageing and checks, exception-log controls, SQL analysis, a Power BI dashboard specification, and Python validation. The [synthetic AP CSV dataset](./fintech-kalp_flutter/assets/fintech_kalp_ap_lab.csv) is supplied for hands-on practice. All records are fictional; report date is 3 November 2026. The dataset is a downloadable exercise file and is not yet bundled into the Flutter app UI.

## Open the app
After GitHub Pages deployment, the app is intended to be available at:
https://bangaru26.github.io/PHALGUN-Study-Planner/

## Included in the current Study Desk app
- Accounting Fundamentals lessons with practice quizzes and score feedback
- Lesson notes saved in this browser
- Study timer and session history
- Daily/weekly study targets and timetable
- Progress overview and review of completed work
- CSV export and JSON backup/restore
- Installable web-app metadata and offline app-shell cache

## Privacy and limits
The current standalone Study Desk stores notes, quiz results, settings and session history in this browser's local storage. It has no third-party authentication or cloud synchronization. Different browsers/devices do not automatically share progress; use the built-in JSON backup/restore to transfer it. Do not enter passwords, government ID numbers, banking details or other sensitive information.

## Subject Dictionary
Open the standalone [Study Desk Subject Dictionary](./dictionary.html). It includes searchable, subject-filtered definitions and practical examples across Accounting, Finance, IFRS, Advanced Excel, Data Analytics, Power BI, SQL, Python, SAP FICO, AI for Finance and Job Readiness.

## Cross-platform and privacy principles
This project is designed as an installable Progressive Web App, so the same web code can run in current browsers on Android, Windows, macOS and Linux. Native capabilities and offline support vary by browser/device; verify install and offline behavior on each target device.

- Keep local/offline learning usable, show clearly whether data is local-only or synced, and provide portable exports so browser resets do not silently destroy records.
- Never store passwords or authentication secrets in localStorage. Cloud sync must verify the signed-in identity server-side and protect each learner's data.
- AI features should be optional, disclose when content leaves the device, cite the material used, and avoid sending private notes to an AI service without explicit consent.
- Automatic cross-device cloud sync is not yet implemented in the GitHub Pages app. Telegram authentication and the shared progress service must pass end-to-end tests before being marked production-ready.

## Learning standard
Every course should follow Understand → Learn → Practise → Build → Test → Portfolio → Interview/Apply → Reassess. Each lesson should include clear objectives, plain-language explanations, worked examples, guided practice, independent exercises, answers/explanations, a mini-capstone, a professional artefact where relevant, a cumulative assessment and revision prompts. Official syllabi, standards and laws must be source-linked, dated and versioned. Use original lessons and practice questions; do not redistribute copyrighted or paid question banks.
