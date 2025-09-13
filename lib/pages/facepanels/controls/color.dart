import 'package:flutter/material.dart';
import 'package:free_rfr/objects/osc_control.dart';
import 'package:free_rfr/objects/parameters.dart';
import 'package:free_rfr/widgets/parameter_widget.dart';

class ColorControl extends StatelessWidget {
  final OSC osc;
  const ColorControl({super.key, required this.osc});

  @override
  Widget build(BuildContext context) {
    return ParameterWidgets(
      role: ParameterRole.color,
      osc: osc,
    );
  }
}
