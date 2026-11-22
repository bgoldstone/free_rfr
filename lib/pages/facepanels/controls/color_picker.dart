import 'package:material_ui/material_ui.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:free_rfr/configurations/context.dart';
import 'package:free_rfr/objects/osc_control.dart';
import 'package:free_rfr/objects/parameters.dart';
import 'package:free_rfr/widgets/button.dart';
import 'package:provider/provider.dart';

class ColorPickerControl extends StatefulWidget {
  final OSC osc;
  const ColorPickerControl(
    this.osc, {
    super.key,
  });

  @override
  State<ColorPickerControl> createState() => _ColorPickerControlState();
}

class _ColorPickerControlState extends State<ColorPickerControl> {
  int index = 0;

  /// Locally selected color from the picker until Eos feedback changes.
  Color? currentColor;

  /// Last color derived from Eos feedback, used to detect stale selection.
  Color? lastFeedbackColor;

  @override
  Widget build(BuildContext context) {
    final ctx = context.watch<FreeRFRContext>();
    final colorFromEos = _colorFromFeedback(ctx);
    if (currentColor != null &&
        lastFeedbackColor != null &&
        colorFromEos != lastFeedbackColor) {
      currentColor = null;
    }
    lastFeedbackColor = colorFromEos;
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        ColorPicker(
          pickerColor: currentColor ?? colorFromEos,
          onColorChanged: (newColor) {
            widget.osc.sendColor(newColor.r, newColor.g, newColor.b);
            setState(() => currentColor = newColor);
          },
          enableAlpha: false,
          labelTypes: const [],
          paletteType: PaletteType.hueWheel,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.25,
          child: Button("Color Home", () {
            widget.osc.sendCmd("select_last Color Home#");
            setState(() {
              currentColor = Colors.white;
            });
          }),
        ),
      ]),
    );
  }
}

/// Builds the preview color from Eos feedback.
///
/// Usable hue/saturation feedback wins; otherwise the color is reconstructed
/// from active color wheels. Falls back to white when neither is available.
Color _colorFromFeedback(FreeRFRContext ctx) {
  final hueSaturation = ctx.hueSaturation;
  if (hueSaturation.length >= 2 && hueSaturation[1] > 0) {
    return HSVColor.fromAHSV(
      1,
      hueSaturation[0],
      hueSaturation[1].clamp(0.0, 1.0).toDouble(),
      1,
    ).toColor();
  }
  return _colorFromWheels(ctx) ?? Colors.white;
}

/// Builds a preview color from the active color wheels.
///
/// Prefers explicit hue/saturation wheels, then RGB/RGBW/CMY values, then
/// other known emitter wheels. Returns null when no wheel describes a color.
Color? _colorFromWheels(FreeRFRContext ctx) {
  /// Returns the first active wheel value whose name ends in one of [names].
  double? wheelValue(List<String> names) {
    for (final entry in ctx.currentChannel.entries) {
      final name = entry.key.oscName.toLowerCase();
      final matches = names.any(
        (candidate) => name == candidate || name.endsWith(' $candidate'),
      );
      if (!matches) continue;
      final values = entry.value;
      if (values != null && values.isNotEmpty) return values.first;
    }
    return null;
  }

  final hue = wheelValue(['hue']);
  final saturation = wheelValue(['saturation', 'sat']);
  if (hue != null && saturation != null) {
    return HSVColor.fromAHSV(
      1,
      hue,
      (saturation / 100).clamp(0.0, 1.0).toDouble(),
      1,
    ).toColor();
  }

  final white = wheelValue(['white']) ?? 0;
  double? red = wheelValue(['red']);
  double? green = wheelValue(['green']);
  double? blue = wheelValue(['blue']);
  final cyan = wheelValue(['cyan']);
  final magenta = wheelValue(['magenta']);
  final yellow = wheelValue(['yellow']);
  red ??= cyan == null ? null : 100 - cyan;
  green ??= magenta == null ? null : 100 - magenta;
  blue ??= yellow == null ? null : 100 - yellow;
  if (red == null && green == null && blue == null && white == 0) {
    return _colorFromEmitters(ctx);
  }

  final whiteLevel = white / 100;

  /// Adds the white channel to a 0-100 color wheel value and scales to 0-1.
  double component(double? value) =>
      (((value ?? 0) / 100) + whiteLevel).clamp(0.0, 1.0).toDouble();

  return Color.fromRGBO(
    (component(red) * 255).round(),
    (component(green) * 255).round(),
    (component(blue) * 255).round(),
    1,
  );
}

/// Blends known emitter wheels into an approximate RGB preview.
Color? _colorFromEmitters(FreeRFRContext ctx) {
  const emitterColors = <String, List<double>>{
    'amber': [1, 0.6, 0],
    'blue': [0, 0, 1],
    'cyan': [0, 1, 1],
    'green': [0, 1, 0],
    'indigo': [0.3, 0, 1],
    'lime': [0.6, 1, 0],
    'magenta': [1, 0, 1],
    'orange': [1, 0.5, 0],
    'pink': [1, 0.4, 0.6],
    'red': [1, 0, 0],
    'red oran': [1, 0.35, 0],
    'ultraviolet': [0.25, 0, 0.6],
    'uv': [0.25, 0, 0.6],
    'white': [1, 1, 1],
    'yellow': [1, 1, 0],
  };

  var red = 0.0;
  var green = 0.0;
  var blue = 0.0;
  var found = false;
  for (final entry in ctx.currentChannel.entries) {
    if (entry.key.role != ParameterRole.color) continue;
    final values = entry.value;
    if (values == null || values.isEmpty) continue;
    final name =
        entry.key.oscName.toLowerCase().replaceAll(RegExp(r'[_-]'), ' ');
    for (final emitter in emitterColors.entries) {
      final matches = name == emitter.key ||
          name.endsWith(' ${emitter.key}') ||
          name.startsWith('${emitter.key} ') ||
          name.contains(' ${emitter.key} ');
      if (!matches) continue;
      final level = (values.first / 100).clamp(0.0, 1.0).toDouble();
      red += emitter.value[0] * level;
      green += emitter.value[1] * level;
      blue += emitter.value[2] * level;
      found = true;
      break;
    }
  }
  if (!found) return null;

  return Color.fromRGBO(
    (red.clamp(0.0, 1.0) * 255).round(),
    (green.clamp(0.0, 1.0) * 255).round(),
    (blue.clamp(0.0, 1.0) * 255).round(),
    1,
  );
}
