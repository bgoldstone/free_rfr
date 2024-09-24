import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../objects/osc_control.dart';
import '../../objects/parameters.dart';
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
    return Column(
      children: [
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            return FutureBuilder<List<Fader>>(
              future: loadedFaders,
              builder: (BuildContext context, AsyncSnapshot<List<Fader>> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return snapshot.data![index].buildFader(widget.osc, setState);
                } else {
                  return const CircularProgressIndicator();
                }
              },
            );
          },
        ),
        //next and previous buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            (faderPage != 1) ? IconButton(
              onPressed: () {
                setState(() {
                  faderPage = faderPage - 1;
                  loadedFaders = loadFaders();
                });
              },
              icon: const Icon(Icons.arrow_back),
            ) : Container(),
            IconButton(
              onPressed: () {
                setState(() {
                  faderPage = faderPage + 1;
                  loadedFaders = loadFaders();
                });
              },
              icon: const Icon(Icons.arrow_forward),
            ),
          ],
        ),
      ],
    );
  }
}

class Fader {
  String name = "";
  int index = 0;
  int faderPage = 0;
  int intensity = 0;

  Fader(this.name, this.index, this.faderPage, this.intensity);

  Widget buildFader(OSC osc, Function(void Function()) setState) {
    return Column(
      children: [
        Text(name),
        ParameterSlider(
          osc: osc,
          attributes: [index, 'Intensity', 0, 100, 0],
          superSetState: setState,
          key: Key('Fader $index'),
        ),
      ],
    );
  }


}