import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:material_ui/material_ui.dart';
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

  bool _isClosed = false;
  Future<void> _commandQueue = Future.value();
  Uint8List _buffer = Uint8List(0);
  int _bufferOffset = 0;

  void _debugLog(String message) {
    if (kDebugMode) {
      debugPrint(message);
    }
  }

  OSC(this.ctx, this.userId, this.client) {
    OSCMessage message = OSCMessage('/eos/subscribe', arguments: [1]);
    sendOSCMessage(message);
    message = OSCMessage('/eos/ping', arguments: ['free rfr']);
    sendOSCMessage(message);
    _updateEosOutput();
    // _setUDPTXIP();
    _debugLog('OSC initialized with ${client.address}:${client.port}');
  }

  Future<void> sendOSCMessage(OSCMessage message) async {
    try {
      final data = message.toBytes();
      final packet = Uint8List(4 + data.length);
      ByteData.view(packet.buffer).setInt32(0, data.length, Endian.big);
      packet.setRange(4, packet.length, data);
      client.add(packet);
    } catch (e) {
      _debugLog("Error sending OSC message: $e");
    }
  }

  void registerControlState(ControlWidget controlWidget) {
    controlStates
        .removeWhere((e) => e.runtimeType == controlWidget.runtimeType);
    controlStates.add(controlWidget);
    _debugLog("added $controlWidget to controlstates");
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
    _debugLog('Sending key $key');
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
    _debugLog('Updating Eos Output');
    List<Object> currentChannel = [];
    client.listen((packet) {
      _appendIncomingBytes(packet);
      while (_buffer.length - _bufferOffset >= 4) {
        final frameStart = _bufferOffset;
        final messageLength =
            ByteData.view(_buffer.buffer, _buffer.offsetInBytes + frameStart, 4)
                .getUint32(0);
        if (_buffer.length - frameStart < 4 + messageLength) {
          break;
        }
        final messageStart = frameStart + 4;
        final messageEnd = messageStart + messageLength;
        final messageData =
            Uint8List.sublistView(_buffer, messageStart, messageEnd);
        try {
          final message = parseEosMessage(messageData);
          _debugLog(
              "Is hs:${message.address.startsWith('/eos/out/color/hs')}, actual :${message.address}");
          _debugLog(message.toString());
          if (kDebugMode) {
            _debugLog(
                "Raw: ${utf8.decode(messageData, allowMalformed: true).trim()}");
          }
          if (message.address == '/eos/out/active/chan') {
            if (message.arguments != currentChannel) {
              currentChannel = message.arguments;
              ctx.currentChannel = {};
            }
          } else if (message.address == '/eos/out/cmd') {
            ctx.commandLine = '${message.arguments[0]}';
          } else if (message.address.startsWith("/eos/out/pantilt") &&
              message.arguments.length >= 4) {
            ctx.updatePanTiltBounds(
              message.arguments[0] as double,
              message.arguments[1] as double,
              message.arguments[2] as double,
              message.arguments[3] as double,
            );
          } else if (message.address.startsWith('/eos/out/active/wheel/')) {
            _debugLog('Original name: ${message.arguments[0]}');
            var origParamName = message.arguments[0].toString().split(" ");
            var parameterName =
                origParamName.sublist(0, origParamName.length - 1).join(" ");
            var value = message.arguments.last as double;
            var role = ParameterRole.getTypeById(message.arguments[1] as int);
            parameterName = parameterName.trimRight();
            _debugLog("Parameter Name: $parameterName|");
            var currentParams = [
              ...ctx.currentChannel.keys,
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
            _debugLog(
                "Creating new ParameterType : $parameterName | ${role.name}");
            _debugLog(ctx.currentChannel.toString());

            if (type == ParameterType.intens) {
              ctx.putCurrentChannel(ParameterType.intens, [value]);
            } else if (type == ParameterType.pan) {
              ctx.putCurrentChannel(ParameterType.pan, [value]);
            } else if (type == ParameterType.tilt) {
              ctx.putCurrentChannel(ParameterType.tilt, [-1 * value]);
            } else {
              ctx.putCurrentChannel(type, [message.arguments.last as double]);
            }
          } else if (message.address.startsWith('/eos/out/color/hs') &&
              message.arguments.isNotEmpty) {
            double hue = double.parse(message.arguments[0].toString());
            double saturation =
                double.parse(message.arguments[1].toString()) / 255;
            _debugLog("HUESAT: $hue $saturation");
            ctx.hueSaturation = [hue, saturation];
          } else if (message.address.startsWith('/eos/out/active/cue/text')) {
            String text = message.arguments[0].toString();
            ctx.updateCurrentCue(text: text.length > 1 ? text : '');
          } else if (message.address.startsWith('/eos/out/active/cue/')) {
            List<String> address = message.address.split('/');
            ctx.updateCurrentCue(
              cue: double.parse(address.last),
              cueList: int.parse(address[address.length - 2]),
            );
          } else if (message.address.startsWith('/eos/out/pending/cue/text')) {
            String text = message.arguments[0].toString();
            ctx.updateNextCue(text: text.length > 1 ? text : '');
          } else if (message.address.startsWith('/eos/out/pending/cue/')) {
            List<String> address = message.address.split('/');
            ctx.updateNextCue(
              cue: double.tryParse(address.last) ?? 0,
            );
          } else if (message.address.startsWith('/eos/out/previous/cue/text')) {
            String text = message.arguments[0].toString();
            ctx.updatePreviousCue(text: text.length > 1 ? text : '');
          } else if (message.address.startsWith('/eos/out/previous/cue/')) {
            List<String> address = message.address.split('/');
            ctx.updatePreviousCue(
              cue: double.tryParse(address.last) ?? 0,
            );
          } else if (message.address.startsWith("/eos/out/fader")) {
            var components = message.address.split("/");
            _debugLog(components.toString());
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
                    _debugLog("Empty arguments");
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
              if (args.length == 4) {
                ctx.updatePanTiltBounds(
                  double.parse(args[0].toString()),
                  double.parse(args[1].toString()),
                  double.parse(args[2].toString()),
                  double.parse(args[3].toString()),
                );
              }
            }
          } else if (message.address.startsWith('/eos/out/ds/1/')) {
            //Direct Selects
            var dsIndex = int.parse(message.address.split('/').last);
            var splitArg = message.arguments[0].toString().split(' ');
            var name = splitArg.sublist(0, splitArg.length - 1).join(' ');
            var objectNumber = double.parse(
                splitArg.last.replaceAll(RegExp(r'\d\/|[^0-9\.]'), ''));
            ctx.updateDirectSelects(dsIndex, objectNumber, name);
          }
        } catch (e) {
          if (kDebugMode) {
            _debugLog(
                'Error parsing OSC message: $e ${utf8.decode(messageData, allowMalformed: true).trim()}');
          }
        }
        _bufferOffset = messageEnd;
      }
      _compactBuffer();
    });
  }

  void _appendIncomingBytes(List<int> packet) {
    final incoming = Uint8List.fromList(packet);
    final remaining = _buffer.length - _bufferOffset;
    if (remaining == 0) {
      _buffer = incoming;
      _bufferOffset = 0;
      return;
    }
    final combined = Uint8List(remaining + incoming.length);
    combined.setRange(0, remaining, _buffer, _bufferOffset);
    combined.setRange(remaining, combined.length, incoming);
    _buffer = combined;
    _bufferOffset = 0;
  }

  void _compactBuffer() {
    final remaining = _buffer.length - _bufferOffset;
    if (_bufferOffset == 0) {
      return;
    }
    if (remaining == 0) {
      _buffer = Uint8List(0);
      _bufferOffset = 0;
      return;
    }
    if (_bufferOffset < 4096) {
      return;
    }
    final compacted = Uint8List(remaining);
    compacted.setRange(0, remaining, _buffer, _bufferOffset);
    _buffer = compacted;
    _bufferOffset = 0;
  }

  void setupFaderBank(int count, FaderControlsState state) {
    OSCMessage message = OSCMessage('/eos/fader/1/config/10', arguments: []);
    sendOSCMessage(message);
    _debugLog('Sent: $message, configuration done!');
    faderControlsState = state;
  }

  void sendCmd(String cmd) {
    _commandQueue = _commandQueue.then((_) async {
      await sendOSCMessage(OSCMessage('/eos/cmd', arguments: [cmd]));
      await Future<void>.delayed(const Duration(milliseconds: 100));
    });
  }

  Future<void> drainCommands() => _commandQueue;

  void send(String cmd, List<Object> list) {
    OSCMessage message = OSCMessage(cmd, arguments: list);
    sendOSCMessage(message);
    _debugLog('Sent: $message');
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
    if (_isClosed) {
      return;
    }
    _isClosed = true;
    try {
      await client.flush();
    } catch (_) {}
    try {
      await client.close();
    } catch (_) {}
    _debugLog('OSC connection closed');
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

OSCMessage parseEosMessage(Uint8List bytes) {
  final data = ByteData.sublistView(bytes);
  int offset = 0;

  // Read OSC address
  final address = _readPaddedString(data, offset);
  offset += _paddedLength(address);

  // Read type tags (starts with ',')
  final typeTagStr = _readPaddedString(data, offset);
  offset += _paddedLength(typeTagStr);

  final List<Object> args = [];
  final tags = typeTagStr.substring(1).split('');

  for (final tag in tags) {
    switch (tag) {
      case 's':
        final str = _readPaddedString(data, offset);
        args.add(str);
        offset += _paddedLength(str);
        break;
      case 'i':
        args.add(data.getInt32(offset, Endian.big));
        offset += 4;
        break;
      case 'f':
        args.add(data.getFloat32(offset, Endian.big));
        offset += 4;
        break;
      default:
        // Skip unknown types safely
        offset += 4;
        break;
    }
  }

  return OSCMessage(address, arguments: args);
}

String _readPaddedString(ByteData data, int offset) {
  final bytes = <int>[];
  while (offset < data.lengthInBytes && data.getUint8(offset) != 0) {
    bytes.add(data.getUint8(offset++));
  }
  offset++; // skip null terminator
  while (offset % 4 != 0) offset++; // realign to next 4-byte boundary
  return utf8.decode(bytes);
}

int _paddedLength(String s) {
  final raw = s.length + 1; // +1 for null terminator
  return (raw + 3) & ~3; // round up to multiple of 4
}
