import 'package:flutter/material.dart';
import 'package:free_rfr/objects/osc_control.dart';
import 'package:free_rfr/objects/parameters.dart';

class IntensityControl extends StatefulWidget {
  final ParameterMap currentChannel;
  final OSC osc;
  const IntensityControl({
    super.key,
    required this.currentChannel,
    required this.osc,
  });

  @override
  State<IntensityControl> createState() => _IntensityControlState();
}

class _IntensityControlState extends State<IntensityControl> {
  List<Widget> intensityWidgets = [];
  List<String> parameters = [];

  @override
  Widget build(BuildContext context) {
    debugPrint(widget.currentChannel.toString());
    if (!widget.currentChannel.containsKey(ParameterType.intens)) {
      return const Empty();
    }
    var intens = widget.currentChannel[ParameterType.intens][1];
    return RotatedBox(
      quarterTurns: 3,
      child: Slider(
        value: intens,
        min: 0,
        max: 100,
        onChanged: (value) {
          widget.osc.setParameter('intens', value.roundToDouble());
          setState(() {
            intens = value;
          });
        },
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
        'No Intensity Control for this channel',
        textAlign: TextAlign.center,
      ),
    );
  }
}
