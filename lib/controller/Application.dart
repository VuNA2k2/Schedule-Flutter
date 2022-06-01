
import 'package:schedule/models/Days.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class Application {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static Application _instance = Application._();
  Application._();
  static Application get instance => _instance;
  final Map<String, int> _mValueDay = {
    "Monday" : 1,
    "Tuesday" : 2,
    "Wednesday" : 3,
    "Thursday" : 4,
    "Friday" : 5,
    "Saturday" : 6,
    "Sunday" : 7,
  };
  final List<Days> _days = [
    Days("Monday"),
    Days("Tuesday"),
    Days("Wednesday"),
    Days("Thursday"),
    Days("Friday"),
    Days("Saturday"),
    Days("Sunday"),
  ];

  List<Days> get days => _days;

  void addTaskToDay(String day, Task, task) {
    for(int i = 0; i < _days.length; i ++) {
      if(day.compareTo(_days[i].name) == 0) {
        _days[i].addTask(task);
        break;
      }
    }
  }


  FlutterLocalNotificationsPlugin get flutterLocalNotificationsPlugin =>
      _flutterLocalNotificationsPlugin;

  void createNotification(int id, String title, String body, DateTime scheduledDate) async {

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'alarm_notification',
      'alarm_notification',
      icon: 'ic_launcher',
    );

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.schedule(0, title, body, scheduledDate, notificationDetails);
  }

  Map<String, int> get mValueDay => _mValueDay;


}