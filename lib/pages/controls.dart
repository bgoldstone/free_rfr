import 'package:flutter/material.dart';
import 'package:free_rfr/configurations/context.dart';
import 'package:free_rfr/objects/osc_control.dart';
import 'package:free_rfr/pages/facepanels/controls/color.dart';
import 'package:free_rfr/pages/facepanels/controls/color_picker.dart';
import 'package:free_rfr/pages/facepanels/controls/pan_tilt_control.dart';
import 'package:provider/provider.dart';

import '../objects/parameters.dart';
import 'facepanels/controls/focus.dart';
import 'facepanels/controls/form.dart';
import 'facepanels/controls/image.dart';
import 'facepanels/controls/intensity.dart';
// import 'facepanels/controls/shutter.dart';

class Controls extends StatefulWidget {
  final OSC osc;
  const Controls({required this.osc, super.key});

  @override
  State<Controls> createState() => _ControlsState();
}

class _ControlsState extends State<Controls> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final ctx = context.watch<FreeRFRContext>();
    List<Widget> pages = [
      IntensityControl(
        osc: widget.osc,
      ),
      (ctx.currentChannel[ParameterType.pan] != null &&
              ctx.currentChannel[ParameterType.tilt] != null &&
              ctx.currentChannel[ParameterType.maxPan] != null &&
              ctx.currentChannel[ParameterType.maxTilt] != null &&
              ctx.currentChannel[ParameterType.minPan] != null &&
              ctx.currentChannel[ParameterType.minTilt] != null)
          ? PanTiltControl(
              osc: widget.osc,
            )
          : noParametersForThisChannel("Pan Tilt"),
      FocusControl(
        osc: widget.osc,
      ),
      ctx.hueSaturation.isNotEmpty &&
              getParameterForType(ctx.currentChannel, ParameterRole.color)
                  .isNotEmpty
          ? ColorPickerControl(widget.osc)
          : noParametersForThisChannel("Color Picker"),
      ColorControl(osc: widget.osc),
      // ShutterControl(
      //   osc: widget.osc,
      //   currentChannel: widget.getCurrentChannel(),
      // ),
      ImageControl(
        osc: widget.osc,
      ),
      FormControl(
        osc: widget.osc,
      )
    ];
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        showUnselectedLabels: true,
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
