import 'package:flutter/material.dart';
import 'package:free_rfr/objects/osc_control.dart';
import 'package:free_rfr/objects/parameters.dart';
import 'package:free_rfr/pages/controls.dart';
import 'package:free_rfr/pages/facepanels/parameter_widget.dart';

class ShutterControl extends StatefulWidget {
  final OSC osc;
  final ParameterMap currentChannel;
  List<ParameterType> controls = [];
  ShutterControl({super.key, required this.osc, required this.currentChannel}) {
    currentChannel.forEach((parameterType, _) {
      if (parameterType.role == ParameterRole.shutter) {
        controls.add(parameterType);
      }
    });
  }

  @override
  State<ShutterControl> createState() => _FocusControlState();
}

class _FocusControlState extends State<ShutterControl> {
  @override
  Widget build(BuildContext context) {
    if (widget.controls.isEmpty) {
      return noParametersForThisChannel("Shutter");
    }
    List<ParameterWidget> targets = widget.controls
        .map((parameter) =>
            ParameterWidget(parameterType: parameter, osc: widget.osc))
        .toList();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: targets,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
