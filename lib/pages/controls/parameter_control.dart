import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:free_rfr/objects/osc_control.dart';
import 'package:free_rfr/objects/parameters.dart';
import 'package:free_rfr/widgets/parameter_entry.dart';

class ParameterControl extends StatefulWidget {
  final ParameterList currentChannel;
  final OSC osc;
  const ParameterControl({
    super.key,
    required this.currentChannel,
    required this.osc,
  });

  @override
  State<ParameterControl> createState() => _ParameterControlState();
}

class _ParameterControlState extends State<ParameterControl> {
  List<String> parameters = [];

  @override
  Widget build(BuildContext context) {
    if (widget.currentChannel.isEmpty) {
      return const Empty();
    }
    List<List<dynamic>> newParameterList = [];
    for (MapEntry<int, List<dynamic>> parameter
        in widget.currentChannel.entries) {
      debugPrint(parameter.toString());
      if (parameter.key != 20) {
        setState(() {
          newParameterList.add(parameter.value);
        });
      }
    }
    if (newParameterList.isEmpty) {
      return const Empty();
    }
    return SingleChildScrollView(
      child: Column(
        children: newParameterList.map((parameters) {
          return ParameterEntry(
            osc: widget.osc,
            attributes: parameters,
          );
        }).toList(),
      ),
    );
  }
}

class Empty extends StatelessWidget {
  const Empty({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'No Parameter Control for this channel',
        textAlign: TextAlign.center,
      ),
    );
  }
}
