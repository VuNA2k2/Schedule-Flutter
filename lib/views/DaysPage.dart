import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule/controller/Application.dart';
import 'package:schedule/models/Days.dart';
import 'package:schedule/views/TaskPage.dart';
class DaysPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DaysPage();
  }
}

class _DaysPage extends State<DaysPage> {
  final Application application = Application.instance;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Day of week",
          style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),),
        elevation: 0,
        backgroundColor: const Color(0xFF2D2F41),
        leading: const Icon(Icons.menu),
      ),
      body: Container(
        alignment: Alignment.center,
        color: const Color(0xFF2D2F41),
        child: ListView.builder(
          itemCount: application.days.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              child: Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.all(4),
                height: size.height/9,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.deepPurple, Colors.blueAccent, Colors.red],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      application.days[index].name,
                      style: const TextStyle(fontSize: 24, color: Colors.white),
                    ),
                    Text('${application.days[index].tasks.length} tasks to complete.', style: TextStyle(color: Colors.white70),)
                  ],
                ),
              ),
              onTap: () {
                _onTapItem(application.days[index]);
              },
            );
          },
        ),
      ),
    );
  }

  void _onTapItem(Days day) async {
    var mDay = await Navigator.push(context, MaterialPageRoute(builder: (context) => TasksPage(day)));
    if(mDay != null) {
      setState(() {
        day.tasks = mDay.tasks;
      });
    }
  }
}
