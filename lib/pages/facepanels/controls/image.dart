import 'package:flutter/material.dart';
import 'package:free_rfr/objects/osc_control.dart';
import 'package:free_rfr/objects/parameters.dart';
import 'package:free_rfr/widgets/parameter_widget.dart';

class ImageControl extends StatefulWidget {
  final OSC osc;
  const ImageControl({super.key, required this.osc});

  @override
  State<ImageControl> createState() => _FocusControlState();
}

class _FocusControlState extends State<ImageControl> {
  @override
  Widget build(BuildContext context) {
    return ParameterWidgets(
      role: ParameterRole.image,
      osc: widget.osc,
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
