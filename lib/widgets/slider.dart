import 'package:flutter/material.dart';
import 'package:free_rfr/osc_control.dart';

class ParameterSlider extends StatefulWidget {
  final OSC osc;
  final List<dynamic> attributes;
  final double minValue;
  final double maxValue;
  final void Function(void Function()) superSetState;
  const ParameterSlider({
    super.key,
    required this.osc,
    required this.attributes,
    this.minValue = 0,
    this.maxValue = 100,
    required this.superSetState,
  });

  @override
  State<ParameterSlider> createState() => _ParameterSliderState();
}

class _ParameterSliderState extends State<ParameterSlider> {
  double currentValue = 0;

  void updateValue(double value) {
    setState(() {
      if (value >= widget.minValue && value <= widget.maxValue) {
        setState(() {
          currentValue = value.round().toDouble();
        });
        widget.osc.setParameter(widget.attributes[1], value);
        // widget.superSetState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    currentValue = widget.attributes[2];
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(widget.attributes.toString());

    return Column(
      children: [
        Text('${widget.attributes[1]}'),
        IconButton(
          onPressed: () => updateValue(currentValue + 5),
          icon: const Icon(Icons.arrow_upward),
        ),
        RotatedBox(
          quarterTurns: 3,
          child: Slider(
            value: currentValue,
            min: widget.minValue,
            max: widget.maxValue,
            onChanged: (value) {},
            onChangeEnd: updateValue,
            divisions: (widget.maxValue - widget.minValue).toInt(),
          ),
        ),
        IconButton(
          onPressed: () => updateValue(currentValue - 5),
          icon: const Icon(Icons.arrow_downward),
        ),
      ],
    );
  }
}
