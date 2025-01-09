import 'package:flutter/material.dart';
import 'package:free_rfr/objects/osc_control.dart';
import 'package:free_rfr/objects/parameters.dart';
import 'package:free_rfr/pages/controls.dart';

class FocusControl extends StatefulWidget {
  final OSC osc;
  final ParameterMap currentChannel;
  final List<Widget> controls = [];
  FocusControl({super.key, required this.osc, required this.currentChannel});

  @override
  State<FocusControl> createState() => _FocusControlState();
}

class _FocusControlState extends State<FocusControl> {
  @override
  Widget build(BuildContext context) {
    if (widget.controls.isEmpty) return noParametersForThisChannel("Focus");
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 1,
              height: MediaQuery.sizeOf(context).height * 2,
              child: GridView.count(
                crossAxisCount: widget.controls.length,
                children: widget.controls,
              ),
            )
          ],
        ));
  }

  @override
  void initState() {
    setup();
    super.initState();
  }

  void setup() {
    widget.currentChannel.forEach((parameterType, value) {
      debugPrint("ParameterType: $parameterType, Value: $value");
      if (value != null && parameterType.role == ParameterRole.focus) {
        widget.controls.add(
            ControlFader(parameterType.name, parameterType, value[0])
                .buildFader(widget.osc, parameterType, updateValue));
      }
    });
  }

  void updateValue(ParameterType parameterType, double newValue) {
    setState(() {
      widget.currentChannel[parameterType] = [newValue];
    });
  }
}
