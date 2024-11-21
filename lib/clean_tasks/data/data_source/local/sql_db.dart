import 'dart:async';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqlDb {
  static Database? _db;
  Future<Database?> get db async {
    if (_db == null) {
      _db = await initDb();
      return _db;
    }
    return _db!;
  }

  Future<Database> initDb() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'tasks.db');
    Database myDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return myDb;
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute('''
CREATE TABLE tasks (
  id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  task_id INTEGER NOT NULL,
  title TEXT NOT NULL,
  desc TEXT NOT NULL
)
''');

    await db.execute('''
CREATE TABLE tasks_history (
  id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  task_id INTEGER NOT NULL,
  title TEXT NOT NULL,
  desc TEXT NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)
''');
  }
}
