import 'package:flutter/material.dart';
import 'package:free_rfr/objects/osc_control.dart';
import 'package:free_rfr/pages/controls/color.dart';
import 'package:free_rfr/pages/controls/pan_tilt_control.dart';

import '../objects/parameters.dart';
import 'controls/focus.dart';
import 'controls/form.dart';
import 'controls/image.dart';
import 'controls/intensity.dart';
import 'controls/shutter.dart';

class Controls extends StatefulWidget {
  final OSC osc;
  final ParameterMap currentChannel;
  final List<double> hueSaturation;
  const Controls(
      {required this.osc,
      required this.currentChannel,
      required this.hueSaturation,
      super.key});

  @override
  State<Controls> createState() => _ControlsState();
}

class _ControlsState extends State<Controls> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      IntensityControl(currentChannel: widget.currentChannel, osc: widget.osc),
      PanTiltControl(currentChannel: widget.currentChannel, osc: widget.osc),
      FocusControl(osc: widget.osc, currentChannel: widget.currentChannel),
      ColorControl(widget.osc,
          currentChannel: widget.currentChannel,
          hueSaturation: widget.hueSaturation),
      const ShutterControl(),
      const ImageControl(),
      const FormControl()
    ];
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.brightness_medium_rounded),
            label: 'Intensity',
            tooltip: 'Intensity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pan_tool),
            label: 'Pan/Tilt',
            tooltip: 'Pan/Tilt',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.center_focus_strong),
            label: 'Focus',
            tooltip: 'Focus',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.color_lens),
            label: 'Color',
            tooltip: 'Color',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.crop),
            label: 'Shutter',
            tooltip: 'Shutter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: 'Image',
            tooltip: 'Image',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.crop_free),
            label: 'Form',
            tooltip: 'Form',
          ),
        ],
        currentIndex: index,
        onTap: (index) => setState(() => this.index = index),
        selectedItemColor: Colors.yellow,
        unselectedItemColor:
            MediaQuery.of(context).platformBrightness == Brightness.dark
                ? Colors.white
                : Colors.black,
        showSelectedLabels: true,
      ),
      body: pages[index],
    );
  }
}

class ControlFader {
  String name = "";
  ParameterType parameter;
  double parameterValue;

  ControlFader(this.name, this.parameter, this.parameterValue);

  Widget buildFader(OSC osc, ParameterType parameterType,
      void Function(ParameterType, double) updateState) {
    return SizedBox(
        height: 400,
        child: Card(
            child: Column(
          children: [
            Text(name),
            RotatedBox(
              quarterTurns: 3,
              child: Slider(
                value: parameterValue,
                min: parameter.minValue,
                max: parameter.maxValue,
                onChanged: (newValue) {
                  osc.sendCmd(
                      "select_last ${name.replaceAll(" ", "_")} $parameterValue#");
                  updateState(parameterType, newValue);
                },
                onChangeEnd: (value) {},
              ),
            )
          ],
        )));
  }
}

Center noParametersForThisChannel(String parameterTypes) {
  return Center(
    child: Text(
      "No $parameterTypes Controls for this channel",
      textAlign: TextAlign.center,
    ),
  );
}
