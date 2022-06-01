
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:schedule/controller/Application.dart';
import 'package:schedule/views/DaysPage.dart';
import 'package:workmanager/workmanager.dart';

final AudioCache player = AudioCache();
var soundPath = "sound.mp3";

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

  Workmanager().initialize(playMusic);

  runApp(
      MyApp()
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (BuildContext context,Widget? child) =>
          MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: child!),
      home: DaysPage(),
    );
  }
}

void playMusic(){
  Workmanager().executeTask((taskName, inputData) async {
    // play music
    var result = await player.play(soundPath);
    return Future.value(true);
  });
}
