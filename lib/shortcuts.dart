import 'package:flutter/services.dart';
import 'package:free_rfr/objects/osc_control.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:material_ui/material_ui.dart';

class _ShortcutBinding {
  final HotKey hotKey;
  final void Function(OSC osc) action;

  const _ShortcutBinding(this.hotKey, this.action);
}

final List<LogicalKeyboardKey> _digitKeys = [
  LogicalKeyboardKey.digit0,
  LogicalKeyboardKey.digit1,
  LogicalKeyboardKey.digit2,
  LogicalKeyboardKey.digit3,
  LogicalKeyboardKey.digit4,
  LogicalKeyboardKey.digit5,
  LogicalKeyboardKey.digit6,
  LogicalKeyboardKey.digit7,
  LogicalKeyboardKey.digit8,
  LogicalKeyboardKey.digit9,
];

final List<LogicalKeyboardKey> _numpadKeys = [
  LogicalKeyboardKey.numpad0,
  LogicalKeyboardKey.numpad1,
  LogicalKeyboardKey.numpad2,
  LogicalKeyboardKey.numpad3,
  LogicalKeyboardKey.numpad4,
  LogicalKeyboardKey.numpad5,
  LogicalKeyboardKey.numpad6,
  LogicalKeyboardKey.numpad7,
  LogicalKeyboardKey.numpad8,
  LogicalKeyboardKey.numpad9,
];

_ShortcutBinding _binding(
  LogicalKeyboardKey key,
  void Function(OSC osc) action, [
  List<HotKeyModifier> modifiers = const [],
]) {
  return _ShortcutBinding(
    HotKey(
      key: key,
      modifiers: modifiers,
      scope: HotKeyScope.inapp,
    ),
    action,
  );
}

void Function(OSC) _sendKey(String key) => (osc) => osc.sendKey(key);

void Function(OSC) _sendCmd(String command) => (osc) => osc.sendCmd(command);

