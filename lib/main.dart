import 'package:chazam/constants.dart';
import 'package:chazam/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.yellow.withOpacity(0.2),
        systemNavigationBarColor: Colors.teal.withOpacity(0.2)));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      title: "Chazam",
    );
  }
}
