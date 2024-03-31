import 'dart:core';
import 'dart:io';

import 'package:osc/osc.dart';

class OSC {
  final InternetAddress ip;
  final int port = 8000;
  late OSCSocket socket;

  OSC(this.ip) {
    socket = OSCSocket(destination: ip, destinationPort: port);
  }

  void sendKey(String key) {
    OSCMessage message = OSCMessage('/eos/key/$key', arguments: []);
    socket.send(message);
  }

  String getCommandLine() {
    OSCMessage message = OSCMessage('/eos/out/cmd', arguments: []);
    socket.send(message);
    String reply = '';
    socket.listen((msg) {
      reply = msg.toString();
      return;
    });
    return reply;
  }

  String getShowName() {
    OSCMessage message = OSCMessage('/eos/out/show/name', arguments: []);
    socket.send(message);
    String reply = '';
    socket.listen((msg) {
      reply = msg.toString();
      return;
    });
    return reply;
  }

  void close() {
    socket.close();
  }

  List<String> getCues() {
    // Get number of cues.
    OSCMessage message = OSCMessage('/eos/get/cuelist/count', arguments: []);
    socket.send(message);
    List<String> cues = [];
    int numOfCues = 0;
    socket.listen((msg) {
      numOfCues = int.parse(msg.toString());
      return;
    });

    // Get each cue
    for (int i = 0; i < numOfCues; i++) {
      OSCMessage message = OSCMessage('/eos/get/cue/0/index/$i', arguments: []);
      socket.send(message);
      socket.listen((msg) {
        cues.add(msg.toString());
        return;
      });
    }
    return cues;
  }

  int getCurrentCueIndex() {
    OSCMessage message = OSCMessage('/eos/out/active/cue/text', arguments: []);
    socket.send(message);
    int reply = -1;
    socket.listen((msg) {
      reply = int.parse(msg.toString());
      return;
    });
    return reply;
  }
}
