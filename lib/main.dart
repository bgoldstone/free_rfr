import 'dart:io';

import 'package:flutter/material.dart';
import 'package:free_rfr/free_rfr.dart';
import 'package:free_rfr/objects/osc_control.dart';
import 'package:free_rfr/objects/parameters.dart';
import 'package:free_rfr/pages/connections.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late OSC osc;
  bool isOSCInitialized = false;
  Map<String, dynamic> activeConnection = {};
  int currentConnectionIndex = -1;
  ParameterList currentChannel = {};
  List<double> hueSaturation = [];
  String commandLine = '';
  double currentCue = -1;
  int currentCueList = -1;
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

  String getCommandLine() {
    return commandLine;
  }

  void setHueSaturation(double hue, double saturation) {
    hueSaturation = [hue, saturation];
  }

  void setCurrentChannel(ParameterList channel) {
    setState(() {
      currentChannel = channel;
    });
  }

  void setActiveConnection(Map<String, dynamic> connection, int index) {
    if (isOSCInitialized) {
      osc.close();
      isOSCInitialized = false;
    }

    setState(() {
      debugPrint('Initilizing OSC...');
      activeConnection = connection;
      currentConnectionIndex = index;
      osc = OSC(
        InternetAddress(activeConnection['ip']),
        setCurrentChannel,
        setCommandLine,
        setCurrentCueList,
        setCurrentCue,
        setCurrentCueText,
        setPreviousCue,
        setPreviousCueText,
        setNextCue,
        setNextCueText,
        setHueSaturation,
      );
      isOSCInitialized = true;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color.fromARGB(255, 255, 196, 0);
    return MaterialApp(
      title: 'Free RFR',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
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
        '/': (context) => Connections(setActiveConnection,
            currentConnectionIndex: currentConnectionIndex
            // isAlreadyAutoDiscovered: false,
            ),
        '/home': (context) => FreeRFR(
              osc: osc,
              setCurrentChannel: setCurrentChannel,
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
            ),
      },
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
    );
  }
}
