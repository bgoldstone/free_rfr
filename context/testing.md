# Testing

- Most tests mirror `lib/` and need `ChangeNotifierProvider` + `MaterialApp`/`Scaffold` around the widget under test.
- `test/connections_test.dart` fakes `PathProviderPlatform.instance` (not just the legacy method channel) because Windows `path_provider` uses FFI; use a per-test temp directory for `free_rfr.json`. Other tests do not need a live Eos console. There are no fixture dirs or skipped tests.
- Platform branches are forced with `debugDefaultTargetPlatformOverride`; reset it in `finally`.
- Fader tests need `registerFallbackValue(FaderControlsState())` for mocktail matchers.
- `MockOSC` overrides `sendOSCMessage`, so `mocktail.when()` cannot stub it; use a recording subclass like `RecordingMockOSC` in `test/pages/direct_selects_test.dart`.
- Hotkey-dependent tests must mock both `dev.leanflutter.plugins/hotkey_manager` and `dev.leanflutter.plugins/hotkey_manager_event`, and reset the singleton with `hotKeyManager.unregisterAll()`.
- `Connections.loadConfig()` reads/writes `free_rfr.json` synchronously after one async path lookup and resets malformed configs; tests can assert the JSON file immediately.
- `test/common.dart:3` `ignoreErrors()` is misnamed: it suppresses non-overflow Flutter errors and prints overflow errors.
- `test/main_test.dart` calls `entry.main()` without awaiting; do not treat it as deterministic async startup coverage.
