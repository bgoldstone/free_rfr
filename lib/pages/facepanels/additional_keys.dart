import 'package:flutter/material.dart';
import 'package:free_rfr/osc_control.dart';
import 'package:free_rfr/widgets/button.dart';
import 'package:free_rfr/widgets/grid.dart';

class AdditionalKeys extends StatelessWidget {
  final OSC osc;
  const AdditionalKeys({required this.osc, super.key});

  @override
  Widget build(BuildContext context) {
    List<Button> additionalKeys = [
      Button('Mark', () => null),
      Button('Sneak', () => null),
      Button('Rem Dim', () => null),
      Button('Select Manual', () => null),
      Button('Select Last', () => null),
      Button('Select Active', () => null),
      Button('Home', () => null),
      Button('Level', () => null),
      Button('Time', () => null),
      Button('Live', () => null),
      Button('Blind', () => null),
      Button('Undo', () => null),
    ];
    return Grid(3, additionalKeys, 1.8);
  }
}
