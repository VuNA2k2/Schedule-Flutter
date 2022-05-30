import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule/controller/Application.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePage();
  }
}

class _HomePage extends State<HomePage> {
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

              },
            );
          },
        ),
      ),
    );
  }
}
