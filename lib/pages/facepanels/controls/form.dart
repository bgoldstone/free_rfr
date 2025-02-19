import 'package:flutter/material.dart';
import 'package:free_rfr/objects/osc_control.dart';
import 'package:free_rfr/objects/parameters.dart';
import 'package:free_rfr/pages/facepanels/parameter_widget.dart';
import 'package:free_rfr/shortcuts.dart';

class FormControl extends StatefulWidget {
  final OSC osc;
  final ParameterMap currentChannel;
  const FormControl(
      {super.key, required this.osc, required this.currentChannel});

  @override
  State<FormControl> createState() => _FocusControlState();
}

class _FocusControlState extends State<FormControl> {
  @override
  Widget build(BuildContext context) {
    return FreeRFRShortcutManager(
      ParameterWidgets(
        type: 'Form',
        currentChannel: widget.currentChannel,
        osc: widget.osc,
      ),
      widget.osc,
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
