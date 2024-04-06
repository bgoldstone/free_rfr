import 'package:flutter/material.dart';

import 'package:free_rfr/objects/osc_control.dart';

class PanTiltControl extends StatefulWidget {
  final double maxPan;
  final double minPan;
  final double maxTilt;
  final double minTilt;
  final double currentPan;
  final double currentTilt;
  final OSC osc;
  const PanTiltControl(
      {required this.maxPan,
      required this.minPan,
      required this.maxTilt,
      required this.minTilt,
      required this.currentPan,
      required this.currentTilt,
      required this.osc,
      super.key});

  @override
  State<PanTiltControl> createState() => _PanTiltControlState();
}

class _PanTiltControlState extends State<PanTiltControl> {
  double? x; // Current X position of the point
  double? y; // Current Y position of the point
  double? panSize;
  double? tiltSize;
  Size? size; // Current size of the point
  Offset? center;

  @override
  void initState() {
    super.initState();
    x = widget.currentPan;
    y = widget.currentTilt;
    panSize = widget.maxPan.abs() + widget.minPan.abs();
    tiltSize = widget.maxTilt.abs() + widget.minTilt.abs();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      x = double.parse((x! + details.delta.dx)
          .toStringAsFixed(3)); // Update X based on drag delta
      y = double.parse((y! + details.delta.dy)
          .toStringAsFixed(3)); // Update Y based on drag delta
      if (x! < widget.minPan) {
        x = widget.minPan;
      } else if (x! > widget.maxPan) {
        x = widget.maxPan;
      }

      if (y! < widget.minTilt) {
        y = widget.minTilt;
      } else if (y! > widget.maxTilt) {
        y = widget.maxTilt;
      }
    });
  }

  void _onPanEnd(DragEndDetails details) {
    widget.osc.updatePanTilt(x!, y! * -1);
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    center = size!.center(Offset.zero);
    var top = size!.height / 2 - tiltSize! / 2 + 10;
    var left = size!.width / 2 - panSize! / 2 + 10;
    if (panSize! + 20 > size!.width || tiltSize! + 20 > size!.height) {
      return const Center(
          child: Text('Screen too small to support Pan Tilt Grid Control.'));
    }
    return Stack(
      children: [
        // Empty box
        Positioned(
          top: top,
          left: left,
          child: GestureDetector(
            child: Container(
              height: tiltSize!,
              width: panSize!,
              decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).primaryColor)),
            ),
            // TODO: Fix tap on box
            // onTapDown: (details) {
            //   setState(() {
            //     debugPrint(details.localPosition.toString());
            //     x = double.parse(
            //         (details.localPosition.dx - center!.dx / 2 - 60)
            //             .toStringAsFixed(3));
            //     y = double.parse(
            //         (details.localPosition.dy - center!.dy / 2 + 60)
            //             .toStringAsFixed(3));
            //   });
            // },
          ),
        ),

        // Point
        Positioned(
          top: center!.dy + y!,
          left: center!.dx + x!,
          child: GestureDetector(
            onPanUpdate: _onPanUpdate,
            onPanEnd: _onPanEnd, // Update position on drag
            child: Container(
              width: 20.0, // Adjust size of the point
              height: 20.0,
              decoration: const BoxDecoration(
                color: Colors.white, // Color of the point
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 15,
          left: size!.width / 2 - 50,
          child: Text("Pan: $x, Tilt: ${y! * -1}"),
        )
      ],
    );
  }
}
