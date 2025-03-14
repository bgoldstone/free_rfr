import 'package:flutter/material.dart';
import 'package:free_rfr/objects/osc_control.dart';
import 'package:free_rfr/objects/parameters.dart';
import 'package:free_rfr/widgets/button.dart';

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

class _IntensityControlState extends ControlWidget<IntensityControl> {
  List<Widget> intensityWidgets = [];
  ParameterMap? currentChannel;

  _IntensityControlState()
      : super(controllingParameters: [ParameterType.intens]);

  @override
  void initState() {
    super.initState();
    currentChannel ??= widget.currentChannel;
    widget.osc.registerControlState(this);
  }

  @override
  void updateCurrentChannel(ParameterMap map) {
    if(!mounted) return;
    setState(() {
      currentChannel = map;
    });
  }


  @override
  Widget build(BuildContext context) {
    debugPrint(currentChannel!.toString());
    if (!currentChannel!.containsKey(ParameterType.intens)) {
      return Empty(widget.osc, "Intensity");
    }
    var intens = currentChannel![ParameterType.intens]?[1] ?? 0;
    var boxHeight = MediaQuery
        .of(context)
        .size
        .height * 0.7;
    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: boxHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Button(
                  "Full",
                      () {
                    widget.osc.setParameter('Intens', 100);
                    setState(() {
                      intens = 100;
                    });
                  },
                  color: intens == 100 ? Colors.greenAccent : Colors.grey,
                ),
                Button(
                  "75%",
                      () {
                    widget.osc.setParameter('Intens', 75);
                    setState(() {
                      intens = 75;
                    });
                  },
                  color: intens == 75 ? Colors.greenAccent : Colors.grey,
                ),
                Button(
                  "50%",
                      () {
                    widget.osc.setParameter('Intens', 50);
                    setState(() {
                      intens = 50;
                    });
                  },
                  color: intens == 50 ? Colors.greenAccent : Colors.grey,
                ),
                Button(
                  "25%",
                      () {
                    widget.osc.setParameter('Intens', 25);
                    setState(() {
                      intens = 25;
                    });
                  },
                  color: intens == 25 ? Colors.greenAccent : Colors.grey,
                ),
                Button(
                  "Out",
                      () {
                    widget.osc.setParameter('Intens', 0);
                    setState(() {
                      intens = 0;
                    });
                  },
                  color: intens == 0 ? Colors.greenAccent : Colors.grey,
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text("Intensity: ${intens.toStringAsFixed(2)}"),
              SizedBox(
                height: boxHeight,
                child: RotatedBox(
                  quarterTurns: 3,
                  child: Slider(
                    value: intens,
                    min: 0,
                    max: 100,
                    onChanged: (value) {
                      widget.osc.setParameter('Intens', value.roundToDouble());
                      setState(() {
                        intens = value;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class Empty extends StatelessWidget {
  final OSC osc;
  final String name;
  const Empty(
      this.osc, this.name,{
        super.key,
      });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No $name Control for this channel',
        textAlign: TextAlign.center,
      ),
    );
  }
}