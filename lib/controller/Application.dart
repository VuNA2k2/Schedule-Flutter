
import 'package:schedule/TaskHelper.dart';
import 'package:schedule/models/Days.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../models/Task.dart';


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

  Future<void> initializeApplication() async {
    var _tasks = await TaskHelper().getTasks();
    _tasks.forEach((element) {
      switch(element.day) {
        case "Monday":
          _days[0].addTask(element);
          break;
        case "Tuesday":
          _days[1].addTask(element);
          break;
        case "Wednesday":
          _days[2].addTask(element);
          break;
        case "Thursday":
          _days[3].addTask(element);
          break;
        case "Friday":
          _days[4].addTask(element);
          break;
        case "Saturday":
          _days[5].addTask(element);
          break;
        case "Sunday":
          _days[6].addTask(element);
          break;
      }
    });
  }

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

    AndroidNotificationDetails androidNotificationDetails = const AndroidNotificationDetails(
      'channel Id 0',
      'alarm_notification',
      icon: 'ic_launcher',
      sound: RawResourceAndroidNotificationSound('sound'),
      playSound: true,
    );

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'sound.mp3'
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.schedule(0, title, body, scheduledDate, notificationDetails);
  }

  Map<String, int> get mValueDay => _mValueDay;

  void cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  void setAlarm(int id, String title, String body,Duration duration) async {
    var now = DateTime.now();
    createNotification(id, title, body, now.add(duration));
  }

  void deleteTask(int id) async {
    var result = await TaskHelper().delete(id);
    cancelNotification(id);
  }

  void insertTask(Task task) async {
    TaskHelper().insert(task);
  }

  Future<int> getLastId() async {
    return TaskHelper().getLastInsertId();
  }

  void updateTask(Task task) async {
    TaskHelper().update(task);
  }
}