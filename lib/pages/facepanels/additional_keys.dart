import 'package:flutter/material.dart';
import 'package:free_rfr/osc_control.dart';
import 'package:free_rfr/widgets/button.dart';
import 'package:free_rfr/widgets/grid.dart';

class AdditionalKeys extends StatelessWidget {
  final OSC osc;
  final void Function(String) setCommandLine;
  const AdditionalKeys(
      {required this.osc, super.key, required this.setCommandLine});

  @override
  Widget build(BuildContext context) {
    List<Button> additionalKeys = [
      Button('Mark', () {
        osc.sendKey('mark', setCommandLine);
      }),
      Button('Sneak', () {
        osc.sendKey('sneak', setCommandLine);
      }),
      Button('Rem Dim', () {
        osc.sendKey('rem_dim', setCommandLine);
      }),
      Button('Select Manual', () {
        osc.sendKey('select_manual', setCommandLine);
      }),
      Button('Select Last', () {
        osc.sendKey('select_last', setCommandLine);
      }),
      Button('Select Active', () {
        osc.sendKey('select_active', setCommandLine);
      }),
      Button('Home', () {
        osc.sendKey('home', setCommandLine);
      }),
      Button('Level', () {
        osc.sendKey('level', setCommandLine);
      }),
      Button('Time', () {
        osc.sendKey('time', setCommandLine);
      }),
      Button('Live', () {
        osc.sendKey('live', setCommandLine);
      }),
      Button('Blind', () {
        osc.sendKey('blind', setCommandLine);
      }),
      Button('Undo', () {
        osc.sendKey('undo', setCommandLine);
      }),
    ];
    return Grid(3, additionalKeys, 1.8);
  }
}
