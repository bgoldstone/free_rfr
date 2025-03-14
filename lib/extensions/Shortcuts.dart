import 'dart:ui';

import 'package:flutter/material.dart';

import '../objects/osc_control.dart';

class Shortcut {
  final String name;
  final String osc_message;
  Shortcut? shortcutAfterTap;
  List<Object> args = [];
  Color? color;
  bool isToggled = true;
  Function()? onTap;

  Shortcut(this.name, this.osc_message, {this.args = const [], this.color, this.onTap, this.shortcutAfterTap});

  Widget buildShortcut(BuildContext ctx, OSC osc, ) {
    if(!isToggled) {
      return shortcutAfterTap?.buildShortcut(ctx, osc) ?? Container();
    }
    return Container(
      width: MediaQuery.sizeOf(ctx).width * 0.2,
      height: MediaQuery.sizeOf(ctx).width * 0.2,
      color: color ?? Theme.of(ctx).primaryColor,
      child:
      GestureDetector(onTap: () {
        osc.send(osc_message, args);
        if(onTap != null) {
          onTap!();
          isToggled = !isToggled;
        }
      },
          child: Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white,))));
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
      body: Center(child:ListView.builder(
        itemCount: widget.shortcuts.length,
        itemBuilder: (context, index) {
          return widget.shortcuts[index].buildShortcut(context, widget.osc);
        },
      ),)
    );
  }
}