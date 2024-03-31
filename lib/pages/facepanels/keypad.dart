import 'package:flutter/material.dart';
import 'package:free_rfr/osc_control.dart';
import 'package:free_rfr/widgets/button.dart';
import 'package:free_rfr/widgets/grid.dart';

class Keypad extends StatelessWidget {
  final OSC osc;
  final void Function(String) setCommandLine;
  const Keypad({super.key, required this.osc, required this.setCommandLine});

  @override
  Widget build(BuildContext context) {
    List<Button> keypad = [
      Button('Park', () {
        osc.sendKey('park', setCommandLine);
      }, fontSize: 13),
      Button('Address', () {
        osc.sendKey('address', setCommandLine);
      }, fontSize: 10),
      Button('Last', () {
        osc.sendKey('last', setCommandLine);
      }, fontSize: 13),
      Button('Next', () {
        osc.sendKey('next', setCommandLine);
      }, fontSize: 13),
      Button('+', () {
        osc.sendKey('plus', setCommandLine);
      }, fontSize: 13),
      Button('Thru', () {
        osc.sendKey('thru', setCommandLine);
      }, fontSize: 13),
      Button('-', () {
        osc.sendKey('-', setCommandLine);
      }, fontSize: 13),
      Button('Group', () {
        osc.sendKey('group', setCommandLine);
      }, fontSize: 13),
      Button('7', () {
        osc.sendKey('7', setCommandLine);
      }, fontSize: 13),
      Button('8', () {
        osc.sendKey('8', setCommandLine);
      }, fontSize: 13),
      Button('9', () {
        osc.sendKey('9', setCommandLine);
      }, fontSize: 13),
      Button('Out', () {
        osc.sendKey('out', setCommandLine);
      }, fontSize: 13),
      Button('4', () {
        osc.sendKey('4', setCommandLine);
      }, fontSize: 13),
      Button('5', () {
        osc.sendKey('5', setCommandLine);
      }, fontSize: 13),
      Button('6', () {
        osc.sendKey('6', setCommandLine);
      }, fontSize: 13),
      Button('Full', () {
        osc.sendKey('full', setCommandLine);
      }, fontSize: 13),
      Button('1', () {
        osc.sendKey('1', setCommandLine);
      }, fontSize: 13),
      Button('2', () {
        osc.sendKey('2', setCommandLine);
      }, fontSize: 13),
      Button('3', () {
        osc.sendKey('3', setCommandLine);
      }, fontSize: 13),
      Button('At', () {
        osc.sendKey('at', setCommandLine);
      }, fontSize: 13),
      Button(
        'Clear',
        () {
          osc.sendKey('clear_cmd', setCommandLine);
        },
        fontSize: 13,
      ),
      Button('0', () {
        osc.sendKey('0', setCommandLine);
      }, fontSize: 13),
      Button('.', () {
        osc.sendKey('.', setCommandLine);
      }, fontSize: 13),
      Button('Enter', () {
        osc.sendKey('enter', setCommandLine);
      }, fontSize: 13),
    ];
    return Grid(4, keypad, 2);
  }
}
