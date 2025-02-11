import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:free_rfr/extensions/Extensions.dart';
import 'package:free_rfr/free_rfr.dart';
import 'package:free_rfr/objects/parameters.dart';
import 'package:osc/osc.dart';
import '../main.dart';
import '../pages/controls/pan_tilt_control.dart';
import '../pages/facepanels/fader.dart';

class OSC {
  final InternetAddress hostIP;
  final int hostPort = 8000;
  final int clientPort = 8001;
  final Function(ParameterMap)? setCurrentChannel;
  final Function(String)? setCommandLine;
  final void Function(int)? setCurrentCueList;
  final void Function(double)? setCurrentCue;
  final void Function(String)? setCurrentCueText;
  final void Function(double)? setPreviousCue;
  final void Function(String)? setPreviousCueText;
  final void Function(double)? setNextCue;
  final void Function(String)? setNextCueText;
  final void Function(double, double)? setHueSaturation;

  FaderControlsState? faderControlsState;
  List<ControlWidget> controlStates = [];

  late final OSCSocket client;

  OSC(
      this.hostIP,
      this.setCurrentChannel,
      this.setCommandLine,
      this.setCurrentCueList,
      this.setCurrentCue,
      this.setCurrentCueText,
      this.setPreviousCue,
      this.setPreviousCueText,
      this.setNextCue,
      this.setNextCueText,
      this.setHueSaturation) {
    client = OSCSocket(destination: hostIP, destinationPort: hostPort);
    OSCMessage message = OSCMessage('/eos/subscribe', arguments: [1]);
    client.send(message);
    message = OSCMessage('/eos/ping', arguments: ['free rfr']);
    client.send(message);
    _updateEosOutput();
    _setUDPTXIP();
    loginAsUser();
  }

  OSC.simple(this.hostIP, {this.setCommandLine = null, this.setCurrentChannel = null, this.setCurrentCueList = null, this.setCurrentCue = null, this.setCurrentCueText = null, this.setPreviousCue = null, this.setPreviousCueText = null, this.setNextCue = null, this.setNextCueText = null, this.setHueSaturation = null}) {
    client = OSCSocket(destination: hostIP, destinationPort: hostPort);
    OSCMessage message = OSCMessage('/eos/subscribe', arguments: [1]);
    client.send(message);
    message = OSCMessage('/eos/ping', arguments: ['free rfr']);
    client.send(message);
    _updateEosOutput();
    _setUDPTXIP();
    loginAsUser();
    }

    void registerControlState(ControlWidget controlWidget) {
    controlStates.removeWhere((e) => e.runtimeType == controlWidget.runtimeType);
      controlStates.add(controlWidget);
      debugPrint("added $controlWidget to controlstates");
    }

    ControlWidget? getControlWidgetForType(ParameterType type) {
      for(var control in controlStates) {
        if(control.controllingParameters.contains(type)) {
          return control;
        }
      }
      return null;
    }


  void _setUDPTXIP() async {
    List<NetworkInterface> list = await NetworkInterface.list();
    List<String> addresses = [];

    for (NetworkInterface interface in list) {
      if (interface.addresses.first.type == InternetAddressType.IPv4 &&
          isPrivateIPAddress(interface.addresses.first.address.toString())) {
        addresses.add(interface.addresses.first.address.toString());
      }
    }
    OSCMessage message;
    String locale = Platform.localeName;
    var split = locale.split('_');
    if(split[0].toLowerCase() == "en") {
      message = OSCMessage('/eos/newcmd',
          arguments: ['OSC_UDP_TX_IP_ADDRESS ${addresses.join(',')}#']);
    }else{
      message = OSCMessage('/eos/newcmd',
          arguments: ['OSC_UDP_TX_IP_ADRESSE ${addresses.join(',')}#']);
    }

    await client.send(message);
    sleep100();
    /*
    OSCSocket listenSocket = OSCSocket(serverPort: clientPort);
    listenSocket.listen((event) {
      if (event.address == '/eos/out/cmd') {
        setCommandLine!('${event.arguments[0]}');
        debugPrint(event.arguments[0].toString());
      }
    });

     */
    sendLive();
  }

