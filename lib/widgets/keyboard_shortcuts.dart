import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:free_rfr/objects/osc_control.dart';

class KeyboardShortcuts extends StatelessWidget {
  final Widget child;
  final OSC osc;
  const KeyboardShortcuts({super.key, required this.child, required this.osc});

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
        bindings: {
          // KEYPAD KEYS
          LogicalKeySet.fromSet(
              {LogicalKeyboardKey.control, LogicalKeyboardKey.keyG}): () {
            osc.sendKey('go_to_cue');
          },
          LogicalKeySet.fromSet({
            LogicalKeyboardKey.shift,
            LogicalKeyboardKey.backspace,
          }): () => osc.sendKey("clear_cmdline"),
          LogicalKeySet.fromSet({
            LogicalKeyboardKey.alt,
            LogicalKeyboardKey.keyA,
          }): () => osc.sendKey("address"),
          const SingleActivator(LogicalKeyboardKey.keyA): () =>
              osc.sendKey("at"),
          const SingleActivator(LogicalKeyboardKey.pageUp): () =>
              osc.sendKey("last"),
          const SingleActivator(LogicalKeyboardKey.pageDown): () =>
              osc.sendKey("next"),
          const SingleActivator(LogicalKeyboardKey.keyT): () =>
              osc.sendKey("thru"),
          const SingleActivator(LogicalKeyboardKey.keyG): () =>
              osc.sendKey("group"),
          const SingleActivator(LogicalKeyboardKey.keyO): () =>
              osc.sendKey("out"),
          const SingleActivator(LogicalKeyboardKey.keyF): () =>
              osc.sendKey("full"),
          const SingleActivator(LogicalKeyboardKey.backspace): () =>
              osc.sendKey("clear_cmd"),
          const SingleActivator(LogicalKeyboardKey.enter): () =>
              osc.sendKey("enter"),
          const SingleActivator(LogicalKeyboardKey.digit0): () =>
              osc.sendKey("0"),
          const SingleActivator(LogicalKeyboardKey.digit1): () =>
              osc.sendKey("1"),
          const SingleActivator(LogicalKeyboardKey.digit2): () =>
              osc.sendKey("2"),
          const SingleActivator(LogicalKeyboardKey.digit3): () =>
              osc.sendKey("3"),
          const SingleActivator(LogicalKeyboardKey.digit4): () =>
              osc.sendKey("4"),
          const SingleActivator(LogicalKeyboardKey.digit5): () =>
              osc.sendKey("5"),
          const SingleActivator(LogicalKeyboardKey.digit6): () =>
              osc.sendKey("6"),
          const SingleActivator(LogicalKeyboardKey.digit7): () =>
              osc.sendKey("7"),
          const SingleActivator(LogicalKeyboardKey.digit8): () =>
              osc.sendKey("8"),
          const SingleActivator(LogicalKeyboardKey.digit9): () =>
              osc.sendKey("9"),
          const SingleActivator(LogicalKeyboardKey.equal): () =>
              osc.sendKey("+"),
          const SingleActivator(LogicalKeyboardKey.minus): () =>
              osc.sendKey("-"),
          const SingleActivator(LogicalKeyboardKey.period): () =>
              osc.sendKey("."),
          // TARGETS
          const SingleActivator(LogicalKeyboardKey.keyP): () =>
              osc.sendKey("part"),
          const SingleActivator(LogicalKeyboardKey.keyQ): () =>
              osc.sendKey("cue"),
          const SingleActivator(LogicalKeyboardKey.keyR): () =>
              osc.sendKey("record"),
          LogicalKeySet.fromSet(
                  {LogicalKeyboardKey.alt, LogicalKeyboardKey.keyP}):
              () => osc.sendKey("preset"),
          const SingleActivator(LogicalKeyboardKey.keyS): () =>
              osc.sendKey("sub"),
          const SingleActivator(LogicalKeyboardKey.keyD): () =>
              osc.sendKey("delay"),
          const SingleActivator(LogicalKeyboardKey.delete): () =>
              osc.sendKey("delete"),
          const SingleActivator(LogicalKeyboardKey.keyC): () =>
              osc.sendKey("copy_to"),
          const SingleActivator(LogicalKeyboardKey.keyE): () =>
              osc.sendKey("recall_from"),
          LogicalKeySet.fromSet(
              {LogicalKeyboardKey.shift, LogicalKeyboardKey.keyU}): () {
            osc.sendKey('save');
            osc.sendKey('enter');
          },
          const SingleActivator(LogicalKeyboardKey.keyU): () =>
              osc.sendKey('update'),
          const SingleActivator(LogicalKeyboardKey.keyX): () =>
              osc.sendKey('cueonlytrack'),
          const SingleActivator(LogicalKeyboardKey.keyK): () =>
              osc.sendKey('mark'),
          const SingleActivator(LogicalKeyboardKey.keyN): () =>
              osc.sendKey('sneak'),
          const SingleActivator(LogicalKeyboardKey.keyH): () =>
              osc.sendKey('rem_dim'),
          LogicalKeySet.fromSet(
                  {LogicalKeyboardKey.control, LogicalKeyboardKey.keyM}):
              () => osc.sendKey('select_manual'),
          LogicalKeySet.fromSet(
                  {LogicalKeyboardKey.control, LogicalKeyboardKey.keyL}):
              () => osc.sendKey('select_last'),
          LogicalKeySet.fromSet(
                  {LogicalKeyboardKey.control, LogicalKeyboardKey.keyA}):
              () => osc.sendKey('select_active'),
          const SingleActivator(LogicalKeyboardKey.home): () =>
              osc.sendKey('home'),
          LogicalKeySet.fromSet({
            LogicalKeyboardKey.control,
            LogicalKeyboardKey.keyV,
          }): () => osc.sendKey('level'),
          const SingleActivator(LogicalKeyboardKey.keyI): () =>
              osc.sendKey('time'),
          const SingleActivator(LogicalKeyboardKey.f1): () =>
              osc.sendKey('live'),
          const SingleActivator(LogicalKeyboardKey.f2): () =>
              osc.sendKey('blind'),
          LogicalKeySet.fromSet({
            LogicalKeyboardKey.control,
            LogicalKeyboardKey.keyX,
          }): () => osc.sendKey('undo'),
          const SingleActivator(LogicalKeyboardKey.slash): () =>
              osc.sendKey('/'),
        },
        child: Focus(
          autofocus: true,
          child: child,
        ));
  }
}
