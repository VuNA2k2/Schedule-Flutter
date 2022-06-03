import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

import 'models/Task.dart';

final String tableName = 'tasks';
final String columnId = 'id';
final String columnDay = 'day';
final String columnName = 'name';
final String columnDescription = 'description';
final String columnTime = 'time';
final String columnIsPending = 'isPending';
final String columnIsDone = 'isDone';


class TaskHelper {
  static Database? _database;
  static TaskHelper? _taskHelper;

  TaskHelper._createInstane();

  factory TaskHelper() {
    if(_taskHelper == null) {
      _taskHelper = TaskHelper._createInstane();
    }

    return _taskHelper!;
  }


  Future<Database> get database async {
    if(_database == null) {
      _database = await  initializeDatabase();
    }
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    var dir = await getDatabasesPath();
    var path = dir + "tasks.db";

    var database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          create table $tableName (
            $columnId integer primary key autoincrement,
            $columnDay text not null,
            $columnName text not null,
            $columnTime text not null,
            $columnDescription text,
            $columnIsPending bool,
            $columnIsDone bool
          )
        ''');
      }
    );
    return database;
  }
  
  void insertTask(Task task) async {
    var db = await this.database;
    var result = await db.insert(tableName, task.toMap());
  }

  Future<List<Task>> getTasks() async {
    List<Task> _task = [];

    var db = await this.database;
    var result = await db.query(tableName);
    result.forEach((element) {
      var task = Task.fromMap(element);
      _task.add(task);
    });
    return _task;
  }

  Future<int> getLastInsertId() async {
    var db = await this.database;
    var result = await db.query(tableName);
    var task = Task.fromMap(result.last);
    return task.id;
  }

  Future<int> delete(int id) async {
    var db = await this.database;
    return await db.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(Task task) async {
    var db = await this.database;
    return await db.update(tableName, task.toMap());
  }
}