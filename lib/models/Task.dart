import 'package:flutter/foundation.dart';

class Task {
  int? _id;
  String? _day;
  String? _name;
  String? _time;
  String? _description;
  int? _isPending;
  int? _isCompleted;

  Task({
    int? id,
    required String day,
    required String name,
    required String time,
    String? description,
    required int isPending,
    required int isComplete,
  }) {
    this._id = id;
    this._day = day;
    this._name = name;
    this._time = time;
    this._description = description;
    this._isPending = isPending;
    this._isCompleted = isComplete;
  }

  String get day => _day!;

  int get isCompleted => _isCompleted!;

  set isCompleted(int value) {
    _isCompleted = value;
    if(_isCompleted == 1) _isPending = 0;
  }

  int get isPending => _isPending!;

  set isPending(int value) {
    _isPending = value;
  }

  String get description => _description!;

  set description(String value) {
    _description = value;
  }

  String get name => _name!;

  set name(String value) {
    _name = value;
  }

  String get time => _time!;

  set time(String value) {
    _time = value;
  }

  factory Task.fromMap(Map<String, dynamic> json) => Task(
    id: json["id"],
    day: json["day"],
    name: json["name"],
    time: json["time"],
    description: json["description"],
    isPending: json["isPending"],
    isComplete: json["isDone"]
  );

  Map<String, dynamic> toMap() => {
    "id": _id,
    "day": _day,
    "name": _name,
    "time": _time,
    "description": _description,
    "isPending": _isPending,
    "isDone": _isCompleted,
  };

  int get id => _id!;

  set id(int value) {
    _id = value;
  }
}