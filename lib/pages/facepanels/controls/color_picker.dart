import 'package:material_ui/material_ui.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:free_rfr/configurations/context.dart';
import 'package:free_rfr/objects/osc_control.dart';
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
  Color? currentColor;

  @override
  Widget build(BuildContext context) {
    final ctx = context.watch<FreeRFRContext>();
    Color? colorFromWheels = _colorFromWheels(ctx);
    Color colorFromEos = colorFromWheels ??
        (ctx.hueSaturation.length >= 2
            ? HSVColor.fromAHSV(
                1,
                ctx.hueSaturation[0],
                ctx.hueSaturation[1],
                1,
              ).toColor()
            : Colors.white);
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

/// Builds a preview color from the active color wheels.
///
/// Prefers explicit hue/saturation wheels, then RGB/RGBW values, then CMY
/// values. Returns null when the active color wheels do not describe a color.
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
    return null;
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
