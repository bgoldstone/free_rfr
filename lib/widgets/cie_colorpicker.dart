import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class CieXyColorPicker extends StatelessWidget {
  final Color currentColor;
  final ValueChanged<HSVColor> onColorChanged;

  const CieXyColorPicker(
      {Key? key, required this.currentColor, required this.onColorChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 200,
          height: 200,
          child:
              ColorPickerArea(HSVColor.fromColor(currentColor), onColorChanged),
        ),
        Column(children: <Widget>[
          Row(
            children: <Widget>[
              const SizedBox(width: 20.0),
              Column(
                children: <Widget>[
                  SizedBox(
                      height: 40.0,
                      width: 260.0,
                      child: ColorPickerSlider(TrackType.value,
                          HSVColor.fromColor(currentColor), onColorChanged)),
                  /*
                  SizedBox(
                      height: 40.0,
                      width: 260.0,
                      child: ColorPickerSlider(TrackType.alpha,
                          HSVColor.fromColor(currentColor), onColorChanged)),

                   */
                ],
              ),
              const SizedBox(width: 10.0),
            ],
          ),
        ])
      ],
    );
  }
}

class RectPainter extends CustomPainter {
  RectPainter({required this.hsvColor, this.pointerColor});

  HSVColor hsvColor;
  final Color? pointerColor;

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Offset.zero & size;
    //center is not actual center (it is offcentered), since HSV(0,0,0) is not white, it is indeed white 3100k
    Offset center = Offset(size.width / 1.6, size.height / 3);
    double radio = size.width <= size.height ? size.width / 2 : size.height / 2;

    final List<Color> colors = [
      const HSVColor.fromAHSV(1.0, 360.0, 1.0, 1.0).toColor(),
      const HSVColor.fromAHSV(1.0, 300.0, 1.0, 1.0).toColor(),
      const HSVColor.fromAHSV(1.0, 240.0, 1.0, 1.0).toColor(),
      const HSVColor.fromAHSV(1.0, 180.0, 1.0, 1.0).toColor(),
      const HSVColor.fromAHSV(1.0, 120.0, 1.0, 1.0).toColor(),
      const HSVColor.fromAHSV(1.0, 60.0, 1.0, 1.0).toColor(),
      const HSVColor.fromAHSV(1.0, 0.0, 1.0, 1.0).toColor(),
    ];
    final Gradient gradientS = SweepGradient(colors: colors);
    const Gradient gradientR = RadialGradient(
      colors: [
        Colors.white,
        Color(0x00FFFFFF),
      ],
    );
    canvas.drawRect(Rect.fromCircle(center: center, radius: radio),
        Paint()..shader = gradientS.createShader(rect));
    canvas.drawRect(Rect.fromCircle(center: center, radius: radio),
        Paint()..shader = gradientR.createShader(rect));
    canvas.drawRect(Rect.fromCircle(center: center, radius: radio),
        Paint()..color = Colors.black.withOpacity(1 - hsvColor.value));

    canvas.drawCircle(
      Offset(
        center.dx +
            hsvColor.saturation * radio * cos((hsvColor.hue * pi / 180)),
        center.dy -
            hsvColor.saturation * radio * sin((hsvColor.hue * pi / 180)),
      ),
      size.height * 0.04,
      Paint()
        ..color = pointerColor ??
            (useWhiteForeground(hsvColor.toColor())
                ? Colors.white
                : Colors.black)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class CieXyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    _drawChromaticityShape(canvas, size);
    debugPrint("painting");
  }

  void _drawChromaticityShape(Canvas canvas, Size size) {
    final Path path = Path();
    List<Offset> spectralPoints = _getSpectralLocus(size);

    path.moveTo(spectralPoints.first.dx, spectralPoints.first.dy);
    for (var point in spectralPoints) {
      path.lineTo(point.dx, point.dy);
    }
    path.close();

    final Paint shapePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPath(path, shapePaint);
  }

