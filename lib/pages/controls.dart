import 'package:flutter/material.dart';
import 'package:free_rfr/objects/osc_control.dart';
import 'package:free_rfr/pages/facepanels/controls/color.dart';
import 'package:free_rfr/pages/facepanels/controls/color_picker.dart';
import 'package:free_rfr/pages/facepanels/controls/pan_tilt_control.dart';

import '../objects/parameters.dart';
import 'facepanels/controls/focus.dart';
import 'facepanels/controls/form.dart';
import 'facepanels/controls/image.dart';
import 'facepanels/controls/intensity.dart';
// import 'facepanels/controls/shutter.dart';

class Controls extends StatefulWidget {
  final OSC osc;
  final ParameterMap Function() getCurrentChannel;
  final List<double> hueSaturation;
  const Controls(
      {required this.osc,
      required this.getCurrentChannel,
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
        currentChannel: widget.getCurrentChannel(),
        osc: widget.osc,
      ),
      (widget.getCurrentChannel()[ParameterType.pan] != null &&
              widget.getCurrentChannel()[ParameterType.tilt] != null &&
              widget.getCurrentChannel()[ParameterType.maxPan] != null &&
              widget.getCurrentChannel()[ParameterType.maxTilt] != null &&
              widget.getCurrentChannel()[ParameterType.minPan] != null &&
              widget.getCurrentChannel()[ParameterType.minTilt] != null)
          ? PanTiltControl(
              currentChannel: widget.getCurrentChannel(),
              osc: widget.osc,
            )
          : noParametersForThisChannel("Pan Tilt"),
      FocusControl(
        osc: widget.osc,
        currentChannel: widget.getCurrentChannel(),
      ),
      widget.hueSaturation.isNotEmpty &&
              getParameterForType(
                      widget.getCurrentChannel(), ParameterRole.color)
                  .isNotEmpty
          ? ColorPickerControl(widget.osc,
              currentChannel: widget.getCurrentChannel(),
              hueSaturation: widget.hueSaturation)
          : noParametersForThisChannel("Color Picker"),
      ColorControl(osc: widget.osc, currentChannel: widget.getCurrentChannel()),
      // ShutterControl(
      //   osc: widget.osc,
      //   currentChannel: widget.getCurrentChannel(),
      // ),
      ImageControl(
        osc: widget.osc,
        currentChannel: widget.getCurrentChannel(),
      ),
      FormControl(
        osc: widget.osc,
        currentChannel: widget.getCurrentChannel(),
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
            icon: Icon(Icons.colorize),
            label: 'Color Picker',
            tooltip: 'Color Picker',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.palette),
            label: 'Color',
            tooltip: 'Color',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.crop),
          //   label: 'Shutter',
          //   tooltip: 'Shutter',
          // ),
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
