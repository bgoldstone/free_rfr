import 'package:flutter/material.dart';
import 'package:free_rfr/objects/osc_control.dart';
import 'package:free_rfr/objects/parameters.dart';
import 'package:free_rfr/pages/facepanels/parameter_widget.dart';

class ShutterControl extends StatelessWidget {
  final OSC osc;
  final ParameterMap currentChannel;
  const ShutterControl(
      {super.key, required this.osc, required this.currentChannel});

  @override
  Widget build(BuildContext context) {
    return ParameterWidgets(
        role: ParameterRole.shutter, currentChannel: currentChannel, osc: osc);
  }
}
