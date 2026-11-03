# Fintech Kalp Flutter — Build & Handover Notes

## Source
- Repository: https://github.com/bangaru26/PHALGUN-Study-Planner
- Flutter project: `fintech-kalp_flutter/`
- Entry point: `fintech-kalp_flutter/lib/main.dart`
- Build workflow: `.github/workflows/fintech-kalp-flutter.yml`

## CI build contract
On a push to `main` touching `fintech-kalp_flutter/**`, or when manually dispatched in GitHub Actions, the workflow:
1. Installs Flutter stable on Ubuntu.
2. Resolves packages using `flutter pub get`.
3. Runs `flutter analyze --no-pub`.
4. Runs `flutter test --no-pub`.
5. Builds a release Android APK with `flutter build apk --release --no-pub`.
6. Uploads `app-release.apk` as the Actions artifact named `fintech-kalp-android-apk` (30-day retention).

**Release gate:** Do not distribute the APK unless the workflow's analyze, test and build jobs pass. The workflow was added to the repository; a successful run and downloadable artifact still need to be confirmed from GitHub Actions.

## Download the APK after a successful CI run
1. Open https://github.com/bangaru26/PHALGUN-Study-Planner/actions
2. Select the **Fintech Kalp Flutter build and verification** workflow.
3. Open the latest successful run on the intended commit.
4. Download the `fintech-kalp-android-apk` artifact ZIP and extract `app-release.apk`.
5. Transfer the APK to Android, permit install from that source if Android asks, and install. Review the permissions requested by Android.

## Local build (Windows / Linux / macOS)
From repository root:
```sh
cd fintech-kalp_flutter
flutter doctor
flutter pub get
flutter analyze
flutter test
flutter build apk --release
```
APK output: `build/app/outputs/flutter-apk/app-release.apk`

## Current functional scope and constraints
- Flutter learner interface contains dashboard, curriculum, practice, capstone, Software & System Requirements, and resources navigation.
- Requirements screen includes learner hardware/software guidance and readiness checklist persisted locally with SharedPreferences.
- The existing app data is local/browser/device persistence rather than a verified account-backed cross-device service.
- This workflow validates source/build and exports an Android APK; it does not certify course completeness, production authentication, sync, security audit, or device-specific UX.
- No Android phone/emulator hands-on test has been performed from this environment.
- The companion practical lab 01 and fictional AP CSV are repository resources; not currently wired as an in-app downloadable course module.

## Verification record
- Workflow definition committed: check GitHub Actions for its execution outcome.
- Flutter analyzer/tests/release build: **pending successful CI evidence** at handover time.
- Device installation and acceptance test: **pending**.
- Course-content acceptance and complete learner handover: **not yet complete**.

## Acceptance test checklist
- [ ] CI workflow passes analyze, tests, and release APK build.
- [ ] APK artifact is downloaded and package installs on Android.
- [ ] Confirm all six main destinations work and navigation state does not crash.
- [ ] Requirements checklist survives app restart.
- [ ] Complete one lesson and quiz; confirm score/progress persistence.
- [ ] Test backup/export and restore if present.
- [ ] Review accessibility, overflow, offline behavior and all resource links on phone.
- [ ] Confirm course chapters have explanations, worked examples, practice, answers and non-placeholder assessment.
