import 'package:flutter/material.dart';

class ParameterType {
  String oscName;
  ParameterRole role;
  double minValue;
  double maxValue;
  ParameterType(this.oscName, this.role,
      {this.minValue = 0, this.maxValue = 100});

  static ParameterType intens = ParameterType("Intens", ParameterRole.intens);
  static ParameterType pan = ParameterType("Pan", ParameterRole.panTilt);
  static ParameterType tilt = ParameterType("Tilt", ParameterRole.panTilt);
  static ParameterType maxPan = ParameterType("Max Pan", ParameterRole.panTilt);
  static ParameterType maxTilt =
      ParameterType("Max Tilt", ParameterRole.panTilt);
  static ParameterType minPan = ParameterType("Min Pan", ParameterRole.panTilt);
  static ParameterType minTilt =
      ParameterType("Min Tilt", ParameterRole.panTilt);

  static List<ParameterType> staticParamTypes = [
    intens,
    pan,
    tilt,
    maxPan,
    maxTilt,
    minPan,
    minTilt
  ];

  String getEosName() {
    return oscName.replaceAll(" ", "_");
  }

  @override
  String toString() {
    return oscName;
  }
}

typedef ParameterMap = Map<ParameterType, List<double>?>;

class ParameterRole {
  int index;
  String name;

  ParameterRole(this.index, this.name);

  static ParameterRole undef = ParameterRole(0, "Other");
  static ParameterRole intens = ParameterRole(1, "Intensity");
  static ParameterRole focus = ParameterRole(2, "Focus");
  static ParameterRole color = ParameterRole(3, "Color");
  static ParameterRole image = ParameterRole(4, "Image");
  static ParameterRole form = ParameterRole(5, "Form");
  static ParameterRole shutter = ParameterRole(6, "Shutter");
  static ParameterRole panTilt = ParameterRole(7, "panTilt");

  static ParameterRole getTypeById(int id) {
    if (_parameterRoleById.containsKey(id)) {
      return _parameterRoleById[id]!;
    }
    return undef;
  }

  static final Map<int, ParameterRole> _parameterRoleById = {
    1: intens,
    2: focus,
    3: color,
    4: image,
    5: form,
    6: shutter,
    7: panTilt
  };
}

abstract class ControlWidget<T extends StatefulWidget> extends State<T> {
  List<ParameterType> controllingParameters;
  ControlWidget({required this.controllingParameters});
}

/// Filters a ParameterMap by ParameterRole.
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

List<ParameterType> getParameterForType(
    ParameterMap parameters, ParameterRole type) {
  List<ParameterType> controls = [];
  parameters.forEach((parameter, _) {
    if (parameter.role == type) {
      controls.add(parameter);
    }
  });
  return controls;
}
