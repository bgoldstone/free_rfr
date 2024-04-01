import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:free_rfr/objects/osc_control.dart';
import 'package:free_rfr/objects/parameters.dart';

class ColorControl extends StatefulWidget {
  final OSC osc;
  final ParameterList currentChannel;
  final List<double> hueSaturation;
  const ColorControl(
    this.osc, {
    required this.currentChannel,
    required this.hueSaturation,
    super.key,
  });

  @override
  State<ColorControl> createState() => _ColorControlState();
}

class _ColorControlState extends State<ColorControl> {
  int index = 0;
  Color? currentColor;
  @override
  Widget build(BuildContext context) {
    Color colorFromEos = widget.hueSaturation.isNotEmpty
        ? HSLColor.fromAHSL(
                1, widget.hueSaturation[0], widget.hueSaturation[1], 1)
            .toColor()
        : Colors.white;
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        ColorPicker(
          pickerColor: currentColor ?? colorFromEos,
          onColorChanged: (newColor) {
            widget.osc.sendColor(
                newColor.red / 255, newColor.green / 255, newColor.blue / 255);
            currentColor = newColor;
          },
          enableAlpha: false,
          paletteType: PaletteType.hueWheel,
        ),
        // TODO: implement this page.
        // ElevatedButton(
        //     onPressed: () {
        //       Navigator.of(context).push(
        //         MaterialPageRoute(
        //           builder: (context) => colorSliderControl(widget.osc),
        //         ),
        //       );
        //     },
        //     child: const Text("Color Sliders")),
      ]),
    );
  }
}

Widget colorSliderControl(OSC osc) {
  return Scaffold(
      appBar: AppBar(title: const Text('Color Adjustments')),
      body: const Row());
}