  void sleep100() {
    sleep(const Duration(milliseconds: 100));
  }

  void _setUDPTXIPDefault() async {
    OSCMessage message =
        OSCMessage('/eos/newcmd', arguments: ['OSC_UDP_TX_IP_ADDRESS#']);
    client.send(message);
    sleep100();
    sendLive();
  }

  void sendBlind() {
    OSCMessage message = OSCMessage('/eos/key/blind', arguments: [1]);
    client.send(message);
    setCommandLine!('BLIND : ');
  }

  void sendLive() {
    OSCMessage message = OSCMessage('/eos/key/live', arguments: [1]);
    client.send(message);
    setCommandLine!('LIVE : ');
  }


  void sendKey(String key, {bool withUpdate = true, double sleepMillis = 100}) async {
    debugPrint('Sending key $key');
    OSCMessage message = OSCMessage('/eos/key/$key', arguments: []);
    client.send(message);
    sleep(Duration(milliseconds: sleepMillis.toInt()));
    _updateEosOutput();
  }

  Future<int> requestCountOfType(String type) async{
    OSCMessage message = OSCMessage('/eos/get/$type/count', arguments: []);
    client.send(message);
    OSCSocket listenSocket = OSCSocket(serverPort: clientPort);
    Completer<int> compl = Completer();
    listenSocket.listen((msg) {
      if (msg.address == '/eos/out/get/$type/count') {
        compl.complete(int.parse(msg.arguments[0].toString()));
        return;
      }
    });
    listenSocket.close();
    return compl.future;
  }

  void loginAsUser({String? id}) {
    var ip = InternetAddress.anyIPv4;
    id ??= ip.address.split(".").last;
    OSCMessage message = OSCMessage('/eos/user/$id', arguments: []);
    client.send(message);
  }

  Map<int, List<String>> currentResponse = {};
  int maxChannel = 0;
  List<int> currentChannel = [];
  bool isCheckingColors = false;
  Completer<int> compl = Completer();

