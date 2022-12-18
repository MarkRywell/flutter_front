import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:flutter_front/models/item.dart';
import 'package:flutter_front/models/user.dart';


class QueryBuilder {

  QueryBuilder.privateConstructor();
  static final QueryBuilder instance = QueryBuilder.privateConstructor();

  static Database? _database;

  Future <Database> getDatabase() async {

    return _database ??= await initDatabase();
  }

  Future <Database> initDatabase() async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String path = join(appDirectory.path, 'onlysells.db');
    return await openDatabase(
        path,
      version: 1,
      onCreate: onCreate,
    );
  }

  Future onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE users(id INTEGER PRIMARY KEY, name TEXT, email TEXT,
          address TEXT)
    ''');

    await db.execute('''
          CREATE TABLE items(id INTEGER PRIMARY KEY, name TEXT, details TEXT,
          userId INTEGER, sold TEXT, 
          FOREIGN KEY(userId) REFERENCES users(id))
    ''');
  }

}