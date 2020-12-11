import 'dart:math';

import 'package:chazam/widgets/batteryIndicator.dart';
import 'package:chazam/widgets/batteryPainter.dart';
import 'package:chazam/constants.dart';
import 'package:chazam/limiter.dart';
import 'package:chazam/widgets/batteryIndicator2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  String channelName = "battery";
  static MethodChannel methodChannel;
  double batteryLevel = 0;
  double prev = 0;
  double chargingTimeLeft;
  bool isCharging = false;
  AnimationController animationController;
  Animation animation;
  AnimationController animationController2;
  Animation animation2;
  AnimationController rotationController;
  Animation rotation;
  bool getChargingType = false;
  String chargingType = '';
  String batteryHealth = '';
  final key = GlobalKey<ScaffoldState>();
  bool type = true;
  @override
  void initState() {
    super.initState();
    batteryLevel = 0;
    methodChannel = MethodChannel(channelName);
    startMethod();
    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    animation = Tween<double>(begin: 0, end: 1).animate(animationController);
    animationController2 = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    animation2 = Tween<double>(begin: 0, end: 1).animate(animationController2);

    rotationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    rotation = Tween<double>(begin: 0, end: pi).animate(rotationController);
    methodChannel.setMethodCallHandler((call) {
      if (call.method == 'getList') {
        List<String> list = List.from(call.arguments);
        getBatteryLevel(list);
      }
      return Future.value(true);
    });
    animation.addListener(() {});
    rotation.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
    animationController2.dispose();
    rotationController.dispose();
  }

  startMethod() async {
    int rs = await methodChannel.invokeMethod('getBatteryLevel');
  }

  getBatteryLevel(List<String> list) {
    setState(() {
      prev = batteryLevel;
      // batteryLevel = 80;
      batteryLevel = double.parse(list[0]);
      chargingTimeLeft = int.parse(list[1]).toDouble();
      chargingTimeLeft =
          (chargingTimeLeft / 3600000).toDouble().roundToDouble();
      isCharging = list[2] == 'true' ? true : false;
      chargingType = (list[3]);
      if (chargingType == 'USB') {
        getChargingType = true;
      } else {
        getChargingType = false;
      }
      // getChargingType = false;
      batteryHealth = list[4];
    });
    if (batteryLevel == batteryLimit) {
      _showNotificationWithSound();
      batteryLimit = -1.0;
    }
    if (prev != batteryLevel) {
      if (type) {
        double startAngle = prev / 100 * 2 * pi;
        double endAngle = batteryLevel / 100 * 2 * pi;
        animationController.value = 0;
        animation = Tween<double>(begin: startAngle, end: endAngle)
            .animate(animationController);
        animationController.forward();
      } else {
        animationController2.value = 0;
        double start = prev;
        double end = batteryLevel;
        animation2 =
            Tween<double>(begin: start, end: end).animate(animationController2);
        animationController2.forward();
      }
    }
  }

  callBackToNoCharging() {
    key.currentState.showSnackBar(SnackBar(
      content: Text("Cannot set limit! No Charger Connected"),
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
    ));
  }

  callBackToHome(double bl) {
    key.currentState.showSnackBar(SnackBar(
      content: Text("Limit Set To $bl%  Enjoy!!"),
      duration: Duration(seconds: 5),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      action: SnackBarAction(
        label: "CANCEL",
        onPressed: () {
          setState(() {
            batteryLimit = -1.0;
          });
          key.currentState.showSnackBar(SnackBar(
            content: Text("Limit Disabled"),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
          ));
        },
        textColor: Colors.white,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    double h = getHeight(context);
    double w = getWidth(context);
    return SafeArea(
      child: Scaffold(
          key: key,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradientColor),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            type = !type;
                          });
                        },
                        child: Icon(Icons.swap_calls)),
                  ),
                  AnimatedCrossFade(
                    duration: Duration(seconds: 1),
                    firstChild: battery1(h),
                    secondChild: battery2(h),
                    crossFadeState: type
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                  ),
                  SizedBox(height: 50.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      menuItem("CHARGING", "ON", "OFF", isCharging),
                      menuItem("TIME LEFT", '$chargingTimeLeft', '', null),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      menuItem("TYPE", 'USB',
                          chargingType == 'AC' ? 'AC' : 'NA', getChargingType),
                      menuItem("HEALTH", batteryHealth, '', null),
                    ],
                  ),
                  SizedBox(height: 30),
                  InkWell(
                    onTap: () {
                      if (batteryLevel >= 100.0) {
                        key.currentState.showSnackBar(SnackBar(
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          duration: Duration(seconds: 4),
                          content:
                              Text("Hey!! Device is full charged already."),
                        ));
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Limiter(
                                isCharging: isCharging,
                                callBackToNoCharging: callBackToNoCharging,
                                batteryLevel: batteryLevel,
                                callBackToHome: callBackToHome,
                              );
                            });
                      }
                    },
                    child: Container(
                      width: w * 0.8,
                      height: h * 0.05,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      // color: Colors.pink,
                      child: Center(
                        child: Text(
                          "SET LIMIT",
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
            ),
          )),
    );
  }

  Container battery2(double h) {
    return Container(
      height: h * 0.35,
      width: h * 0.35,
      child: Stack(
        children: [
          Center(
            child: BatteryIndicator2(
              batteryLevel: batteryLevel,
              prev: prev,
              animation: animation2,
            ),
          ),
          Center(
            child: Container(
              height: h * 0.3,
              width: h * 0.3,
              child: Center(
                child: Text('$batteryLevel%',
                    style: TextStyle(
                        fontFamily: "Segoe",
                        fontSize: 50,
                        fontWeight: FontWeight.normal)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container battery1(double h) {
    return Container(
      height: h * 0.35,
      width: h * 0.35,
      child: GestureDetector(
        onLongPress: () async {
          print("re");
          for (int i = 0; i < 3; i++) {
            await rotationController.forward().whenComplete(() async {
              await rotationController.reverse();
            });
          }
        },
        child: Stack(
          children: [
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..rotateY(rotation.value),
              child: BatteryIndicator(
                animation: animation,
                batteryLevel: batteryLevel,
                prev: prev,
              ),
            ),
            Center(
              child: Container(
                height: h * 0.3,
                width: h * 0.3,
                child: Center(
                  child: Text('$batteryLevel%',
                      style: TextStyle(
                          fontFamily: "Segoe",
                          fontSize: 50,
                          fontWeight: FontWeight.normal)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _showNotificationWithSound() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'SV5463', 'BatteryLimiter', 'Notifies when baterry reaches limit',
        playSound: true,
        sound: SoundGetter('battery'),
        importance: Importance.max,
        priority: Priority.high);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Battery Limit Reached',
      'Please turn off your charger',
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  menuItem(String title, String sub1, String sub2, bool rs) {
    double h = getHeight(context);
    double w = getWidth(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      elevation: 8.0,
      child: Container(
        width: w * 0.4,
        height: h * 0.2,
        decoration: BoxDecoration(
            gradient: RadialGradient(colors: revgradientColor),
            borderRadius: BorderRadius.circular(20.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: "Segoe",
              ),
            ),
            rs == null
                ? Text(
                    sub1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30.0,
                      fontFamily: "Segoe",
                    ),
                  )
                : AnimatedCrossFade(
                    firstCurve: Curves.decelerate,
                    secondCurve: Curves.decelerate,
                    crossFadeState: rs
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    firstChild: Text(
                      "$sub1",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30.0,
                        fontFamily: "Segoe",
                      ),
                    ),
                    secondChild: Text(
                      "$sub2",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30.0,
                        fontFamily: "Segoe",
                      ),
                    ),
                    duration: Duration(seconds: 1),
                  ),
          ],
        ),
      ),
    );
  }
}

class ArrowPainter extends CustomPainter {
  Color color;
  ArrowPainter({this.color});
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 8.0;
    path.moveTo(0, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(0, size.height);
    // path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class SoundGetter extends RawResourceAndroidNotificationSound {
  SoundGetter(String sound) : super(sound);
  @override
  // TODO: implement sound
  String get sound => 'battery';
}
