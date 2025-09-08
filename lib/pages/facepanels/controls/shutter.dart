import 'package:flutter/material.dart';
import 'package:free_rfr/objects/osc_control.dart';
import 'package:free_rfr/objects/parameters.dart';
import 'package:free_rfr/pages/facepanels/parameter_widget.dart';

class ShutterControl extends StatelessWidget {
  final OSC osc;
  const ShutterControl({super.key, required this.osc});

  @override
  Widget build(BuildContext context) {
    return ParameterWidgets(role: ParameterRole.shutter, osc: osc);
  }
}
