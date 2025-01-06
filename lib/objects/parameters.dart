// ignore: constant_identifier_names
import 'package:flutter/cupertino.dart';

class ParameterType {
  String name;

  static List<ParameterType> values = [
    ParameterType("Intens"),
    ParameterType("Red"),
    ParameterType("RedOrange"),
    ParameterType("Amber"),
    ParameterType("Green"),
    ParameterType("Blue"),
    ParameterType("Indigo"),
    ParameterType("Cyan"),
    ParameterType("Hue"),
    ParameterType("Saturation"),
    ParameterType("ColorTemperature"),
    ParameterType("ShutterStrobe"),
    ParameterType("Pan"),
    ParameterType("Tilt"),
    ParameterType("X Focus"),
    ParameterType("Y Focus"),
    ParameterType("Z Focus"),
    ParameterType("PositionMSpeed"),
    ParameterType("PositionBlink"),
    ParameterType("CTC"),
    ParameterType("ColorMix"),
    ParameterType("ColorMixMSpeed"),
    ParameterType("Zoom"),
  ];

  ParameterType(this.name);

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
