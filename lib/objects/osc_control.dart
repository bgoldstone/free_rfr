import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:free_rfr/objects/parameters.dart';
import 'package:osc/osc.dart';
import '../pages/facepanels/controls/pan_tilt_control.dart';
import '../pages/facepanels/faders.dart';

class OSC {
  List<double> hueSaturation = [0, 0];
  final Function(ParameterMap)? setCurrentChannel;
  final Function(String)? setCommandLine;
  final void Function(int)? setCurrentCueList;
  final void Function(double)? setCurrentCue;
  final void Function(String)? setCurrentCueText;
  final void Function(String)? addToCommandLine;
  final void Function(double)? setPreviousCue;
  final void Function(String)? setPreviousCueText;
  final void Function(double)? setNextCue;
  final void Function(String)? setNextCueText;
  final void Function(double, double)? setHueSaturation;
  final int userId;

  FaderControlsState? faderControlsState;
  List<ControlWidget> controlStates = [];

  final Socket client;

  OSC(
      this.setCurrentChannel,
      this.setCommandLine,
      this.setCurrentCueList,
      this.setCurrentCue,
      this.setCurrentCueText,
      this.setPreviousCue,
      this.addToCommandLine,
      this.setPreviousCueText,
      this.setNextCue,
      this.setNextCueText,
      this.setHueSaturation,
      this.userId,
      this.client) {
    OSCMessage message = OSCMessage('/eos/subscribe', arguments: [1]);
    sendOSCMessage(message);
    message = OSCMessage('/eos/ping', arguments: ['free rfr']);
    sendOSCMessage(message);
    _updateEosOutput();
    // _setUDPTXIP();
    debugPrint('OSC initialized with ${client.address}:${client.port}');
  }

  Future<void> sendOSCMessage(OSCMessage message) async {
    final data = message.toBytes();
    final lengthBytes = Uint8List(4); // 4 bytes for the length (big-endian)
    ByteData.view(lengthBytes.buffer).setInt32(0, data.length, Endian.big);
    client.add(lengthBytes);
    client.add(message.toBytes());
  }

  void registerControlState(ControlWidget controlWidget) {
    controlStates
        .removeWhere((e) => e.runtimeType == controlWidget.runtimeType);
    controlStates.add(controlWidget);
    debugPrint("added $controlWidget to controlstates");
  }

  ControlWidget? getControlWidgetForType(ParameterType type) {
    for (var control in controlStates) {
      if (control.controllingParameters.contains(type)) {
        return control;
      }
    }
    return null;
  }

  void shutdownMultiConsole() {
    sendKey('multiconsole_power_off');
    sendKey('confirm_command');
    sleep(const Duration(milliseconds: 500));
    try {
      sendKey('quit');
      sendKey('confirm_command');
    } catch (_) {}
    _setUDPTXIPDefault();
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
    //get system language of the phone
    String locale = Platform.localeName;
    var split = locale.split('_');
    //Eos 3.0 and later
    if (split[0].toLowerCase() == "en") {
      message = OSCMessage('/eos/newcmd/OSC_UDP_TX_IP_ADDRESS',
          arguments: ['${addresses.join(',')}#']);
    } else {
      message = OSCMessage('/eos/newcmd/OSC_UDP_TX_IP_ADDRESSE',
          arguments: ['${addresses.join(',')}#']);
    }
    await sendOSCMessage(message);
    sleep100();
    /*
    OSCSocket listenSocket = OSCSocket(serverPort: clientPort);
    listenSocket.listen((event) {
      if (message.address == '/eos/out/cmd') {
        setCommandLine!('${message.arguments[0]}');
        debugPrint(message.arguments[0].toString());
      }
    });

     */
    sendLive();
  }

  void sleep100() {
    sleep(const Duration(milliseconds: 100));
  }

  void _setUDPTXIPDefault() async {
    OSCMessage message =
        OSCMessage('/eos/newcmd', arguments: ['OSC_UDP_TX_IP_ADDRESS#']);
    sendOSCMessage(message);
    sleep100();
    sendLive();
  }

  void sendBlind() {
    OSCMessage message = OSCMessage('/eos/key/blind', arguments: [1]);
    sendOSCMessage(message);
    setCommandLine!('BLIND : ');
  }

