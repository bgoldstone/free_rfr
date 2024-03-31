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
      Button('Part', () {
        osc.sendKey('part', setCommandLine);
      }),
      Button('Cue', () {
        osc.sendKey('cue', setCommandLine);
      }),
      Button('Record', () {
        osc.sendKey('record', setCommandLine);
      }),
      Button('Preset', () {
        osc.sendKey('preset', setCommandLine);
      }),
      Button('Sub', () {
        osc.sendKey('sub', setCommandLine);
      }),
      Button('Delay', () {
        osc.sendKey('delay', setCommandLine);
      }),
      Button('Delete', () {
        osc.sendKey('delete', setCommandLine);
      }),
      Button('Copy To', () {
        osc.sendKey('copy_to', setCommandLine);
      }),
      Button('Recall From', () {
        osc.sendKey('recall_from', setCommandLine);
      }),
      Button('Update', () {
        osc.sendKey('update', setCommandLine);
      }),
      Button('Q-Only/Track', () {
        osc.sendKey('cueonlytrack', setCommandLine);
      }),
      Button('Save', () {
        osc.sendKey('save', setCommandLine);
      }),
    ];
    return Grid(3, targets, 1.8);
  }
}
