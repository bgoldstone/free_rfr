import 'package:flutter/material.dart';
import 'package:free_rfr/objects/osc_control.dart';
import 'package:free_rfr/objects/parameters.dart';
import 'package:free_rfr/pages/channel_check.dart';
import 'package:free_rfr/pages/controls.dart';
import 'package:free_rfr/pages/cues.dart';
import 'package:free_rfr/pages/direct_selects.dart';
import 'package:free_rfr/pages/facepanel.dart';
import 'package:free_rfr/pages/facepanels/faders.dart';
import 'package:free_rfr/pages/facepanels/keypad.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class FreeRFR extends StatefulWidget {
  final OSC osc;
  final List<double> hueSaturation;
  final ParameterMap currentChannel;
  final void Function(String) setCommandLine;
  final void Function(int) setCurrentConnection;
  final String commandLine;
  final double previousCue;
  final double currentCue;
  final double nextCue;
  final int currentCueList;
  final String previousCueText;
  final String currentCueText;
  final String nextCueText;
  const FreeRFR(
      {super.key,
      required this.osc,
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
      required this.setCurrentConnection});

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
  Widget build(BuildContext context) {
    List<Widget> pages = [
      FacePanel(key: const Key('Facepanel'), osc: widget.osc),
      FaderControls(osc: widget.osc),
      ChannelCheck(osc: widget.osc),
      Controls(
        key: const Key('Controls'),
        osc: widget.osc,
        currentChannel: widget.currentChannel,
        hueSaturation: widget.hueSaturation,
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
      DirectSelects(osc: widget.osc, currentChannel: widget.currentChannel),
    ];
    return PopScope(
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        widget.setCurrentConnection(-1);
      },
      child: Scaffold(
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

                    /// 4. Controls: a page with controls for selecting parameters, setting values,
                    ///    and setting cues.
                    /// 5. Playback: a page with controls for playing back cues.
                    ///
                    /// The command line is shown when the button in the app bar is pressed. The
                    /// command line shows the current command line of the Hog 4 console.
                  ]);
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
            clearCommandLine(context),
            shutdownMultiConsole(context),
            keypad(context),
          ],
        ),
        body: pages.isEmpty ? const CircularProgressIndicator() : pages[index],
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.keyboard), label: 'Facepanel'),
            BottomNavigationBarItem(
                icon: Icon(Symbols.instant_mix), label: 'Faders'),
            BottomNavigationBarItem(
                icon: Icon(Icons.lightbulb), label: 'Channel Check'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Controls'),
            BottomNavigationBarItem(
                icon: Icon(Symbols.play_pause), label: 'Playback'),
            BottomNavigationBarItem(
                icon: Icon(Symbols.grid_on), label: 'Direct Selects'),
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
        ),
      ),
    );
  }

  IconButton keypad(BuildContext context) {
    return IconButton(
      onPressed: () {
        keypadWindow(context, clearCommandLine(context));
        // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        //   return keypadWindow(context);
        // }));
      },
      icon: const Icon(Icons.dialpad_rounded),
      tooltip: "Keypad",
    );
  }

  IconButton clearCommandLine(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.backspace),
      color: MediaQuery.of(context).platformBrightness == Brightness.dark
          ? Colors.white
          : Colors.black,
      onPressed: () {
        widget.osc.sendKey('clear_cmdline');
        widget.osc.setCommandLine!('LIVE: ');
      },
      tooltip: "Clear Command Line",
    );
  }

  IconButton shutdownMultiConsole(BuildContext context) {
    return IconButton(
      onPressed: () => showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Shut Down Eos Console'),
              content: const Text(
                  'Are you sure you want to shut down your Eos Console?'),
              actions: [
                TextButton(
                    onPressed: (() => Navigator.of(context).pop()),
                    child: const Text('Cancel')),
                TextButton(
                    onPressed: () {
                      widget.osc.shutdownMultiConsole();
                      Navigator.pop(context);
                      Navigator.of(context).pop();
                      widget.setCurrentConnection(-1);
                    },
                    child: const Text('OK')),
              ],
            );
          }),
      icon: const Icon(Icons.power_settings_new),
      tooltip: 'Shut Down MultiConsole',
    );
  }

  void keypadWindow(BuildContext context, IconButton clearCommandLine) {
    showGeneralDialog(
        context: context,
        pageBuilder: (context, anim1, anim2) {
          return Scaffold(
            appBar: AppBar(
                automaticallyImplyLeading: false,
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
                  clearCommandLine,
                  IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close))
                ]),
            body: Keypad(
              osc: widget.osc,
              isKeypadWindow: true,
            ),
          );
        });
  }
}
