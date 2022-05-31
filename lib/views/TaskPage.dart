import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:schedule/controller/Application.dart';
import 'package:intl/intl.dart';
import 'package:schedule/models/Days.dart';
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
                                Text(DateFormat("HH:mm").format(_day.tasks[index].time), style: const TextStyle(fontSize: 20, color: Colors.white70),),
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

  Future<Task> _addTask(BuildContext context) async {
    String stringTaskName = "Task Name";
    String stringTaskTime = "Time";
    String stringTaskDes = "Description";
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(4),
          margin: EdgeInsets.all(4),
          height: MediaQuery.of(context).size.height / 2.5,
          child: Form(
            key: _keyForm,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector( // Task Name
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.task, size: 32,),
                        Container(
                          margin: EdgeInsets.all(8),
                          child: Text(
                              style: TextStyle(fontSize: 20),
                              stringTaskName
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios)
                      ],
                    ),
                  ),
                  onTap: () {
                    stringTaskName = showTaskNameDialog(context);
                    print(stringTaskName);
                    if(stringTaskName != null) {
                      setState(() {
                        
                      });
                    }
                  },
                ),
                GestureDetector( // Time
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.task, size: 32,),
                      Container(
                        margin: EdgeInsets.all(8),
                        child: Text(
                            style: TextStyle(fontSize: 20),
                            stringTaskTime
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios)
                    ],
                  ),
                ),
                GestureDetector( // Description
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.task, size: 32,),
                      Container(
                        margin: EdgeInsets.all(8),
                        child: Text(
                            style: TextStyle(fontSize: 20),
                            stringTaskDes
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios)
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {

                  },
                  child: Text("Add"),
                )
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
    
    return Task(_day.name, "Test", DateTime.now(), "tes", true, false);
  }

  void _setAlarm(DateTime selectTime) {

  }

  String showTaskNameDialog(BuildContext context) {
    var controllerName = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            height: MediaQuery.of(context).size.height / 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                TextField(
                  controller: controllerName,
                  decoration: InputDecoration(
                    label: Text("Task Name",),
                    hintText: "Enter Task",
                    border: OutlineInputBorder(),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("OK"),
                )
              ],
            )
          ),
        );
      }
    );
    return controllerName.text;
  }
}