  void sendLive() {
    OSCMessage message = OSCMessage('/eos/key/live', arguments: [1]);
    sendOSCMessage(message);
    setCommandLine!('LIVE : ');
  }

  void sendKey(String key,
      {bool withUpdate = true, double sleepMillis = 100}) async {
    debugPrint('Sending key $key');
    OSCMessage message = OSCMessage('/eos/key/$key', arguments: []);
    sendOSCMessage(message);
    sleep(Duration(milliseconds: sleepMillis.toInt()));
  }

  // Future<int> requestCountOfType(String type) async {
  //   OSCMessage message = OSCMessage('/eos/get/$type/count', arguments: []);
  //   sendOSCMessage(message);
  //   OSCSocket listenSocket = OSCSocket(serverPort: clientPort);
  //   Completer<int> compl = Completer();
  //   listenSocket.listen((msg) {
  //     if (msg.address == '/eos/out/get/$type/count') {
  //       compl.complete(int.parse(msg.arguments[0].toString()));
  //       return;
  //     }
  //   });
  //   listenSocket.close();
  //   return compl.future;
  // }

  void _updateEosOutput() async {
    debugPrint('Updating Eos Output');
    ParameterMap parameters = {};
    List<int> buffer = [];
    client.listen((packet) {
      buffer.addAll(packet);
      while (buffer.isNotEmpty) {
        if (buffer.length < 4) {
          break;
        }
        final lengthBytes = Uint8List.fromList(buffer.sublist(0, 4));
        final lengthBuffer = lengthBytes.buffer.asByteData();
        final messageLength = lengthBuffer.getUint32(0);
        if (buffer.length < 4 + messageLength) {
          break;
        }
        final messageBytes = buffer.sublist(0, 4 + messageLength);
        final messageData = Uint8List.fromList(messageBytes);
        try {
          final message = OSCMessage.fromBytes(messageData.sublist(4));
          debugPrint(
              "Is hs:${message.address.startsWith('/eos/out/color/hs')}, actual :${message.address}");
          debugPrint(message.toString());
          if (message.address == '/eos/out/cmd') {
            setCommandLine!('${message.arguments[0]}');
          } else if (message.address.startsWith("/eos/out/pantilt") &&
              message.arguments.length >= 4) {
            parameters[ParameterType.minPan] = [message.arguments[0] as double];
            parameters[ParameterType.maxPan] = [message.arguments[1] as double];
            parameters[ParameterType.minTilt] = [
              message.arguments[2] as double
            ];
            parameters[ParameterType.maxTilt] = [
              message.arguments[3] as double
            ];
          } else if (message.address.startsWith('/eos/out/active/wheel/')) {
            var args = message.arguments[0].toString().split(" ");
            debugPrint("args: $args");
            String parameterName = "";
            for (int i = 0; i < args.length; i++) {
              if (i + 1 < args.length) {
                parameterName += "${args[i]} ";
              }
            }
            debugPrint("Parameter Name: $parameterName");
            parameterName = parameterName.replaceAll(" ", "");
            debugPrint(parameters.toString());

            var key = ParameterType.getTypeByName(parameterName);
            if (key != null) {
              if (!parameters.containsKey(key)) {
                parameters[key] = [];
              }
              if (key == ParameterType.intens) {
                parameters[ParameterType.intens] = [
                  0,
                  double.parse(message.arguments[0]
                      .toString()
                      .split(" ")
                      .last
                      .replaceAll("[", "")
                      .replaceAll("]", ""))
                ];
              } else if (key == ParameterType.pan ||
                  key == ParameterType.tilt) {
                parameters[key] = [
                  1,
                  (key == ParameterType.tilt ? -1 : 1) *
                      double.parse(message.arguments[0]
                          .toString()
                          .split(" ")
                          .last
                          .replaceAll("[", "")
                          .replaceAll("]", ""))
                ];
              }
            } else {
              ParameterType? paramType =
                  ParameterType.getTypeByName(parameterName);
              if (paramType != null) {
                parameters[paramType] = [message.arguments.last as double];
              }
            }
          } else if (message.address.startsWith('/eos/out/color/hs') &&
              message.arguments.isNotEmpty) {
            double hue = double.parse(message.arguments[0].toString());
            double saturation =
                double.parse(message.arguments[1].toString()) / 255;
            debugPrint("HUESAT: $hue $saturation");
            setHueSaturation!(hue, saturation);
          } else if (message.address.startsWith('/eos/out/active/cue/text')) {
            String text = message.arguments[0].toString();
            if (text.length > 1) {
              setCurrentCueText!(text);
            } else {
              setCurrentCueText!('');
            }
          } else if (message.address.startsWith('/eos/out/active/cue/')) {
            List<String> address = message.address.split('/');
            setCurrentCue!(double.parse(address.last));
            setCurrentCueList!(int.parse(address[address.length - 2]));
          } else if (message.address.startsWith('/eos/out/pending/cue/text')) {
            String text = message.arguments[0].toString();
            if (text.length > 1) {
              setNextCueText!(text);
            } else {
              setNextCueText!('');
            }
          } else if (message.address.startsWith('/eos/out/pending/cue/')) {
            List<String> address = message.address.split('/');
            try {
              setNextCue!(double.parse(address.last));
            } catch (e) {
              setNextCue!(0);
            }
          } else if (message.address.startsWith('/eos/out/previous/cue/text')) {
            String text = message.arguments[0].toString();
            if (text.length > 1) {
              setPreviousCueText!(text);
            } else {
              setPreviousCueText!('');
            }
          } else if (message.address.startsWith('/eos/out/previous/cue/')) {
            List<String> address = message.address.split('/');
            try {
              setPreviousCue!(double.parse(address.last));
            } catch (e) {
              setPreviousCue!(0);
            }
          } else if (message.address.startsWith("/eos/out/fader")) {
            var components = message.address.split("/");
            debugPrint(components.toString());
            if (components[4] == "range") {
              // var faderPage = int.parse(components[5]);
              var faderIndex = int.parse(components[6]);
              var faderRange = int.parse(message.arguments[1].toString());
              faderControlsState!.updateFader(faderIndex, 0, "", faderRange);
            } else if (components.length == 7) {
              if (components[6] == "name") {
                // var faderPage = int.parse(components[4]);
                var faderIndex = int.parse(components[5]);
                if (faderControlsState != null) {
                  if (message.arguments.toString() == "[]") {
                    debugPrint("Empty arguments");
                    faderControlsState!
                        .updateFader(faderIndex, 0, "", 0, forceUpdate: true);
                  } else {
                    faderControlsState!.updateFader(
                        faderIndex, 0, message.arguments.join(" "), 0);
                  }
                }
              }
            }
          } else if (message.address.startsWith("/eos/fader/")) {
            var components = message.address.split("/");
            // var faderPage = int.parse(components[3]);
            var faderIndex = int.parse(components[4]);
            faderControlsState!.updateFader(faderIndex,
                double.parse(message.arguments[0].toString()), "", 0);
          } else if (message.address.startsWith("/eos/out/pantilt")) {
            if (getControlWidgetForType(ParameterType.pan) != null) {
              PanTiltControlState state =
                  getControlWidgetForType(ParameterType.pan)!
                      as PanTiltControlState;
              var args = message.arguments;
              if (args.isNotEmpty && args.length <= 4) {
                state.updateValues(
                    double.parse(args[0].toString()),
                    double.parse(args[1].toString()),
                    double.parse(args[2].toString()),
                    double.parse(args[3].toString()));
              }
            }
          }
        } catch (e) {
          debugPrint(
              'Error parsing OSC message: $e ${utf8.decode(messageData, allowMalformed: true).trim()}');
          // Consider how to handle parsing errors (e.g., send an error message to the client, close the connection).
          // socket.add(Uint8List.fromList("ERROR".codeUnits)); //send error
          // socket.close();
        }
        buffer.removeRange(0, 4 + messageLength);
      } //End While
    });

    setCurrentChannel!(parameters);
  }

