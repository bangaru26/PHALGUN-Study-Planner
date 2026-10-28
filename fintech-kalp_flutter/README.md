# Fintech Kalp — Flutter app

A Flutter/Dart application for the focused finance-and-related-technology learning pathway within GFPA and PHALGUN. GFPA remains the wider academy; Fintech Kalp is not a replacement for it.

## Run locally

Install Flutter stable, then:

```sh
cd fintech-kalp_flutter
flutter pub get
flutter run -d chrome
```

## Build for web

```sh
flutter build web --release --base-href /PHALGUN-Study-Planner/fintech-kalp/
```

The GitHub Actions workflow at `.github/workflows/deploy-fintech-kalp.yml` builds the app and publishes its compiled web output into `/fintech-kalp/` within the existing PHALGUN GitHub Pages site. The intended public path is:

https://bangaru26.github.io/PHALGUN-Study-Planner/fintech-kalp/

## Current release scope

- Responsive Flutter learning dashboard for mobile and desktop browsers.
- Six pathway areas: finance foundations, finance operations, data for finance, automation and AI, fintech systems, Agile and transformation.
- Chapter navigation and a sample finance operations case study.
- Quiz answers are hidden until the learner submits all questions; feedback and explanations then appear.
- Mini-capstone writing area and resource directory.

## Known limitations — do not mistake this for the completed academy

- This is the first Flutter app shell/prototype, not the full GFPA curriculum or all Fintech Kalp lessons.
- The curriculum entries are starter placeholders; full authored lessons, assignments, and capstone rubrics remain to be added after the GFPA/Fintech Kalp subject map is validated.
- Progress, quiz state and the capstone draft are session-local; no cloud sync, user account, shared progress backend or offline caching is connected yet.
- No financial transactions, bank connections, credential storage or production fintech operations are implemented.
- Public availability depends on the GitHub Actions build succeeding and GitHub Pages serving the existing main-branch root site. Verify the workflow before announcing a successful deployment.
