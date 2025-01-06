import 'package:flutter/material.dart';

import 'package:free_rfr/objects/osc_control.dart';
import 'package:free_rfr/objects/parameters.dart';

class PanTiltControl extends StatefulWidget {
  double maxPan = 200;
  double minPan = -200;
  double maxTilt = 200;
  double minTilt = -200;
  double currentPan = 0;
  double currentTilt = 0;
  final ParameterMap currentChannel;
  final OSC osc;
  PanTiltControl({required this.currentChannel, required this.osc, super.key});

  @override
  PanTiltControlState createState() => PanTiltControlState();
}

class PanTiltControlState extends ControlWidget<PanTiltControl> {
  double? x; // Current X position of the point
  double? y; // Current Y position of the point
  double? panSize;
  double? tiltSize;
  Size? size;

  PanTiltControlState()
      : super(controllingParameters: [
          ParameterType.pan,
          ParameterType.tilt
        ]); // Current size of the point

  @override
  void initState() {
    super.initState();
    x = widget.currentPan;
    y = widget.currentTilt;
    panSize = widget.maxPan.abs() + widget.minPan.abs();
    tiltSize = widget.maxTilt.abs() + widget.minTilt.abs();
    widget.osc.registerControlState(this);
  }

  void updateValues(
      double minPan, double maxPan, double minTilt, double maxTilt) {
    widget.minPan = minPan;
    widget.maxPan = maxPan;
    widget.minTilt = minTilt;
    widget.maxTilt = maxTilt;
    debugPrint("Updated min and max values");
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      x = details.localPosition.dx - panSize! / 2;
      y = details.localPosition.dy - tiltSize! / 2;
      //Update Y based on drag delta
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
      debugPrint('Pan: $x, Tilt: ${y! * -1}');

      widget.osc.updatePanTilt(x!, y! * -1);
    });
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      x = details.localPosition.dx - panSize! / 2;
      y = details.localPosition.dy - tiltSize! / 2;
      debugPrint('Pan: $x, Tilt: ${y! * -1}');
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
      widget.osc.updatePanTilt(x!, y! * -1);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!(widget.currentChannel.containsKey(ParameterType.pan) &&
        widget.currentChannel.containsKey(ParameterType.tilt))) {
      return const Center(
        child: Text(
          'No Pan Tilt Control for this channel',
          textAlign: TextAlign.center,
        ),
      );
    }
    widget.currentPan = widget.currentChannel[ParameterType.pan]![1];
    widget.currentTilt = widget.currentChannel[ParameterType.tilt]![1];
    x = widget.currentPan;
    y = widget.currentTilt;
    size = MediaQuery.of(context).size;
    if (panSize! + 30 > size!.width || tiltSize! + 30 > size!.height) {
      return const Center(
          child: Text('Screen too small to support Pan Tilt Grid Control.'));
    }
    return Center(
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        //slider for pan and tilt
        SizedBox(
            width: size!.width / 2 - 50,
            height: size!.height - 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Slider(
                  value: x!,
                  min: widget.minPan,
                  max: widget.maxPan,
                  onChanged: (value) {
                    setState(() {
                      x = value;
                      widget.osc.updatePanTilt(x!, y! * -1);
                    });
                  },
                  onChangeEnd: (value) {},
                ),
                Row(
                  children: [
                    //max and min buttons for pan

                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          x = widget.minPan;
                          widget.osc.updatePanTilt(x!, y! * -1);
                        });
                      },
                      child: const Text('Min Pan'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          x = widget.maxPan;
                          widget.osc.updatePanTilt(x!, y! * -1);
                        });
                      },
                      child: const Text('Max Pan'),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            x = 0;
                            widget.osc.updatePanTilt(x!, y! * -1);
                          });
                        },
                        child: const Text("Home")),
                    Text("Pan: $x"),
                  ],
                ),
                //same for tilt
                RotatedBox(
                    quarterTurns: 3,
                    child: Slider(
                      value: -y!,
                      min: widget.minTilt,
                      max: widget.maxTilt,
                      onChanged: (value) {
                        setState(() {
                          y = -value;
                          widget.osc.updatePanTilt(x!, y! * -1);
                        });
                      },
                      onChangeEnd: (value) {},
                    )),
                Row(children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        y = widget.minTilt;
                        widget.osc.updatePanTilt(x!, y! * -1);
                      });
                    },
                    child: const Text('Min Tilt'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        y = widget.maxTilt;
                        widget.osc.updatePanTilt(x!, y! * -1);
                      });
                    },
                    child: const Text('Max Tilt'),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        y = 0;
                        widget.osc.updatePanTilt(x!, y! * -1);
                      },
                      child: const Text("Home")),
                  Text("Tilt: ${y! * -1}")
                ])
              ],
            )),

        Container(
          height: tiltSize!,
          width: panSize!,
          decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor)),
          child: Stack(children: [
            GestureDetector(
              onTapDown: (details) => _onTapDown(details),
              onPanUpdate: (details) => _onPanUpdate(details),
              onPanEnd: (details) {},
              //Update position on tap
              child: Container(
                height: size!.height,
                width: size!.width,
                color: Colors.transparent,
              ),
            ),
            Positioned(
              top: panSize! / 2 + y! - 10,
              left: tiltSize! / 2 + x! - 10,
              child: GestureDetector(
                onPanUpdate: (call) => _onPanUpdate(call),
                //Update position on drag
                child: Container(
                  width: 20.0, // Adjust size of the point
                  height: 20.0,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor, // Color of the point
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
          ]),
        ),
      ]),
    );
  }
}