  void setupFaderBank(int count, FaderControlsState state) {
    OSCMessage message = OSCMessage('/eos/fader/1/config/10', arguments: []);
    sendOSCMessage(message);
    debugPrint('Sent: $message, configuration done!');
    faderControlsState = state;
  }

  void sendCmd(String cmd) {
    OSCMessage message = OSCMessage('/eos/cmd', arguments: [cmd]);
    sendOSCMessage(message);
    sleep100();
  }

  void send(String cmd, List<Object> list) {
    OSCMessage message = OSCMessage(cmd, arguments: list);
    sendOSCMessage(message);
    debugPrint('Sent: $message');
  }

  void setParameter(String attributeName, double parameterValue) {
    OSCMessage message =
        OSCMessage('/eos/cmd', arguments: ['$attributeName $parameterValue#']);
    sendOSCMessage(message);
  }

  void setLabel(double cueNumber, String label) {
    if (label == '') {
      return;
    }
    OSCMessage message =
        OSCMessage('/eos/newcmd', arguments: ['Cue $cueNumber Label $label#']);
    sendOSCMessage(message);
    sendLive();
  }

  // Future<String> getCmdLine() async {
  //   OSCMessage message = OSCMessage('/eos/get/cmd', arguments: []);
  //   var i = await sendOSCMessage(message);
  //   debugPrint(i.toString());
  //   _updateEosOutput();
  //   return "";
  // }

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

