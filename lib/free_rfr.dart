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
  String commandLine = '';

  void setCommandLine(String command) {
    setState(() {
      commandLine = command;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  void setActiveConnection(Map<String, dynamic> connection) {
    setState(() {
      activeConnection = connection;
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<RawDatagramSocket> socket =
        RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
    return FutureBuilder(
        future: socket,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            OSC osc;
            if (activeConnection.isEmpty) {
              osc = OSC(InternetAddress('127.0.0.1'),
                  InternetAddress('127.0.0.1'), snapshot.data);
            } else {
              osc = OSC(activeConnection['host'], activeConnection['port'],
                  snapshot.data);
            }
            List<Widget> pages = [
              Connections(setActiveConnection, key: const Key('Connections')),
              FacePanel(
                  key: const Key('Facepanel'),
                  osc: osc,
                  setCommandLine: setCommandLine),
              Controls(
                  key: const Key('Controls'),
                  osc: osc,
                  setCommandLine: setCommandLine),
              CueList(
                  key: const Key('CueList'),
                  osc: osc,
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
              body: pages.isEmpty
                  ? const CircularProgressIndicator()
                  : pages[index],
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
                }),
                showSelectedLabels: true,
              ),
            );
          }

          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
