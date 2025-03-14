import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:osc/osc.dart';

extension NumDurationExtensions on num {
  Duration get microseconds => Duration(microseconds: round());
  Duration get ms => (this * 1000).microseconds;
  Duration get milliseconds => (this * 1000).microseconds;
  Duration get seconds => (this * 1000 * 1000).microseconds;
  Duration get minutes => (this * 1000 * 1000 * 60).microseconds;
  Duration get hours => (this * 1000 * 1000 * 60 * 60).microseconds;
  Duration get days => (this * 1000 * 1000 * 60 * 60 * 24).microseconds;
}

extension GetMaterialColor on Color {
  MaterialColor get materialColor {
    return MaterialColor(value, {
      50: withAlpha(0x1A),
      100: withAlpha(0x33),
      200: withAlpha(0x4D),
      300: withAlpha(0x66),
      400: withAlpha(0x80),
      500: withAlpha(0x99),
      600: withAlpha(0xB3),
      700: withAlpha(0xCC),
      800: withAlpha(0xE6),
      900: withAlpha(0xFF),
    });
  }
}

extension ColorTemperature on Color {
  // < 6500 warmer
  // > 6500 colder
  Color kelvinToRGB(double kelvin) {
    double temperature = kelvin / 100;

    double red, green, blue;

    // Calculate red
    if (temperature <= 66) {
      red = 255;
    } else {
      red = 329.698727446 * pow((temperature - 60),-0.1332047592);
      red = red.clamp(0, 255);
    }

    // Calculate green
    if (temperature <= 66) {
      green = 99.4708025861 * log(temperature) - 161.1195681661;
    } else {
      green = 288.1221695283 * pow((temperature - 60),-0.0755148492);
    }
    green = green.clamp(0, 255);

    // Calculate blue
    if (temperature >= 66) {
      blue = 255;
    } else if (temperature <= 19) {
      blue = 0;
    } else {
      blue = 138.5177312231 * log(temperature - 10) - 305.0447927307;
      blue = blue.clamp(0, 255);
    }

    return Color.fromARGB(255, red.round(), green.round(), blue.round());
  }

  //blend with other color function
 Color blend(Color other) {
   int r = (this.red + other.red).clamp(0, 255);
   int g = (this.green + other.green).clamp(0, 255);
   int b = (this.blue + other.blue).clamp(0, 255);
   return Color.fromARGB(255, r, g, b);
  }

  //this kelvin to temperature should foxus on the following parameters:
//6600k = normal white
//2700k = slightly warm white

}