  void _updateEosOutput() {
    OSCSocket listenSocket = OSCSocket(serverPort: clientPort);
    ParameterMap parameters = {};
    listenSocket.listen((event) {
      if (event.address == '/eos/out/cmd') {
        setCommandLine!('${event.arguments[0]}');
      }
      debugPrint(event.address);
      if(event.address.startsWith("/eos/out/active/chan")) {

        if(currentResponse.keys.isNotEmpty) {
          if(currentResponse.keys.last >= maxChannel) {
            if(!compl.isCompleted) {
              compl.complete(maxChannel);
            }
          }
        }

        if(event.arguments.isEmpty || event.arguments.toString()=="[]") {
          return;
        }
        if(compl.isCompleted && !isCheckingColors) {
          compl = Completer();
          debugPrint("channel args: ${event.address} : ${event.arguments}");
          //todo: multiple selected channel
          var c = getChannelsFromCurrentChannel(event.arguments[0].toString());
          currentChannel = [];
          currentChannel.addAll(c);
          debugPrint(currentChannel.toString());
          return;
        }
        debugPrint("args:" + event.arguments.toString());
        var c = int.parse(event.arguments[0].toString().split(" ")[0]);
        currentResponse[c] = [];

      }
      //TODO: only do this in special commands, secondary user

        if (event.address.startsWith('/eos/out/active/wheel/')) {
          addResponseToCache(event);
        String parameterName = event.arguments[0].toString().split(" ")[0] + " " + event.arguments[0].toString().split(" ")[1];
        parameterName = parameterName.replaceAll(" ", "");
        var key = ParameterType.getTypeByName(parameterName);
        if(key == null) {
          return;
        }
        if(!parameters.containsKey(key)) {
          parameters[key] = [];
        }
        if(key == ParameterType.intens) {
          debugPrint("key is intens");
          parameters[ParameterType.intens] = [0, double.parse(event.arguments[0].toString().split(" ").last.replaceAll("[", "").replaceAll("]", ""))];
          return;
        }
        if(key == ParameterType.pan || key == ParameterType.tilt) {
            parameters[key] = [1, (key == ParameterType.tilt ? -1 : 1) *  double.parse(event.arguments[0].toString().split(" ").last.replaceAll("[", "").replaceAll("]", ""))];
          return;
        }
        if(key == ParameterType.colorTemperature) {
          var temp = double.parse(event.arguments[0].toString().split(" ").last.replaceAll("[", "").replaceAll("]", ""));
          parameters[key] = [0, temp];
          return;
        }
        if(key.isColorWheel()) {
          parameters[key] = double.parse(event.arguments[0].toString().split(" ").last.replaceAll("[", "").replaceAll("]", ""));

          return;
        }
        parameters[ParameterType.getTypeByName(parameterName)]
            .addAll(event.arguments.skip(1));
      }
       else if (event.address.startsWith('/eos/out/color/hs') &&
          event.arguments.length == 2){
        double hue = double.parse(event.arguments[0].toString());
        double saturation = double.parse(event.arguments[1].toString()) / 255;
        setHueSaturation!(hue, saturation);
        addResponseToCache(event);
      } else if (event.address.startsWith('/eos/out/active/cue/text')) {
        String text = event.arguments[0].toString();
        if (text.length > 1) {
          setCurrentCueText!(text);
        } else {
          setCurrentCueText!('');
        }
      } else if (event.address.startsWith('/eos/out/active/cue/')) {
        List<String> address = event.address.split('/');
        setCurrentCue!(double.parse(address.last));
        setCurrentCueList!(int.parse(address[address.length - 2]));
      } else if (event.address.startsWith('/eos/out/pending/cue/text')) {
        String text = event.arguments[0].toString();
        if (text.length > 1) {
          setPreviousCueText!(text);
        } else {
          setPreviousCueText!('');
        }
      } else if (event.address.startsWith('/eos/out/pending/cue/')) {
        List<String> address = event.address.split('/');
        try {
          setPreviousCue!(double.parse(address.last));
        } catch (e) {
          setPreviousCue!(0);
        }
      }else if(event.address.startsWith("/eos/out/fader")) {
       var components = event.address.split("/");
       debugPrint(components.toString());
       if(components[4] == "range") {
          var faderPage = int.parse(components[5]);
          var faderIndex = int.parse(components[6]);
          var faderRange = int.parse(event.arguments[1].toString());
          faderControlsState!.updateFader(faderIndex, 0, "", faderRange);
       }else if(components.length == 7){
         if(components[6] == "name") {
           var faderPage = int.parse(components[4]);
           var faderIndex = int.parse(components[5]);
           if(event.arguments.toString() == "[]") {
             debugPrint("Empty arguments");
             faderControlsState!.updateFader(faderIndex, 0, "", 0, forceUpdate: true);
           }else {
             faderControlsState!.updateFader(faderIndex, 0, event.arguments.join(" "), 0);
           }
         }

    }
      }else if(event.address.startsWith("/eos/fader/")) {
        var components = event.address.split("/");
        var faderPage = int.parse(components[3]);
        var faderIndex = int.parse(components[4]);
        faderControlsState!.updateFader(faderIndex, double.parse(event.arguments[0].toString()), "", 0);
      }

       else if(event.address.startsWith("/eos/out/pantilt")) {
         if(getControlWidgetForType(ParameterType.pan) == null) return;
        PanTiltControlState state = getControlWidgetForType(ParameterType.pan)! as PanTiltControlState;
        var args = event.arguments;
        if(args.length == 6) {
          state.updateValues(double.parse(args[0].toString()),
              double.parse(args[1].toString()), double.parse(args[2].toString()), double.parse(args[3].toString()));
        }
         addResponseToCache(event);
      }

      setCurrentChannel!(parameters);
    });
    FreeRFR.sheet?.update();
    currentChannel = [];
  }

