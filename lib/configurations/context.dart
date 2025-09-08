import 'package:flutter/widgets.dart';
import 'package:free_rfr/objects/parameters.dart';

class FreeRFRContext extends ChangeNotifier {
  ParameterMap _currentChannel = {};
  String _commandLine = '';
  int _currentCueList = 1;
  double _currentCue = -1;
  String _currentCueText = '';
  double _previousCue = -1;
  String _previousCueText = '';
  double _nextCue = -1;
  String _nextCueText = '';
  List<double> _hueSaturation = [];

  ParameterMap get currentChannel => _currentChannel;

  set currentChannel(ParameterMap channel) {
    _currentChannel = channel;
    notifyListeners();
  }

  String get commandLine => _commandLine;

  set commandLine(String command) {
    _commandLine = command;
    notifyListeners();
  }

  int get currentCueList => _currentCueList;

  set currentCueList(int cueList) {
    _currentCueList = cueList;
    notifyListeners();
  }

  double get currentCue => _currentCue;

  set currentCue(double cue) {
    _currentCue = cue;
    notifyListeners();
  }

  String get currentCueText => _currentCueText;

  set currentCueText(String text) {
    _currentCueText = text;
    notifyListeners();
  }

  double get previousCue => _previousCue;

  set previousCue(double cue) {
    _previousCue = cue;
    notifyListeners();
  }

  String get previousCueText => _previousCueText;

  set previousCueText(String text) {
    _previousCueText = text;
    notifyListeners();
  }

  double get nextCue => _nextCue;

  set nextCue(double cue) {
    _nextCue = cue;
    notifyListeners();
  }

  String get nextCueText => _nextCueText;

  set nextCueText(String text) {
    _nextCueText = text;
    notifyListeners();
  }

  List<double> get hueSaturation => _hueSaturation;

  set hueSaturation(List<double> hueSaturation) {
    _hueSaturation = hueSaturation;
    notifyListeners();
  }
}
