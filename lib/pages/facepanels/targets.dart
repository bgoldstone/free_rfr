import 'package:flutter/material.dart';
import 'package:free_rfr/osc_control.dart';
import 'package:free_rfr/widgets/button.dart';

import '../../widgets/grid.dart';

class Target extends StatelessWidget {
  final OSC osc;
  final void Function(String) setCommandLine;
  const Target({required this.osc, super.key, required this.setCommandLine});

  @override
  Widget build(BuildContext context) {
    List<Button> targets = [
      Button('Part', () {osc.sendKey('part'); osc.setCommandLine(setCommandLine);}),
      Button('Cue', () {osc.sendKey('cue'); osc.setCommandLine(setCommandLine);}),
      Button('Record', () {osc.sendKey('record'); osc.setCommandLine(setCommandLine);}),
      Button('Preset', () {osc.sendKey('preset'); osc.setCommandLine(setCommandLine);}),
      Button('Sub', () {osc.sendKey('sub'); osc.setCommandLine(setCommandLine);}),
      Button('Delay', () {osc.sendKey('delay'); osc.setCommandLine(setCommandLine);}),
      Button('Delete', () {osc.sendKey('delete'); osc.setCommandLine(setCommandLine);}),
      Button('Copy To', () {osc.sendKey('copy_to'); osc.setCommandLine(setCommandLine);}),
      Button('Recall From', () {osc.sendKey('recall_from'); osc.setCommandLine(setCommandLine);}),
      Button('Update', () {osc.sendKey('update'); osc.setCommandLine(setCommandLine);}),
      Button('Q-Only/Track', () {osc.sendKey('cueonlytrack'); osc.setCommandLine(setCommandLine);}),
      Button('Save', () {osc.sendKey('save'); osc.setCommandLine(setCommandLine);}),
    ];
    return Grid(3, targets, 1.8);
  }
}
