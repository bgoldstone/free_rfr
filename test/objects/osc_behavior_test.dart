import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:free_rfr/configurations/context.dart';
import 'package:free_rfr/objects/osc_control.dart';
import 'package:free_rfr/objects/parameters.dart';
import 'package:free_rfr/pages/facepanels/faders.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:osc/osc.dart';

class MockSocket extends Mock implements Socket {}

class MockedStreamSubscription<T> extends Mock
    implements StreamSubscription<T> {}

class OscHarness {
  OscHarness() {
    when(() => client.address).thenReturn(InternetAddress('127.0.0.1'));
    when(() => client.port).thenReturn(12345);
    when(() => client.add(any<List<int>>())).thenAnswer((invocation) {
      writes
          .add(List<int>.from(invocation.positionalArguments[0] as List<int>));
    });
    when(() => client.listen(any())).thenAnswer((invocation) {
      onData = invocation.positionalArguments[0] as Function;
      return MockedStreamSubscription<Uint8List>();
    });
    osc = OSC(context, 0, client);
  }

  final client = MockSocket();
  final context = FreeRFRContext();
  final writes = <List<int>>[];
  late final OSC osc;
  late final Function onData;

  List<Uint8List> framesFrom(int start) {
    final all =
        Uint8List.fromList(writes.skip(start).expand((item) => item).toList());
    final frames = <Uint8List>[];
    var offset = 0;
    while (offset + 4 <= all.length) {
      final length = ByteData.view(all.buffer, all.offsetInBytes + offset, 4)
          .getUint32(0, Endian.big);
      final end = offset + 4 + length;
      if (end > all.length) {
        break;
      }
      frames.add(Uint8List.sublistView(all, offset + 4, end));
      offset = end;
    }
    return frames;
  }

  void emit(OSCMessage message) => onData(framed(message));

  void emitBytes(Uint8List bytes) => onData(bytes);
}

Uint8List framed(OSCMessage message) {
  final payload = message.toBytes();
  final header = Uint8List(4);
  ByteData.view(header.buffer).setInt32(0, payload.length, Endian.big);
  return Uint8List.fromList([...header, ...payload]);
}

class TestControl extends StatefulWidget {
  final ParameterType type;

  const TestControl(this.type, {super.key});

  @override
  State<TestControl> createState() => TestControlState(type);
}

