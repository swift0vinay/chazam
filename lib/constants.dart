import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
double batteryLimit = -1.0;
getWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

getHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

List<Color> gradientColor = [
  Colors.green.withOpacity(0.3),
  Colors.teal.withOpacity(0.3),
  Colors.yellow.withOpacity(0.3),
];

List<Color> revgradientColor = [
  // Colors.yellow.withOpacity(0.3),
  Colors.teal.withOpacity(0.3),
  Colors.green.withOpacity(0.3),
];
