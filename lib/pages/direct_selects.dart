import 'package:flutter/material.dart';
import 'package:free_rfr/objects/osc_control.dart';
import 'package:free_rfr/objects/parameters.dart';

class DirectSelects extends StatefulWidget {
  final OSC osc;
  final ParameterMap currentChannel;
  const DirectSelects(
      {super.key, required this.osc, required this.currentChannel});

  @override
  State<DirectSelects> createState() => _DirectSelectsState();
}

class _DirectSelectsState extends State<DirectSelects> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
