import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:free_rfr/objects/osc_control.dart';
import 'package:free_rfr/objects/parameters.dart';
import 'package:free_rfr/widgets/parameter_entry.dart';

class ParameterControl extends StatefulWidget {
  final ParameterList currentChannel;
  final OSC osc;
  final String commandLine;
  const ParameterControl({
    super.key,
    required this.currentChannel,
    required this.osc,
    required this.commandLine,
  });

  @override
  State<ParameterControl> createState() => _ParameterControlState();
}

class _ParameterControlState extends State<ParameterControl> {
  List<String> parameters = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.currentChannel.isEmpty) {
      return const Empty();
    }
    List<List<dynamic>> newParameterList = [];
    for (MapEntry<dynamic, List<dynamic>> parameter
        in widget.currentChannel.entries) {
      if (parameter.key is String) {
        continue;
      }
      if (parameter.key != 20) {
        setState(() {
          newParameterList.add(parameter.value);
        });
      }
    }
    if (newParameterList.isEmpty) {
      return const Empty();
    }
    return ListView.builder(
      itemCount: newParameterList.length,
      itemBuilder: (context, index) {
        List<dynamic> parameters = newParameterList[index];
        if (parameters[1].startsWith("Pan")) {
          return ParameterEntry(
            osc: widget.osc,
            attributes: parameters,
            minValue: widget.currentChannel[20]![0],
            maxValue: widget.currentChannel[20]![1],
          );
        } else if (parameters[1].startsWith("Tilt")) {
          return ParameterEntry(
            osc: widget.osc,
            attributes: parameters,
            minValue: widget.currentChannel[20]![2],
            maxValue: widget.currentChannel[20]![3],
          );
        }
        if (parameters[1] == '' ||
            parameters[1] == 'Macros' ||
            parameters[1].contains('Ind')) {
          return null;
        }
        String paramNameUnderscored = parameters[1].contains('/')
            ? null
            : parameters[1].toLowerCase().replaceAll(" ", "_");
        List<dynamic>? paramExist = widget.currentChannel[paramNameUnderscored];
        if (paramExist != null && paramExist.length == 3) {
          return ParameterEntry(
            osc: widget.osc,
            attributes: parameters,
            minValue: paramExist[1],
            maxValue: paramExist[2],
            isParam: true,
          );
        }
        return ParameterEntry(
          osc: widget.osc,
          attributes: parameters,
        );
      },
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
