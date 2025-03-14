import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:free_rfr/extensions/Extensions.dart';
import 'package:free_rfr/free_rfr.dart';
import 'package:free_rfr/objects/osc_control.dart';
import 'package:free_rfr/objects/parameters.dart';
import 'package:free_rfr/widgets/cie_colorpicker.dart';

import 'intensity.dart';

class ColorControl extends StatefulWidget {
  final OSC osc;
  final ParameterMap currentChannel;
  const ColorControl(
    this.osc, {
    required this.currentChannel,
    super.key,
  });

  @override
  State<ColorControl> createState() => ColorControlState();
}

class ColorControlState extends ControlWidget<ColorControl> {
  int index = 0;
  Color? currentColor;
  ParameterMap? currentChannel;

  final List<Map<String, dynamic>> colors = [
    {'name': '2700 K', 'color': Color(0xFFFFFFFF).kelvinToRGB(2700)},
    {'name': '2800 K', 'color': Color(0xFFFFFFFF).kelvinToRGB(2800)},
    {'name': '2900 K', 'color': Color(0xFFFFFFFF).kelvinToRGB(2900)},
    {'name': '3000 K', 'color': Color(0xFFFFFFFF).kelvinToRGB(3000)},
    {'name': '3100 K', 'color': Color(0xFFFFFFFF).kelvinToRGB(3100)},
    {'name': '3200 K', 'color': Color(0xFFFFFFFF).kelvinToRGB(3200)},
    {'name': '3300 K', 'color': Color(0xFFFFFFFF).kelvinToRGB(3300)},
    {'name': '3400 K', 'color': Color(0xFFFFFFFF).kelvinToRGB(3400)},
    {'name': '3500 K', 'color': Color(0xFFFFFFFF).kelvinToRGB(3500)},
    {'name': '3600 K', 'color': Color(0xFFFFFFFF).kelvinToRGB(3600)},
    {'name': '3700 K', 'color': Color(0xFFFFFFFF).kelvinToRGB(3700)},
    {'name': '3800 K', 'color':Color(0xFFFFFFFF).kelvinToRGB(3800)},
    {'name': '3900 K', 'color': Color(0xFFFFFFFF).kelvinToRGB(3900)},
    {'name': '4000 K', 'color': Color(0xFFFFFFFF).kelvinToRGB(4000)},
    {'name': '4100 K', 'color': Color(0xFFFFFFFF).kelvinToRGB(4100)},
    {'name': '4200 K', 'color': Color(0xFFFFFFFF).kelvinToRGB(4200)},
    {'name': '4300 K', 'color': Color(0xFFFFFFFF).kelvinToRGB(4300)},
    {'name': '4400 K', 'color': Color(0xFFFFFFFF).kelvinToRGB(4400)},
    {'name': '4500 K', 'color': Color(0xFFFFFFFF).kelvinToRGB(4500)},
    {'name': '4600 K', 'color': Color(0xFFFFFFFF).kelvinToRGB(4600)},
    {'name': '4700 K', 'color': Color(0xFFFFFFFF).kelvinToRGB(4700)},
    {'name': '4800 K', 'color': Color(0xFFFFFFFF).kelvinToRGB(4800)},
    {'name': '4900 K', 'color': Color(0xFFFFFFFF).kelvinToRGB(4900)},
    {'name': '5000 K', 'color': Color(0xFFFFFFFF).kelvinToRGB(5000)},
    {'name': '5100 K', 'color': Color(0xFFFFFFFF).kelvinToRGB(5100)},
    {'name': '5200 K', 'color': Color(0xFFFFFFFF).kelvinToRGB(5200)},
    {'name': '5300 K', 'color': Color(0xFFFFFFFF).kelvinToRGB(5300)},
    {'name': '5400 K', 'color': Color(0xFFFFFFFF).kelvinToRGB(5400)},
    {'name': '5500 K', 'color': Color(0xFFFFFFFF).kelvinToRGB(5500)},
    {'name': '5600 K', 'color': Color(0xFFFFFFFF).kelvinToRGB(5600)},
    {'name': '5700 K', 'color': Color(0xFFFFFFFF).kelvinToRGB(5700)},
    {'name': '5800 K', 'color': Color(0xFFFFFFFF).kelvinToRGB(5800)},
    {'name': '5900 K', 'color': Color(0xFFFFFFFF).kelvinToRGB(5900)},
    {'name': '6000 K', 'color': Color(0xFFFFFFFF).kelvinToRGB(6000)},
    {'name': '6100 K', 'color': Color(0xFFFFFFFF).kelvinToRGB(6100)},
    {'name': '6200 K', 'color': Color(0xFFFFFFFF).kelvinToRGB(6200)},
    {'name': '6300 K', 'color': Color(0xFFFFFFFF).kelvinToRGB(6300)},
    {'name': '6400 K', 'color': Color(0xFFFFFFFF).kelvinToRGB(6400)},
    {'name': '6500 K', 'color': Color(0xFFFFFFFF).kelvinToRGB(6500)},

    {'name': '6500 K', 'color': Colors.white},
    {'name': 'Red', 'color': Color(0xFFFF0000)},
    {'name': 'Red 75%', 'color': Colors.red.shade500},
    {'name': 'Red 50%', 'color': Colors.red.shade300},
    {'name': 'Red 25%', 'color': Colors.red.shade100},
    {'name': 'Orange', 'color': Colors.orange},
    {'name': 'Orange 75%', 'color': Colors.orange.shade300},
    {'name': 'Orange 50%', 'color': Colors.orange.shade200},
    {'name': 'Orange 25%', 'color': Colors.orange.shade100},
    {'name': 'Yellow', 'color': Colors.yellow},
    {'name': 'Yellow 75%', 'color': Colors.yellow.shade300},
    {'name': 'Yellow 50%', 'color': Colors.yellow.shade200},
    {'name': 'Yellow 25%', 'color': Colors.yellow.shade100},
    {'name': 'Green', 'color': Color(0xFF00FF00)},
    {'name': 'Green 75%', 'color': Colors.greenAccent.shade400},
    {'name': 'Green 50%', 'color': Colors.greenAccent.shade200},
    {'name': 'Green 25%', 'color': Colors.greenAccent.shade100},
    {'name': 'Blue', 'color': Colors.blue},
    {'name': 'Blue 75%', 'color': Colors.blue.shade300},
    {'name': 'Blue 50%', 'color': Colors.blue.shade200},
    {'name': 'Blue 25%', 'color': Colors.blue.shade100},
    {'name': 'Purple', 'color': Colors.purple},
    {'name': 'Purple 75%', 'color': Colors.purple.shade300},
    {'name': 'Purple 50%', 'color': Colors.purple.shade200},
    {'name': 'Purple 25%', 'color': Colors.purple.shade100},
    {'name': 'Pink', 'color': Colors.pink},
    {'name': 'Pink 75%', 'color': Colors.pink.shade300},
    {'name': 'Pink 50%', 'color': Colors.pink.shade200},
    {'name': 'Pink 25%', 'color': Colors.pink.shade100},
  ];

