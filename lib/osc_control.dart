import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:osc/osc.dart';

class OSC {
  final InternetAddress hostIP;
  final int hostPort = 8000;
  final int clientPort = 8001;
  late final OSCSocket client;

  OSC(this.hostIP) {
    client = OSCSocket(destination: hostIP, destinationPort: hostPort);
    OSCMessage message = OSCMessage('/eos/subscribe', arguments: [1]);
    client.send(message);
    message = OSCMessage('/eos/ping', arguments: ['free rfr']);
    client.send(message);
    OSCSocket(destinationPort: 8001).listen((msg) {
      debugPrint(msg.address);
      debugPrint(msg.arguments.toString());
    });
    debugPrint(hostIP.toString());
  }

  void sendKey(String key) async {
    OSCMessage message = OSCMessage('/eos/key/$key', arguments: []);
    client.send(message);
    debugPrint(hostIP.toString());
    OSCSocket listenSocket = OSCSocket();
    listenSocket.listen((msg) {
      debugPrint(msg.toString());
    });
    listenSocket.close();
  }

  // void setCommandLine(void Function(String) setCommandLine) {
  //   String reply = '';
  //   OSCMessage message = OSCMessage('/eos/out/cmd', arguments: []);
  //   client.send(message);
  //   OSCSocket socket = OSCSocket(serverPort: 8001);
  //   socket.listen((msg) {
  //     reply = msg.toString();
  //   });
  //   debugPrint('Received: $reply');
  //   setCommandLine(reply);
  // }

  String getShowName() {
    OSCMessage message = OSCMessage('/eos/out/show/name', arguments: []);
    client.send(message);
    String reply = '';
    client.listen((msg) {
      reply = msg.toString();
      return;
    });
    return reply;
  }

  void close() {
    client.close();
  }

  List<String> getCues() {
    // Get number of cues.
    OSCMessage message = OSCMessage('/eos/get/cuelist/count', arguments: []);
    client.send(message);
    List<String> cues = [];
    int numOfCues = 0;
    client.listen((msg) {
      numOfCues = int.parse(msg.toString());
      return;
    });

    // Get each cue
    for (int i = 0; i < numOfCues; i++) {
      OSCMessage message = OSCMessage('/eos/get/cue/0/index/$i', arguments: []);
      client.send(message);
      client.listen((msg) {
        cues.add(msg.toString());
        return;
      });
    }
    return cues;
  }

  int getCurrentCueIndex() {
    OSCMessage message = OSCMessage('/eos/out/active/cue/text', arguments: []);
    client.send(message);
    int reply = -1;
    client.listen((msg) {
      reply = int.parse(msg.toString());
      return;
    });
    return reply;
  }
}
