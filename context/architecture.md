# Architecture

- `lib/main.dart` is the only app entrypoint; `lib/test.dart` is a manual OSC socket probe to `127.0.0.1:3032`, not a `flutter test` target.
- Root `ChangeNotifierProvider` creates `FreeRFRContext`, but connection/socket state actually lives in `MyApp` (`_oscCache`, `_socketCache`, `currentConnectionIndex`). `FreeRFRContext.currentConnectionIndex` is effectively unused by the app.
- `OSC` is not provided via Provider; it is passed as a concrete constructor arg through pages/widgets. Tests mock it with `test/mocks/MockOSC.dart` and use `MockSocket` for protocol assertions.
- TCP OSC port is fixed at `3032`; frames are 4-byte big-endian length + OSC bytes (`lib/objects/osc_control.dart`).
- `OSC.setupFaderBank` stores a `FaderControlsState` back-reference; inbound OSC mutates fader widgets directly.
- `ColorPickerControl` sets `labelTypes: const []` because `flutter_colorpicker`'s legacy `DropdownButton` needs a Flutter `Material` ancestor that `material_ui`'s `Scaffold` does not provide; re-enabling labels breaks color-picker tests.
