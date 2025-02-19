import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:free_rfr/objects/osc_control.dart';

class FreeRFRShortcutManager extends StatefulWidget {
  final Widget child;
  final OSC osc;
  const FreeRFRShortcutManager(this.child, this.osc, {super.key});

  @override
  State<FreeRFRShortcutManager> createState() => _FreeRFRShortcutManagerState();
}

class _FreeRFRShortcutManagerState extends State<FreeRFRShortcutManager> {
  final FocusNode focusNode = FocusNode();
  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
        focusNode: focusNode,
        child: widget.child,
        onKeyEvent: (event) {
          var isCtrlPressed = false;
          var isShiftPressed = false;
          var isAltPressed = false;
          if (event.logicalKey == LogicalKeyboardKey.controlLeft ||
              event.logicalKey == LogicalKeyboardKey.controlRight) {
            isCtrlPressed = true;
          }
          if (event.logicalKey == LogicalKeyboardKey.shiftLeft ||
              event.logicalKey == LogicalKeyboardKey.shiftRight) {
            isShiftPressed = true;
          }
          if (event.logicalKey == LogicalKeyboardKey.altLeft ||
              event.logicalKey == LogicalKeyboardKey.altRight) {
            isAltPressed = true;
          }
          /**Two Modifiers */
          if (isCtrlPressed &&
              isShiftPressed &&
              event.logicalKey == LogicalKeyboardKey.keyG) {
            widget.osc.sendKey("go_to_cue");
          }
          /** One Modifiers */
          else if (isAltPressed &&
              event.logicalKey == LogicalKeyboardKey.keyA) {
            widget.osc.sendKey("address");
          } else if (isShiftPressed &&
              event.logicalKey == LogicalKeyboardKey.backspace) {
            widget.osc.sendKey("clear_cmdline");
          }
          //soft keys
          else if (isAltPressed &&
              event.logicalKey == LogicalKeyboardKey.digit1) {
            widget.osc.sendKey("softkey1");
          } else if (isAltPressed &&
              event.logicalKey == LogicalKeyboardKey.digit2) {
            widget.osc.sendKey("softkey2");
          } else if (isAltPressed &&
              event.logicalKey == LogicalKeyboardKey.digit3) {
            widget.osc.sendKey("softkey3");
          } else if (isAltPressed &&
              event.logicalKey == LogicalKeyboardKey.digit4) {
            widget.osc.sendKey("softkey4");
          } else if (isAltPressed &&
              event.logicalKey == LogicalKeyboardKey.digit5) {
            widget.osc.sendKey("softkey5");
          } else if (isAltPressed &&
              event.logicalKey == LogicalKeyboardKey.digit6) {
            widget.osc.sendKey("softkey6");
          } else if (isCtrlPressed &&
              event.logicalKey == LogicalKeyboardKey.keyA) {
            widget.osc.sendKey("select_active");
          } else if (isCtrlPressed &&
              event.logicalKey == LogicalKeyboardKey.keyL) {
            widget.osc.sendKey("select_last");
          } else if (isCtrlPressed &&
              event.logicalKey == LogicalKeyboardKey.keyH) {
            widget.osc.sendKey("home");
          } else if (isCtrlPressed &&
              event.logicalKey == LogicalKeyboardKey.keyV) {
            widget.osc.sendKey("level");
          } else if (isCtrlPressed &&
              event.logicalKey == LogicalKeyboardKey.keyI) {
            widget.osc.sendKey("time");
          } else if (isShiftPressed &&
              event.logicalKey == LogicalKeyboardKey.keyU) {
            widget.osc.sendKey("save_show");
          } else if (isAltPressed &&
              event.logicalKey == LogicalKeyboardKey.keyC) {
            widget.osc.sendKey("color_palette");
          } else if (isAltPressed &&
              event.logicalKey == LogicalKeyboardKey.keyI) {
            widget.osc.sendKey("intensity_palette");
          } else if (isAltPressed &&
              event.logicalKey == LogicalKeyboardKey.keyF) {
            widget.osc.sendKey("focus_palette");
          } else if (isAltPressed &&
              event.logicalKey == LogicalKeyboardKey.keyB) {
            widget.osc.sendKey("beam_palette");
          } else if (isAltPressed &&
              event.logicalKey == LogicalKeyboardKey.keyP) {
            widget.osc.sendKey("preset");
          } else if (isAltPressed &&
              event.logicalKey == LogicalKeyboardKey.keyR) {
            widget.osc.sendKey("record");
          } else if (isCtrlPressed &&
              event.logicalKey == LogicalKeyboardKey.keyR) {
            widget.osc.sendKey("record_only");
          } else if (isCtrlPressed &&
              event.logicalKey == LogicalKeyboardKey.space) {
            widget.osc.sendKey("stop");
          }

          /** Keys without Modifiers */
          else if (event.logicalKey == LogicalKeyboardKey.backspace) {
            widget.osc.sendKey("clear");
          } else if (event.logicalKey == LogicalKeyboardKey.enter) {
            widget.osc.sendKey("#");
          } else if (event.logicalKey == LogicalKeyboardKey.keyG) {
            widget.osc.sendKey("group");
          } else if (event.logicalKey == LogicalKeyboardKey.pageUp) {
            widget.osc.sendKey("last");
          } else if (event.logicalKey == LogicalKeyboardKey.pageDown) {
            widget.osc.sendKey("next");
          } else if (event.logicalKey == LogicalKeyboardKey.keyK) {
            widget.osc.sendKey("mark");
          } else if (event.logicalKey == LogicalKeyboardKey.f1) {
            widget.osc.sendLive();
          } else if (event.logicalKey == LogicalKeyboardKey.f2) {
            widget.osc.sendBlind();
          } else if (isCtrlPressed &&
              event.logicalKey == LogicalKeyboardKey.keyX) {
            widget.osc.sendKey("undo");
          } else if (event.logicalKey == LogicalKeyboardKey.keyU) {
            widget.osc.sendKey("update");
          } else if (event.logicalKey == LogicalKeyboardKey.keyF) {
            widget.osc.sendKey("full");
          } else if (event.logicalKey == LogicalKeyboardKey.keyO) {
            widget.osc.sendKey("out");
          } else if (event.logicalKey == LogicalKeyboardKey.numpad0 ||
              event.logicalKey == LogicalKeyboardKey.digit0) {
            widget.osc.sendKey("0");
          } else if (event.logicalKey == LogicalKeyboardKey.numpad1 ||
              event.logicalKey == LogicalKeyboardKey.digit1) {
            widget.osc.sendKey("1");
          } else if (event.logicalKey == LogicalKeyboardKey.numpad2 ||
              event.logicalKey == LogicalKeyboardKey.digit2) {
            widget.osc.sendKey("2");
          } else if (event.logicalKey == LogicalKeyboardKey.numpad3 ||
              event.logicalKey == LogicalKeyboardKey.digit3) {
            widget.osc.sendKey("3");
          } else if (event.logicalKey == LogicalKeyboardKey.numpad4 ||
              event.logicalKey == LogicalKeyboardKey.digit4) {
            widget.osc.sendKey("4");
          } else if (event.logicalKey == LogicalKeyboardKey.numpad5 ||
              event.logicalKey == LogicalKeyboardKey.digit5) {
            widget.osc.sendKey("5");
          } else if (event.logicalKey == LogicalKeyboardKey.numpad6 ||
              event.logicalKey == LogicalKeyboardKey.digit6) {
            widget.osc.sendKey("6");
          } else if (event.logicalKey == LogicalKeyboardKey.numpad7 ||
              event.logicalKey == LogicalKeyboardKey.digit7) {
            widget.osc.sendKey("7");
          } else if (event.logicalKey == LogicalKeyboardKey.numpad8 ||
              event.logicalKey == LogicalKeyboardKey.digit8) {
            widget.osc.sendKey("8");
          } else if (event.logicalKey == LogicalKeyboardKey.numpad9 ||
              event.logicalKey == LogicalKeyboardKey.digit9) {
            widget.osc.sendKey("9");
          } else if (event.logicalKey == LogicalKeyboardKey.keyN) {
            widget.osc.sendKey("sneak");
          } else if (event.logicalKey == LogicalKeyboardKey.delete) {
            widget.osc.sendKey("delete");
          } else if (event.logicalKey == LogicalKeyboardKey.keyQ) {
            widget.osc.sendKey("cue");
          } else if (event.logicalKey == LogicalKeyboardKey.keyS) {
            widget.osc.sendKey("sub");
          } else if (event.logicalKey == LogicalKeyboardKey.keyD) {
            widget.osc.sendKey("delay");
          } else if (event.logicalKey == LogicalKeyboardKey.keyE) {
            widget.osc.sendKey("recall_from");
          } else if (event.logicalKey == LogicalKeyboardKey.keyT) {
            widget.osc.sendKey("thru");
          } else if (event.logicalKey == LogicalKeyboardKey.keyX) {
            widget.osc.sendKey("cueonlytrack");
          } else if (event.logicalKey == LogicalKeyboardKey.keyC) {
            widget.osc.sendKey("copy_to");
          } else if (event.logicalKey == LogicalKeyboardKey.keyP) {
            widget.osc.sendKey("part");
          } else if (event.logicalKey == LogicalKeyboardKey.space) {
            widget.osc.sendKey("go_0");
          }
        });
  }
}
