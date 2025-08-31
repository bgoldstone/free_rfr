import 'dart:io';

import 'package:flutter/material.dart';
import 'package:free_rfr/configurations/scroll_behavior.dart';
import 'package:free_rfr/free_rfr.dart';
import 'package:free_rfr/objects/osc_control.dart';
import 'package:free_rfr/objects/parameters.dart';
import 'package:free_rfr/pages/connections.dart';
import 'package:hotkey_manager/hotkey_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await hotKeyManager.unregisterAll();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  final int tcpPort = 3032;
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  OSC? _oscCache;
  Socket? _socketCache;
  Future<OSC>? _oscFuture;
  bool isOSCInitialized = false;
  Map<String, dynamic> activeConnection = {};
  int currentConnectionIndex = -1;
  ParameterMap currentChannel = {};
  List<double> hueSaturation = [];
  String commandLine = '';
  double currentCue = -1;
  int currentCueList = 1;
  String currentCueText = '';
  double previousCue = -1;
  String previousCueText = '';
  double nextCue = -1;
  String nextCueText = '';

  void setPreviousCue(double cue) {
    setState(() {
      previousCue = cue;
    });
  }

  void setPreviousCueText(String text) {
    setState(() {
      previousCueText = text;
    });
  }

  void setNextCue(double cue) {
    setState(() {
      nextCue = cue;
    });
  }

  void setNextCueText(String text) {
    setState(() {
      nextCueText = text;
    });
  }

  void setCurrentCueText(String text) {
    setState(() {
      currentCueText = text;
    });
  }

  void setCurrentCue(double cue) {
    setState(() {
      currentCue = cue;
    });
  }

  void setCurrentCueList(int cueList) {
    setState(() {
      currentCueList = cueList;
    });
  }

  void setCommandLine(String command) {
    try {
      setState(() {
        commandLine = command;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void addToCommandLine(String command) {
    try {
      setState(() {
        commandLine += command;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  String getCommandLine() {
    return commandLine;
  }

  void setHueSaturation(double hue, double saturation) {
    hueSaturation = [hue, saturation];
  }

  void setCurrentChannel(ParameterMap channel) {
    currentChannel = channel;
  }

  void setActiveConnection(Map<String, dynamic> connection, int index) async {
    if (isOSCInitialized) {
      isOSCInitialized = false;
    }
    debugPrint(connection.toString());

    setState(() {
      debugPrint('Initilizing OSC...');
      activeConnection = connection;
      currentConnectionIndex = index;
      isOSCInitialized = true;
      _oscFuture = getOSC();
    });
  }

  Future<OSC> getOSC() async {
    if (_oscCache != null) return _oscCache!;
    if (_socketCache == null) {
      InternetAddress address = await InternetAddress.lookup(
              activeConnection['ip'],
              type: InternetAddressType.IPv4)
          .then((value) => value.first);
      _socketCache = await Socket.connect(address, widget.tcpPort);
    }

    _oscCache = OSC(
        setCurrentChannel,
        setCommandLine,
        setCurrentCueList,
        setCurrentCue,
        setCurrentCueText,
        setPreviousCue,
        addToCommandLine,
        setPreviousCueText,
        setNextCue,
        setNextCueText,
        setHueSaturation,
        int.tryParse(activeConnection['userId'].toString()) ?? 0,
        _socketCache!);
    return _oscCache!;
  }

  void setCurrentConnection(int index) {
    setState(() {
      currentConnectionIndex = index;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color.fromARGB(255, 255, 196, 0);
    return MaterialApp(
      scrollBehavior: FreeRFRScrollBehavior(),
      title: 'Free RFR',
      theme: ThemeData(
        primaryColor: primaryColor,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.yellow,
        primaryColor: primaryColor,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      routes: {
        '/': (context) {
          _socketCache = null;
          _oscCache = null;
          return Connections(
            setActiveConnection,
            currentConnectionIndex: currentConnectionIndex,
          );
        },
        '/home': (context) {
          return FutureBuilder<OSC>(
              future: _oscFuture,
              builder: (ctx, snapshot) {
                debugPrint("Has Data? ${snapshot.hasData}");
                if (snapshot.hasData) {
                  return FreeRFR(
                      osc: snapshot.data!,
                      currentChannel: currentChannel,
                      hueSaturation: hueSaturation,
                      setCommandLine: setCommandLine,
                      commandLine: getCommandLine(),
                      currentCue: currentCue,
                      currentCueList: currentCueList,
                      currentCueText: currentCueText,
                      nextCue: nextCue,
                      nextCueText: nextCueText,
                      previousCue: previousCue,
                      previousCueText: previousCueText,
                      setCurrentConnection: setCurrentConnection);
                } else if (snapshot.hasError) {
                  activeConnection = {};
                  currentConnectionIndex = -1;
                  return AlertDialog(
                    title: const Text('An error occured connecting to eos!'),
                    content: Text("Error has occured: ${snapshot.error}"),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () => Navigator.pop(context, 'OK'),
                          child: const Text('OK')),
                    ],
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              });
        }
      },
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
    );
  }
}
