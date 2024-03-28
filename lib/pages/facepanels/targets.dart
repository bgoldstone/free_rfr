import 'package:flutter/material.dart';
import 'package:free_rfr/widgets/button.dart';

import '../../widgets/grid.dart';

class Target extends StatefulWidget {
  const Target({super.key});

  @override
  State<Target> createState() => _TargetState();
}

class _TargetState extends State<Target> {
  @override
  Widget build(BuildContext context) {
    List<Button> targets = [
      Button('Part', () => null),
      Button('Cue', () => null),
      Button('Record', () => null),
      Button('Update', () => null),
      Button('Preset', () => null),
      Button('Sub', () => null),
      Button('Group', () => null),
      Button('Delay', () => null),
      Button('Time', () => null),
      Button('Copy To', () => null),
      Button('Save', () => null),
      Button('Recall From', () => null),
    ];
    return Grid(3, targets, 1.8);
  }
}
