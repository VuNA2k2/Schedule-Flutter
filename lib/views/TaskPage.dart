
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:schedule/controller/Application.dart';
import 'package:intl/intl.dart';
import 'package:schedule/models/Days.dart';
import '../config/event.dart';
import '../models/Task.dart';


final AudioCache player = AudioCache();
var soundPath = "sound.mp3";

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
  bool isFabVisible = true;
  final Application application = Application.instance;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Navigator.pop(context, _day);
        return false;
      },
      child: Scaffold(
        floatingActionButton: Visibility(
          visible: isFabVisible,
          child: FloatingActionButton(
            onPressed: () {
              showModal(context, Event.ADD, null);
            },
            child: Icon(Icons.add),
          ),
        ),
        backgroundColor: const Color(0xFF2D2F41),
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              title: Text(
                _day.name,
                style: const TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              backgroundColor: const Color(0xFF2D2F41),
            )
          ],
          body: NotificationListener<UserScrollNotification> (
            onNotification: (notification) {
              if(notification.direction == ScrollDirection.forward) {
                setState(() {
                  if(!isFabVisible) isFabVisible = true;
                });
              } else if(notification.direction == ScrollDirection.reverse) {
                setState(() {
                  if(isFabVisible) isFabVisible = false;
                });
              }
              return true;
            },
              child: ListView.builder(
                padding: EdgeInsets.zero,
                  itemCount: _day.tasks.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: Key(_day.tasks[index].id.toString()),
                      onDismissed: (direction) async {
                        application.deleteTask(_day.tasks[index].id);
                        setState(() {
                          _day.tasks.removeAt(index);
                        });
                      },
                      child: Container(
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
                                  onPressed: () {
                                    setState(() {
                                      showModal(context, Event.EDIT, _day.tasks[index]);
                                    });
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
                                  value: _day.tasks[index].isPending == 1 ? true : false,
                                  onChanged: (value) {
                                    setState(() {
                                      if(!value) {
                                        application.cancelNotification(_day.tasks[index].id);
                                      } else if(value && _day.tasks[index].isPending == 0) {
                                        var now = DateTime.now();
                                        application.createNotification(_day.tasks[index].id, _day.tasks[index].name, _day.tasks[index].description, DateTime(
                                            now.year,
                                            now.month,
                                            now.day + (7 - (application.mValueDay[_day.name]! - application.mValueDay[DateFormat("EEEE").format(now)]!)) % 7,
                                            int.parse(_day.tasks[index].time.split(":")[0]),
                                            int.parse(_day.tasks[index].time.split(":")[1])
                                        ));
                                      }
                                      value ? _day.tasks[index].isPending = 1 : _day.tasks[index].isPending = 0;
                                    });
                                  },
                                activeColor: Colors.white30,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }
              ),
            ),
          ),
        ),
    );
  }

  void showModal(BuildContext context, Event event, Task? task) async {
    String stringTaskName =  event == Event.ADD ? "Task Name" : task!.name;
    String stringTaskTime = event == Event.ADD ? DateFormat("HH:mm").format(DateTime.now()) : task!.time;
    String stringTaskDes = event == Event.ADD ? "Description" : task!.description;
    var now = DateTime.now();
    DateTime selectDateTime = event == Event.ADD ? DateTime.now() : DateTime(
      now.year,
      now.month,
      now.day + (7 - (application.mValueDay[task!.day]! - application.mValueDay[DateFormat("EEEE").format(now)]!)) % 7,
      int.parse(task.time.split(":")[0]),
      int.parse(task.time.split(":")[1])
    );
    var controllerName = TextEditingController();
    var controllerDes = TextEditingController();
    if(event == Event.EDIT) {
      controllerName.text = stringTaskName;
      controllerDes.text = stringTaskDes;
    }
    Duration duration = event == Event.ADD ? Duration(days: (7 - (application.mValueDay[_day.name]! - application.mValueDay[DateFormat("EEEE").format(DateTime.now())]!)) % 7) : 
                                              selectDateTime.difference(DateTime.now());
    showModalBottomSheet(
        context: context,
        isScrollControlled: true, // only work on showModalBottomSheet function
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: 400,
            margin: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  decoration: InputDecoration(
                    label: const Text("Name"),
                    hintText: "Enter Name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                  controller: controllerName,
                  autofocus: true,
                ),
                const SizedBox(height: 20,),
                GestureDetector( // Time
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.all(8),
                        child: Text(
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            'Time: ${stringTaskTime}'
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios)
                    ],
                  ),
                  onTap: () async {
                    var selectTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(hour: selectDateTime.hour, minute: selectDateTime.minute),
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
                        if(selectDateTime.isAfter(DateTime.now())) {
                          duration = selectDateTime.difference(now);
                        } else {
                          duration = selectDateTime.add(const Duration(days: 7)).difference(now);
                        }
                        stringTaskTime = DateFormat("HH:mm").format(selectDateTime);
                      });
                    }
                  },
                ),
                const SizedBox(height: 20,),
                TextField(
                  decoration: InputDecoration(
                    label: const Text("Description"),
                    hintText: "Enter Description",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                  maxLines: 5,
                  controller: controllerDes,
                ),
                const SizedBox(height: 20,),
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width / 2,
                  child: ElevatedButton(
                    onPressed: () async {
                        stringTaskName = controllerName.text;
                        stringTaskDes = controllerDes.text;
                        Task mtask = Task(
                          day: _day.name,
                          name: stringTaskName,
                          time: stringTaskTime,
                          description:  stringTaskDes,
                          isPending:  1,
                          isComplete:  0,
                        );
                        var id;
                        if(event == Event.ADD) {
                          application.insertTask(mtask);
                          id = await application.getLastId();
                          setState(() {
                            mtask.id = id;
                            _day.tasks.add(mtask);
                          });
                        } else {
                          id = task!.id;
                          setState(() {
                            task.name = stringTaskName;
                            task.description = stringTaskDes;
                            task.time = stringTaskTime;
                            application.updateTask(task);
                          });
                        }
                        application.setAlarm(id, stringTaskName, stringTaskDes, duration);
                        Navigator.pop(context);
                    },
                    child: event == Event.ADD ? Text("Add") : Text("Save"),
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
}
