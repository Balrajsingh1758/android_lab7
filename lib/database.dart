import 'package:floor/floor.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'ToDoItem.dart';
import 'ToDoDao.dart';

part 'database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [ToDoItem])
abstract class AppDatabase extends FloorDatabase {
  ToDoDao get toDoDao;
}