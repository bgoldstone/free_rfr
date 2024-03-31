import 'package:flutter/material.dart';
import 'package:free_rfr/osc_control.dart';
import 'package:free_rfr/widgets/button.dart';
import 'package:free_rfr/widgets/grid.dart';

class Keypad extends StatelessWidget {
  final OSC osc;
  const Keypad({super.key, required this.osc});

  @override
  Widget build(BuildContext context) {
    List<Button> keypad = [
      Button('Park', () => osc.sendKey('park'), fontSize: 13),
      Button('Address', () => osc.sendKey('address'), fontSize: 10),
      Button('Last', () => osc.sendKey('last'), fontSize: 13),
      Button('Next', () => osc.sendKey('next'), fontSize: 13),
      Button('+', () => osc.sendKey('plus'), fontSize: 13),
      Button('Thru', () => osc.sendKey('thru'), fontSize: 13),
      Button('-', () => osc.sendKey('-'), fontSize: 13),
      Button('Group', () => osc.sendKey('group'), fontSize: 13),
      Button('7', () => osc.sendKey('7'), fontSize: 13),
      Button('8', () => osc.sendKey('8'), fontSize: 13),
      Button('9', () => osc.sendKey('9'), fontSize: 13),
      Button('Out', () => osc.sendKey('out'), fontSize: 13),
      Button('4', () => osc.sendKey('4'), fontSize: 13),
      Button('5', () => osc.sendKey('5'), fontSize: 13),
      Button('6', () => osc.sendKey('6'), fontSize: 13),
      Button('Full', () => osc.sendKey('full'), fontSize: 13),
      Button('1', () => osc.sendKey('1'), fontSize: 13),
      Button('2', () => osc.sendKey('2'), fontSize: 13),
      Button('3', () => osc.sendKey('3'), fontSize: 13),
      Button('At', () => osc.sendKey('at'), fontSize: 13),
      Button('Clear', () => osc.sendKey('clear'), fontSize: 13),
      Button('0', () => osc.sendKey('0'), fontSize: 13),
      Button('.', () => osc.sendKey('.'), fontSize: 13),
      Button('Enter', () => osc.sendKey('enter'), fontSize: 13),
    ];
    return Grid(4, keypad, 2);
  }
}
