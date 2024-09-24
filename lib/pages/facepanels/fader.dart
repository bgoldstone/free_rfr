import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../objects/osc_control.dart';
import '../../objects/parameters.dart';
import '../../widgets/grid.dart';
import '../../widgets/slider.dart';
import '../controls/intensity.dart';

class FaderControls extends StatefulWidget {
  final OSC osc;
  const FaderControls({
    super.key,
    required this.osc,
  });

  @override
  State<FaderControls> createState() => _FaderControlsState();
}

class _FaderControlsState extends State<FaderControls> {

  int faderPage = 1;
  late Future<List<Fader>> loadedFaders;

  @override
  void initState() {
    super.initState();
    loadedFaders = loadFaders();
  }

  Future<List<Fader>> loadFaders () async{
    List<Fader> faders = [];
    for (int i = 1; i <= 10; i++) {
      faders.add(Fader(await widget.osc.getFaderInformation(faderPage, i), i, faderPage, 0));
    }
    return faders;
  }

  @override
  Widget build(BuildContext context) {
   //return grid of faders
    var pads = <Widget>[];
    for(int i = 0; i < 10; i++){
      pads.add(FutureBuilder(
        future: loadedFaders,
        builder: (BuildContext context, AsyncSnapshot<List<Fader>> snapshot) {
          if (snapshot.hasData) {
            return snapshot.data![i].buildFader(widget.osc, setState);
          } else {
            return const CircularProgressIndicator();
          }
        },
      ));
    }
    return SingleChildScrollView(scrollDirection: Axis.vertical, child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  faderPage --;
                  loadedFaders = loadFaders();
                });
              },
              icon: const Icon(Icons.arrow_back),
            ),
            const Text('Faders'),
            IconButton(
              onPressed: () {
                setState(() {
                  faderPage ++;
                  loadedFaders = loadFaders();
                });
              },
              icon: const Icon(Icons.arrow_forward),
            ),
          ],
        ),
        SizedBox(width: MediaQuery.sizeOf(context).width * 1, height: MediaQuery.sizeOf(context).height *2, child:
        GridView.count(
          crossAxisCount: 5,
          children: pads,
        ),)
      ],
    ));
  }
}

class Fader {
  String name = "";
  int index = 0;
  int faderPage = 0;
  int intensity = 0;

  Fader(this.name, this.index, this.faderPage, this.intensity);

  Widget buildFader(OSC osc, Function(void Function()) setState) {
    return SizedBox(
      height: 400,
      child:
    Card(
        child: Column(
          children: [
            Text(name),
            ParameterSlider(
              osc: osc,
              attributes: [index, 'Intensity', 0.0, 100.0, 0.0],
              superSetState: setState,
              key: Key('Fader $index'),
            ),
          ],)
    ));
  }


}