import 'package:flutter/material.dart';
import 'package:free_rfr/osc_control.dart';
import 'package:free_rfr/widgets/button.dart';

import '../../widgets/grid.dart';

class Target extends StatelessWidget {
  final OSC osc;
  const Target({required this.osc, super.key});

  @override
  Widget build(BuildContext context) {
    List<Button> targets = [
      Button('Part', () => osc.sendKey('part')),
      Button('Cue', () => osc.sendKey('cue')),
      Button('Record', () => osc.sendKey('record')),
      Button('Preset', () => osc.sendKey('preset')),
      Button('Sub', () => osc.sendKey('sub')),
      Button('Delay', () => osc.sendKey('delay')),
      Button('Delete', () => osc.sendKey('delete')),
      Button('Copy To', () => osc.sendKey('copy_to')),
      Button('Recall From', () => osc.sendKey('recall_from')),
      Button('Update', () => osc.sendKey('update')),
      Button('Q-Only/Track', () => osc.sendKey('cueonlytrack')),
      Button('Save', () => osc.sendKey('save')),
    ];
    return Grid(3, targets, 1.8);
  }
}
