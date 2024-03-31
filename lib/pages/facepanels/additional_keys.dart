import 'package:flutter/material.dart';
import 'package:free_rfr/osc_control.dart';
import 'package:free_rfr/widgets/button.dart';
import 'package:free_rfr/widgets/grid.dart';

class AdditionalKeys extends StatelessWidget {
  final OSC osc;
  final void Function(String) setCommandLine;
  const AdditionalKeys({required this.osc, super.key, required this.setCommandLine});

  @override
  Widget build(BuildContext context) {
    List<Button> additionalKeys = [
      Button('Mark', (){osc.sendKey('mark'); osc.setCommandLine(setCommandLine);}),
      Button('Sneak', () {osc.sendKey('sneak'); osc.setCommandLine(setCommandLine);}),
      Button('Rem Dim', () {osc.sendKey('rem_dim'); osc.setCommandLine(setCommandLine);}),
      Button('Select Manual', () {osc.sendKey('select_manual'); osc.setCommandLine(setCommandLine);}),
      Button('Select Last', () {osc.sendKey('select_last'); osc.setCommandLine(setCommandLine);}),
      Button('Select Active', () {osc.sendKey('select_active'); osc.setCommandLine(setCommandLine);}),
      Button('Home', () {osc.sendKey('home'); osc.setCommandLine(setCommandLine);}),
      Button('Level', () {osc.sendKey('level'); osc.setCommandLine(setCommandLine);}),
      Button('Time', () {osc.sendKey('time'); osc.setCommandLine(setCommandLine);}),
      Button('Live', () {osc.sendKey('live'); osc.setCommandLine(setCommandLine);}),
      Button('Blind', () {osc.sendKey('blind'); osc.setCommandLine(setCommandLine);}),
      Button('Undo', () {osc.sendKey('undo'); osc.setCommandLine(setCommandLine);}),
    ];
    return Grid(3, additionalKeys, 1.8);
  }
}
