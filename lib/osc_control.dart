import 'dart:core';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:free_rfr/parameters.dart';
import 'package:osc/osc.dart';

class OSC {
  final InternetAddress hostIP;
  final int hostPort = 8000;
  final int clientPort = 8001;
  final Function(ParameterList) setCurrentChannel;
  final Function(double, double) setColor;
  final Function(String) setCommandLine;
  final void Function(int) setCurrentCueList;
  final void Function(double) setCurrentCue;
  final void Function(String) setCurrentCueText;
  final void Function(double) setPreviousCue;
  final void Function(String) setPreviousCueText;
  final void Function(double) setNextCue;
  final void Function(String) setNextCueText;
  late final OSCSocket client;

  OSC(
      this.hostIP,
      this.setCurrentChannel,
      this.setColor,
      this.setCommandLine,
      this.setCurrentCueList,
      this.setCurrentCue,
      this.setCurrentCueText,
      this.setPreviousCue,
      this.setPreviousCueText,
      this.setNextCue,
      this.setNextCueText) {
    client = OSCSocket(destination: hostIP, destinationPort: hostPort);
    OSCMessage message = OSCMessage('/eos/subscribe', arguments: [1]);
    client.send(message);
    message = OSCMessage('/eos/ping', arguments: ['free rfr']);
    client.send(message);
    OSCSocket(destinationPort: 8001).listen((msg) {});
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
    await client.send(message);
    sleep100();
    OSCSocket listenSocket = OSCSocket(serverPort: clientPort);
    listenSocket.listen((event) {
      if (event.address == '/eos/out/cmd') {
        setCommandLine('${event.arguments[0]}');
      }
    });
    sendLive();
    updateEosOutput();
  }

  void sleep100() {
    sleep(const Duration(milliseconds: 100));
  }

