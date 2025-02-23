import 'package:flutter/material.dart';
import 'package:free_rfr/objects/osc_control.dart';
import 'package:free_rfr/objects/parameters.dart';
import 'package:free_rfr/pages/controls.dart';
import 'package:free_rfr/pages/facepanels/parameter_widget.dart';

class ShutterControl extends StatelessWidget {
  final OSC osc;
  final ParameterMap currentChannel;
  final List<ParameterType> controls = [];
  ShutterControl({super.key, required this.osc, required this.currentChannel}) {
    currentChannel.forEach((parameterType, _) {
      if (parameterType.role == ParameterRole.shutter) {
        controls.add(parameterType);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (controls.isEmpty) {
      return noParametersForThisChannel("Shutter");
    }
    List<ParameterWidget> targets = controls
        .map((parameter) => ParameterWidget(parameterType: parameter, osc: osc))
        .toList();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: targets,
      ),
    );
  }
}