class TestControlState extends ControlWidget<TestControl> {
  TestControlState(ParameterType type) : super(controllingParameters: [type]);

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

void main() {
  setUpAll(() {
    registerFallbackValue(<int>[]);
  });

  test('sendOSCMessage writes big-endian framed OSC bytes', () async {
    final harness = OscHarness();
    final start = harness.writes.length;
    final message = OSCMessage('/eos/key/abc', arguments: []);

    await harness.osc.sendOSCMessage(message);

    expect(harness.writes.length - start, 1);
    expect(harness.framesFrom(start), [equals(message.toBytes())]);
    expect(
      harness.writes.skip(start).expand((item) => item).take(4).toList(),
      [0, 0, 0, message.toBytes().length],
    );
  });

  test('OSC command builders send exact messages', () async {
    final harness = OscHarness();

    var start = harness.writes.length;
    harness.osc.sendBlind();
    expect(harness.framesFrom(start), [
      equals(OSCMessage('/eos/key/blind', arguments: [1]).toBytes()),
    ]);
    expect(harness.context.commandLine, 'BLIND : ');

    start = harness.writes.length;
    harness.osc.sendLive();
    expect(harness.framesFrom(start), [
      equals(OSCMessage('/eos/key/live', arguments: [1]).toBytes()),
    ]);
    expect(harness.context.commandLine, 'LIVE : ');

    start = harness.writes.length;
    harness.osc.setParameter('Intens', 42.0);
    expect(harness.framesFrom(start), [
      equals(OSCMessage('/eos/cmd', arguments: ['Intens 42.0#']).toBytes()),
    ]);

    start = harness.writes.length;
    harness.osc.setLabel(1.5, 'Focus');
    expect(harness.framesFrom(start), [
      equals(
        OSCMessage('/eos/newcmd', arguments: ['Cue 1.5 Label Focus#'])
            .toBytes(),
      ),
      equals(OSCMessage('/eos/key/live', arguments: [1]).toBytes()),
    ]);

    start = harness.writes.length;
    harness.osc.setLabel(2, '');
    expect(harness.framesFrom(start), isEmpty);

    start = harness.writes.length;
    harness.osc.updatePanTilt(10.0, -20.0);
    expect(harness.framesFrom(start), [
      equals(
        OSCMessage('/eos/param/pan/tilt', arguments: [10.0, -20.0]).toBytes(),
      ),
    ]);

    start = harness.writes.length;
    harness.osc.sendColor(0.1, 0.2, 0.3);
    expect(harness.framesFrom(start), [
      equals(
        OSCMessage('/eos/color/rgb', arguments: [0.1, 0.2, 0.3]).toBytes(),
      ),
    ]);

    start = harness.writes.length;
    await harness.osc.sendKey('abc', sleepMillis: 0);
    expect(harness.framesFrom(start), [
      equals(OSCMessage('/eos/key/abc', arguments: []).toBytes()),
    ]);
  });

  test('setupFaderBank sends config request and stores state', () {
    final harness = OscHarness();
    final state = FaderControlsState();
    final start = harness.writes.length;

    harness.osc.setupFaderBank(10, state);

    expect(harness.framesFrom(start), [
      equals(OSCMessage('/eos/fader/1/config/10', arguments: []).toBytes()),
    ]);
    expect(harness.osc.faderControlsState, same(state));
  });

  test('parseEosMessage decodes padded strings and typed arguments', () {
    final bytes =
        OSCMessage('/eos/out/test', arguments: ['LIVE', 7, 0.5]).toBytes();

    final parsed = parseEosMessage(Uint8List.fromList(bytes));

    expect(parsed.address, '/eos/out/test');
    expect(parsed.arguments, equals(['LIVE', 7, closeTo(0.5, 0.0001)]));
  });

  test('parseEosMessage handles messages without arguments', () {
    final bytes = OSCMessage('/eos/ping', arguments: []).toBytes();

    final parsed = parseEosMessage(Uint8List.fromList(bytes));

    expect(parsed.address, '/eos/ping');
    expect(parsed.arguments, isEmpty);
  });

  test('inbound OSC frames update context state', () {
    final harness = OscHarness();

    harness.emit(OSCMessage('/eos/out/cmd', arguments: ['LIVE : ']));
    expect(harness.context.commandLine, 'LIVE : ');

    harness.emit(OSCMessage('/eos/out/color/hs', arguments: [240, 127.5]));
    expect(harness.context.hueSaturation, [240.0, 0.5]);

    harness.emit(
      OSCMessage('/eos/out/active/cue/text', arguments: ['Long label']),
    );
    expect(harness.context.currentCueText, 'Long label');
    harness.emit(OSCMessage('/eos/out/active/cue/text', arguments: ['A']));
    expect(harness.context.currentCueText, '');

    harness.emit(OSCMessage('/eos/out/active/cue/2/3', arguments: []));
    expect(harness.context.currentCue, 3.0);
    expect(harness.context.currentCueList, 2);

    harness.emit(OSCMessage('/eos/out/pending/cue/4', arguments: []));
    expect(harness.context.nextCue, 4.0);
    harness.emit(OSCMessage('/eos/out/pending/cue/bad', arguments: []));
    expect(harness.context.nextCue, 0.0);

    harness.emit(OSCMessage('/eos/out/previous/cue/5', arguments: []));
    expect(harness.context.previousCue, 5.0);
  });

  test('inbound OSC wheel messages update matching static parameters', () {
    final harness = OscHarness();

    harness.emit(
      OSCMessage('/eos/out/active/wheel/1', arguments: ['Intens 1', 1, 42.0]),
    );
    expect(harness.context.currentChannel[ParameterType.intens], [42.0]);

    harness.emit(
      OSCMessage('/eos/out/active/wheel/2', arguments: ['Tilt 1', 7, 30.0]),
    );
    expect(harness.context.currentChannel[ParameterType.tilt], [-30.0]);
  });

  test('inbound OSC pan/tilt and direct select messages update context', () {
    final harness = OscHarness();

    harness.emit(
      OSCMessage('/eos/out/pantilt/bounds', arguments: [
        -270.0,
        270.0,
        -120.0,
        120.0,
      ]),
    );
    expect(harness.context.currentChannel[ParameterType.minPan], [-270.0]);
    expect(harness.context.currentChannel[ParameterType.maxPan], [270.0]);
    expect(harness.context.currentChannel[ParameterType.minTilt], [-120.0]);
    expect(harness.context.currentChannel[ParameterType.maxTilt], [120.0]);

    harness.emit(
      OSCMessage('/eos/out/ds/1/5', arguments: ['Group 12']),
    );
    final ds = harness.context.directSelects[5];
    expect(ds, isNotNull);
    expect(ds!.name, 'Group');
    expect(ds.objectNumber, 12.0);
  });

  test('inbound OSC reassembles split frames and processes later frames', () {
    final harness = OscHarness();
    final first = framed(OSCMessage('/eos/out/cmd', arguments: ['FIRST']));
    final second = framed(OSCMessage('/eos/out/cmd', arguments: ['SECOND']));

    harness.emitBytes(first.sublist(0, 2));
    expect(harness.context.commandLine, '');

    harness.emitBytes(Uint8List.fromList([...first.sublist(2), ...second]));
    expect(harness.context.commandLine, 'SECOND');
  });

  test('inbound OSC continues after a malformed frame', () {
    final harness = OscHarness();
    final malformed = Uint8List.fromList([0, 0, 0, 3, 1, 2, 3]);
    final valid = framed(OSCMessage('/eos/out/cmd', arguments: ['RECOVERED']));

    harness.emitBytes(Uint8List.fromList([...malformed, ...valid]));

    expect(harness.context.commandLine, 'RECOVERED');
  });

  test('control state registry keeps latest state per runtime type', () {
    final harness = OscHarness();
    final first = TestControlState(ParameterType.pan);
    final second = TestControlState(ParameterType.tilt);

    harness.osc.registerControlState(first);
    expect(harness.osc.getControlWidgetForType(ParameterType.pan), same(first));

    harness.osc.registerControlState(second);
    expect(harness.osc.controlStates, hasLength(1));
    expect(harness.osc.getControlWidgetForType(ParameterType.pan), isNull);
    expect(
        harness.osc.getControlWidgetForType(ParameterType.tilt), same(second));
  });

  test('isPrivateIPAddress recognizes private and local ranges', () {
    for (final address in [
      '10.0.0.1',
      '172.16.0.1',
      '192.168.1.1',
      '127.0.0.1'
    ]) {
      expect(isPrivateIPAddress(address), isTrue, reason: address);
    }
    for (final address in ['1.1.1.1', '8.8.8.8']) {
      expect(isPrivateIPAddress(address), isFalse, reason: address);
    }
  });
}
