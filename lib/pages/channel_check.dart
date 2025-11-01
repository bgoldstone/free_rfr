import 'package:flutter/material.dart';
import 'package:free_rfr/objects/osc_control.dart';
import 'package:free_rfr/widgets/button.dart';
import 'package:free_rfr/widgets/grid.dart';

class ChannelCheck extends StatelessWidget {
  final OSC osc;
  final bool isKeypadWindow;
  final double scale;
  const ChannelCheck(
      {super.key,
      required this.osc,
      this.isKeypadWindow = false,
      this.scale = 2});

  @override
  Widget build(BuildContext context) {
    List<Button> channelCheck = [
      Button(
        'Go To Cue',
        () {
          osc.sendKey('go_to_cue');
        },
      ),
      Button(
        'Address',
        () {
          osc.sendKey('address');
        },
      ),
      Button(
        'Last',
        () {
          osc.sendKey('last');
        },
      ),
      Button(
        'Next',
        () {
          osc.sendKey('next');
        },
      ),
      Button(
        '+',
        () {
          osc.sendKey('plus');
        },
      ),
      Button(
        'Check',
        () {
          osc.sendKey('check');
        },
      ),
      Button(
        '-',
        () {
          osc.sendKey('-');
        },
      ),
      Button(
        'Group',
        () {
          osc.sendKey('group');
        },
      ),
      Button(
        '7',
        () {
          osc.sendKey('7');
        },
      ),
      Button(
        '8',
        () {
          osc.sendKey('8');
        },
      ),
      Button(
        '9',
        () {
          osc.sendKey('9');
        },
      ),
      Button(
        'Out',
        () {
          osc.sendKey('out');
        },
      ),
      Button(
        '4',
        () {
          osc.sendKey('4');
        },
      ),
      Button(
        '5',
        () {
          osc.sendKey('5');
        },
      ),
      Button(
        '6',
        () {
          osc.sendKey('6');
        },
      ),
      Button(
        'Full',
        () {
          osc.sendKey('full');
        },
      ),
      Button(
        '1',
        () {
          osc.sendKey('1');
        },
      ),
      Button(
        '2',
        () {
          osc.sendKey('2');
        },
      ),
      Button(
        '3',
        () {
          osc.sendKey('3');
        },
      ),
      Button(
        'At',
        () {
          osc.sendKey('at');
        },
      ),
      Button(
        'Clear',
        () {
          osc.sendKey('clear_cmd');
        },
      ),
      Button(
        '0',
        () {
          osc.sendKey('0');
        },
      ),
      Button(
        '.',
        () {
          osc.sendKey('.');
        },
      ),
      Button(
        'Enter',
        () {
          osc.sendKey('enter');
          isKeypadWindow ? Navigator.of(context).pop() : null;
        },
      ),
    ];
    return Grid(4, channelCheck);
  }
}
