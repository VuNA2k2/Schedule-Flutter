
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:schedule/controller/Application.dart';
import 'package:schedule/views/DaysPage.dart';
import 'package:schedule/views/HomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings(
    'ic_launcher'
  );

  IOSInitializationSettings iosInitializationSettings = IOSInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
    onDidReceiveLocalNotification: (
        int id,
        String? title,
        String? body,
        String? payload
        ) async {

    });

  InitializationSettings initializationSettings = InitializationSettings(
    android: androidInitializationSettings, iOS: iosInitializationSettings
  );

  await Application.instance.flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onSelectNotification: (String? payload) async {
      if(payload != null) {
        print(payload);
      }
    }
  );

  runApp(
      MyApp()
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DaysPage(),
    );
  }
}
