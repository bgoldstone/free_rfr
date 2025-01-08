import 'package:flutter/material.dart';

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
  static ParameterType magenta = ParameterType("Magenta");
  static ParameterType yellow = ParameterType("Yellow");
  static ParameterType hue = ParameterType("Hue");
  static ParameterType saturation = ParameterType("Saturation");
  static ParameterType colorTemperature = ParameterType("ColorTemperature");
  static ParameterType shutterStrobe = ParameterType("ShutterStrobe");
  static ParameterType pan = ParameterType("Pan");
  static ParameterType tilt = ParameterType("Tilt");
  static ParameterType xFocus = ParameterType("X Focus");
  static ParameterType yFocus = ParameterType("Y Focus");
  static ParameterType zFocus = ParameterType("Z Focus");
  static ParameterType positionMSpeed = ParameterType("Position MSpeed");
  static ParameterType positionMSpeedMode =
      ParameterType("Position MSpeed Mode");
  static ParameterType positionBlink = ParameterType("PositionBlink");
  static ParameterType ctc = ParameterType("CTC");
  static ParameterType cto = ParameterType("CTO");
  static ParameterType colorMix = ParameterType("ColorMix");
  static ParameterType colorMixMSpeed = ParameterType("ColorMixMSpeed");
  static ParameterType zoom = ParameterType("Zoom");
  static ParameterType colorSelect = ParameterType("Color Select");
  static ParameterType colorMSpeed = ParameterType("Color MSpeed");
  static ParameterType colorMSpeedMode = ParameterType("Color MSpeed Mode");
  static ParameterType goboIndSpd = ParameterType("Gobo Ind/Spd");
  static ParameterType goboSelect = ParameterType("Gobo Select");
  static ParameterType goboIndSpd2 = ParameterType("Gobo Ind/Spd 2");
  static ParameterType goboSelect2 = ParameterType("Gobo Select 2");
  //ADD BELOW
  static ParameterType goboIndSpd3 = ParameterType("Gobo Ind/Spd 3");
  static ParameterType goboSelect3 = ParameterType("Gobo Select 3");
  static ParameterType goboWheelSelectMSpeed =
      ParameterType("Gobo Wheel Select MSpeed");
  static ParameterType goboWheelSelectMSpeedMode =
      ParameterType("Gobo Wheel Select MSpeed Mode");
  static ParameterType iris = ParameterType("Iris");
  static ParameterType edge = ParameterType("Edge");
  static ParameterType formMSpeed = ParameterType("Form MSpeed");
  static ParameterType formMSpeedMode = ParameterType("Form MSpeed Mode");

  static List<ParameterType> values = [
    intens,
    red,
    redOrange,
    amber,
    green,
    blue,
    indigo,
    cyan,
    magenta,
    yellow,
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
    positionMSpeedMode,
    positionBlink,
    ctc,
    colorMix,
    colorMixMSpeed,
    zoom,
    colorSelect,
    cto,
    colorMSpeed,
    colorMSpeedMode,
    goboIndSpd,
    goboSelect,
    goboIndSpd2,
    goboSelect2,
    goboIndSpd3,
    goboSelect3,
    goboWheelSelectMSpeed,
    goboWheelSelectMSpeedMode,
    iris,
    edge,
    formMSpeed,
    formMSpeedMode
  ];

  ParameterType(this.name);

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

typedef ParameterMap = Map<ParameterType, dynamic>;

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
}
