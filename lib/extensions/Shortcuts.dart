import 'dart:ui';

import 'package:flutter/material.dart';

import '../objects/osc_control.dart';

class Shortcut {
  final String name;
  final String osc_message;
  List<Object> args = [];
  Color? color;
  Function()? onTap;

  Shortcut(this.name, this.osc_message, {this.args = const [], this.color, this.onTap});

  Widget buildShortcut(BuildContext ctx, OSC osc) {

    return ElevatedButton(onPressed: () {
      osc.send(osc_message, args);
      if(onTap != null) {
        onTap!();
      }
    }
    ,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: color ?? Theme.of(ctx).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Text(name));

  }
}

class ShortcutsPage extends StatefulWidget {
  final List<Shortcut> shortcuts;
  final OSC osc;

  ShortcutsPage(this.shortcuts, this.osc);

  @override
  State<ShortcutsPage> createState() => _ShortcutsPageState();
}

class _ShortcutsPageState extends State<ShortcutsPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shortcuts'),
      ),
      body: ListView.builder(
        itemCount: widget.shortcuts.length,
        itemBuilder: (context, index) {
          return widget.shortcuts[index].buildShortcut(context, widget.osc);
        },
      ),
    );
  }
}