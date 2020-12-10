import 'package:chazam/constants.dart';
import 'package:chazam/widgets/batteryPainter.dart';
import 'package:chazam/widgets/batteryPainter2.dart';
import 'package:chazam/widgets/notifier.dart';
import 'package:flutter/material.dart';

class BatteryIndicator2 extends StatefulWidget {
  double prev;
  Animation animation;
  double batteryLevel;
  BatteryIndicator2({this.batteryLevel, this.prev, this.animation});

  @override
  _BatteryIndicator2State createState() => _BatteryIndicator2State();
}

class _BatteryIndicator2State extends State<BatteryIndicator2>
    with SingleTickerProviderStateMixin {
  AnimationController waveController;
  Animation<double> waveAnimation;
  bool forward = true;
  AnimationStatus animationStatus = AnimationStatus.forward;
  ValueNotifier<AnimationNotifier> notifier;
  @override
  void initState() {
    notifier = new ValueNotifier(
        AnimationNotifier(heightValue: widget.animation.value, waveValue: 0));
    waveController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 2500))
          ..repeat(reverse: true);
    waveAnimation = Tween<double>(begin: -8, end: 8).animate(waveController);
    waveAnimation.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    waveController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    notifier.value = AnimationNotifier(
        heightValue: widget.animation.value, waveValue: waveAnimation.value);
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
          color: (widget.batteryLevel >= 0 && widget.batteryLevel <= 20)
              ? Colors.red
              : (widget.batteryLevel > 20 && widget.batteryLevel < 80)
                  ? Colors.yellow
                  : Colors.green,
          listenable: notifier,
          forward: forward,
          // wave: waveAnimation,
          batteryLevel: widget.batteryLevel,
          prev: widget.prev,
        ),
      ),
    );
  }
}
