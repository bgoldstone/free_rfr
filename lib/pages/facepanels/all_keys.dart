import 'package:flutter/material.dart';
import 'package:free_rfr/objects/osc_control.dart';
import 'package:free_rfr/pages/facepanels/additional_keys.dart';
import 'package:free_rfr/pages/facepanels/keypad.dart';
import 'package:free_rfr/pages/facepanels/targets.dart';

class AllKeys extends StatelessWidget {
  final OSC osc;
  const AllKeys({required this.osc, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Keypad(
          osc: osc,
          scale: .6,
        )),
        Expanded(
            child: Target(
          osc: osc,
          scale: .65,
        )),
        Expanded(
            child: AdditionalKeys(
          osc: osc,
          scale: .53,
        )),
      ],
    );
  }
}
