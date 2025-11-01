import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:free_rfr/configurations/context.dart';
import 'package:free_rfr/objects/osc_control.dart';
import 'package:free_rfr/pages/facepanels/faders.dart';
import 'package:mocktail/mocktail.dart';
import 'package:osc/osc.dart';

class MockSocket extends Mock implements Socket {}

class MockedStreamSubscription<T> extends Mock
    implements StreamSubscription<T> {}

Future<void> main() async {
  test('Test OSC Contruction', () async {
    late OSCMessage msg;
    MockSocket client = MockSocket();
    FreeRFRContext freeRFRContext = FreeRFRContext();

    when(() => client.address).thenReturn(InternetAddress('127.0.0.1'));
    when(() => client.port).thenReturn(12345);
    when(() => client.listen(any<void Function(Uint8List?)>()))
        .thenAnswer((invocation) {
      return MockedStreamSubscription<Uint8List>();
    });
    OSC osc = await setUp(client, freeRFRContext);
    verify(() => client.listen(any())).called(1);
    FaderControlsState state = FaderControlsState();
    //test setup fader bank.
    osc.setupFaderBank(5, state);
    osc.shutdownMultiConsole();
    osc.sendBlind();
    osc.sendLive();
    osc.sendKey('key');
    osc.updatePanTilt(0, 0);
    osc.sendColor(0, 0, 0);
    expect(isPrivateIPAddress('127.0.0.1'), true);
    expect(isPrivateIPAddress('1.1.1.1'), false);
    osc.sleep250();
    osc.sleep100();

    osc.sendCmd('/eos/key/live');
    msg = OSCMessage('/eos/cmd', arguments: ['/eos/key/live']);
    verify(() => client.add(msg.toBytes())).called(1);

    osc.send('/eos/key/abc', []);
    msg = OSCMessage('/eos/key/abc', arguments: []);
    verify(() => client.add(msg.toBytes())).called(1);

    osc.setParameter('Intens', 0);
    msg = OSCMessage('/eos/cmd', arguments: ['Intens 0#']);

    osc.setLabel(1, 'Test Cue Label');
    msg = OSCMessage('/eos/newcmd', arguments: ['Cue 1 Label Test Cue Label#']);
    osc.setLabel(1, '');

    osc.sendLive();
    msg = OSCMessage('/eos/key/live', arguments: []);
    osc.sendBlind();
    msg = OSCMessage('/eos/key/blind', arguments: []);
    when(() => client.flush()).thenAnswer((invocation) async {});
    when(() => client.close()).thenAnswer((invocation) async {});
    await osc.close();
    verify(() => client.flush()).called(1);
    verify(() => client.close()).called(1);
  });
}

Future<OSC> setUp(Socket client, FreeRFRContext freeRFRContext) async {
  return OSC(freeRFRContext, 0, client);
}