  void addResponseToCache(OSCMessage event) {
    if(currentResponse.keys.isNotEmpty && FreeRFR.sheet != null) {
      if(currentChannel.isNotEmpty) {
        for(var c in currentChannel) {
          currentResponse[c]!.removeWhere((e) => e.startsWith(event.address));
          currentResponse[c]!.add("${event.address}:${event.arguments}");
          debugPrint("---> ${event.address}:${event.arguments}");
          Channel? channel = FreeRFR.sheet?.channels.where((e) => e.number == c).first;
          debugPrint("current Channel: " + channel.toString());
          var response = getColorFromResponse(currentResponse[c]!, isUpdate: true);

          var color = _getColorFromList(response, c);
          debugPrint("response: $response -> color: $color");
          channel?.color = color;
          FreeRFR.sheet?.update();
        }
      }else {
        currentResponse[currentResponse.keys.last]!.add("${event.address}:${event.arguments}");
      }
    }
  }

  List<int> getChannelsFromCurrentChannel(String arg0) {
    List<int> channels = [];


    for(var e in arg0.split(",")) {
      debugPrint("e: $e");
      e = e.contains("  ") ? e.split("  ")[0] : e;
      if(e.contains("-")) {
        var split = e.split("-");
        var start = int.parse(split[0]);
        var end = int.parse(split[1].split("  ")[0]);
        channels.addAll(List.generate(end-start+1, (index) => start+index));
      }
      else {

        channels.add(int.parse(e));
      }
    }
   if(arg0.contains("-") && !arg0.contains(",")) {
     var split = arg0.split("-");
     var start = int.parse(split[0]);
     var spl1 = split[1];
     spl1 = spl1.contains("  ") ? spl1.split("  ")[0] : spl1;
     var end = int.parse(spl1);
     channels.addAll(List.generate(end - start + 1, (index) => start + index));
     return channels;
   }

    if(!arg0.contains(",") && !arg0.contains("-")) {
      var spl0 = arg0.contains("  ") ? arg0.split("  ")[0] : arg0;
      return [int.parse(spl0)];
    }
    return channels;
  }

  double currentValue = 0;
  double currentTemperature = 0;
  double latestHue = 0;
  double latestSaturation = 0;

  Future<void> getColorsForEveryChannel(int maxChannel) async{
    this.maxChannel = maxChannel;
    this.isCheckingColors = true;
    for(var i = 1; i<=maxChannel+1; i++) {
      sendNumber(i);
      sendKey("enter", sleepMillis: 155);
    }
    await compl.future;
    for(var i = 1; i<=maxChannel; i++) {
      var list = getColorFromResponse(currentResponse[i]!);
      var c = _getColorFromList(list, i);
      debugPrint("color for channel $i: $c");
      var channel = Channel()..number = i..color = c;
      channel.color = channel.constructColor();
      FreeRFR.sheet!.channels.add(channel);

        //..hue = latestHue..saturation = latestSaturation..value = currentValue/100..temperature = currentTemperature);
    }
    this.isCheckingColors = false;
    FreeRFR.sheet!.channels.map((e) => debugPrint(e.toString()));
  }

  Color _getColorFromList(List<double?> list, int channel) {
    var hue = list[0];
    var saturation = list[1];
    var currentValue = list[2] ?? 0;
    var currentTemperature = list[3] ?? 0;
    debugPrint("hue: $hue, saturation: $saturation, value: $currentValue, temperature: $currentTemperature, color here: ${HSVColor.fromAHSV(1, hue??0, saturation??0, currentValue/100).toColor()}");
    if(hue == null || saturation == null) {
      var c = FreeRFR.sheet!.channels.firstWhere((element) => element.number == channel-1).color;
      var hsv = HSVColor.fromColor(c!);
      debugPrint("value: $currentValue");
      if(currentValue == 0) {
        return Colors.black;
      }
      var construct = HSVColor.fromAHSV(1, hsv.hue, hsv.saturation, currentValue/100).toColor();
      if(currentTemperature == 0) {
        return construct;
      }
      return construct.kelvinToRGB(currentTemperature*1.5);
    }

    //hue and saturation are vertically mirrored:
    debugPrint("value: $currentValue");
    //if(currentTemperature == 0) {
      return HSVColor.fromAHSV(1, hue, saturation, currentValue/100).toColor();
    //}
    //return HSVColor.fromAHSV(1, hue, saturation, currentValue/100).toColor().kelvinToRGB(currentTemperature*1.5);

  }

