import 'package:flutter_test/flutter_test.dart';
import 'package:free_rfr/objects/parameters.dart';

void main() {
  test('Test Static Parameter Types', () {
    expect(ParameterType.intens.role, ParameterRole.intens);
    expect(ParameterType.pan.role, ParameterRole.panTilt);
    expect(ParameterType.tilt.role, ParameterRole.panTilt);
    expect(ParameterType.maxPan.role, ParameterRole.panTilt);
    expect(ParameterType.maxTilt.role, ParameterRole.panTilt);
    expect(ParameterType.minPan.role, ParameterRole.panTilt);
    expect(ParameterType.minTilt.role, ParameterRole.panTilt);
    expect(ParameterType.staticParamTypes.length, 7);
  });

  test("Test Parameter Roles", () {
    expect(ParameterRole.undef.name, 'Other');
    expect(ParameterRole.intens.name, 'Intensity');
    expect(ParameterRole.panTilt.name, 'panTilt');
    expect(ParameterRole.focus.name, 'Focus');
    expect(ParameterRole.color.name, 'Color');
    expect(ParameterRole.image.name, 'Image');
    expect(ParameterRole.form.name, 'Form');
    expect(ParameterRole.shutter.name, 'Shutter');
    expect(ParameterRole.getTypeById(0), ParameterRole.undef);
    expect(ParameterRole.getTypeById(1), ParameterRole.intens);
    expect(ParameterRole.getTypeById(2), ParameterRole.focus);
    expect(ParameterRole.getTypeById(3), ParameterRole.color);
    expect(ParameterRole.getTypeById(4), ParameterRole.image);
    expect(ParameterRole.getTypeById(5), ParameterRole.form);
    expect(ParameterRole.getTypeById(6), ParameterRole.shutter);
    expect(ParameterRole.getTypeById(7), ParameterRole.panTilt);
    expect(ParameterRole.getTypeById(999), ParameterRole.undef);
  });

  test('Filter By Parameters Type', () {
    Map<ParameterType, List<double>?> paramMap = {
      ParameterType.intens: [0.0, 100.0],
      ParameterType.pan: [0.0, 540.0],
      ParameterType.tilt: [0.0, 270.0],
    };
    expect(filterByParameterType(paramMap, ParameterRole.panTilt).length, 2);
    expect(filterByParameterType(paramMap, ParameterRole.intens).length, 1);
    expect(getParameterForType(paramMap, ParameterRole.intens).length, 1);
    expect(getParameterForType(paramMap, ParameterRole.panTilt).length, 2);
  });
}
