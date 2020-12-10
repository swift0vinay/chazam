import 'dart:math';

import 'package:chazam/widgets/batteryIndicator2.dart';
import 'package:chazam/widgets/notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BatteryPainter2 extends CustomPainter {
  ValueNotifier<AnimationNotifier> listenable;
  Color color;
  bool forward;
  double batteryLevel, prev;
  BatteryPainter2(
      {this.color, this.forward, this.listenable, this.batteryLevel, this.prev})
      : super(repaint: listenable);
  @override
  void paint(Canvas canvas, Size size) {
    // print(wave.value);
    double h = size.height;
    double w = size.width;
    double batteryHeight = listenable.value.heightValue == 0
        ? (h * batteryLevel / 100)
        : (h * listenable.value.heightValue / 100);
    double radius = h / 2;
    Paint paint = Paint()
      ..shader = LinearGradient(
        colors: [
          color.withOpacity(1),
          color.withOpacity(0.6),
          color.withOpacity(0.4),
          color.withOpacity(0.6),
          color.withOpacity(1),
        ],
      ).createShader(
          Rect.fromCircle(center: Offset(h / 2, h / 2), radius: radius))
      ..style = PaintingStyle.fill;
    Path path = Path();
    double angle = asin(((h / 2 - batteryHeight).abs()) / radius);
    double batteryWidth = cos(angle) * radius;
    Offset start = Offset(w / 2, h);
    Offset left = Offset(radius - batteryWidth, h - batteryHeight);
    Offset right = Offset(radius + batteryWidth, h - batteryHeight);
    path.moveTo(start.dx, start.dy);
    if (batteryLevel != 100.0) {
      path.arcToPoint(
        left,
        clockwise: true,
        radius: Radius.circular(radius),
      );
    } else {
      path.arcToPoint(
        Offset(h / 2, 0),
        clockwise: true,
        radius: Radius.circular(radius),
      );
    }
    // path.lineTo(w / 2, h - batteryHeight);
    // path.lineTo(left.dx, left.dy);

    double dist = right.dx - left.dx;
    double parts = 0;
    if (batteryLevel >= 0 && batteryLevel <= 10) {
      parts = 1;
    } else if (batteryLevel > 10 && batteryLevel <= 90) {
      parts = 5;
    } else if (batteryLevel > 90 && batteryLevel <= 95) {
      parts = 3;
    } else if (batteryLevel > 95 && batteryLevel < 98) {
      parts = 3;
    } else {
      parts = 1;
    }
    double partDist = dist / parts;
    if (batteryLevel < 98) {
      for (int i = 1; i <= parts; i++) {
        if (i % 2 != 0)
          path.quadraticBezierTo(
              left.dx + (i - 1) * partDist + partDist / 2,
              left.dy + listenable.value.waveValue,
              left.dx + i * partDist,
              left.dy);
        else
          path.quadraticBezierTo(
              left.dx + (i - 1) * partDist + partDist / 2,
              left.dy - listenable.value.waveValue,
              left.dx + i * partDist,
              left.dy);
      }
    }
    if (batteryLevel != 100) {
      path.lineTo(right.dx, right.dy);
    }
    // if(batteryLevel)
    path.arcToPoint(
      start,
      clockwise: true,
      radius: Radius.circular(radius),
    );
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
