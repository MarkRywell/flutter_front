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
    // Directory appDirectory = await getApplicationDocumentsDirectory();
    String path = join(await getDatabasesPath(), 'onlysells.db');
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
          price REAL, userId INTEGER, sold TEXT, picture TEXT, soldTo TEXT, 
          created_at TEXT, updated_at TEXT,
          FOREIGN KEY(userId) REFERENCES users(id))
    ''');
  }

  Future <List<Item>> items() async {

    Database db = await instance.getDatabase();

    final List<Map<String, dynamic>> map = await db.query('items');

    return map.isNotEmpty ?
      List.generate(map.length, (i) {
      return Item(
        id: map[i]['id'],
        name: map[i]['name'],
        details: map[i]['details'],
        price: map[i]['price'],
        userId: map[i]['userId'],
        sold: map[i]['sold'],
        picture: map[i]['picture'],
        createdAt: map[i]['created_at'],
        updatedAt: map[i]['updated_at'],
      );
    }) : [];
  }

  Future addItem(Item item) async {

    Database db = await instance.getDatabase();

    int status = await db.insert('items', item.toMap());

    return status;
  }

  Future deleteItem(int id) async {

    Database db = await instance.getDatabase();
    
    int status = await db.delete('items', where: 'id = ?', whereArgs: [id]);

    return status;
  }

  Future truncateTable() async {

    Database db = await instance.getDatabase();

    await db.execute('''DELETE FROM items''');
    await db.execute('''VACUUM''');
  }

  Future updateItem(Item item) async {

    Database db = await instance.getDatabase();

    int status = await db.update('items', item.toMap(),
        where: 'id = ?', whereArgs: [item.id]);

    return status;
  }
}