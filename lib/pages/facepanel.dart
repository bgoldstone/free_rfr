import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:free_rfr/objects/osc_control.dart';
import 'package:free_rfr/pages/facepanels/all_keys.dart';
import 'package:free_rfr/pages/facepanels/keypad.dart';
import 'package:free_rfr/pages/facepanels/additional_keys.dart';
import 'package:free_rfr/pages/facepanels/targets.dart';

class FacePanel extends StatefulWidget {
  final OSC osc;
  const FacePanel({required this.osc, super.key});

  @override
  State<FacePanel> createState() => _FacePanelState();
}

class _FacePanelState extends State<FacePanel> {
  int index = 1;
  Size? size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    final List<Widget> pages = [
      Target(
        osc: widget.osc,
      ),
      Keypad(
        osc: widget.osc,
      ),
      AdditionalKeys(
        osc: widget.osc,
      )
    ];
    debugPrint(size!.width.toString());
    bool isWide = size!.width > 1200;
    return Scaffold(
      body: pages.isEmpty
          ? const CircularProgressIndicator()
          : isWide
              ? AllKeys(osc: widget.osc)
              : pages[index],
      bottomNavigationBar: !isWide
          ? BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.adjust), label: 'Targets'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.keyboard), label: 'Keypad'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.light_mode), label: 'Additional Keys'),
              ],
              onTap: (index) => setState(() => this.index = index),
              unselectedItemColor:
                  MediaQuery.of(context).platformBrightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
              selectedItemColor: Colors.yellow,
              currentIndex: index,
            )
          : null,
    );
  }
}
