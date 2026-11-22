import 'dart:io';

import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:free_rfr/configurations/context.dart';
import 'package:free_rfr/objects/osc_control.dart';
import 'package:free_rfr/pages/channel_check.dart';
import 'package:free_rfr/pages/controls.dart';
import 'package:free_rfr/pages/cues.dart';
import 'package:free_rfr/pages/direct_selects.dart';
import 'package:free_rfr/pages/facepanel.dart';
import 'package:free_rfr/pages/facepanels/faders.dart';
import 'package:free_rfr/pages/facepanels/keypad.dart';
import 'package:free_rfr/shortcuts.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:provider/provider.dart';

class FreeRFR extends StatefulWidget {
  final OSC osc;
  final void Function(int) setCurrentConnection;
  const FreeRFR(
      {super.key, required this.osc, required this.setCurrentConnection});

  @override
  State<FreeRFR> createState() => _FreeRFRState();
}

class _FreeRFRState extends State<FreeRFR> {
  Map<String, dynamic> activeConnection = {};
  int index = 0;
  List<Widget> pages = [];
  late final FreeRFRContext rfrContext;
  bool _pageHotKeysRegistered = false;

  int currentConnectionIndex = -1;

  @override
  void initState() {
    super.initState();
    pages = [
      FacePanel(key: const Key('Facepanel'), osc: widget.osc),
      FaderControls(osc: widget.osc),
      ChannelCheck(osc: widget.osc),
      Controls(
        key: const Key('Controls'),
        osc: widget.osc,
      ),
      Cues(
        key: const Key('CueList'),
        osc: widget.osc,
      ),
      DirectSelects(osc: widget.osc),
    ];
    rfrContext = context.read<FreeRFRContext>();
    rfrContext.addListener(_handleContextChange);
    //if desktop os and popup is not open
    if (!(Platform.isAndroid || Platform.isIOS)) {
      registerHotKeys(widget.osc);
      setFreeRFRHotKeys();
    }
  }

  void _handleContextChange() {
    if (Platform.isAndroid || Platform.isIOS) return;
    if (rfrContext.hasHotKeyBeenUninitialized) {
      setFreeRFRHotKeys();
      rfrContext.hasHotKeyBeenUninitialized = false;
    }
  }

  void setFreeRFRHotKeys() {
    if (_pageHotKeysRegistered) return;
    _pageHotKeysRegistered = true;
    HotKey pageLeft =
        HotKey(key: LogicalKeyboardKey.home, scope: HotKeyScope.inapp);
    hotKeyManager.register(pageLeft, keyDownHandler: (key) {
      if (index > 0) {
        setState(() => index--);
      }
    });
    HotKey pageRight =
        HotKey(key: LogicalKeyboardKey.end, scope: HotKeyScope.inapp);
    hotKeyManager.register(pageRight, keyDownHandler: (key) {
      if (index + 1 < pages.length) {
        setState(() => index++);
      }
    });
  }

  @override
  void dispose() {
    rfrContext.removeListener(_handleContextChange);
    //if desktop os
    if (!(Platform.isAndroid || Platform.isIOS)) {
      hotKeyManager.unregisterAll();
    }
    _pageHotKeysRegistered = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctx = context.read<FreeRFRContext>();
    return PopScope(
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        widget.setCurrentConnection(-1);
      },
      child: Scaffold(
        appBar: AppBar(
          title: TextButton(
            key: const Key('CommandLineButton'),
            onPressed: () {
              AlertDialog alert = AlertDialog(
                  title: const Text('Command Line'),
                  content: Text(ctx.commandLine),
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
            child: AnimatedBuilder(
              animation: ctx,
              builder: (context, _) => Text(
                ctx.commandLine,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: ctx.commandLine.startsWith('BLIND')
                      ? Colors.blue
                      : Theme.of(context).primaryColor,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          actions: [
            clearCommandLine(context),
            shutdownMultiConsole(context),
            keypad(context),
          ],
        ),
        body: pages.isEmpty
            ? const CircularProgressIndicator()
            : IndexedStack(index: index, children: pages),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.keyboard),
                label: 'Facepanel',
                tooltip: 'Facepanel'),
            BottomNavigationBarItem(
                icon: Icon(Symbols.instant_mix),
                label: 'Faders',
                tooltip: 'Faders'),
            BottomNavigationBarItem(
                icon: Icon(Icons.lightbulb),
                label: 'Channel Check',
                tooltip: 'Channel Check'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Controls',
                tooltip: 'Controls'),
            BottomNavigationBarItem(
                icon: Icon(Symbols.play_pause),
                label: 'Playback',
                tooltip: 'Playback'),
            BottomNavigationBarItem(
                icon: Icon(Symbols.grid_on),
                label: 'Direct Selects',
                tooltip: 'Direct Selects'),
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
          showUnselectedLabels: true,
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
    final ctx = context.read<FreeRFRContext>();
    return IconButton(
      icon: const Icon(Icons.backspace),
      color: MediaQuery.of(context).platformBrightness == Brightness.dark
          ? Colors.white
          : Colors.black,
      onPressed: () {
        widget.osc.sendKey('clear_cmdline');
        ctx.commandLine = 'LIVE: ';
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
                    onPressed: (() {
                      Navigator.of(context).pop();
                    }),
                    child: const Text('Cancel')),
                TextButton(
                    onPressed: () async {
                      await widget.osc.shutdownMultiConsole();
                      if (context.mounted) {
                        Navigator.of(context).pop();
                        Navigator.pop(context);
                        widget.setCurrentConnection(-1);
                      }
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
          final ctx = context.read<FreeRFRContext>();
          return Scaffold(
            appBar: AppBar(
                automaticallyImplyLeading: false,
                title: TextButton(
                  key: const Key('CommandLineButton'),
                  onPressed: () {
                    AlertDialog alert = AlertDialog(
                      title: const Text('Command Line'),
                      content: Text(ctx.commandLine),
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
                  child: AnimatedBuilder(
                    animation: ctx,
                    builder: (context, _) => Text(
                      ctx.commandLine,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: ctx.commandLine.startsWith('BLIND')
                            ? Colors.blue
                            : Theme.of(context).primaryColor,
                        fontSize: 15,
                      ),
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
