import 'package:flutter/material.dart';
import 'package:free_rfr/objects/osc_control.dart';
import 'package:free_rfr/widgets/button.dart';
import 'package:free_rfr/widgets/grid.dart';

class AdditionalKeys extends StatelessWidget {
  final OSC osc;
  const AdditionalKeys({required this.osc, super.key});

  @override
  Widget build(BuildContext context) {
    List<Button> additionalKeys = [
      Button('Mark', () {
        osc.sendKey('mark');
      }, fontSize: 30),
      Button('Sneak', () {
        osc.sendKey('sneak');
      }, fontSize: 30),
      Button('Rem Dim', () {
        osc.sendKey('rem_dim');
      }, fontSize: 30),
      Button('Select Manual', () {
        osc.sendKey('select_manual');
      }, fontSize: 30),
      Button('Select Last', () {
        osc.sendKey('select_last');
      }, fontSize: 30),
      Button('Select Active', () {
        osc.sendKey('select_active');
      }, fontSize: 30),
      Button('Home', () {
        osc.sendKey('home');
      }, fontSize: 30),
      Button('Level', () {
        osc.sendKey('level');
      }, fontSize: 30),
      Button('Time', () {
        osc.sendKey('time');
      }, fontSize: 30),
      Button('Live', () {
        osc.sendKey('live');
      }, fontSize: 30),
      Button('Blind', () {
        osc.sendKey('blind');
      }, fontSize: 30),
      Button('Undo', () {
        osc.sendKey('undo');
      }, fontSize: 30),
    ];
    return Grid(3, additionalKeys, 1.8);
  }
}
