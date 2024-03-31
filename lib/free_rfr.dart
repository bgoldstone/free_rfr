import 'dart:io';

import 'package:flutter/material.dart';
import 'package:free_rfr/osc_control.dart';
import 'package:free_rfr/pages/connections.dart';
import 'package:free_rfr/pages/controls.dart';
import 'package:free_rfr/pages/cue_list.dart';
import 'package:free_rfr/pages/facepanel.dart';

class FreeRFR extends StatefulWidget {
  const FreeRFR({super.key});

  @override
  State<FreeRFR> createState() => _FreeRFRState();
}

class _FreeRFRState extends State<FreeRFR> {
  Map<String, dynamic> activeConnection = {};
  int index = 0;
  late OSC osc;

  void setActiveConnection(Map<String, dynamic> connection) {
    setState(() {
      activeConnection = connection;
      osc = OSC(InternetAddress(activeConnection['ip']));
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      Connections(setActiveConnection, key: const Key('Connections')),
      FacePanel(key: const Key('Facepanel'), osc: osc),
      Controls(key: const Key('Controls'), osc: osc),
      CueList(key: const Key('CueList'), osc: osc),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Free RFR',
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
            icon: Icon(Icons.wifi),
            label: 'Connections',
          ),
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
          debugPrint('index: $index');
        }),
        showSelectedLabels: true,
      ),
    );
  }
}
