import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:free_rfr/keyboard_shortcuts.dart';
import 'package:free_rfr/objects/osc_control.dart';
import 'package:free_rfr/objects/parameters.dart';
import 'package:free_rfr/pages/controls.dart';
import 'package:free_rfr/pages/cues.dart';
import 'package:free_rfr/pages/facepanel.dart';
import 'package:free_rfr/pages/facepanels/keypad.dart';
import 'package:free_rfr/pages/pan_tilt_control.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class FreeRFR extends StatefulWidget {
  final OSC osc;
  final void Function(ParameterList) setCurrentChannel;
  final List<double> hueSaturation;
  final ParameterList currentChannel;
  final void Function(String) setCommandLine;
  final String commandLine;
  final double previousCue;
  final double currentCue;
  final double nextCue;
  final int currentCueList;
  final String previousCueText;
  final String currentCueText;
  final String nextCueText;
  const FreeRFR({
    super.key,
    required this.osc,
    required this.setCurrentChannel,
    required this.currentChannel,
    required this.hueSaturation,
    required this.setCommandLine,
    required this.commandLine,
    required this.previousCue,
    required this.currentCue,
    required this.nextCue,
    required this.currentCueList,
    required this.previousCueText,
    required this.currentCueText,
    required this.nextCueText,
  });

  @override
  State<FreeRFR> createState() => _FreeRFRState();
}

class _FreeRFRState extends State<FreeRFR> {
  Map<String, dynamic> activeConnection = {};
  int index = 0;
  int currentConnectionIndex = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    HardwareKeyboard.instance.removeHandler((event) => false);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      FacePanel(key: const Key('Facepanel'), osc: widget.osc),
      Controls(
        key: const Key('Controls'),
        osc: widget.osc,
        currentChannel: widget.currentChannel,
        hueSaturation: widget.hueSaturation,
      ),
      PanTiltControl(
        minPan: widget.currentChannel[20]?[0] ?? 0,
        maxPan: widget.currentChannel[20]?[1] ?? 0,
        minTilt: widget.currentChannel[20]?[2] ?? 0,
        maxTilt: widget.currentChannel[20]?[3] ?? 0,
        currentPan: widget.currentChannel[20]?[4] ?? 0,
        currentTilt: widget.currentChannel[20]?[5] ?? 0,
        key: const Key('PanTiltControl'),
        osc: widget.osc,
      ),
      Cues(
        key: const Key('CueList'),
        osc: widget.osc,
        currentCue: widget.currentCue,
        currentCueList: widget.currentCueList,
        currentCueText: widget.currentCueText,
        nextCue: widget.nextCue,
        nextCueText: widget.nextCueText,
        previousCue: widget.previousCue,
        previousCueText: widget.previousCueText,
      ),
    ];
    return KeyboardShortcuts(
      osc: widget.osc,
      child: Scaffold(
        appBar: freeRFRAppBar(context),
        body: pages.isEmpty ? const CircularProgressIndicator() : pages[index],
        bottomNavigationBar: bottomNavBar(context),
      ),
    );
  }

  BottomNavigationBar bottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.keyboard), label: 'Facepanel'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Controls'),
        BottomNavigationBarItem(
            icon: Icon(Symbols.point_scan), label: 'Pan/Tilt Control'),
        BottomNavigationBarItem(
            icon: Icon(Symbols.play_pause), label: 'Playback'),
      ],
      selectedItemColor: Colors.yellow,
      currentIndex: index,
      unselectedItemColor:
          MediaQuery.of(context).platformBrightness == Brightness.dark
              ? Colors.white
              : Colors.black,
      onTap: (i) => setState(() {
        index = i;
      }),
      showSelectedLabels: true,
    );
  }

  AppBar freeRFRAppBar(BuildContext context) {
    return AppBar(
      title: TextButton(
        onPressed: () {
          AlertDialog alert = AlertDialog(
            title: const Text('Command Line'),
            content: Text(widget.commandLine),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK')),
            ],
          );
          showDialog(context: context, builder: (context) => alert);
        },
        child: Text(
          widget.commandLine,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: widget.commandLine.startsWith('BLIND')
                ? Colors.blue
                : Theme.of(context).primaryColor,
            fontSize: 15,
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return keypadWindow(context);
            }));
          },
          icon: const Icon(Icons.dialpad_rounded),
        ),
        IconButton(
          icon: const Icon(Icons.backspace),
          color: MediaQuery.of(context).platformBrightness == Brightness.dark
              ? Colors.white
              : Colors.black,
          onPressed: () {
            widget.osc.sendKey('clear_cmdline');
          },
        ),
      ],
    );
  }

  Scaffold keypadWindow(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextButton(
          onPressed: () {
            AlertDialog alert = AlertDialog(
              title: const Text('Command Line'),
              content: Text(widget.commandLine),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK')),
              ],
            );
            showDialog(context: context, builder: (context) => alert);
          },
          child: Text(
            widget.commandLine,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: widget.commandLine.startsWith('BLIND')
                  ? Colors.blue
                  : Theme.of(context).primaryColor,
              fontSize: 15,
            ),
          ),
        ),
      ),
      body: Keypad(osc: widget.osc),
    );
  }
}
