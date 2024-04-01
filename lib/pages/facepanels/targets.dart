import 'package:flutter/material.dart';
import 'package:free_rfr/objects/osc_control.dart';
import 'package:free_rfr/widgets/button.dart';

import '../../widgets/grid.dart';

class Target extends StatelessWidget {
  final OSC osc;
  const Target({required this.osc, super.key});

  @override
  Widget build(BuildContext context) {
    List<Button> targets = [
      Button('Part', () {
        osc.sendKey(
          'part',
        );
      }, fontSize: 30),
      Button('Cue', () {
        osc.sendKey(
          'cue',
        );
      }, fontSize: 30),
      Button('Record', () {
        osc.sendKey(
          'record',
        );
      }, fontSize: 27),
      Button('Preset', () {
        osc.sendKey(
          'preset',
        );
      }, fontSize: 30),
      Button('Sub', () {
        osc.sendKey(
          'sub',
        );
      }, fontSize: 30),
      Button('Delay', () {
        osc.sendKey(
          'delay',
        );
      }, fontSize: 30),
      Button('Delete', () {
        osc.sendKey(
          'delete',
        );
      }, fontSize: 30),
      Button('Copy To', () {
        osc.sendKey(
          'copy_to',
        );
      }, fontSize: 30),
      Button('Recall From', () {
        osc.sendKey(
          'recall_from',
        );
      }, fontSize: 30),
      Button('Update', () {
        osc.sendKey(
          'update',
        );
      }, fontSize: 27),
      Button('Q-Only/Track', () {
        osc.sendKey(
          'cueonlytrack',
        );
      }, fontSize: 25),
      Button('Save', () {
        osc.sendKey(
          'save',
        );
      }, fontSize: 30),
      Button('Last', () {
        osc.sendKey('last');
      }, fontSize: 30),
      Button('Next', () {
        osc.sendKey('next');
      }, fontSize: 30),
      Button('Enter', () {
        osc.sendKey('enter');
      }, fontSize: 30),
    ];
    return Grid(3, targets, 2.22);
  }
}
