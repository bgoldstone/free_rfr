import 'package:flutter/material.dart';
import 'package:free_rfr/objects/osc_control.dart';

class ParameterEntry extends StatefulWidget {
  final OSC osc;
  final List<dynamic> attributes;
  final double minValue;
  final double maxValue;
  final bool isParam;
  const ParameterEntry({
    super.key,
    required this.osc,
    required this.attributes,
    this.minValue = 0,
    this.maxValue = 100,
    this.isParam = false,
  });

  @override
  State<ParameterEntry> createState() => _ParameterEntryState();
}

class _ParameterEntryState extends State<ParameterEntry> {
  double? currentValue;
  void updateValue(double value) {
    if (currentValue! + value > widget.maxValue ||
        currentValue! + value < widget.minValue) return;
    currentValue = currentValue! + value;
    widget.isParam
        ? widget.osc.setParamter(widget.attributes[1], currentValue!)
        : widget.osc
            .setParamString(widget.attributes[1], currentValue!.toString());
    _updateState();
  }

  @override
  void initState() {
    super.initState();
    currentValue = widget.attributes[2];
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FittedBox(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              // child: TextButton(
              //   child: Text('${widget.attributes[1]}',
              //       style: const TextStyle(fontWeight: FontWeight.bold)),
              //   onPressed: () => widget.osc
              //       .sendCommandNoEnter('/eos/wheel/${widget.attributes[1]}'),
              // ),
              child: Text('${widget.attributes[1]}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  widget.isParam
                      ? widget.osc.setParameterMin(widget.attributes[1])
                      : widget.osc.setParamMinString(widget.attributes[1]);
                  currentValue = widget.minValue;
                  _updateState();
                },
                child: const Text(
                  'Min',
                ),
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
              child: IconButton(
                onPressed: () => updateValue(-0.1),
                icon: const Icon(Icons.keyboard_arrow_left),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                child: Text(currentValue!.toStringAsFixed(2)),
                onPressed: () {
                  widget.osc.setParamterHome(widget.attributes[1]);
                  currentValue = 0;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () => updateValue(0.1),
                icon: const Icon(Icons.keyboard_arrow_right),
              ),
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
              child: ElevatedButton(
                onPressed: () {
                  widget.isParam
                      ? widget.osc.setParameterMax(widget.attributes[1])
                      : widget.osc.setParamMaxString(widget.attributes[1]);
                  currentValue = widget.maxValue;
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
    debugPrint(currentValue.toString());
    setState(() {});
  }
}
