import 'package:flutter/material.dart';
import 'package:free_rfr/objects/osc_control.dart';

class ParameterEntry extends StatefulWidget {
  final OSC osc;
  final List<dynamic> attributes;
  final double minValue;
  final double maxValue;
  const ParameterEntry({
    super.key,
    required this.osc,
    required this.attributes,
    this.minValue = 0,
    this.maxValue = 100,
  });

  @override
  State<ParameterEntry> createState() => _ParameterEntryState();
}

class _ParameterEntryState extends State<ParameterEntry> {
  double currentValue = 0;

  void updateValue(double value) {
    String newValue = (currentValue + value).toStringAsFixed(2);
    widget.osc.setParameter(widget.attributes[1], newValue);
    currentValue += value;
    _updateState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(widget.attributes.toString());
    currentValue = widget.attributes[2];

    return Center(
      child: FittedBox(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('${widget.attributes[1]}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  widget.osc.setMinValue(widget.attributes[1]);
                  _updateState();
                },
                child: const Text(
                  'Min',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () => updateValue(-0.1),
                icon: const Icon(Icons.keyboard_arrow_left),
              ),
            ),
            GestureDetector(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () => updateValue(-1),
                  icon: const Icon(Icons.keyboard_double_arrow_left),
                ),
              ),
              onDoubleTap: () => updateValue(-5),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(currentValue.toString()),
            ),
            GestureDetector(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () => updateValue(1),
                  icon: const Icon(Icons.keyboard_double_arrow_right),
                ),
              ),
              onDoubleTap: () => updateValue(5),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () => updateValue(0.1),
                icon: const Icon(Icons.keyboard_arrow_right),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  widget.osc.setMaxValue(widget.attributes[1]);
                  _updateState();
                },
                child: const Text(
                  'Max',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateState() {
    setState(() {});
  }
}
