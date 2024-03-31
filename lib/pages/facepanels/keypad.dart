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
        osc.sendKey('park');
        osc.setCommandLine(setCommandLine);
      }, fontSize: 13),
      Button('Address', () {
        osc.sendKey('address');
        osc.setCommandLine(setCommandLine);
      }, fontSize: 10),
      Button('Last', () {
        osc.sendKey('last');
        osc.setCommandLine(setCommandLine);
      }, fontSize: 13),
      Button('Next', () {
        osc.sendKey('next');
        osc.setCommandLine(setCommandLine);
      }, fontSize: 13),
      Button('+', () {
        osc.sendKey('plus');
        osc.setCommandLine(setCommandLine);
      }, fontSize: 13),
      Button('Thru', () {
        osc.sendKey('thru');
        osc.setCommandLine(setCommandLine);
      }, fontSize: 13),
      Button('-', () {
        osc.sendKey('-');
        osc.setCommandLine(setCommandLine);
      }, fontSize: 13),
      Button('Group', () {
        osc.sendKey('group');
        osc.setCommandLine(setCommandLine);
      }, fontSize: 13),
      Button('7', () {
        osc.sendKey('7');
        osc.setCommandLine(setCommandLine);
      }, fontSize: 13),
      Button('8', () {
        osc.sendKey('8');
        osc.setCommandLine(setCommandLine);
      }, fontSize: 13),
      Button('9', () {
        osc.sendKey('9');
        osc.setCommandLine(setCommandLine);
      }, fontSize: 13),
      Button('Out', () {
        osc.sendKey('out');
        osc.setCommandLine(setCommandLine);
      }, fontSize: 13),
      Button('4', () {
        osc.sendKey('4');
        osc.setCommandLine(setCommandLine);
      }, fontSize: 13),
      Button('5', () {
        osc.sendKey('5');
        osc.setCommandLine(setCommandLine);
      }, fontSize: 13),
      Button('6', () {
        osc.sendKey('6');
        osc.setCommandLine(setCommandLine);
      }, fontSize: 13),
      Button('Full', () {
        osc.sendKey('full');
        osc.setCommandLine(setCommandLine);
      }, fontSize: 13),
      Button('1', () {
        osc.sendKey('1');
        osc.setCommandLine(setCommandLine);
      }, fontSize: 13),
      Button('2', () {
        osc.sendKey('2');
        osc.setCommandLine(setCommandLine);
      }, fontSize: 13),
      Button('3', () {
        osc.sendKey('3');
        osc.setCommandLine(setCommandLine);
      }, fontSize: 13),
      Button('At', () {
        osc.sendKey('at');
        osc.setCommandLine(setCommandLine);
      }, fontSize: 13),
      Button('Clear', () {
        osc.sendKey('clear_cmd');
        osc.setCommandLine(setCommandLine);
      }, fontSize: 13),
      Button('0', () {
        osc.sendKey('0');
        osc.setCommandLine(setCommandLine);
      }, fontSize: 13),
      Button('.', () {
        osc.sendKey('.');
        osc.setCommandLine(setCommandLine);
      }, fontSize: 13),
      Button('Enter', () {
        osc.sendKey('enter');
        osc.setCommandLine(setCommandLine);
      }, fontSize: 13),
    ];
    return Grid(4, keypad, 2);
  }
}
