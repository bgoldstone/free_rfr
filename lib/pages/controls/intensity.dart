import 'package:flutter/material.dart';
import 'package:free_rfr/osc_control.dart';
import 'package:free_rfr/parameters.dart';
import 'package:free_rfr/widgets/slider.dart';

class IntensityControl extends StatefulWidget {
  final ParameterList currentChannel;
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
    List<List<dynamic>> intensityControl =
        widget.currentChannel[ParameterType.Intensity.index];
    if (intensityControl.isEmpty) {
      return const Empty();
    }
    for (List<dynamic> parameter in intensityControl) {
      debugPrint(parameter.toString());
      String parameterKey = 'Intensity Parameter # ${parameter[0]}';
      if (!parameters.contains(parameterKey)) {
        intensityWidgets.add(ParameterSlider(
          osc: widget.osc,
          attributes: parameter,
          superSetState: setState,
          key: Key(parameterKey),
        ));
      }
    }
    if (intensityWidgets.isEmpty) {
      return const Empty();
    }
    return Row(
      children: intensityWidgets,
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
