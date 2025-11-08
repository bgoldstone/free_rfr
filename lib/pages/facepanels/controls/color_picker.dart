import 'package:flutter/material.dart';
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
    Color colorFromEos = ctx.hueSaturation.isNotEmpty
        ? HSLColor.fromAHSL(1, ctx.hueSaturation[0], ctx.hueSaturation[1], 1)
            .toColor()
        : Colors.white;
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        ColorPicker(
          pickerColor: currentColor ?? colorFromEos,
          onColorChanged: (newColor) {
            widget.osc.sendColor(newColor.r.round() / 255,
                newColor.g.round() / 255, newColor.b.round() / 255);
            currentColor = newColor;
          },
          enableAlpha: false,
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
