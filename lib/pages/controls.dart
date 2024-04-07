import 'package:flutter/material.dart';
import 'package:free_rfr/objects/osc_control.dart';
import 'package:free_rfr/objects/parameters.dart';
import 'package:free_rfr/pages/controls/color.dart';
import 'package:free_rfr/pages/controls/parameter_control.dart';

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
      ParameterControl(
        currentChannel: widget.currentChannel,
        osc: widget.osc,
      ),
      ColorControl(widget.osc,
          currentChannel: widget.currentChannel,
          hueSaturation: widget.hueSaturation),
    ];
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Parameters',
            tooltip: 'Parameters',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.color_lens),
            label: 'Color',
            tooltip: 'Color',
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
