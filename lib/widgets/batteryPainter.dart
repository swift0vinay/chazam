import 'dart:math';

import 'package:flutter/material.dart';

class BatteryPainter extends CustomPainter {
  Animation<double> listenable;
  Color color;
  BatteryPainter({
    this.listenable,
    this.color,
  }) : super(repaint: listenable);
  @override
  void paint(Canvas canvas, Size size) {
    double startAngle = -pi / 2;
    double h = size.height / 2;
    double w = size.width / 2;
    Offset center = Offset(w, h);
    double radius = w;
    Offset center2 = Offset(center.dx + radius * cos(listenable.value - pi / 2),
        center.dy + radius * sin(listenable.value - pi / 2));
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 8.0;
    Paint paint2 = Paint()
      ..shader = RadialGradient(colors: [
        Colors.white,
        color,
        color.withOpacity(0.5),
        color.withOpacity(0.2),
      ]).createShader(Rect.fromCircle(center: center2, radius: 15))
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle,
        listenable.value, false, paint);
    canvas.drawCircle(center2, 15, paint2);
  }

  @override
  bool shouldRepaint(BatteryPainter old) {
    return false;
  }
}
