import 'package:flutter/material.dart';
import 'package:free_rfr/osc_control.dart';

class CueList extends StatefulWidget {
  final OSC osc;
  final void Function(String) setCommandLine;
  const CueList({required this.osc, super.key, required this.setCommandLine});

  @override
  State<CueList> createState() => _CueListState();
}

class _CueListState extends State<CueList> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
