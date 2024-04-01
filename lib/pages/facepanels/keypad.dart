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
      Button('Go To Cue', () {
        osc.sendKey('go_to_cue');
      }, fontSize: 15),
      Button('Addr', () {
        osc.sendKey('address');
      }, fontSize: 15),
      Button('Last', () {
        osc.sendKey('last');
      }, fontSize: 18),
      Button('Next', () {
        osc.sendKey('next');
      }, fontSize: 17),
      Button('+', () {
        osc.sendKey('plus');
      }, fontSize: 30),
      Button('Thru', () {
        osc.sendKey('thru');
      }, fontSize: 16),
      Button('-', () {
        osc.sendKey('-');
      }, fontSize: 30),
      Button('Grp', () {
        osc.sendKey('group');
      }, fontSize: 20),
      Button(
        '7',
        () {
          osc.sendKey('7');
        },
        fontSize: 30,
      ),
      Button(
        '8',
        () {
          osc.sendKey('8');
        },
        fontSize: 30,
      ),
      Button(
        '9',
        () {
          osc.sendKey('9');
        },
        fontSize: 30,
      ),
      Button('Out', () {
        osc.sendKey('out');
      }, fontSize: 20),
      Button(
        '4',
        () {
          osc.sendKey('4');
        },
        fontSize: 30,
      ),
      Button(
        '5',
        () {
          osc.sendKey('5');
        },
        fontSize: 30,
      ),
      Button(
        '6',
        () {
          osc.sendKey('6');
        },
        fontSize: 30,
      ),
      Button('Full', () {
        osc.sendKey('full');
      }, fontSize: 20),
      Button(
        '1',
        () {
          osc.sendKey('1');
        },
        fontSize: 30,
      ),
      Button(
        '2',
        () {
          osc.sendKey('2');
        },
        fontSize: 30,
      ),
      Button('3', () {
        osc.sendKey('3');
      }, fontSize: 30),
      Button('At', () {
        osc.sendKey('at');
      }),
      Button(
        'Clear',
        () {
          osc.sendKey('clear_cmd');
        },
        fontSize: 15,
      ),
      Button(
        '0',
        () {
          osc.sendKey('0');
        },
        fontSize: 30,
      ),
      Button('.', () {
        osc.sendKey('.');
      }, fontSize: 30),
      Button('Enter', () {
        osc.sendKey('enter');
      }, fontSize: 15),
    ];
    return Grid(4, keypad, 2);
  }
}
