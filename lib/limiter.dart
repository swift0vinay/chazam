import 'package:chazam/constants.dart';
import 'package:chazam/widgets/customThumbSlider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Limiter extends StatefulWidget {
  double batteryLevel;
  bool isCharging;
  Function callBackToNoCharging;
  Function callBackToHome;
  Limiter(
      {this.batteryLevel,
      this.callBackToNoCharging,
      this.callBackToHome,
      this.isCharging});
  @override
  _LimiterState createState() => _LimiterState();
}

class _LimiterState extends State<Limiter> with SingleTickerProviderStateMixin {
  double value = 0;
  AnimationController animationController;
  Animation animation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    animation = Tween<double>(begin: 0, end: 1).animate(animationController);
    value = this.widget.batteryLevel + 1;
    animation.addListener(() {
      setState(() {});
    });
    animationController.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        animationController.reverse().whenComplete(() {
          Navigator.pop(context);
          return Future.value(true);
        });
      },
      child: Transform.scale(
        scale: animation.value,
        child: Center(
          child: Material(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradientColor),
                borderRadius: BorderRadius.circular(20.0),
              ),
              height: getHeight(context) * 0.4,
              width: getWidth(context) * 0.9,
              padding: EdgeInsets.symmetric(
                vertical: 5.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: 'Current Battery Level    ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      TextSpan(
                        text: '${this.widget.batteryLevel}%',
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      )
                    ]),
                  ),
                  SliderTheme(
                    data: SliderThemeData(
                        // trackHeight: 20,
                        thumbShape: CustomThumb(
                            min: this.widget.batteryLevel.toInt(),
                            max: 100,
                            currentValue: value.toInt(),
                            thumbRadius: 15)),
                    child: Slider(
                      min: this.widget.batteryLevel,
                      max: 100,
                      value: value,
                      onChanged: (val) {
                        setState(() {
                          value = val;
                        });
                      },
                    ),
                  ),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: 'Set Battery Limit To    ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      TextSpan(
                        text: '${value.toInt().toDouble()}%',
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      )
                    ]),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          animationController.reverse().whenComplete(() {
                            Navigator.pop(context);
                          });
                        },
                        child: Container(
                          width: getWidth(context) * 0.35,
                          height: getHeight(context) * 0.05,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          // color: Colors.pink,
                          child: Center(
                            child: Text(
                              "CANCEL",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (!this.widget.isCharging) {
                              animationController.reverse().whenComplete(() {
                                Navigator.pop(context);
                              });
                              this.widget.callBackToNoCharging();
                            } else {
                              batteryLimit = value.toInt().toDouble();
                              animationController.reverse().whenComplete(() {
                                this.widget.callBackToHome(batteryLimit);
                                Navigator.pop(context);
                              });
                            }
                          });
                        },
                        child: Container(
                          width: getWidth(context) * 0.35,
                          height: getHeight(context) * 0.05,
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          // color: Colors.pink,
                          child: Center(
                            child: Text(
                              "SET",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