final List<_ShortcutBinding> shortcutBindings = [
  _binding(
    LogicalKeyboardKey.keyG,
    _sendKey('go_to_cue'),
    [HotKeyModifier.control, HotKeyModifier.shift],
  ),
  _binding(LogicalKeyboardKey.keyA, _sendKey('address'), [
    HotKeyModifier.alt,
  ]),
  _binding(LogicalKeyboardKey.backspace, _sendKey('clear_cmdline'), [
    HotKeyModifier.shift,
  ]),
  ...List.generate(6, (index) {
    return _binding(_digitKeys[index + 1], _sendKey('softkey_${index + 1}'), [
      HotKeyModifier.alt,
    ]);
  }),
  _binding(LogicalKeyboardKey.digit7, _sendKey('more_softkeys'), [
    HotKeyModifier.alt,
  ]),
  _binding(LogicalKeyboardKey.keyA, _sendKey('select_active'), [
    HotKeyModifier.control,
  ]),
  _binding(LogicalKeyboardKey.keyL, _sendKey('select_last'), [
    HotKeyModifier.control,
  ]),
  _binding(LogicalKeyboardKey.keyH, _sendKey('home'), [
    HotKeyModifier.control,
  ]),
  _binding(LogicalKeyboardKey.keyU, _sendKey('save_show'), [
    HotKeyModifier.shift,
  ]),
  _binding(LogicalKeyboardKey.keyC, _sendKey('color_palette'), [
    HotKeyModifier.alt,
  ]),
  _binding(LogicalKeyboardKey.keyI, _sendKey('intensity_palette'), [
    HotKeyModifier.alt,
  ]),
  _binding(LogicalKeyboardKey.keyF, _sendKey('focus_palette'), [
    HotKeyModifier.alt,
  ]),
  _binding(LogicalKeyboardKey.keyB, _sendKey('beam_palette'), [
    HotKeyModifier.alt,
  ]),
  _binding(LogicalKeyboardKey.keyP, _sendKey('preset'), [
    HotKeyModifier.alt,
  ]),
  _binding(LogicalKeyboardKey.keyR, _sendKey('record'), [
    HotKeyModifier.alt,
  ]),
  _binding(LogicalKeyboardKey.keyR, _sendKey('record_only'), [
    HotKeyModifier.control,
  ]),
  _binding(LogicalKeyboardKey.space, _sendKey('stop'), [
    HotKeyModifier.control,
  ]),
  _binding(LogicalKeyboardKey.keyI, _sendKey('time')),
  _binding(LogicalKeyboardKey.backspace, _sendKey('clear_cmd')),
  _binding(LogicalKeyboardKey.enter, _sendCmd('#')),
  _binding(LogicalKeyboardKey.keyG, _sendKey('group')),
  _binding(LogicalKeyboardKey.pageUp, _sendKey('last')),
  _binding(LogicalKeyboardKey.pageDown, _sendKey('next')),
  _binding(LogicalKeyboardKey.keyK, _sendKey('mark')),
  _binding(LogicalKeyboardKey.f1, (osc) => osc.sendLive()),
  _binding(LogicalKeyboardKey.f2, (osc) => osc.sendBlind()),
  _binding(LogicalKeyboardKey.keyX, _sendKey('undo')),
  _binding(LogicalKeyboardKey.keyU, _sendCmd('update')),
  _binding(LogicalKeyboardKey.keyF, _sendKey('full')),
  _binding(LogicalKeyboardKey.keyO, _sendKey('out')),
  ...List.generate(10, (index) {
    return _binding(_digitKeys[index], _sendCmd('$index'));
  }),
  ...List.generate(10, (index) {
    return _binding(_numpadKeys[index], _sendCmd('$index'));
  }),
  _binding(LogicalKeyboardKey.keyN, _sendKey('sneak')),
  _binding(LogicalKeyboardKey.delete, _sendKey('delete')),
  _binding(LogicalKeyboardKey.keyQ, _sendKey('cue')),
  _binding(LogicalKeyboardKey.keyS, _sendKey('sub')),
  _binding(LogicalKeyboardKey.keyD, _sendKey('delay')),
  _binding(LogicalKeyboardKey.keyE, _sendKey('recall_from')),
  _binding(LogicalKeyboardKey.keyT, _sendKey('thru')),
  _binding(LogicalKeyboardKey.keyC, _sendKey('copy_to')),
  _binding(LogicalKeyboardKey.keyP, _sendKey('part')),
  _binding(LogicalKeyboardKey.space, _sendKey('go_0')),
  _binding(LogicalKeyboardKey.keyA, _sendKey('at')),
  _binding(LogicalKeyboardKey.period, _sendKey('.')),
  _binding(LogicalKeyboardKey.equal, _sendKey('+')),
  _binding(LogicalKeyboardKey.minus, _sendKey('-')),
  _binding(LogicalKeyboardKey.add, _sendCmd('+%'), [HotKeyModifier.shift]),
  _binding(LogicalKeyboardKey.minus, _sendCmd('-%'), [HotKeyModifier.shift]),
  _binding(LogicalKeyboardKey.slash, _sendCmd('/')),
  _binding(LogicalKeyboardKey.colon, _sendCmd(':')),
  _binding(LogicalKeyboardKey.digit9, _sendCmd('('), [HotKeyModifier.shift]),
  _binding(LogicalKeyboardKey.digit0, _sendCmd(')'), [HotKeyModifier.shift]),
];

List<HotKey> get registeredShortcutHotKeys =>
    shortcutBindings.map((binding) => binding.hotKey).toList();

Future<void> registerHotKeys(OSC osc) async {
  final identifiers = <String>{};
  for (final binding in shortcutBindings) {
    if (!identifiers.add(binding.hotKey.identifier)) {
      throw ArgumentError('Duplicate hotkey: ${binding.hotKey.identifier}');
    }
    await hotKeyManager.register(
      binding.hotKey,
      keyDownHandler: (_) => binding.action(osc),
    );
  }
}

Future<void> unregisterHotKeys(BuildContext _) async {
  for (final hotKey in registeredShortcutHotKeys) {
    await hotKeyManager.unregister(hotKey);
  }
}
