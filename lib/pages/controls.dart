import 'package:flutter/material.dart';
import 'package:free_rfr/osc_control.dart';
import 'package:free_rfr/pages/controls/color.dart';
import 'package:free_rfr/pages/controls/focus.dart';
import 'package:free_rfr/pages/controls/form.dart';
import 'package:free_rfr/pages/controls/image.dart';
import 'package:free_rfr/pages/controls/intensity.dart';
import 'package:free_rfr/pages/controls/shutter.dart';
import 'package:free_rfr/parameters.dart';

class Controls extends StatefulWidget {
  final OSC osc;
  final ParameterList currentChannel;
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
      const FocusControl(),
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