  ColorControlState()
      : super(controllingParameters: [
          ParameterType.hue,
          ParameterType.saturation
        ]);

  @override
  void initState() {
    super.initState();
    currentChannel ??= widget.currentChannel;
    widget.osc.registerControlState(this);
  }

  @override
  void updateCurrentChannel(ParameterMap map) {
    if (!mounted) return;
    setState(() {
      currentChannel = map;
    });
  }

  void updateCurrentColor(double hue, double saturation) {
    if (!mounted) return;
    setState(() {
      currentChannel ??= widget.currentChannel;
      currentChannel![ParameterType.hue] = [2, hue];
      currentChannel![ParameterType.saturation] = [3, saturation];
      debugPrint(currentChannel.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!currentChannel!.containsKey(ParameterType.hue) ||
        !currentChannel!.containsKey(ParameterType.saturation)) {
      return Empty(widget.osc, "Color");
    }
    Color colorFromEos = HSVColor.fromAHSV(
            1,
            currentChannel![ParameterType.hue]![1],
            currentChannel![ParameterType.saturation]![1],
            1)
        .toColor();
    currentColor = colorFromEos;
    return Scaffold(
      body: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        CieXyColorPicker(
          currentColor: currentColor ?? colorFromEos,
          onColorChanged: (c) {
            var newColor = c.toColor();
            widget.osc.sendColor(
                newColor.red / 255, newColor.green / 255, newColor.blue / 255);
            for (var c in widget.osc.currentChannel) {
              FreeRFR.sheet?.channels
                  .where((element) => element.number == c)
                  .first
                  .color = newColor;
            }
            currentColor = newColor;
          },
          /*
          enableAlpha: false,
          paletteType: PaletteType.hueWheel,

           */
        ),
      SizedBox(
          width: 150 + MediaQuery.of(context).size.width * 0.2,
          height: MediaQuery.of(context).size.height,
          child:
        GridView.count(
              crossAxisCount: 5,
              children: List.generate(
                colors.length,
                (index) {
                  return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors[index]['color'],
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () {
                        widget.osc.sendColor(
                            colors[index]['color'].red / 255,
                            colors[index]['color'].green / 255,
                            colors[index]['color'].blue / 255);
                        for (var c in widget.osc.currentChannel) {
                          FreeRFR.sheet?.channels
                              .where((element) => element.number == c)
                              .first
                              .color = colors[index]['color'];
                        }
                      },
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: Text(
                          colors[index]['name'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ));
                },
              ),
            ))
      ]),
    );
  }

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
}

Widget colorSliderControl(OSC osc) {
  return Scaffold(
      appBar: AppBar(title: const Text('Color Adjustments')),
      body: const Row());
}
