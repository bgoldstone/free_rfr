// ignore: constant_identifier_names
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:free_rfr/extensions/Extensions.dart';

class ParameterType {

  String name;

  static ParameterType intens = ParameterType("Intens");
  static ParameterType red = ParameterType("Red");
  static ParameterType redOrange = ParameterType("RedOrange");
  static ParameterType amber = ParameterType("Amber");
  static ParameterType green = ParameterType("Green");
  static ParameterType blue = ParameterType("Blue");
  static ParameterType indigo = ParameterType("Indigo");
  static ParameterType cyan = ParameterType("Cyan");
  static ParameterType hue = ParameterType("Hue");
  static ParameterType saturation = ParameterType("Saturation");
  static ParameterType colorTemperature = ParameterType("ColorTemperature");
  static ParameterType shutterStrobe = ParameterType("ShutterStrobe");
  static ParameterType pan = ParameterType("Pan");
  static ParameterType tilt = ParameterType("Tilt");
  static ParameterType xFocus = ParameterType("X Focus");
  static ParameterType yFocus = ParameterType("Y Focus");
  static ParameterType zFocus = ParameterType("Z Focus");
  static ParameterType positionMSpeed = ParameterType("PositionMSpeed");
  static ParameterType positionBlink = ParameterType("PositionBlink");
  static ParameterType ctc = ParameterType("CTC");
  static ParameterType colorMix = ParameterType("ColorMix");
  static ParameterType colorMixMSpeed = ParameterType("ColorMixMSpeed");
  static ParameterType zoom = ParameterType("Zoom");

  static List<ParameterType> values = [
    intens,
    red,
    redOrange,
    amber,
    green,
    blue,
    indigo,
    cyan,
    hue,
    saturation,
    colorTemperature,
    shutterStrobe,
    pan,
    tilt,
    xFocus,
    yFocus,
    zFocus,
    positionMSpeed,
    positionBlink,
    ctc,
    colorMix,
    colorMixMSpeed,
    zoom,
  ];


  ParameterType(this.name);

  bool isColorWheel() {
    return this == red || this == redOrange || this == amber || this == green || this == blue || this == indigo || this == cyan;
  }

  static ParameterType? getTypeByName(String name) {
    for (var type in ParameterType.values) {
      if (type.name.toLowerCase() == name.toLowerCase()) {
        return type;
      }
    }
    return null;
  }

  @override
  String toString() {
    return name;
  }
}

typedef ParameterMap = Map<ParameterType, List<dynamic>>;

class ParameterRole {
  int index;

  ParameterRole(this.index);

  static ParameterRole intens = ParameterRole(0);
static ParameterRole focus = ParameterRole(1);
static ParameterRole color = ParameterRole(2);
static ParameterRole form = ParameterRole(3);
static ParameterRole image = ParameterRole(4);
static ParameterRole shutter = ParameterRole(5);
}

abstract class ControlWidget<T extends StatefulWidget> extends State<T> {
  List<ParameterType> controllingParameters;
  ControlWidget({required this.controllingParameters});

  void updateCurrentChannel(ParameterMap map) ;
}
class Channel {
  int? number;
  double? hue;
  double? saturation;
  double? value;
  Color? color;
  double? temperature;
  String? name;

  Channel();

  bool hasColorInfo() {
    return hue != null && saturation != null && value != null;
  }

  Color constructColor() {
    if(!hasColorInfo()) {
      return color ?? Colors.black;
    }
    var c = HSVColor.fromAHSV(1, hue!, saturation!, value!).toColor();
    if(temperature != null ) {
      if(temperature != 0) {
        c = c.kelvinToRGB(temperature!);
      }
    }

    return c;
  }

  @override
  String toString() {
    return 'Channel{number: $number, hue: $hue, saturation: $saturation, value: $value}';
  }
}