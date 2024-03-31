import 'package:flutter/material.dart';
import 'package:free_rfr/osc_control.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorControl extends StatefulWidget {
  final OSC osc;
  ColorControl(this.osc, {super.key});

  @override
  State<ColorControl> createState() => _ColorControlState();
}

class _ColorControlState extends State<ColorControl> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        ColorPicker(
          pickerColor: Colors.white,
          onColorChanged: (newColor) => widget.osc.sendColor(
              newColor.red / 255, newColor.green / 255, newColor.blue / 255),
          enableAlpha: false,
          paletteType: PaletteType.hsvWithValue,
        ),
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => manualRGBControl(widget.osc),
                ),
              );
            },
            child: const Text("Color Sliders")),
      ]),
    );
  }
}

Widget manualRGBControl(OSC osc) {
  return Scaffold(
      appBar: AppBar(title: Text('Color Adjustments')), body: const Row());
}
