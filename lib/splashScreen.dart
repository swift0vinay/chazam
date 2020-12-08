import 'package:chazam/constants.dart';
import 'package:chazam/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;
  Animation animation;
  bool completed = false;
  AnimationController animationController2;
  Animation animation2;
  bool initAnimation = false;
  @override
  void initState() {
    super.initState();
    initalize();
    animationController =
        new AnimationController(duration: Duration(seconds: 2), vsync: this)
          ..repeat();
    animation = Tween<double>(begin: 0, end: 350).animate(animationController);
    animation.addListener(() {
      setState(() {
        if (animation.status == AnimationStatus.completed) {
          completed = true;
          animationController2.forward();
          Future.delayed(Duration(seconds: 3)).then((value) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return Home();
            }));
          });
        }
      });
    });

    animationController2 =
        new AnimationController(duration: Duration(seconds: 2), vsync: this)
          ..repeat();
    animation2 =
        Tween<double>(begin: 200, end: 100).animate(animationController2);
    animation2.addListener(() {
      setState(() {});
    });
    animationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  Future onSelectNotification(String payload) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Battery Charged"),
            content: Text("Task Completed $payload"),
          );
        });
  }

  initalize() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  @override
  Widget build(BuildContext context) {
    double h = getHeight(context);
    double w = getWidth(context);
    if (!initAnimation) {
      initAnimation = true;
      animation =
          Tween<double>(begin: 0, end: h * 0.45).animate(animationController);
      animation2 = Tween<double>(begin: w * 0.35, end: w * 0.20)
          .animate(animationController2);
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
            Positioned(
              left: !completed ? w * 0.25 : w * 0.70 - animation2.value,
              top: animation.value,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 800),
                opacity: !completed ? 0.0 : 1.0,
                child: Container(
                  height: 100,
                  width: 130,
                  child: Center(
                      child: Text(
                    "CHAZAM",
                    style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Segoe",
                        foreground: Paint()
                          ..shader = LinearGradient(colors: [
                            Colors.green.withOpacity(1),
                            Colors.yellow.withOpacity(0.6),
                          ]).createShader(Rect.largest)),
                  )),
                ),
              ),
            ),
            Positioned(
              left: !completed ? w * 0.35 : animation2.value,
              top: animation.value,
              child: Container(
                color: Colors.white,
                height: 100,
                width: 100,
                child: Center(
                    child: Image.asset(
                  'assets/chazam.png',
                  height: 150,
                  width: 150,
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