  List<double?> getColorFromResponse(List<String> responses, {bool isUpdate = false}) {
    double? hue;
    double? saturation;
    int channel = currentResponse.keys.where((e) => currentResponse[e]==responses).first;
    if(isUpdate) {
      var hsv = HSVColor.fromColor(FreeRFR.sheet!.channels.firstWhere((element) => element.number == channel).color!);
      hue = hsv.hue;
      saturation = hsv.saturation;
      currentValue = hsv.value;
    }
    currentTemperature = 0;
    for(var response in responses) {
      if(response.startsWith("/eos/out/color/hs")) {
        response = response.split(":")[1];
        var args = response.split(" ");
        if(args.length == 2) {
          hue = double.parse(args[0].replaceAll("[", "").replaceAll("]", "").replaceAll(",", ""));
          saturation = double.parse(args[1].replaceAll("[", "").replaceAll("]", ""))/100;
        }else {
          if(!isUpdate) {
            hue = 0;
            saturation = 0;
          }
        }
        latestHue = hue!;
        latestSaturation = saturation!;
      }
      if(response.startsWith("/eos/out/active/wheel/")) {
        var arguments = response.split(":")[1].split(",");
        String parameterName = "${arguments[0].toString().split(" ")[0]} ${arguments[0].toString().split(" ")[1]}";
        parameterName = parameterName.replaceAll("[", "").replaceAll(" ", "");
        var key = ParameterType.getTypeByName(parameterName);
        if(key == null) {
          continue;
        }
        if(key == ParameterType.intens) {
          var d = arguments[0].toString().split("  ")[1].replaceAll("[", "").replaceAll("]", "");
          currentValue = double.parse(d);
        }
        if(key == ParameterType.colorTemperature) {
          var d = arguments[0].toString().split("  ")[1].replaceAll("[", "").replaceAll("]", "");
          currentTemperature = double.parse(d);
        }

      }
    }
    debugPrint("channel: $channel ---> hue: $hue, saturation: $saturation, value: $currentValue");

    return [hue, saturation, currentValue, currentTemperature];
  }

  bool isChannelSelected(num channelNumber) {
   return currentChannel.contains(channelNumber);
  }

 void setupFaderBank(int count, FaderControlsState state) {
    OSCMessage message = OSCMessage('/eos/fader/1/config/10', arguments: []);
    client.send(message);
    debugPrint('Sent: $message, configuration done!');
    faderControlsState = state;
    _updateEosOutput();
 }

  void sendCmd(String cmd) {
    OSCMessage message = OSCMessage('/eos/cmd/="$cmd"', arguments: []);
    client.send(message);
    sleep100();
  }

  void send(String cmd, List<Object> list) {
    OSCMessage message = OSCMessage(cmd, arguments: list);
    client.send(message);
    debugPrint('Sent: $message');
  }

  void sendNumber(int num) {
    for (var digit in num.toString().split("")) {

        sendKey("$digit", sleepMillis: 0, withUpdate: false);
        continue;


  }
  }

  void setParameter(String attributeName, double parameterValue) {
    OSCMessage message =
        OSCMessage('/eos/cmd', arguments: ['$attributeName $parameterValue#']);
    client.send(message);
  }

