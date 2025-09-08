import 'package:flutter/material.dart';
import 'package:free_rfr/configurations/context.dart';

import 'package:free_rfr/objects/osc_control.dart';
import 'package:free_rfr/objects/parameters.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class PanTiltControl extends StatefulWidget {
  final OSC osc;
  const PanTiltControl({required this.osc, super.key});
  @override
  PanTiltControlState createState() => PanTiltControlState();
}

class PanTiltControlState extends ControlWidget<PanTiltControl> {
  double? x; // Current X position of the point
  double? y; // Current Y position of the point
  double? panSize;
  double? tiltSize;
  double currentPan = 0;
  double currentTilt = 0;
  double maxPan = 0;
  double minPan = 0;
  double maxTilt = 0;
  double minTilt = 0;
  Size? size;

  PanTiltControlState()
      : super(controllingParameters: [
          ParameterType.pan,
          ParameterType.tilt
        ]); // Current size of the point

  @override
  void initState() {
    final ctx = context.read<FreeRFRContext>();
    currentPan = ctx.currentChannel[ParameterType.pan]![0];
    currentTilt = ctx.currentChannel[ParameterType.tilt]![0];
    maxPan = ctx.currentChannel[ParameterType.maxPan]![0];
    minPan = ctx.currentChannel[ParameterType.minPan]![0];
    maxTilt = ctx.currentChannel[ParameterType.maxTilt]![0];
    minTilt = ctx.currentChannel[ParameterType.minTilt]![0];
    x = currentPan;
    y = currentTilt;
    panSize = maxPan.abs() + minPan.abs();
    tiltSize = maxTilt.abs() + minTilt.abs();
    widget.osc.registerControlState(this);
    super.initState();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      x = details.localPosition.dx - panSize! / 2;
      y = details.localPosition.dy - tiltSize! / 2;
      //Update Y based on drag delta
      if (x! < minPan) {
        x = minPan;
      } else if (x! > maxPan) {
        x = maxPan;
      }

      if (y! < minTilt) {
        y = minTilt;
      } else if (y! > maxTilt) {
        y = maxTilt;
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
      if (x! < minPan) {
        x = minPan;
      } else if (x! > maxPan) {
        x = maxPan;
      }
      if (y! < minTilt) {
        y = minTilt;
      } else if (y! > maxTilt) {
        y = maxTilt;
      }
      widget.osc.updatePanTilt(x!, y! * -1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentChannel = context.watch<FreeRFRContext>().currentChannel;
    currentPan = currentChannel[ParameterType.pan]![0];
    currentTilt = currentChannel[ParameterType.tilt]![0];
    x = currentPan;
    y = currentTilt;
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
                  min: minPan.roundToDouble(),
                  max: maxPan.roundToDouble(),
                  onChanged: (value) {
                    setState(() {
                      if (x! >= minPan && x! <= maxPan) {
                        x = value;
                        widget.osc.updatePanTilt(x!, y!);
                      }
                    });
                  },
                  onChangeEnd: (value) {},
                ),
                Row(
                  children: [
                    //     //max and min buttons for pan

                    //     ElevatedButton(
                    //       onPressed: () {
                    //         setState(() {
                    //           x = minPan;
                    //           widget.osc.updatePanTilt(x!, y!);
                    //         });
                    //       },
                    //       child: const Text('Min Pan'),
                    //     ),
                    //     ElevatedButton(
                    //       onPressed: () {
                    //         setState(() {
                    //           x = maxPan;
                    //           widget.osc.updatePanTilt(x!, y!);
                    //         });
                    //       },
                    //       child: const Text('Max Pan'),
                    //     ),
                    //     ElevatedButton(
                    //         onPressed: () {
                    //           setState(() {
                    //             x = 0;
                    //             widget.osc.updatePanTilt(x!, y!);
                    //           });
                    //         },
                    //         child: const Text("Home")),
                    Center(child: Text("Pan: ${x!.toStringAsFixed(2)}")),
                  ],
                ),
                //same for tilt
                RotatedBox(
                    quarterTurns: 1,
                    child: Slider(
                      value: y!,
                      min: minTilt.roundToDouble(),
                      max: maxTilt.roundToDouble(),
                      onChanged: (value) {
                        setState(() {
                          if (y! >= minTilt && y! <= maxTilt) {
                            y = value;
                            widget.osc.updatePanTilt(x!, -y!);
                          }
                        });
                      },
                      onChangeEnd: (value) {},
                    )),
                Row(children: [
                  //   ElevatedButton(
                  //     onPressed: () {
                  //       setState(() {
                  //         y = minTilt;
                  //         widget.osc.updatePanTilt(x!, y!);
                  //       });
                  //     },
                  //     child: const Text('Min Tilt'),
                  //   ),
                  //   ElevatedButton(
                  //     onPressed: () {
                  //       setState(() {
                  //         y = maxTilt;
                  //         widget.osc.updatePanTilt(x!, y!);
                  //       });
                  //     },
                  //     child: const Text('Max Tilt'),
                  //   ),
                  //   ElevatedButton(
                  //       onPressed: () {
                  //         y = 0;
                  //         widget.osc.updatePanTilt(x!, y!);
                  //       },
                  //       child: const Text("Home")),
                  Center(child: Text("Tilt: ${(y! * -1).toStringAsFixed(2)}"))
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
                  child: Container()
                  // Container(
                  //     width: 20.0, // Adjust size of the point
                  //     height: 20.0,
                  //     decoration: BoxDecoration(
                  //       color: Theme.of(context)
                  //           .primaryColor, // Color of the point
                  //       shape: BoxShape.circle,
                  //     ),
                  //   ),
                  ),
            ),
            // Positioned(
            //   bottom: 15,
            //   left: size!.width / 2 - 50,
            //   child: Text("Pan: $x, Tilt: ${y! * -1}"),
            // )
          ]),
        ),
      ]),
    );
  }
}
