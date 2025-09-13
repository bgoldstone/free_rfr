import 'package:flutter/material.dart';
import 'package:free_rfr/configurations/context.dart';
import 'package:free_rfr/objects/osc_control.dart';
import 'package:free_rfr/objects/parameters.dart';
import 'package:free_rfr/pages/controls.dart';
import 'package:free_rfr/widgets/button.dart';
import 'package:provider/provider.dart';

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
  final OSC osc;
  final ParameterRole role;

  const ParameterWidgets({super.key, required this.role, required this.osc});

  @override
  State<ParameterWidgets> createState() => _ParameterWidgetsState();
}

class _ParameterWidgetsState extends State<ParameterWidgets> {
  List<ParameterType> controls = [];
  @override
  Widget build(BuildContext context) {
    final ctx = context.watch<FreeRFRContext>();
    controls = getParameterForType(ctx.currentChannel, widget.role);
    if (controls.isEmpty) {
      return noParametersForThisChannel(widget.role.name);
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
}
