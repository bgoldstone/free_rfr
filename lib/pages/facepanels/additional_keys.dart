import 'package:flutter/material.dart';
import 'package:free_rfr/osc_control.dart';
import 'package:free_rfr/widgets/button.dart';
import 'package:free_rfr/widgets/grid.dart';

class AdditionalKeys extends StatelessWidget {
  final OSC osc;
  const AdditionalKeys({required this.osc, super.key});

  @override
  Widget build(BuildContext context) {
    List<Button> additionalKeys = [
      Button('Mark', ()=>osc.sendKey('mark')),
      Button('Sneak', () => osc.sendKey('sneak')),
      Button('Rem Dim', () => osc.sendKey('rem_dim')),
      Button('Select Manual', () => osc.sendKey('select_manual')),
      Button('Select Last', () => osc.sendKey('select_last')),
      Button('Select Active', () => osc.sendKey('select_active')),
      Button('Home', () => osc.sendKey('home')),
      Button('Level', () => osc.sendKey('level')),
      Button('Time', () => osc.sendKey('time')),
      Button('Live', () => osc.sendKey('live')),
      Button('Blind', () => osc.sendKey('blind')),
      Button('Undo', () =>osc.sendKey('undo')),
    ];
    return Grid(3, additionalKeys, 1.8);
  }
}
