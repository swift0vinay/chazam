import 'package:chazam/constants.dart';
import 'package:chazam/widgets/batteryPainter.dart';
import 'package:chazam/widgets/batteryPainter2.dart';
import 'package:flutter/material.dart';

class BatteryIndicator2 extends StatelessWidget {
  double prev;
  Animation animation;
  double batteryLevel;
  BatteryIndicator2({this.batteryLevel, this.prev, this.animation});
  @override
  @override
  Widget build(BuildContext context) {
    double h = getHeight(context);
    return Container(
      height: h * 0.3,
      width: h * 0.3,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        shape: BoxShape.circle,
      ),
      child: CustomPaint(
        painter: BatteryPainter2(
          color: (batteryLevel >= 0 && batteryLevel <= 20)
              ? Colors.red
              : (batteryLevel > 20 && batteryLevel < 80)
                  ? Colors.yellow
                  : Colors.green,
          listenable: animation,
          batteryLevel: batteryLevel,
          prev: prev,
        ),
      ),
    );
  }
}
