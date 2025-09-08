import 'package:flutter/material.dart';
import 'package:free_rfr/configurations/context.dart';
import 'package:free_rfr/objects/osc_control.dart';
import 'package:free_rfr/objects/parameters.dart';
import 'package:free_rfr/widgets/button.dart';
import 'package:provider/provider.dart';

class IntensityControl extends StatefulWidget {
  final OSC osc;
  const IntensityControl({
    super.key,
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
    final ctx = context.watch<FreeRFRContext>();
    debugPrint(ctx.currentChannel.toString());
    if (!ctx.currentChannel.containsKey(ParameterType.intens)) {
      return Empty(widget.osc);
    }
    var intens = ctx.currentChannel[ParameterType.intens]?[0] ?? 0;
    var boxHeight = MediaQuery.of(context).size.height * 0.7;
    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: boxHeight * .75,
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
                ),
                Button(
                  "75%",
                  () {
                    widget.osc.setParameter('Intens', 75);
                    setState(() {
                      intens = 100;
                    });
                  },
                ),
                Button(
                  "50%",
                  () {
                    widget.osc.setParameter('Intens', 50);
                    setState(() {
                      intens = 100;
                    });
                  },
                ),
                Button(
                  "25%",
                  () {
                    widget.osc.setParameter('Intens', 25);
                    setState(() {
                      intens = 100;
                    });
                  },
                ),
                Button(
                  "Out",
                  () {
                    widget.osc.setParameter('Intens', 0);
                    setState(() {
                      intens = 100;
                    });
                  },
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
  const Empty(
    this.osc, {
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
