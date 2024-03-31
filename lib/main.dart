import 'dart:io';

import 'package:flutter/material.dart';
import 'package:free_rfr/free_rfr.dart';
import 'package:free_rfr/osc_control.dart';
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

  void setActiveConnection(Map<String, dynamic> connection, int index) {
    if (isOSCInitialized) {
      osc.close();
      isOSCInitialized = false;
    }

    setState(() {
      debugPrint('Initilizing OSC...');
      activeConnection = connection;
      currentConnectionIndex = index;
      osc = OSC(InternetAddress(activeConnection['ip']));
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
        '/': (context) => Connections(
              setActiveConnection,
              currentConnectionIndex: currentConnectionIndex,
            ),
        '/home': (context) => FreeRFR(osc: osc),
      },
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
    );
  }
}
