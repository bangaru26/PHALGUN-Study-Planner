# PHALGUN Study Planner

A free, mobile-friendly study desk for GFPA / PHALGUN learning.

## Open the app
After GitHub Pages deployment, the app is intended to be available at:
https://bangaru26.github.io/PHALGUN-Study-Planner/

## Included
- Accounting Fundamentals lessons with practice quizzes and score feedback
- Lesson notes saved in this browser
- Study timer and session history
- Daily/weekly study targets and timetable
- Progress overview and review of completed work
- CSV export and JSON backup/restore
- Installable web-app metadata and offline app-shell cache

## Privacy and limits
This standalone Study Planner stores notes, quiz results, settings and session history in this browser's local storage. It has no third-party authentication or cloud synchronization. Different browsers/devices do not automatically share progress; use the built-in JSON backup/restore to transfer it. Do not enter passwords, government ID numbers, banking details or other sensitive information.

## Deploy
The `.github/workflows/pages.yml` workflow deploys this repository to GitHub Pages on pushes to `main`. Repository Pages source is configured for **GitHub Actions**.


## Subject Dictionary
Open the standalone [PHALGUN Subject Dictionary](./dictionary.html) from the Study Planner. It includes searchable, subject-filtered definitions and practical examples across Accounting, Finance, IFRS, Advanced Excel, Data Analytics, Power BI, SQL, Python, SAP FICO, AI for Finance and Job Readiness. It is bundled as a web page: no dictionary document needs to be downloaded or uploaded.

## Cross-platform feature benchmark (October 2026)
This project is designed as an installable Progressive Web App, so the same web code can run in current browsers on Android, Windows, macOS and Linux. Native capabilities and offline support vary by browser/device; verify install and offline behavior on each target device.

| Product / project | Strength worth learning from | PHALGUN design decision |
|---|---|---|
| Anki / AnkiDroid | Mature spaced repetition and durable flashcard review across desktop and Android | Plan a subject glossary that can become editable flashcards, plus scheduled revision and exportable learning records. |
| RemNote | Notes and flashcards connected to the same learning material | Keep notes attached to each lesson/topic and allow a later “turn note into card” flow. |
| NotebookLM / AI study tools | Source-grounded summaries, study guides and practice questions | Add AI-assisted explanations and quiz generation only when the source is shown, the output is reviewable, and a privacy-safe provider/local model is configured. |
| Super Productivity | Focus timer, timeboxing, offline-first planning and progress statistics | Keep the prominent stopwatch, daily/weekly targets, session history and next-study suggestions. |
| Obsidian / Markdown knowledge tools | Portable, user-controlled notes and linking between concepts | Make notes exportable as JSON/Markdown and link glossary terms to related lessons; avoid trapping learning records in a proprietary format. |

References for this benchmark: [Anki](https://apps.ankiweb.net/), [RemNote](https://www.remnote.com/), [NotebookLM](https://notebooklm.google/), [Super Productivity](https://super-productivity.com/), [Obsidian](https://obsidian.md/), and a [2026 cross-platform AI study app comparison](https://unstore.io/discover/best-apps-for-studying-with-ai-desktop/).

### Privacy and fileless design principles
- “Fileless” means the learner can write notes, revise, and track progress inside the app without managing separate documents. Browser storage still exists behind the scenes.
- Keep local/offline learning usable, show clearly whether data is local-only or synced, and provide portable exports so browser resets do not silently destroy records.
- Never store passwords or authentication secrets in localStorage. Login must use a trusted authentication flow; cloud sync must verify the signed-in identity server-side and protect each learner's data.
- AI features should be optional, disclose when content leaves the device, cite the material used, and avoid sending private notes to an AI service without explicit consent.
- Automatic cross-device cloud sync is intentionally disabled. The GitHub Pages app runs locally and offline, and portable JSON backup/restore is the supported transfer path until a separately approved, sovereign sync service is implemented and tested.
