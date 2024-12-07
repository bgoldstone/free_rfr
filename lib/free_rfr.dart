import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:free_rfr/pages/channel_check.dart';
import 'package:free_rfr/widgets/keyboard_shortcuts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:free_rfr/objects/osc_control.dart';
import 'package:free_rfr/objects/parameters.dart';
import 'package:free_rfr/pages/controls.dart';
import 'package:free_rfr/pages/cues.dart';
import 'package:free_rfr/pages/facepanel.dart';
import 'package:free_rfr/pages/facepanels/keypad.dart';
import 'package:free_rfr/pages/pan_tilt_control.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:url_launcher/url_launcher.dart';

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
    IconButton clearCommandLine = IconButton(
      icon: const Icon(Icons.backspace),
      color: MediaQuery.of(context).platformBrightness == Brightness.dark
          ? Colors.white
          : Colors.black,
      onPressed: () {
        widget.osc.sendKey('clear_cmdline');
      },
    );
    List<Widget> pages = [
      FacePanel(key: const Key('Facepanel'), osc: widget.osc),
      Controls(
        key: const Key('Controls'),
        osc: widget.osc,
        currentChannel: widget.currentChannel,
        hueSaturation: widget.hueSaturation,
        commandLine: widget.commandLine,
      ),
      ChannelCheck(osc: widget.osc),
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
        appBar: freeRFRAppBar(context, clearCommandLine),
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
            icon: Icon(Icons.lightbulb),
            label: 'Channel Check',
            tooltip: 'Channel Check'),
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

  AppBar freeRFRAppBar(BuildContext context, IconButton clearCommandLine) {
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
            keypadWindow(context, clearCommandLine);
            // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            //   return keypadWindow(context);
            // }));
          },
          icon: const Icon(Icons.dialpad_rounded),
        ),
        clearCommandLine,
        IconButton(
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
                        },
                        child: const Text('OK')),
                  ],
                );
              }),
          icon: const Icon(Icons.power_settings_new),
          tooltip: 'Shut Down MultiConsole',
        ),
        donateButton(context)
      ],
    );
  }

  IconButton donateButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Donate'),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Like What I do? Please consider making a donation!",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              icon: const FaIcon(FontAwesomeIcons.paypal),
                              onPressed: () => launchUrl(Uri.parse(
                                  "https://paypal.me/BenjaminGoldstone")),
                              tooltip: 'Paypal',
                            ),
                            IconButton(
                              icon: const FaIcon(FontAwesomeIcons.vimeo),
                              onPressed: () => launchUrl(Uri.parse(
                                  "https://www.venmo.com/bgoldstone")),
                              tooltip: 'Venmo',
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  actions: [
                    TextButton(
                        child: const Text('OK'),
                        onPressed: () => Navigator.of(context).pop())
                  ],
                ));
      },
      icon: const Icon(Icons.monetization_on),
      tooltip: 'Donate',
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
