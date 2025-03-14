import 'dart:ui';

import 'package:flutter/material.dart';

import '../objects/osc_control.dart';

class Shortcut extends StatefulWidget {
  final String name;
  final String osc_message;
  String? shortcutDescription;
  Shortcut? shortcutAfterTap;
  late OSC osc;
  List<Object> args = [];
  Color? color;
  Function()? onTap;

  Shortcut(this.name, this.osc_message,
      {this.args = const [],
      this.color,
      this.onTap,
      this.shortcutAfterTap,
      this.shortcutDescription});

  @override
  State<StatefulWidget> createState() {
    return _ShortcutState();
  }
}

class _ShortcutState extends State<Shortcut> {
  bool isToggled = true;

  @override
  Widget build(BuildContext context) {
    return buildShortcut(context, widget.osc);
  }

  Widget buildShortcut(BuildContext ctx, OSC osc) {
    debugPrint("Building shortcut $isToggled");

    return SizedBox(
        width: MediaQuery.sizeOf(ctx).width /3,
        height: MediaQuery.sizeOf(ctx).height,
        child:
    Column(children: [
      GestureDetector(
        onTap: () {
          osc.send(
              isToggled
                  ? (widget.osc_message)
                  : (widget.shortcutAfterTap?.osc_message ??
                      widget.osc_message),
              isToggled
                  ? widget.args
                  : (widget.shortcutAfterTap?.args ?? widget.args));
          isToggled = !isToggled;
          setState(() {});
        },
        child: Container(
            width: MediaQuery.sizeOf(ctx).width * 0.3,
            height: MediaQuery.sizeOf(ctx).width * 0.3,
            color: isToggled
                ? (widget.color ?? Theme.of(ctx).primaryColor)
                : (widget.shortcutAfterTap?.color ??
                    Theme.of(ctx).primaryColor),
            child: Center(
                child: Text(
                    isToggled
                        ? widget.name
                        : (widget.shortcutAfterTap?.name ?? widget.name),
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)))),
      ),
      Padding(padding: const EdgeInsets.only(top: 20)),
      widget.shortcutDescription == null
          ? Container()
          : Text(widget.shortcutDescription!)
    ]));
  }
}

class ShortcutsPage extends StatefulWidget {
  final List<Shortcut> shortcuts;
  final OSC osc;

  ShortcutsPage(this.shortcuts, this.osc);

  @override
  State<ShortcutsPage> createState() => _ShortcutsPageState();
}

class _ShortcutsPageState extends State<ShortcutsPage> {
  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    for (var element in widget.shortcuts) {
      element.osc = widget.osc;
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('Shortcuts'),
        ),
        body: SizedBox(
            child: ListView(scrollDirection: Axis.horizontal,children: widget.shortcuts,)
    ));
  }
}
