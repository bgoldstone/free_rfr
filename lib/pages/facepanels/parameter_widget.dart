import 'package:flutter/material.dart';
import 'package:free_rfr/objects/osc_control.dart';
import 'package:free_rfr/objects/parameters.dart';
import 'package:free_rfr/pages/controls.dart';
import 'package:free_rfr/widgets/button.dart';

class ParameterWidget extends StatelessWidget {
  final ParameterType parameterType;
  final OSC osc;

  const ParameterWidget(
      {super.key, required this.parameterType, required this.osc});

  @override
  Widget build(BuildContext context) {
    double aspectRatio = MediaQuery.of(context).size.aspectRatio / 1;
    List<Widget> children = [
      Button(
        parameterType.oscName,
        () => osc.sendCmd("select_last ${parameterType.getEosName()}"),
        fontSize: 10 * aspectRatio,
        padding: 2 * aspectRatio,
      ),
      Button(
        "Max   ",
        () => osc.sendCmd("select_last ${parameterType.getEosName()} Full#"),
        fontSize: 10 * aspectRatio,
        padding: 2 * aspectRatio,
      ),
      Button(
        "+10",
        () => osc.sendCmd("select_last ${parameterType.getEosName()} +10#"),
        fontSize: 10 * aspectRatio,
        padding: 2 * aspectRatio,
      ),
      Button(
        "+1",
        () => osc.sendCmd("select_last ${parameterType.getEosName()} +01#"),
        fontSize: 10 * aspectRatio,
        padding: 2 * aspectRatio,
      ),
      Button(
        "Home",
        () => osc.sendCmd("select_last ${parameterType.getEosName()} Home#"),
        fontSize: 10 * aspectRatio,
        padding: 2 * aspectRatio,
      ),
      Button(
        "-1",
        () => osc.sendCmd("select_last ${parameterType.getEosName()} -01#"),
        fontSize: 10 * aspectRatio,
        padding: 2 * aspectRatio,
      ),
      Button(
        "-10",
        () => osc.sendCmd("select_last ${parameterType.getEosName()} -10#"),
        fontSize: 10 * aspectRatio,
        padding: 2 * aspectRatio,
      ),
      Button(
        "Min    ",
        () => osc.sendCmd("select_last ${parameterType.getEosName()} Min#"),
        fontSize: 10 * aspectRatio,
        padding: 2 * aspectRatio,
      ),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(children: children),
    );
  }
}

class ParameterWidgets extends StatefulWidget {
  final ParameterMap currentChannel;
  final OSC osc;
  final String type;

  const ParameterWidgets(
      {super.key,
      required this.type,
      required this.currentChannel,
      required this.osc});

  @override
  State<ParameterWidgets> createState() => _ParameterWidgetsState();
}

class _ParameterWidgetsState extends State<ParameterWidgets> {
  List<ParameterType> controls = [];
  @override
  Widget build(BuildContext context) {
    if (controls.isEmpty) {
      return noParametersForThisChannel(widget.type);
    }
    List<Widget> targets = [];
    for (var parameter in controls) {
      targets.add(ParameterWidget(parameterType: parameter, osc: widget.osc));
      targets.add(const VerticalDivider(width: 15));
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: targets,
      ),
    );
  }

  @override
  initState() {
    super.initState();
    widget.currentChannel.forEach((parameter, _) {
      if (parameter.role.name == widget.type.toLowerCase()) {
        controls.add(parameter);
      }
    });
  }
}
