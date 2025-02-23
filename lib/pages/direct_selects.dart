import 'package:flutter/material.dart';
import 'package:free_rfr/objects/osc_control.dart';
import 'package:free_rfr/objects/parameters.dart';

class DirectSelects extends StatelessWidget {
  final OSC osc;
  final ParameterMap currentChannel;
  const DirectSelects(
      {super.key, required this.osc, required this.currentChannel});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      "Coming Soon!",
      style: TextStyle(fontSize: MediaQuery.of(context).size.aspectRatio * 15),
    ));
  }
}
