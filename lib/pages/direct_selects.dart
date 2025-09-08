import 'package:flutter/material.dart';
import 'package:free_rfr/objects/osc_control.dart';

class DirectSelects extends StatelessWidget {
  final OSC osc;
  const DirectSelects({super.key, required this.osc});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      "Coming Soon!",
      style: TextStyle(fontSize: MediaQuery.of(context).size.aspectRatio * 15),
    ));
  }
}
