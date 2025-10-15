import 'package:flutter/material.dart';
import 'package:free_rfr/objects/osc_control.dart';
import 'package:free_rfr/widgets/button.dart';
import 'package:free_rfr/widgets/grid.dart';

class AdditionalKeys extends StatelessWidget {
  final OSC osc;
  const AdditionalKeys({required this.osc, super.key});

  @override
  Widget build(BuildContext context) {
    double? fontSize = 30;
    List<Button> additionalKeys = [
      Button('Mark', () {
        osc.sendKey('mark');
      }, fontSize: fontSize),
      Button('Sneak', () {
        osc.sendKey('sneak');
      }, fontSize: fontSize),
      Button('Rem Dim', () {
        osc.sendKey('rem_dim');
      }, fontSize: fontSize),
      Button('Select Manual', () {
        osc.sendKey('select_manual');
      }, fontSize: fontSize),
      Button('Select Last', () {
        osc.sendKey('select_last');
      }, fontSize: fontSize),
      Button('Select Active', () {
        osc.sendKey('select_active');
      }, fontSize: fontSize),
      Button('Home', () {
        osc.sendKey('home');
      }, fontSize: fontSize),
      Button('Level', () {
        osc.sendKey('level');
      }, fontSize: fontSize),
      Button('Time', () {
        osc.sendKey('time');
      }, fontSize: fontSize),
      Button('Live', () {
        osc.sendLive();
      }, fontSize: fontSize),
      Button('Blind', () {
        osc.sendBlind();
      }, fontSize: fontSize),
      Button('Undo', () {
        osc.sendKey('undo');
      }, fontSize: fontSize),
      Button('', () {}),
      Button('', () {}),
      Button('Enter', () {
        osc.sendKey('enter');
      }, fontSize: fontSize),
    ];
    return Grid(3, additionalKeys);
  }
}
