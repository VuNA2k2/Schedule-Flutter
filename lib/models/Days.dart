import 'package:schedule/models/Task.dart';

class Days {
  String _name;
  List<Task> _tasks = [];

  Days(this._name);

  List<Task> get tasks => _tasks;

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  void addTask(Task task) {
    _tasks.add(task);
  }

  set tasks(List<Task> value) {
    _tasks = value;
  }
}
