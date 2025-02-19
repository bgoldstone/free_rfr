import 'package:flutter/material.dart';
import 'package:free_rfr/objects/osc_control.dart';
import 'package:free_rfr/objects/parameters.dart';
import 'package:free_rfr/pages/facepanels/parameter_widget.dart';
import 'package:free_rfr/shortcuts.dart';

class FocusControl extends StatefulWidget {
  final OSC osc;
  final ParameterMap currentChannel;
  const FocusControl(
      {super.key, required this.osc, required this.currentChannel});

  @override
  State<FocusControl> createState() => _FocusControlState();
}

class _FocusControlState extends State<FocusControl> {
  @override
  Widget build(BuildContext context) {
    return FreeRFRShortcutManager(
      ParameterWidgets(
        type: 'Focus',
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