  List<Offset> _getSpectralLocus(Size size) {
    List<Offset> points = [];
    List<List<double>> ciePoints = [
      [0.7347, 0.2653],
      [0.7213, 0.2720],
      [0.7079, 0.2835],
      [0.6938, 0.2993],
      [0.6780, 0.3198],
      [0.6587, 0.3438],
      [0.6375, 0.3704],
      [0.6180, 0.3959],
      [0.5796, 0.4335],
      [0.5501, 0.4586],
      [0.5269, 0.4782],
      [0.5102, 0.4919],
      [0.5000, 0.5000],
      [0.4452, 0.5520],
      [0.4000, 0.5800],
      [0.3648, 0.5988],
      [0.3264, 0.6300],
      [0.3059, 0.6450],
      [0.2845, 0.6638],
      [0.2658, 0.6780],
      [0.2500, 0.6900],
      [0.2350, 0.7000],
      [0.2170, 0.7100],
      [0.2000, 0.7170],
      [0.1800, 0.7250],
      [0.1550, 0.7350],
      [0.1250, 0.7450],
      [0.0900, 0.7500],
      [0.0600, 0.7500],
      [0.0300, 0.7500],
      [0.0000, 0.7500],
      [0.1750, 0.0050],
      [0.3500, 0.0000],
      [0.5300, 0.0000],
      [0.7100, 0.0000],
      [0.8300, 0.1200]
    ];
    for (var p in ciePoints) {
      points.add(Offset(p[0] * size.width, (1 - p[1]) * size.height));
    }
    return points;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

Color _xyToRGB(double x, double y) {
  double Y = 1.0;
  double X = (Y / y) * x;
  double Z = (Y / y) * (1 - x - y);

  double r = 3.2406 * X - 1.5372 * Y - 0.4986 * Z;
  double g = -0.9689 * X + 1.8758 * Y + 0.0415 * Z;
  double b = 0.0557 * X - 0.2040 * Y + 1.0570 * Z;

  r = r.clamp(0, 1) * 255;
  g = g.clamp(0, 1) * 255;
  b = b.clamp(0, 1) * 255;

  return Color.fromARGB(255, r.toInt(), g.toInt(), b.toInt());
}

/// Provide Rectangle & Circle 2 categories, 10 variations of palette widget.
class ColorPickerArea extends StatelessWidget {
  const ColorPickerArea(
    this.hsvColor,
    this.onColorChanged, {
    Key? key,
  }) : super(key: key);

  final HSVColor hsvColor;
  final ValueChanged<HSVColor> onColorChanged;

  void _handleColorWheelChange(double hue, double radio) {
    onColorChanged(hsvColor.withHue(hue).withSaturation(radio));
  }

  void _handleGesture(
      Offset position, BuildContext context, double height, double width) {
    RenderBox? getBox = context.findRenderObject() as RenderBox?;
    if (getBox == null) return;

    Offset localOffset = getBox.globalToLocal(position);
    double horizontal = localOffset.dx.clamp(0.0, width);
    double vertical = localOffset.dy.clamp(0.0, height);

    Offset center = Offset(width / 2, height / 2);
    double radio = width <= height ? width / 2 : height / 2;
    double dist =
        sqrt(pow(horizontal - center.dx, 2) + pow(vertical - center.dy, 2)) /
            radio;
    double rad =
        (atan2(horizontal - center.dx, vertical - center.dy) / pi + 1) /
            2 *
            360;
    _handleColorWheelChange(((rad + 90) % 360).clamp(0, 360), dist.clamp(0, 1));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 200,
        height: 200,
        child: GestureDetector(
            onTapDown: ((details) =>
                _handleGesture(details.globalPosition, context, 200, 200)),
            onPanUpdate: ((details) =>
                _handleGesture(details.globalPosition, context, 200, 200)),
            child: CustomPaint(
              size: Size(200, 200),
              painter: RectPainter(hsvColor: hsvColor),
            )));
  }
}