  // Future<String> getShowName() async {
  //   OSCMessage message = OSCMessage('/eos/out/show/name', arguments: []);
  //   sendOSCMessage(message);
  //   String reply = '';
  //   client.listen((msg) {
  //     reply = msg.toString();
  //     return;
  //   });
  //   return reply;
  // }

  void close() async {
    // _setUDPTXIPDefault();
    client.flush();
    client.close();
  }

  // Future<List<String>> getCues() async {
  //   // Get number of cues.
  //   OSCMessage message;
  //   List<String> cues = [];
  //   message = OSCMessage('/eos/get/cue/1/count', arguments: []);
  //   sendOSCMessage(message);
  //   sleep100();
  //   client.listen((event) async {
  //     OSCMessage msg = OSCMessage.fromBytes(event);
  //     if (msg.address == '/eos/out/get/cue/1/count') {
  //       for (int i = 0; i < int.parse(msg.arguments[0].toString()); i++) {
  //         message = OSCMessage('/eos/get/cue/0/index/$i', arguments: []);
  //         await sendOSCMessage(message);
  //         OSCSocket listenSocket = OSCSocket(serverPort: clientPort);
  //         sleep(const Duration(milliseconds: 25));
  //         await listenSocket.listen((msg) {
  //           debugPrint(msg.address);
  //           if (msg.address == '/eos/out/get/cue/0/0') {
  //             debugPrint(msg.arguments.toString());
  //             cues.add(msg.arguments.toString());
  //           }
  //         });
  //         listenSocket.close();
  //       }
  //     }
  //   });
  //   debugPrint(cues.toString());
  //   return cues;
  // }

  void sleep250() {
    sleep(const Duration(milliseconds: 250));
  }

  void updatePanTilt(double pan, double tilt) {
    OSCMessage message =
        OSCMessage('/eos/param/pan/tilt', arguments: [pan, tilt]);
    sendOSCMessage(message);
  }

  // int getCurrentCueIndex() {
  //   OSCMessage message = OSCMessage('/eos/out/active/cue/', arguments: []);
  //   sendOSCMessage(message);
  //   int reply = -1;
  //   OSCSocket listenSocket = OSCSocket(serverPort: clientPort);
  //   listenSocket.listen((msg) {
  //     debugPrint('Index: ${msg.arguments[0].toString()}');
  //     if (msg.address == '/eos/out/active/cue/text') {
  //       reply = int.parse(msg.arguments[0].toString());
  //       return;
  //     }
  //   });
  //   listenSocket.close();
  //   return reply;
  // }

  void sendColor(double red, double green, double blue) {
    OSCMessage message =
        OSCMessage('/eos/color/rgb', arguments: [red, green, blue]);
    sendOSCMessage(message);
  }

//   Future<List<Fader>> getFader(int faderPage) {
//     OSCSocket listenSocket = OSCSocket(serverPort: clientPort);
//     List<Fader> faders = [];
//     listenSocket.listen((msg) {
//       if (msg.address.contains('/eos/out/fader/$faderPage')) {
//         var message = msg.address.split('/');
//         var index = int.parse(message[4]);
//         faders.add(Fader(msg.arguments.join(" "), index, faderPage, 0));
//       }
//     });
//     listenSocket.close();
//     return Future.value(faders);
//   }
}

bool isPrivateIPAddress(String string) {
  return string.startsWith('10.') ||
      string.startsWith('172.') ||
      string.startsWith('192.168.') ||
      string.startsWith('127.');
}