  void _setUDPTXIPDefault() async {
    OSCMessage message =
        OSCMessage('/eos/newcmd', arguments: ['OSC_UDP_TX_IP_ADDRESS#']);
    client.send(message);
    sleep100();
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

  void sendKey(String key) async {
    debugPrint('Sending key $key');
    OSCMessage message = OSCMessage('/eos/key/$key', arguments: []);
    client.send(message);
    sleep100();
    updateEosOutput();
  }

  void updateEosOutput() {
    OSCSocket listenSocket = OSCSocket(serverPort: clientPort);
    ParameterList parameters = [];
    for (ParameterType _ in ParameterType.values) {
      parameters.add([]);
    }
    int wheelIndex = 1;
    listenSocket.listen((event) {
      if (event.address == '/eos/out/cmd') {
        setCommandLine('${event.arguments[0]}');
      } else if (event.address.startsWith('/eos/out/active/wheel/')) {
        String parameterName = event.arguments[0].toString().split(" ")[0];
        int parameterIndex = int.parse(event.arguments[1].toString());
        double parameterValue = double.parse(event.arguments[2].toString());
        parameters[parameterIndex]
            .add([wheelIndex, parameterName, parameterValue]);
        wheelIndex++;
      } else if (event.address.startsWith('/eos/out/pantilt') &&
          event.arguments.isNotEmpty) {
        double minPan = double.parse(event.arguments[0].toString());
        double maxPan = double.parse(event.arguments[1].toString());
        double minTilt = double.parse(event.arguments[2].toString());
        double maxTilt = double.parse(event.arguments[3].toString());
        parameters[ParameterType.PT.index]
            .add([minPan, maxPan, minTilt, maxTilt]);
      } else if (event.address.startsWith('/eos/out/color/hs') &&
          event.arguments.length == 2) {
        double hue = double.parse(event.arguments[0].toString());
        double saturation = double.parse(event.arguments[1].toString()) / 255;
        setColor(hue, saturation);
      } else if (event.address.startsWith('/eos/out/active/cue/text')) {
        String text = event.arguments[0].toString();
        List<String> textList = text.split(' ');
        if (textList.length > 1) {
          String label =
              text.replaceAll(textList.first, '').replaceAll(textList.last, '');
          setCurrentCueText(
              'Cue#: ${textList.first} Label: $label Fade Time: ${textList.last}');
        } else {
          setCurrentCueText('Cue#: ${textList[0]} Fade Time: ${textList[1]}');
        }
      } else if (event.address.startsWith('/eos/out/active/cue/')) {
        List<String> address = event.address.split('/');
        setCurrentCue(double.parse(address.last));
        setCurrentCueList(int.parse(address[address.length - 2]));
      } else if (event.address.startsWith('/eos/out/previous/cue/text')) {
        List<String> text = event.arguments[0].toString().split(' ');
        if (text.length > 1) {
          setPreviousCueText(
              'Cue#: ${text[0]} Label: ${text[1]} Fade Time: ${text[2]}');
        } else {
          setPreviousCueText('');
        }
      } else if (event.address.startsWith('/eos/out/previous/cue/')) {
        List<String> address = event.address.split('/');
        setPreviousCue(double.parse(address.last));
      } else if (event.address.startsWith('/eos/out/pending/cue/text')) {
        List<String> text = event.arguments[0].toString().split(' ');
        if (text.length > 1) {
          setNextCueText(
              'Cue#: ${text[0]} Label: ${text[1]} Fade Time: ${text[2]}');
        } else {
          setNextCueText('');
        }
      } else if (event.address.startsWith('/eos/out/pending/cue/')) {
        List<String> address = event.address.split('/');
        try {
          setPreviousCue(double.parse(address.last));
        } catch (e) {
          setPreviousCue(0);
        }
      }

      setCurrentChannel(parameters);
    });
    listenSocket.close();
  }

  void setParameter(String attributeName, double parameterValue) {
    OSCMessage message =
        OSCMessage('/eos/cmd', arguments: ['$attributeName $parameterValue#']);
    client.send(message);
    sleep100();
  }

  void setLabel(double cueNumber, String label) {
    if (label == '') {
      return;
    }
    OSCMessage message =
        OSCMessage('/eos/newcmd', arguments: ['Cue $cueNumber Label $label#']);
    client.send(message);
    sendLive();
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

  Future<List<String>> getCues() async {
    // Get number of cues.
    OSCSocket listenSocket;
    OSCMessage message;
    List<String> cues = [];
    client.send(OSCMessage('/eos/get/cue/1/count', arguments: []));
    sleep100();
    listenSocket = OSCSocket(serverPort: clientPort);
    await listenSocket.listen((msg) async {
      if (msg.address == '/eos/out/get/cue/1/count') {
        for (int i = 0; i < int.parse(msg.arguments[0].toString()); i++) {
          message = OSCMessage('/eos/get/cue/0/index/$i', arguments: []);
          await client.send(message);
          OSCSocket listenSocket = OSCSocket(serverPort: clientPort);
          sleep(const Duration(milliseconds: 25));
          await listenSocket.listen((msg) {
            debugPrint(msg.address);
            if (msg.address == '/eos/out/get/cue/0/0') {
              debugPrint(msg.arguments.toString());
              cues.add(msg.arguments.toString());
            }
          });
          listenSocket.close();
        }
      }
    });
    debugPrint(cues.toString());
    return cues;
  }

  void sleep250() {
    sleep(const Duration(milliseconds: 250));
  }

  int getCurrentCueIndex() {
    OSCMessage message = OSCMessage('/eos/out/active/cue/', arguments: []);
    client.send(message);
    int reply = -1;
    OSCSocket listenSocket = OSCSocket(serverPort: clientPort);
    listenSocket.listen((msg) {
      debugPrint('Index: ${msg.arguments[0].toString()}');
      if (msg.address == '/eos/out/active/cue/text')
        reply = int.parse(msg.arguments[0].toString());
      return;
    });
    listenSocket.close();
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
