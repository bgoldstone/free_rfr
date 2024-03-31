import 'dart:io';

import 'package:flutter/material.dart';
import 'package:free_rfr/osc_control.dart';
import 'package:free_rfr/pages/connections.dart';
import 'package:free_rfr/pages/controls.dart';
import 'package:free_rfr/pages/cue_list.dart';
import 'package:free_rfr/pages/facepanel.dart';

class FreeRFR extends StatefulWidget {
  final OSC osc;
  const FreeRFR({super.key, required this.osc});

  @override
  State<FreeRFR> createState() => _FreeRFRState();
}

class _FreeRFRState extends State<FreeRFR> {
  Map<String, dynamic> activeConnection = {};
  int index = 0;
  String commandLine = '';
  int currentConnectionIndex = -1;

  void setCommandLine(String command) {
    setState(() {
      commandLine = command;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      FacePanel(
          key: const Key('Facepanel'),
          osc: widget.osc,
          setCommandLine: setCommandLine),
      Controls(
          key: const Key('Controls'),
          osc: widget.osc,
          setCommandLine: setCommandLine),
      CueList(
          key: const Key('CueList'),
          osc: widget.osc,
          setCommandLine: setCommandLine),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          commandLine,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        centerTitle: true,
      ),
      body: pages.isEmpty ? const CircularProgressIndicator() : pages[index],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.keyboard), label: 'Facepanel'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Controls'),
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt), label: 'Cue List'),
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
    );
  }
}
