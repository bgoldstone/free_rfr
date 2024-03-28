import 'package:flutter/material.dart';

import '../../widgets/button.dart';
import '../../widgets/grid.dart';

class Keypad extends StatefulWidget {
  const Keypad({super.key});

  @override
  State<Keypad> createState() => _KeypadState();
}

class _KeypadState extends State<Keypad> {
  @override
  Widget build(BuildContext context) {
    List<Button> keypad = [
      Button('+', () => null),
      Button('Thru', () => null),
      Button('-', () => null),
      Button('7', () => null),
      Button('8', () => null),
      Button('9', () => null),
      Button('4', () => null),
      Button('5', () => null),
      Button('6', () => null),
      Button('1', () => null),
      Button('2', () => null),
      Button('3', () => null),
      Button('Clear', () => null),
      Button('0', () => null),
      Button('.', () => null),
    ];
    return Grid(3, keypad, 2.2);
  }
}
