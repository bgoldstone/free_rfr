import 'package:flutter/material.dart';

class ParameterType {
  String name;
  ParameterRole role;
  double minValue = 0;
  double maxValue = 100;
  ParameterType(this.name, this.role, {minValue, maxValue});

  static ParameterType intens = ParameterType("Intens", ParameterRole.intens);
  static ParameterType red = ParameterType("Red", ParameterRole.color);
  static ParameterType redOrange =
      ParameterType("Red Orange", ParameterRole.color);
  static ParameterType amber = ParameterType("Amber", ParameterRole.color);
  static ParameterType green = ParameterType("Green", ParameterRole.color);
  static ParameterType blue = ParameterType("Blue", ParameterRole.color);
  static ParameterType indigo = ParameterType("Indigo", ParameterRole.color);
  static ParameterType cyan = ParameterType("Cyan", ParameterRole.color);
  static ParameterType magenta = ParameterType("Magenta", ParameterRole.color);
  static ParameterType yellow = ParameterType("Yellow", ParameterRole.color);
  static ParameterType hue = ParameterType("Hue", ParameterRole.color);
  static ParameterType saturation =
      ParameterType("Saturation", ParameterRole.color);
  static ParameterType colorTemperature =
      ParameterType("Color Temperature", ParameterRole.color);
  static ParameterType shutterStrobe =
      ParameterType("Shutter Strobe", ParameterRole.form);
  static ParameterType pan = ParameterType("Pan", ParameterRole.panTilt);
  static ParameterType tilt = ParameterType("Tilt", ParameterRole.panTilt);
  // static ParameterType xFocus = ParameterType("X Focus", ParameterRole.focus);
  // static ParameterType yFocus = ParameterType("Y Focus", ParameterRole.focus);
  // static ParameterType zFocus = ParameterType("Z Focus", ParameterRole.focus);
  static ParameterType positionMSpeed = ParameterType(
      "Position MSpeed", ParameterRole.focus,
      minValue: 0, maxValue: 255);
  static ParameterType positionMSpeedMode =
      ParameterType("Position MSpeed Mode", ParameterRole.focus);
  static ParameterType positionBlink =
      ParameterType("Position Blink", ParameterRole.focus);
  static ParameterType ctc = ParameterType("CTC", ParameterRole.color);
  static ParameterType cto = ParameterType("CTO", ParameterRole.color);
  static ParameterType colorMix =
      ParameterType("Color Mix", ParameterRole.color);
  static ParameterType colorMixMSpeed =
      ParameterType("ColorMixMSpeed", ParameterRole.color);
  static ParameterType zoom = ParameterType("Zoom", ParameterRole.form);
  static ParameterType colorSelect =
      ParameterType("Color Select", ParameterRole.color);
  static ParameterType colorMSpeed =
      ParameterType("Color MSpeed", ParameterRole.color);
  static ParameterType colorMSpeedMode =
      ParameterType("Color MSpeed Mode", ParameterRole.color);
  static ParameterType goboIndSpd =
      ParameterType("Gobo Ind/Spd", ParameterRole.image);
  static ParameterType goboSelect =
      ParameterType("Gobo Select", ParameterRole.image);
  static ParameterType goboIndSpd2 =
      ParameterType("Gobo Ind/Spd 2", ParameterRole.image);
  static ParameterType goboSelect2 =
      ParameterType("Gobo Select 2", ParameterRole.image);
  static ParameterType goboIndSpd3 =
      ParameterType("Gobo Ind/Spd 3", ParameterRole.image);
  static ParameterType goboSelect3 =
      ParameterType("Gobo Select 3", ParameterRole.image);
  static ParameterType goboWheelSelectMSpeed =
      ParameterType("Gobo Wheel Select MSpeed", ParameterRole.image);
  static ParameterType goboWheelSelectMSpeedMode =
      ParameterType("Gobo Wheel Select MSpeed Mode", ParameterRole.image);
  static ParameterType iris = ParameterType("Iris", ParameterRole.form);
  static ParameterType edge = ParameterType("Edge", ParameterRole.form);
  static ParameterType formMSpeed =
      ParameterType("Form MSpeed", ParameterRole.form);
  static ParameterType formMSpeedMode =
      ParameterType("Form MSpeed Mode", ParameterRole.form);
  static ParameterType goboWheel =
      ParameterType("Gobo Wheel", ParameterRole.image);
  static ParameterType maxPan = ParameterType("Max Pan", ParameterRole.panTilt);
  static ParameterType maxTilt =
      ParameterType("Max Tilt", ParameterRole.panTilt);
  static ParameterType minPan = ParameterType("Min Pan", ParameterRole.panTilt);
  static ParameterType minTilt =
      ParameterType("Min Tilt", ParameterRole.panTilt);

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
    // xFocus,
    // yFocus,
    // zFocus,
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
    formMSpeedMode,
    goboWheel,
  ];

  static ParameterType? getTypeByName(String name) {
    for (var type in ParameterType.values) {
      if (type.name.toLowerCase().replaceAll(" ", "") == name.toLowerCase()) {
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

typedef ParameterMap = Map<ParameterType, List<double>?>;

class ParameterRole {
  int index;

  ParameterRole(this.index);

  static ParameterRole intens = ParameterRole(1);
  static ParameterRole focus = ParameterRole(2);
  static ParameterRole color = ParameterRole(3);
  static ParameterRole image = ParameterRole(4);
  static ParameterRole form = ParameterRole(5);
  static ParameterRole shutter = ParameterRole(6);
  static ParameterRole panTilt = ParameterRole(7);
}

abstract class ControlWidget<T extends StatefulWidget> extends State<T> {
  List<ParameterType> controllingParameters;
  ControlWidget({required this.controllingParameters});
}

/**
 * Filters a ParameterMap by ParameterRole.
 */
ParameterMap filterByParameterType(ParameterMap map, ParameterRole role) {
  ParameterMap result = {};
  for (var parameterType in map.keys) {
    ParameterRole parameterRole = parameterType.role;
    if (parameterRole == role) {
      result[parameterType] = map[parameterType];
    }
  }
  return result;
}
