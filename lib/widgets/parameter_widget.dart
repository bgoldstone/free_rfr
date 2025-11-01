import 'package:flutter/material.dart';
import 'package:free_rfr/configurations/context.dart';
import 'package:free_rfr/objects/osc_control.dart';
import 'package:free_rfr/objects/parameters.dart';
import 'package:free_rfr/pages/controls.dart';
import 'package:free_rfr/widgets/button.dart';
import 'package:provider/provider.dart';

class ParameterWidget extends StatefulWidget {
  final ParameterType parameterType;
  final OSC osc;

  const ParameterWidget(
      {super.key, required this.parameterType, required this.osc});

  @override
  State<ParameterWidget> createState() => _ParameterWidgetState();
}

class _ParameterWidgetState extends State<ParameterWidget> {
  @override
  Widget build(BuildContext context) {
    final ctx = context.watch<FreeRFRContext>();
    final channelValue = ctx.currentChannel[widget.parameterType] != null
        ? ctx.currentChannel[widget.parameterType]![0].toStringAsFixed(2)
        : '';
    List<Widget> children = [
      Expanded(
        child: Button(
          "${widget.parameterType.oscName} [${channelValue}]",
          () => widget.osc
              .sendCmd("select_last ${widget.parameterType.getEosName()}"),
        ),
      ),
      Expanded(
        child: Button(
          "Max   ",
          () => widget.osc.sendCmd(
              "select_last ${widget.parameterType.getEosName()} Full#"),
        ),
      ),
      Expanded(
        child: Button(
          "+10",
          () => widget.osc
              .sendCmd("select_last ${widget.parameterType.getEosName()} +10#"),
        ),
      ),
      Expanded(
        child: Button(
          "+1",
          () => widget.osc
              .sendCmd("select_last ${widget.parameterType.getEosName()} +01#"),
        ),
      ),
      Expanded(
        child: Button(
          "Home",
          () => widget.osc.sendCmd(
              "select_last ${widget.parameterType.getEosName()} Home#"),
        ),
      ),
      Expanded(
        child: Button(
          "-1",
          () => widget.osc
              .sendCmd("select_last ${widget.parameterType.getEosName()} -01#"),
        ),
      ),
      Expanded(
        child: Button(
          "-10",
          () => widget.osc
              .sendCmd("select_last ${widget.parameterType.getEosName()} -10#"),
        ),
      ),
      Expanded(
        child: Button(
          "Min    ",
          () => widget.osc
              .sendCmd("select_last ${widget.parameterType.getEosName()} Min#"),
        ),
      ),
    ];
    return Column(
      children: children,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
    if (widget.role == ParameterRole.panTilt) {
      controls = [ParameterType.pan, ParameterType.tilt];
    }
    for (var parameter in controls) {
      targets.add(
        ParameterWidget(
          parameterType: parameter,
          osc: widget.osc,
        ),
      );
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
