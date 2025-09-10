import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:osc/osc.dart';

void main() async {
  Socket socket = await Socket.connect('127.0.0.1', 3032);
  OSCMessage message = OSCMessage('/eos/key/confirm_command', arguments: []);
  // OSCMessage message = OSCMessage('/eos/ds/2/group/page/1', arguments: []);
  debugPrint(utf8.decode(message.toBytes()));
  debugPrint(message.toString());

  final data = message.toBytes();
  final lengthBytes = Uint8List(4); // 4 bytes for the length (big-endian)
  ByteData.view(lengthBytes.buffer).setInt32(0, data.length, Endian.big);
  socket.add(lengthBytes);
  socket.add(message.toBytes());
  List<int> buffer = [];
  socket.listen((data) {
    buffer.addAll(data);

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
        // Attempt to parse the OSC message.
        debugPrint(messageData.length.toString());
        final message = OSCMessage.fromBytes(messageData.sublist(4));
        debugPrint(
            'Received OSC message: ${message.address} ${message.arguments}');
        // Process the OSC message (e.g., send a reply)
        // Example of sending a reply (assuming you have the necessary data):
        // final replyMessage = OSCMessage('/reply', [42]);
        // sendOscMessage(socket, replyMessage); // Use the sendOscMessage function
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
