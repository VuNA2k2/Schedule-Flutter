import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:schedule/controller/Application.dart';
import 'package:intl/intl.dart';
import 'package:schedule/models/Days.dart';
import 'package:workmanager/workmanager.dart';
import '../models/Task.dart';

class TasksPage extends StatefulWidget {
  Days _day;


  TasksPage(this._day);

  @override
  State<StatefulWidget> createState() {
    return _TasksPage(_day);
  }
}

class _TasksPage extends State<TasksPage> {
  Days _day;
  final _keyForm = GlobalKey<FormState>();
  var controllerName = TextEditingController();
  _TasksPage(this._day);

  final Application application = Application.instance;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Navigator.pop(context, _day);
        return false;
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _addTask(context);
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          title: Text(
            _day.name,
            style: const TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),),
          elevation: 0,
          backgroundColor: const Color(0xFF2D2F41),
          leading: const Icon(Icons.menu),
        ),
        body: Container(
          alignment: Alignment.center,
          color: const Color(0xFF2D2F41),
          child: NotificationListener<UserScrollNotification> (
            child: ListView.builder(
                itemCount: _day.tasks.length,
                itemBuilder: (context, index) {
                  return Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    margin: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.purple, Colors.red],
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.5),
                            blurRadius: 12,
                            offset: Offset(1,1),
                          )
                        ]
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_day.tasks[index].name, style: const TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),),
                            IconButton(
                              onPressed: () async {
                                // edit button
                              },
                              icon: const Icon(Icons.edit, color: Colors.white,),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(_day.tasks[index].time, style: const TextStyle(fontSize: 20, color: Colors.white70),),
                                Text(_day.tasks[index].description, style: const TextStyle(fontSize: 14, color: Colors.white30),maxLines: 2,)
                              ],
                            ),
                            Switch(
                              value: _day.tasks[index].isPending,
                              onChanged: (value) {
                                setState(() {
                                  _day.tasks[index].isPending = value;
                                });
                              },
                              activeColor: Colors.white30,
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                }
            ),
          ),
        ),
      ),
    );
  }

  Future<Task?> _addTask(BuildContext context) async {
    String stringTaskName = "Task Name";
    String stringTaskTime = DateFormat("HH:mm").format(DateTime.now());
    String stringTaskDes = "Description";
    DateTime selectDateTime = DateTime.now();
    var controllerName = TextEditingController();
    var controllerDes = TextEditingController();
    Duration duration = Duration();
    showModalBottomSheet<Task?>(
        context: context,
        isScrollControlled: true, // only work on showModalBottomSheet function
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: 350,
            margin: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  decoration: InputDecoration(
                    label: Text("Name"),
                    hintText: "Enter Name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                  controller: controllerName,
                ),
                SizedBox(height: 20,),
                GestureDetector( // Time
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.all(8),
                        child: Text(
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            "Time: ${stringTaskTime}"
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios)
                    ],
                  ),
                  onTap: () async {
                    var selectTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if(selectTime != null) {
                      setState(() {
                        var now = DateTime.now();
                        selectDateTime = DateTime(
                          now.year,
                          now.month,
                          now.day + (7 - (application.mValueDay[_day.name]! - application.mValueDay[DateFormat("EEEE").format(now)]!)) % 7,
                          selectTime.hour,
                          selectTime.minute,
                        );
                        if(selectDateTime.isAfter(now)) selectDateTime.add(Duration(days: 7));
                        duration = selectDateTime.difference(now);
                        stringTaskTime = DateFormat("HH:mm").format(selectDateTime);
                      });
                    }
                  },
                ),
                SizedBox(height: 20,),
                TextField(
                  decoration: InputDecoration(
                    label: Text("Description"),
                    hintText: "Enter Description",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                  maxLines: 5,
                  controller: controllerDes,
                ),
                SizedBox(height: 20,),
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width / 2,
                  child: ElevatedButton(
                    onPressed: () {
                        stringTaskName = controllerName.text;
                        stringTaskDes = controllerDes.text;
                        Navigator.pop(context);
                        _setAlarm(stringTaskName, stringTaskDes, duration);
                        setState(() {
                          _day.tasks.add(Task(_day.name, stringTaskName, stringTaskTime, stringTaskDes, true, false));
                        });
                    },
                    child: Text("Add"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        )
      )
    );
  }

  void _setAlarm(String title, String body,Duration duration) {
    var now = DateTime.now();
    application.createNotification(0, title, body, now.add(duration));
  }
}