  void setLabel(double cueNumber, String label) {
    if (label == '') {
      return;
    }
    OSCMessage message =
        OSCMessage('/eos/newcmd', arguments: ['Cue $cueNumber Label $label#']);
    client.send(message);
    sendLive();
  }
  Future<String> getCmdLine() async {
    OSCMessage message = OSCMessage('/eos/get/cmd', arguments: []);
    var i = await client.send(message);
    debugPrint(i.toString());
    _updateEosOutput();
    return "";
  }

  // void setCommandLine(void Function(String) setCommandLine) {
  //   String reply = '';
  //   OSCMessage message = OSCMessage('/eos/out/cmd', arguments: []);
  //   client.send(message);
  //   OSCSocket socket = OSCSocket(serverPort: 8001);
  //   socket.listen((msg) {
  //     reply = msg.toString();
  //   });
  //   debugPrint('Received: $reply');
  //   setCommandLine(reply);
  // }

  String getShowName() {
    OSCMessage message = OSCMessage('/eos/out/show/name', arguments: []);
    client.send(message);
    String reply = '';
    client.listen((msg) {
      reply = msg.toString();
      return;
    });
    return reply;
  }

  void close() {
    _setUDPTXIPDefault();
    client.close();
  }

  Future<List<String>> getCues() async {
    // Get number of cues.
    OSCSocket listenSocket;
    OSCMessage message;
    List<String> cues = [];
    client.send(OSCMessage('/eos/get/cue/1/count', arguments: []));
    sleep100();
    listenSocket = OSCSocket(serverPort: clientPort);
    await listenSocket.listen((msg) async {
      if (msg.address == '/eos/out/get/cue/1/count') {
        for (int i = 0; i < int.parse(msg.arguments[0].toString()); i++) {
          message = OSCMessage('/eos/get/cue/0/index/$i', arguments: []);
          await client.send(message);
          OSCSocket listenSocket = OSCSocket(serverPort: clientPort);
          sleep(const Duration(milliseconds: 25));
          await listenSocket.listen((msg) {
            debugPrint(msg.address);
            if (msg.address == '/eos/out/get/cue/0/0') {
              debugPrint(msg.arguments.toString());
              cues.add(msg.arguments.toString());
            }
          });
          listenSocket.close();
        }
      }
    });
    debugPrint(cues.toString());
    return cues;
  }

  void sleep250() {
    sleep(const Duration(milliseconds: 250));
  }

  void updatePanTilt(double pan, double tilt) {
    OSCMessage message = OSCMessage('/eos/param/pan/tilt', arguments: [pan, tilt]);
    client.send(message);
  }

  int getCurrentCueIndex() {
    OSCMessage message = OSCMessage('/eos/out/active/cue/', arguments: []);
    client.send(message);
    int reply = -1;
    OSCSocket listenSocket = OSCSocket(serverPort: clientPort);
    listenSocket.listen((msg) {
      debugPrint('Index: ${msg.arguments[0].toString()}');
      if (msg.address == '/eos/out/active/cue/text') {
        reply = int.parse(msg.arguments[0].toString());
        return;
      }
    });
    listenSocket.close();
    return reply;
  }

  void sendColor(double red, double green, double blue) {
    OSCMessage message =
        OSCMessage('/eos/color/rgb', arguments: [red, green, blue]);
    client.send(message);
  }

  Future<List<Fader>> getFader(int faderPage) {
    OSCSocket listenSocket = OSCSocket(serverPort: clientPort);
    List<Fader> faders = [];
    listenSocket.listen((msg) {
      if (msg.address.contains('/eos/out/fader/$faderPage')) {
        var message = msg.address.split('/');
        var index = int.parse(message[4]);
          faders.add(Fader(msg.arguments.join(" "), index, faderPage, 0));
      }
    });
    listenSocket.close();
    return Future.value(faders);
  }
}

bool isPrivateIPAddress(String string) {
  return string.startsWith('10.') ||
      string.startsWith('172.') ||
      string.startsWith('192.168.') ||
      string.startsWith('127.');
}