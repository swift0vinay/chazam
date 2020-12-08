import 'package:flutter/material.dart';

class CustomThumb extends SliderComponentShape {
  final double thumbRadius;
  final int max;
  final int min;
  final int currentValue;
  CustomThumb({this.currentValue, this.max, this.min, this.thumbRadius});
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  String getValue(double value) {
    int r = ((max - min) * value).round();
    return (min + r).toString();
  }

  @override
  void paint(PaintingContext context, Offset center,
      {Animation<double> activationAnimation,
      Animation<double> enableAnimation,
      bool isDiscrete,
      TextPainter labelPainter,
      RenderBox parentBox,
      SliderThemeData sliderTheme,
      TextDirection textDirection,
      double value,
      double textScaleFactor,
      Size sizeWithOverflow}) {
    final Canvas canvas = context.canvas;
    final Paint paint = Paint()
      ..color = Colors.blueAccent
      ..style = PaintingStyle.fill;
    TextSpan span = TextSpan(
      style: TextStyle(
        fontSize: thumbRadius * 0.8,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      text: '$currentValue',
    );
    TextPainter textPainter = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    Offset myCenter = Offset(center.dx - (textPainter.width / 2),
        center.dy - (textPainter.height / 2));
    canvas.drawCircle(center, thumbRadius * 0.9, paint);
    textPainter.paint(canvas, myCenter);
  }
}
