import 'package:flutter/material.dart';

AlertDialog errorDialog(String msg, BuildContext context) {
  return AlertDialog(
    title: const Text('An error occured connecting to eos!'),
    content: Text("Error has occured: $msg"),
    actions: <Widget>[
      TextButton(
          onPressed: () {
            Navigator.pop(context, 'OK');
          },
          child: const Text('OK')),
    ],
  );
}
