import 'package:flutter/material.dart';
import 'package:free_rfr/objects/osc_control.dart';
import 'package:free_rfr/pages/facepanels/controls/color.dart';
import 'package:free_rfr/pages/facepanels/controls/pan_tilt_control.dart';

import '../objects/parameters.dart';
import 'facepanels/controls/focus.dart';
import 'facepanels/controls/form.dart';
import 'facepanels/controls/image.dart';
import 'facepanels/controls/intensity.dart';
import 'facepanels/controls/shutter.dart';

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
      IntensityControl(
        currentChannel: widget.currentChannel,
        osc: widget.osc,
      ),
      (widget.currentChannel[ParameterType.pan] != null &&
              widget.currentChannel[ParameterType.tilt] != null &&
              widget.currentChannel[ParameterType.maxPan] != null &&
              widget.currentChannel[ParameterType.maxTilt] != null &&
              widget.currentChannel[ParameterType.minPan] != null &&
              widget.currentChannel[ParameterType.minTilt] != null)
          ? PanTiltControl(
              currentChannel: widget.currentChannel,
              osc: widget.osc,
            )
          : noParametersForThisChannel("Pan Tilt"),
      FocusControl(
        osc: widget.osc,
        currentChannel: widget.currentChannel,
      ),
      widget.hueSaturation.isNotEmpty
          ? ColorControl(widget.osc,
              currentChannel: widget.currentChannel,
              hueSaturation: widget.hueSaturation)
          : noParametersForThisChannel("Color"),
      ShutterControl(
        osc: widget.osc,
        currentChannel: widget.currentChannel,
      ),
      ImageControl(
        osc: widget.osc,
        currentChannel: widget.currentChannel,
      ),
      FormControl(
        osc: widget.osc,
        currentChannel: widget.currentChannel,
      )
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
        onTap: (index) => setState(() {
          this.index = index;
        }),
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

  @override
  void initState() {
    super.initState();
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
