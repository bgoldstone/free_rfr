import 'package:flutter/material.dart';
import 'package:free_rfr/objects/osc_control.dart';
import 'package:free_rfr/objects/parameters.dart';
import 'package:free_rfr/pages/facepanels/parameter_widget.dart';

class FocusControl extends StatelessWidget {
  final OSC osc;
  final ParameterMap currentChannel;
  const FocusControl(
      {super.key, required this.osc, required this.currentChannel});

  @override
  Widget build(BuildContext context) {
    return ParameterWidgets(
      role: ParameterRole.focus,
      currentChannel: currentChannel,
      osc: osc,
    );
  }
}
