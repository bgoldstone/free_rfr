import 'dart:convert';
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
    _setUDPTXIP();
  }

  void _setUDPTXIP() async {
    List<NetworkInterface> list = await NetworkInterface.list();
    List<String> addresses = [];

    for (NetworkInterface interface in list) {
      if (interface.addresses.first.type == InternetAddressType.IPv4 &&
          isPrivateIPAddress(interface.addresses.first.address.toString())) {
        addresses.add(interface.addresses.first.address.toString());
      }
    }
    OSCMessage message;
    message = OSCMessage('/eos/newcmd',
        arguments: ['OSC_UDP_TX_IP_ADDRESS ${addresses.join(',')}#']);
    client.send(message);
    sleep(const Duration(milliseconds: 250));
    sendLive();
  }

  void _setUDPTXIPDefault() async {
    OSCMessage message =
        OSCMessage('/eos/newcmd', arguments: ['OSC_UDP_TX_IP_ADDRESS#']);
    client.send(message);
    sleep(const Duration(milliseconds: 250));
    sendLive();
  }

  void sendBlind() {
    OSCMessage message = OSCMessage('/eos/key/blind', arguments: [1]);
    client.send(message);
  }

  void sendLive() {
    OSCMessage message = OSCMessage('/eos/key/live', arguments: [1]);
    client.send(message);
  }

  void sendKey(String key, Function(String) setCommandLine) async {
    OSCMessage message = OSCMessage('/eos/key/$key', arguments: []);
    client.send(message);
    OSCSocket listenSocket = OSCSocket(serverPort: clientPort);
    listenSocket.listen((event) {
      if (event.address == '/eos/out/cmd') {
        setCommandLine('${event.arguments[0]}');
      }
      debugPrint(event.arguments.toString());
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
    _setUDPTXIPDefault();
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

  void sendColor(double red, double green, double blue) {
    OSCMessage message =
        OSCMessage('/eos/color/rgb', arguments: [red, green, blue]);
    client.send(message);
  }
}

bool isPrivateIPAddress(String string) {
  return string.startsWith('10.') ||
      string.startsWith('172.') ||
      string.startsWith('192.168.') ||
      string.startsWith('127.');
}
