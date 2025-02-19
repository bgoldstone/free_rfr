import 'dart:io';

import 'package:flutter/material.dart';
import 'package:free_rfr/shortcuts.dart';

import '../../objects/osc_control.dart';

class FaderControls extends StatefulWidget {
  final OSC osc;

  const FaderControls({
    super.key,
    required this.osc,
  });

  @override
  State<FaderControls> createState() => FaderControlsState();
}

class FaderControlsState extends State<FaderControls> {
  int faderPage = 1;
  List<int> faderBanks = [];
  List<Fader> faders = [];
  final Map<String, String> pageLocale = {"en": "Page", "de": "Seite"};
  final String locale = Platform.localeName.split('_')[0];

  @override
  void initState() {
    super.initState();
    widget.osc.setupFaderBank(10, this);
  }

  void updateFader(int index, double intensity, String name, int range,
      {bool forceUpdate = false}) {
    setState(() {
      if (faders.length < index) {
        faders.add(Fader(name, index, faderPage, intensity));
      } else {
        if (forceUpdate) {
          faders[index - 1].forceUpdate(name, index, faderPage, intensity);
        } else {
          faders[index - 1].update(name, index, faderPage, intensity);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //return grid of faders
    debugPrint(faders.toString());
    return FreeRFRShortcutManager(
      SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (faderPage == 1) return;
                      widget.osc.send("/eos/fader/1/page/-1", []);
                      faderPage--;
                    });
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                Text('Faders (${pageLocale[locale]} $faderPage)'),
                IconButton(
                  onPressed: () {
                    setState(() {
                      widget.osc.send("/eos/fader/1/page/1", []);
                      faderPage++;
                    });
                  },
                  icon: const Icon(Icons.arrow_forward),
                ),
              ],
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 1,
              height: MediaQuery.sizeOf(context).height * 2,
              child: GridView.count(
                crossAxisCount: 5,
                children: faders
                    .map((fader) => fader.buildFader(widget.osc, setState))
                    .toList(),
              ),
            )
          ],
        ),
      ),
      widget.osc,
    );
  }
}

class Fader {
  String name = "";
  int index = 0;
  int faderPage = 1;
  double intensity = 0;

  Fader(this.name, this.index, this.faderPage, this.intensity);

  Widget buildFader(OSC osc, Function(void Function()) setState) {
    return SizedBox(
        height: 400,
        child: Card(
            child: Column(
          children: [
            Text(name),
            RotatedBox(
              quarterTurns: 3,
              child: Slider(
                value: intensity * 100,
                min: 0,
                max: 100,
                onChanged: (value) {
                  setState(() {
                    intensity = value / 100;
                    osc.send("/eos/fader/1/$index", [intensity]);
                  });
                },
                onChangeEnd: (value) {},
              ),
            )
          ],
        )));
  }

  void update(String name, int index, int faderPage, double intensity) {
    //if name == "" dont update, also for 0 values in int
    if (name != "") this.name = name;
    if (index != 0) this.index = index;
    if (faderPage != 0) this.faderPage = faderPage;
    if (intensity != 0) this.intensity = intensity;
  }

  void forceUpdate(String name, int index, int faderPage, double intensity) {
    this.name = name;
    this.index = index;
    this.faderPage = faderPage;
    this.intensity = intensity;
    debugPrint("Force updated fader $name");
  }
}
