# Commands

- Format with `dart format .` before PR (per `CONTRIBUTING.md`).
- Validate with `dart format --output=none --set-exit-if-changed .`, `flutter analyze`, and `flutter test`; focused tests are fine while iterating, but run the full suite before PR.
- Focused test example: `flutter test test/pages/facepanels/controls/color_picker_test.dart`.
- Coverage command: `flutter test --coverage`; `coverage/` is generated and gitignored.
- Flutter is pinned to `3.50.1` in `.github/workflows/flutter_build.yml` and `README.md`; Android CI uses Temurin JDK 21.
- From `android/`, verify Kotlin Gradle plugin drift with `.\gradlew kgpVersion -q`; Flutter has warned on older pins.
- Document new helpers, state, and behavior; keep doc comments accurate when changing existing code.
