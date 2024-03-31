import 'package:flutter/material.dart';
import 'package:free_rfr/widgets/button.dart';

import '../../widgets/grid.dart';

class Target extends StatelessWidget {
  const Target({super.key});

  @override
  Widget build(BuildContext context) {
    List<Button> targets = [
      Button('Part', () => null),
      Button('Cue', () => null),
      Button('Record', () => null),
      Button('Preset', () => null),
      Button('Sub', () => null),
      Button('Delay', () => null),
      Button('Delete', () => null),
      Button('Copy To', () => null),
      Button('Recall From', () => null),
      Button('Update', () => null),
      Button('Q-Only/Track', () => null),
      Button('Save', () => null),
    ];
    return Grid(3, targets, 1.8);
  }
}
