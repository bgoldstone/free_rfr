import 'package:free_rfr/objects/osc_control.dart';
import 'package:mocktail/mocktail.dart';
import 'package:osc/osc.dart';

class MockOSC extends Mock implements OSC {
  @override
  Future<void> sendOSCMessage(OSCMessage message) async {
    // Mock implementation
  }
}
