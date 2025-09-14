import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:free_rfr/configurations/context.dart';
import 'package:free_rfr/objects/parameters.dart';
import 'package:osc/osc.dart';
import '../pages/facepanels/faders.dart';

class OSC {
  List<double> hueSaturation = [0, 0];
  final FreeRFRContext ctx;
  final int userId;

  FaderControlsState? faderControlsState;
  List<ControlWidget> controlStates = [];

  final Socket client;

  OSC(this.ctx, this.userId, this.client) {
    OSCMessage message = OSCMessage('/eos/subscribe', arguments: [1]);
    sendOSCMessage(message);
    message = OSCMessage('/eos/ping', arguments: ['free rfr']);
    sendOSCMessage(message);
    _updateEosOutput();
    // _setUDPTXIP();
    debugPrint('OSC initialized with ${client.address}:${client.port}');
  }

  Future<void> sendOSCMessage(OSCMessage message) async {
    try {
      final data = message.toBytes();
      final lengthBytes = Uint8List(4); // 4 bytes for the length (big-endian)
      ByteData.view(lengthBytes.buffer).setInt32(0, data.length, Endian.big);
      client.add(lengthBytes);
      client.add(message.toBytes());
    } catch (e) {
      debugPrint("Error sending OSC message: $e");
    }
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

  Future<void> shutdownMultiConsole() async {
    await sendKey('power_off');
    await sendKey('enter');
    await close();
  }

  void sleep100() {
    sleep(const Duration(milliseconds: 100));
  }

  void sendBlind() {
    OSCMessage message = OSCMessage('/eos/key/blind', arguments: [1]);
    sendOSCMessage(message);
    ctx.commandLine = 'BLIND : ';
  }

  void sendLive() {
    OSCMessage message = OSCMessage('/eos/key/live', arguments: [1]);
    sendOSCMessage(message);
    ctx.commandLine = 'LIVE : ';
  }

  Future<void> sendKey(String key, {int sleepMillis = 100}) async {
    debugPrint('Sending key $key');
    OSCMessage message = OSCMessage('/eos/key/$key', arguments: []);
    await sendOSCMessage(message);
    await Future.delayed(Duration(milliseconds: sleepMillis));
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
    List<int> buffer = [];
    ParameterMap parameters = {};
    List<Object> currentChannel = [];
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
          debugPrint(
              "Raw: ${utf8.decode(messageData.sublist(4), allowMalformed: true).trim()}");
          if (message.address == '/eos/out/active/chan') {
            if (message.arguments != currentChannel) {
              currentChannel = message.arguments;
              parameters = {};
            }
          } else if (message.address == '/eos/out/cmd') {
            ctx.commandLine = '${message.arguments[0]}';
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
            var parameterName = message.arguments[0]
                .toString()
                .split(" ")
                .sublist(0, message.arguments.length - 1)
                .join(" ");
            var value = message.arguments.last as double;
            var role = ParameterRole.getTypeById(message.arguments[1] as int);
            parameterName = parameterName.trimRight();
            debugPrint("args: $parameterName");
            debugPrint("Parameter Name: $parameterName|");
            var currentParams = [
              ...parameters.keys,
              ...ParameterType.staticParamTypes
            ];
            ParameterType? type;
            for (ParameterType t in currentParams) {
              if (t.oscName == parameterName) {
                type = t;
                break;
              }
            }
            //if type null create parameterType.
            type ??= ParameterType(parameterName, role);
            debugPrint(parameters.toString());

            if (type == ParameterType.intens) {
              parameters[ParameterType.intens] = [value];
            } else if (type == ParameterType.pan) {
              parameters[ParameterType.pan] = [value];
            } else if (type == ParameterType.tilt) {
              parameters[ParameterType.tilt] = [-1 * value];
            } else {
              parameters[type] = [message.arguments.last as double];
            }
          } else if (message.address.startsWith('/eos/out/color/hs') &&
              message.arguments.isNotEmpty) {
            double hue = double.parse(message.arguments[0].toString());
            double saturation =
                double.parse(message.arguments[1].toString()) / 255;
            debugPrint("HUESAT: $hue $saturation");
            ctx.hueSaturation = [hue, saturation];
          } else if (message.address.startsWith('/eos/out/active/cue/text')) {
            String text = message.arguments[0].toString();
            if (text.length > 1) {
              ctx.currentCueText = text;
            } else {
              ctx.currentCueText = '';
            }
          } else if (message.address.startsWith('/eos/out/active/cue/')) {
            List<String> address = message.address.split('/');
            ctx.currentCue = double.parse(address.last);
            ctx.currentCueList = int.parse(address[address.length - 2]);
          } else if (message.address.startsWith('/eos/out/pending/cue/text')) {
            String text = message.arguments[0].toString();
            if (text.length > 1) {
              ctx.nextCueText = text;
            } else {
              ctx.nextCueText = '';
            }
          } else if (message.address.startsWith('/eos/out/pending/cue/')) {
            List<String> address = message.address.split('/');
            try {
              ctx.nextCue = double.parse(address.last);
            } catch (e) {
              ctx.nextCue = 0;
            }
          } else if (message.address.startsWith('/eos/out/previous/cue/text')) {
            String text = message.arguments[0].toString();
            if (text.length > 1) {
              ctx.previousCueText = text;
            } else {
              ctx.previousCueText = '';
            }
          } else if (message.address.startsWith('/eos/out/previous/cue/')) {
            List<String> address = message.address.split('/');
            try {
              ctx.previousCue = double.parse(address.last);
            } catch (e) {
              ctx.previousCue = 0;
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
              var args = message.arguments;
              if (args.isNotEmpty && args.length <= 4) {
                ctx.currentChannel[ParameterType.minPan]![0] =
                    double.parse(args[0].toString());
                ctx.currentChannel[ParameterType.maxPan]![0] =
                    double.parse(args[1].toString());
                ctx.currentChannel[ParameterType.minTilt]![0] =
                    double.parse(args[2].toString());
                ctx.currentChannel[ParameterType.maxTilt]![0] =
                    double.parse(args[3].toString());
              }
            }
          } else if (message.address.startsWith('/eos/out/ds/1/')) {
            //Direct Selects
            var dsIndex = int.parse(message.address.split('/').last);
            var splitArg = message.arguments[0].toString().split(' ');
            var name = splitArg.sublist(0, splitArg.length - 1).join(' ');
            var objectNumber =
                int.parse(splitArg.last.replaceAll(RegExp(r'[^0-9]'), ''));
            ctx.directSelects[dsIndex] = DS(objectNumber, name);
          }
          debugPrint('setting current channel: $parameters');
          ctx.currentChannel = parameters; //End While
        } catch (e) {
          debugPrint(
              'Error parsing OSC message: $e ${utf8.decode(messageData, allowMalformed: true).trim()}');
          // Consider how to handle parsing errors (e.g., send an error message to the client, close the connection).
          // socket.add(Uint8List.fromList("ERROR".codeUnits)); //send error
          // socket.close();
        }
        buffer.removeRange(0, 4 + messageLength);
      }
    });
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

  Future<void> close() async {
    await client.flush();
    await client.close();
    debugPrint('OSC connection closed');
  }

  void sleep250() {
    sleep(const Duration(milliseconds: 250));
  }

  void updatePanTilt(double pan, double tilt) {
    OSCMessage message =
        OSCMessage('/eos/param/pan/tilt', arguments: [pan, tilt]);
    sendOSCMessage(message);
  }

  void sendColor(double red, double green, double blue) {
    OSCMessage message =
        OSCMessage('/eos/color/rgb', arguments: [red, green, blue]);
    sendOSCMessage(message);
  }
}

bool isPrivateIPAddress(String string) {
  return string.startsWith('10.') ||
      string.startsWith('172.') ||
      string.startsWith('192.168.') ||
      string.startsWith('127.');
}
