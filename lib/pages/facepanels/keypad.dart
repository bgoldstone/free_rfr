import 'package:flutter/material.dart';
import 'package:free_rfr/objects/osc_control.dart';
import 'package:free_rfr/shortcuts.dart';
import 'package:free_rfr/widgets/button.dart';
import 'package:free_rfr/widgets/grid.dart';

class Keypad extends StatelessWidget {
  final OSC osc;
  final bool isKeypadWindow;
  final double scale;
  const Keypad(
      {super.key,
      required this.osc,
      this.isKeypadWindow = false,
      this.scale = 2});

  @override
  Widget build(BuildContext context) {
    List<Button> keypad = [
      Button('Go To Cue', () {
        osc.sendKey('go_to_cue');
      }, fontSize: 17.4),
      Button('Addr', () {
        osc.sendKey('address');
      }, fontSize: 20),
      Button('Last', () {
        osc.sendKey('last');
      }, fontSize: 20),
      Button('Next', () {
        osc.sendKey('next');
      }, fontSize: 20),
      Button('+', () {
        osc.sendKey('plus');
      }, fontSize: 30),
      Button('Thru', () {
        osc.sendKey('thru');
      }, fontSize: 20),
      Button('-', () {
        osc.sendKey('-');
      }, fontSize: 30),
      Button('Group', () {
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
      Button('Clear', () {
        osc.sendKey('clear_cmd');
        osc.setCommandLine!('LIVE: ');
      }, fontSize: 18.5),
      Button('0', () {
        osc.sendKey('0');
      }, fontSize: 30),
      Button('.', () {
        osc.sendKey('.');
      }, fontSize: 30),
      Button('Enter', () {
        osc.sendKey('enter');
        isKeypadWindow ? Navigator.of(context).pop() : null;
      }, fontSize: 18.5),
    ];
    return FreeRFRShortcutManager(Grid(4, keypad, scale), osc);
  }
}
