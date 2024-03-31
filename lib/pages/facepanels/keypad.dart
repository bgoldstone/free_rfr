import 'package:flutter/material.dart';
import 'package:free_rfr/widgets/button.dart';
import 'package:free_rfr/widgets/grid.dart';

class Keypad extends StatelessWidget {
  const Keypad({super.key});

  @override
  Widget build(BuildContext context) {
    List<Button> keypad = [
      Button('Park', () => null, fontSize: 13),
      Button('Address', () => null, fontSize: 10),
      Button('Last', () => null, fontSize: 13),
      Button('Next', () => null, fontSize: 13),
      Button('+', () => null, fontSize: 13),
      Button('Thru', () => null, fontSize: 13),
      Button('-', () => null, fontSize: 13),
      Button('Group', () => null, fontSize: 13),
      Button('7', () => null, fontSize: 13),
      Button('8', () => null, fontSize: 13),
      Button('9', () => null, fontSize: 13),
      Button('Out', () => null, fontSize: 13),
      Button('4', () => null, fontSize: 13),
      Button('5', () => null, fontSize: 13),
      Button('6', () => null, fontSize: 13),
      Button('Full', () => null, fontSize: 13),
      Button('1', () => null, fontSize: 13),
      Button('2', () => null, fontSize: 13),
      Button('3', () => null, fontSize: 13),
      Button('At', () => null, fontSize: 13),
      Button('Clear', () => null, fontSize: 13),
      Button('0', () => null, fontSize: 13),
      Button('.', () => null, fontSize: 13),
      Button('Enter', () => null, fontSize: 13),
    ];
    return Grid(4, keypad, 2);
  }
}
