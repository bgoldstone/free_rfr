import 'package:flutter/material.dart';
import 'package:free_rfr/objects/osc_control.dart';
import 'package:free_rfr/objects/parameters.dart';
import 'package:free_rfr/pages/facepanels/parameter_widget.dart';

class ImageControl extends StatefulWidget {
  final OSC osc;
  final ParameterMap currentChannel;
  final List<ParameterType> controls = [];
  ImageControl({super.key, required this.osc, required this.currentChannel}) {
    currentChannel.forEach((parameterType, _) {
      debugPrint(parameterType.oscName);
      if (parameterType.role == ParameterRole.image) {
        debugPrint(parameterType.oscName);
        controls.add(parameterType);
      }
    });
  }

  @override
  State<ImageControl> createState() => _FocusControlState();
}

class _FocusControlState extends State<ImageControl> {
  @override
  Widget build(BuildContext context) {
    return ParameterWidgets(
      type: "Image",
      currentChannel: widget.currentChannel,
      osc: widget.osc,
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
