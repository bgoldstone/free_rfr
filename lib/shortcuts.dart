import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:free_rfr/objects/osc_control.dart';
import 'package:hotkey_manager/hotkey_manager.dart';

void registerHotKeys(OSC osc) async {
  /**Two Modifiers */
  HotKey goToCue = HotKey(
      key: LogicalKeyboardKey.keyG,
      modifiers: [HotKeyModifier.control, HotKeyModifier.shift],
      scope: HotKeyScope.inapp);
  hotKeyManager.register(goToCue,
      keyDownHandler: (key) => osc.sendKey('go_to_cue'));
  /**One Modifier */
  HotKey address = HotKey(
      key: LogicalKeyboardKey.keyA,
      modifiers: [HotKeyModifier.alt],
      scope: HotKeyScope.inapp);
  hotKeyManager.register(address,
      keyDownHandler: (key) => osc.sendKey('address'));

  HotKey clearCommandLine = HotKey(
      key: LogicalKeyboardKey.backspace,
      modifiers: [HotKeyModifier.shift],
      scope: HotKeyScope.inapp);
  hotKeyManager.register(clearCommandLine,
      keyDownHandler: (key) => osc.sendKey('clear_cmdline'));
  /** Softkeys */
  HotKey softkey1 = HotKey(
      key: LogicalKeyboardKey.digit1,
      modifiers: [HotKeyModifier.alt],
      scope: HotKeyScope.inapp);
  hotKeyManager.register(softkey1,
      keyDownHandler: (key) => osc.sendKey('softkey_1'));

  HotKey softkey2 = HotKey(
      key: LogicalKeyboardKey.digit2,
      modifiers: [HotKeyModifier.alt],
      scope: HotKeyScope.inapp);
  hotKeyManager.register(softkey2,
      keyDownHandler: (key) => osc.sendKey('softkey_2'));

  HotKey softkey3 = HotKey(
      key: LogicalKeyboardKey.digit3,
      modifiers: [HotKeyModifier.alt],
      scope: HotKeyScope.inapp);
  hotKeyManager.register(softkey3,
      keyDownHandler: (key) => osc.sendKey('softkey_3'));

  HotKey softkey4 = HotKey(
      key: LogicalKeyboardKey.digit4,
      modifiers: [HotKeyModifier.alt],
      scope: HotKeyScope.inapp);
  hotKeyManager.register(softkey4,
      keyDownHandler: (key) => osc.sendKey('softkey_4'));

  HotKey softkey5 = HotKey(
      key: LogicalKeyboardKey.digit5,
      modifiers: [HotKeyModifier.alt],
      scope: HotKeyScope.inapp);
  hotKeyManager.register(softkey5,
      keyDownHandler: (key) => osc.sendKey('softkey_5'));

  HotKey softkey6 = HotKey(
      key: LogicalKeyboardKey.digit6,
      modifiers: [HotKeyModifier.alt],
      scope: HotKeyScope.inapp);
  hotKeyManager.register(softkey6,
      keyDownHandler: (key) => osc.sendKey('softkey_6'));

  HotKey moreSoftkeys = HotKey(
      key: LogicalKeyboardKey.digit7,
      modifiers: [HotKeyModifier.alt],
      scope: HotKeyScope.inapp);
  hotKeyManager.register(moreSoftkeys,
      keyDownHandler: (key) => osc.sendKey('more_softkeys'));

  HotKey selectActive = HotKey(
      key: LogicalKeyboardKey.keyA,
      modifiers: [HotKeyModifier.control],
      scope: HotKeyScope.inapp);
  hotKeyManager.register(selectActive,
      keyDownHandler: (key) => osc.sendKey('select_active'));

  HotKey selectLast = HotKey(
      key: LogicalKeyboardKey.keyL,
      modifiers: [HotKeyModifier.control],
      scope: HotKeyScope.inapp);
  hotKeyManager.register(selectLast,
      keyDownHandler: (key) => osc.sendKey('select_last'));

  HotKey home = HotKey(
      key: LogicalKeyboardKey.keyH,
      modifiers: [HotKeyModifier.control],
      scope: HotKeyScope.inapp);
  hotKeyManager.register(home, keyDownHandler: (key) => osc.sendKey('home'));

  HotKey level = HotKey(
      key: LogicalKeyboardKey.keyL,
      modifiers: [HotKeyModifier.control],
      scope: HotKeyScope.inapp);
  hotKeyManager.register(level, keyDownHandler: (key) => osc.sendKey('level'));

  HotKey saveShow = HotKey(
      key: LogicalKeyboardKey.keyU,
      modifiers: [HotKeyModifier.shift],
      scope: HotKeyScope.inapp);
  hotKeyManager.register(saveShow,
      keyDownHandler: (key) => osc.sendKey('save_show'));

  HotKey colorPalette = HotKey(
      key: LogicalKeyboardKey.keyC,
      modifiers: [HotKeyModifier.alt],
      scope: HotKeyScope.inapp);
  hotKeyManager.register(colorPalette,
      keyDownHandler: (key) => osc.sendKey('color_palette'));

  HotKey intensityPalette = HotKey(
      key: LogicalKeyboardKey.keyI,
      modifiers: [HotKeyModifier.alt],
      scope: HotKeyScope.inapp);
  hotKeyManager.register(intensityPalette,
      keyDownHandler: (key) => osc.sendKey('intensity_palette'));

  HotKey focusPalette = HotKey(
      key: LogicalKeyboardKey.keyF,
      modifiers: [HotKeyModifier.alt],
      scope: HotKeyScope.inapp);
  hotKeyManager.register(focusPalette,
      keyDownHandler: (key) => osc.sendKey('focus_palette'));

  HotKey beamPalette = HotKey(
      key: LogicalKeyboardKey.keyB,
      modifiers: [HotKeyModifier.alt],
      scope: HotKeyScope.inapp);
  hotKeyManager.register(beamPalette,
      keyDownHandler: (key) => osc.sendKey('beam_palette'));

  HotKey preset = HotKey(
      key: LogicalKeyboardKey.keyP,
      modifiers: [HotKeyModifier.alt],
      scope: HotKeyScope.inapp);
  hotKeyManager.register(preset,
      keyDownHandler: (key) => osc.sendKey('preset'));

  HotKey record = HotKey(
      key: LogicalKeyboardKey.keyR,
      modifiers: [HotKeyModifier.alt],
      scope: HotKeyScope.inapp);
  hotKeyManager.register(record,
      keyDownHandler: (key) => osc.sendKey('record'));

  HotKey recordOnly = HotKey(
      key: LogicalKeyboardKey.keyR,
      modifiers: [HotKeyModifier.control],
      scope: HotKeyScope.inapp);
  hotKeyManager.register(recordOnly,
      keyDownHandler: (key) => osc.sendKey('record_only'));

  HotKey stop = HotKey(
      key: LogicalKeyboardKey.space,
      modifiers: [HotKeyModifier.control],
      scope: HotKeyScope.inapp);
  hotKeyManager.register(stop, keyDownHandler: (key) => osc.sendKey('stop'));
  /**Keys without modifiers */
  HotKey time = HotKey(key: LogicalKeyboardKey.keyI, scope: HotKeyScope.inapp);
  hotKeyManager.register(time, keyDownHandler: (key) => osc.sendKey('time'));
  HotKey clear =
      HotKey(key: LogicalKeyboardKey.backspace, scope: HotKeyScope.inapp);
  hotKeyManager.register(clear,
      keyDownHandler: (key) => osc.sendKey('clear_cmd'));

  HotKey enter =
      HotKey(key: LogicalKeyboardKey.enter, scope: HotKeyScope.inapp);
  hotKeyManager.register(enter, keyDownHandler: (key) => (osc.sendCmd('#')));

  HotKey group = HotKey(key: LogicalKeyboardKey.keyG, scope: HotKeyScope.inapp);
  hotKeyManager.register(group, keyDownHandler: (key) => osc.sendKey('group'));
  HotKey last =
      HotKey(key: LogicalKeyboardKey.pageUp, scope: HotKeyScope.inapp);
  hotKeyManager.register(last, keyDownHandler: (key) => osc.sendKey('last'));

  HotKey next =
      HotKey(key: LogicalKeyboardKey.pageDown, scope: HotKeyScope.inapp);
  hotKeyManager.register(next, keyDownHandler: (key) => osc.sendKey('next'));

  HotKey mark = HotKey(key: LogicalKeyboardKey.keyK, scope: HotKeyScope.inapp);
  hotKeyManager.register(mark, keyDownHandler: (key) => osc.sendKey('mark'));

  HotKey live = HotKey(key: LogicalKeyboardKey.f1, scope: HotKeyScope.inapp);
  hotKeyManager.register(live, keyDownHandler: (key) => osc.sendLive());

  HotKey blind = HotKey(key: LogicalKeyboardKey.f2, scope: HotKeyScope.inapp);
  hotKeyManager.register(blind, keyDownHandler: (key) => osc.sendBlind());

  HotKey undo = HotKey(key: LogicalKeyboardKey.keyX, scope: HotKeyScope.inapp);
  hotKeyManager.register(undo, keyDownHandler: (key) => osc.sendKey('undo'));

  HotKey update =
      HotKey(key: LogicalKeyboardKey.keyU, scope: HotKeyScope.inapp);
  hotKeyManager.register(update,
      keyDownHandler: (key) => osc.sendCmd('update'));

  HotKey full = HotKey(key: LogicalKeyboardKey.keyF, scope: HotKeyScope.inapp);
  hotKeyManager.register(full, keyDownHandler: (key) => osc.sendKey('full'));

  HotKey out = HotKey(key: LogicalKeyboardKey.keyO, scope: HotKeyScope.inapp);
  hotKeyManager.register(out, keyDownHandler: (key) => osc.sendKey('out'));
  /** Number Keys */
  HotKey zeroKey =
      HotKey(key: LogicalKeyboardKey.digit0, scope: HotKeyScope.inapp);
  hotKeyManager.register(zeroKey, keyDownHandler: (key) => osc.sendCmd('0'));

  HotKey numpad0 =
      HotKey(key: LogicalKeyboardKey.numpad0, scope: HotKeyScope.inapp);
  hotKeyManager.register(numpad0, keyDownHandler: (key) => osc.sendCmd('0'));

  HotKey oneKey =
      HotKey(key: LogicalKeyboardKey.digit1, scope: HotKeyScope.inapp);
  hotKeyManager.register(oneKey, keyDownHandler: (key) => osc.sendCmd('1'));

  HotKey numpad1 =
      HotKey(key: LogicalKeyboardKey.numpad1, scope: HotKeyScope.inapp);
  hotKeyManager.register(numpad1, keyDownHandler: (key) => osc.sendCmd('1'));

  HotKey twoKey =
      HotKey(key: LogicalKeyboardKey.digit2, scope: HotKeyScope.inapp);
  hotKeyManager.register(twoKey, keyDownHandler: (key) => osc.sendCmd('2'));

  HotKey numpad2 =
      HotKey(key: LogicalKeyboardKey.numpad2, scope: HotKeyScope.inapp);
  hotKeyManager.register(numpad2, keyDownHandler: (key) => osc.sendCmd('2'));

  HotKey threeKey =
      HotKey(key: LogicalKeyboardKey.digit3, scope: HotKeyScope.inapp);
  hotKeyManager.register(threeKey, keyDownHandler: (key) => osc.sendCmd('3'));

  HotKey numpad3 =
      HotKey(key: LogicalKeyboardKey.numpad3, scope: HotKeyScope.inapp);
  hotKeyManager.register(numpad3, keyDownHandler: (key) => osc.sendCmd('3'));

  HotKey fourKey =
      HotKey(key: LogicalKeyboardKey.digit4, scope: HotKeyScope.inapp);
  hotKeyManager.register(fourKey, keyDownHandler: (key) => osc.sendCmd('4'));

  HotKey numpad4 =
      HotKey(key: LogicalKeyboardKey.numpad4, scope: HotKeyScope.inapp);
  hotKeyManager.register(numpad4, keyDownHandler: (key) => osc.sendCmd('4'));

  HotKey fiveKey =
      HotKey(key: LogicalKeyboardKey.digit5, scope: HotKeyScope.inapp);
  hotKeyManager.register(fiveKey, keyDownHandler: (key) => osc.sendCmd('5'));

  HotKey numpad5 =
      HotKey(key: LogicalKeyboardKey.numpad5, scope: HotKeyScope.inapp);
  hotKeyManager.register(numpad5, keyDownHandler: (key) => osc.sendCmd('5'));

  HotKey sixKey =
      HotKey(key: LogicalKeyboardKey.digit6, scope: HotKeyScope.inapp);
  hotKeyManager.register(sixKey, keyDownHandler: (key) => osc.sendCmd('6'));

  HotKey numpad6 =
      HotKey(key: LogicalKeyboardKey.numpad6, scope: HotKeyScope.inapp);
  hotKeyManager.register(numpad6, keyDownHandler: (key) => osc.sendCmd('6'));

  HotKey sevenKey =
      HotKey(key: LogicalKeyboardKey.digit7, scope: HotKeyScope.inapp);
  hotKeyManager.register(sevenKey, keyDownHandler: (key) => osc.sendCmd('7'));

  HotKey numpad7 =
      HotKey(key: LogicalKeyboardKey.numpad7, scope: HotKeyScope.inapp);
  hotKeyManager.register(numpad7, keyDownHandler: (key) => osc.sendCmd('7'));

  HotKey eightKey =
      HotKey(key: LogicalKeyboardKey.digit8, scope: HotKeyScope.inapp);
  hotKeyManager.register(eightKey, keyDownHandler: (key) => osc.sendCmd('8'));

  HotKey numpad8 =
      HotKey(key: LogicalKeyboardKey.numpad8, scope: HotKeyScope.inapp);
  hotKeyManager.register(numpad8, keyDownHandler: (key) => osc.sendCmd('8'));

  HotKey nineKey =
      HotKey(key: LogicalKeyboardKey.digit9, scope: HotKeyScope.inapp);
  hotKeyManager.register(nineKey, keyDownHandler: (key) => osc.sendCmd('9'));

  HotKey numpad9 =
      HotKey(key: LogicalKeyboardKey.numpad9, scope: HotKeyScope.inapp);
  hotKeyManager.register(numpad9, keyDownHandler: (key) => osc.sendCmd('9'));

  /** End of Number Keys */

  HotKey sneak = HotKey(key: LogicalKeyboardKey.keyN, scope: HotKeyScope.inapp);
  hotKeyManager.register(sneak, keyDownHandler: (key) => osc.sendKey('sneak'));

  HotKey delete =
      HotKey(key: LogicalKeyboardKey.delete, scope: HotKeyScope.inapp);
  hotKeyManager.register(delete,
      keyDownHandler: (key) => osc.sendKey('delete'));

  HotKey cue = HotKey(key: LogicalKeyboardKey.keyQ, scope: HotKeyScope.inapp);
  hotKeyManager.register(cue, keyDownHandler: (key) => osc.sendKey('cue'));

  HotKey sub = HotKey(key: LogicalKeyboardKey.keyS, scope: HotKeyScope.inapp);
  hotKeyManager.register(sub, keyDownHandler: (key) => osc.sendKey('sub'));

  HotKey delay = HotKey(key: LogicalKeyboardKey.keyD, scope: HotKeyScope.inapp);
  hotKeyManager.register(delay, keyDownHandler: (key) => osc.sendKey('delay'));

  HotKey recallFrom =
      HotKey(key: LogicalKeyboardKey.keyE, scope: HotKeyScope.inapp);
  hotKeyManager.register(recallFrom,
      keyDownHandler: (key) => osc.sendKey('recall_from'));

  HotKey thru = HotKey(key: LogicalKeyboardKey.keyT, scope: HotKeyScope.inapp);
  hotKeyManager.register(thru, keyDownHandler: (key) => osc.sendKey('thru'));

  HotKey cueonlytrack =
      HotKey(key: LogicalKeyboardKey.keyX, scope: HotKeyScope.inapp);
  hotKeyManager.register(cueonlytrack,
      keyDownHandler: (key) => osc.sendKey('cueonlytrack'));

  HotKey copyTo =
      HotKey(key: LogicalKeyboardKey.keyC, scope: HotKeyScope.inapp);
  hotKeyManager.register(copyTo,
      keyDownHandler: (key) => osc.sendKey('copy_to'));

  HotKey part = HotKey(key: LogicalKeyboardKey.keyP, scope: HotKeyScope.inapp);
  hotKeyManager.register(part, keyDownHandler: (key) => osc.sendKey('part'));

  HotKey go0 = HotKey(key: LogicalKeyboardKey.space, scope: HotKeyScope.inapp);
  hotKeyManager.register(go0, keyDownHandler: (key) => osc.sendKey('go_0'));

  HotKey at = HotKey(key: LogicalKeyboardKey.keyA, scope: HotKeyScope.inapp);
  hotKeyManager.register(at, keyDownHandler: (key) => osc.sendKey('at'));

  HotKey peroid =
      HotKey(key: LogicalKeyboardKey.period, scope: HotKeyScope.inapp);
  hotKeyManager.register(peroid, keyDownHandler: (key) => osc.sendKey('.'));

  HotKey plus = HotKey(key: LogicalKeyboardKey.equal, scope: HotKeyScope.inapp);
  hotKeyManager.register(plus, keyDownHandler: (key) => osc.sendKey('+'));

  HotKey minus =
      HotKey(key: LogicalKeyboardKey.minus, scope: HotKeyScope.inapp);
  hotKeyManager.register(minus, keyDownHandler: (key) => osc.sendKey('-'));

  HotKey plus10 = HotKey(
      key: LogicalKeyboardKey.add,
      modifiers: [HotKeyModifier.shift],
      scope: HotKeyScope.inapp);
  hotKeyManager.register(plus10, keyDownHandler: (key) => osc.sendCmd('+%'));

  HotKey minus10 = HotKey(
      key: LogicalKeyboardKey.minus,
      modifiers: [HotKeyModifier.shift],
      scope: HotKeyScope.inapp);
  hotKeyManager.register(minus10, keyDownHandler: (key) => osc.sendCmd('-%'));

  HotKey slash =
      HotKey(key: LogicalKeyboardKey.slash, scope: HotKeyScope.inapp);
  hotKeyManager.register(slash, keyDownHandler: (key) => osc.sendCmd('/'));

  HotKey colon =
      HotKey(key: LogicalKeyboardKey.colon, scope: HotKeyScope.inapp);
  hotKeyManager.register(colon, keyDownHandler: (key) => osc.sendCmd(':'));

  HotKey parenthesisLeft = HotKey(
      key: LogicalKeyboardKey.digit9,
      modifiers: [HotKeyModifier.shift],
      scope: HotKeyScope.inapp);
  hotKeyManager.register(parenthesisLeft,
      keyDownHandler: (key) => osc.sendCmd('('));

  HotKey parenthesisRight = HotKey(
      key: LogicalKeyboardKey.digit0,
      modifiers: [HotKeyModifier.shift],
      scope: HotKeyScope.inapp);
  hotKeyManager.register(parenthesisRight,
      keyDownHandler: (key) => osc.sendCmd(')'));
}

Future<void> unregisterHotKeys(BuildContext context) async {
  await hotKeyManager.unregisterAll();
}
