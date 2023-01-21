import 'package:flutter_front/models/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_front/models/item.dart';


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
          CREATE TABLE users(id INTEGER PRIMARY KEY, name TEXT, contactNo TEXT, 
          picture TEXT, email TEXT, address TEXT)
    ''');
    await db.execute('''
          CREATE TABLE items(id INTEGER PRIMARY KEY, name TEXT, details TEXT,
          price REAL, userId INTEGER, sold TEXT, picture TEXT, soldTo TEXT, 
          created_at TEXT, updated_at TEXT,
          FOREIGN KEY(userId) REFERENCES users(id))
    ''');
  }

  Future <dynamic> users() async {

    Database db = await instance.getDatabase();

    final List<Map<String, dynamic>> map = await db.query('users');

    return map.isNotEmpty ?
        List.generate(map.length, (i) {
          return User(
            id: map[i]['id'],
            name: map[i]['name'],
            contactNo: map[i]['contactNo'],
            picture: map[i]['picture'],
            email: map[i]['email'],
            address: map[i]['address'],
          );
        }) : [];
  }

  Future <dynamic> fetchUser(int id) async {

    Database db = await instance.getDatabase();

    final List<Map<String, Object?>> map = await db.query('users', columns: ['name', 'contactNo', 'address'], where: 'id', whereArgs: [id]);

    return User.fromMapObject(map[0]);
  }

  Future addUser (User user) async {

    Database db = await instance.getDatabase();

    int status = await db.insert('users', user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

    return status;
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

  Future <dynamic> otherItems(int id) async {

    Database db = await instance.getDatabase();
    print(id);

    final List<Map<String, dynamic>> map = await db.query('items', where: "userId != ?", whereArgs: [id]);
    print(map);

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

  Future fetchItemSeller (int userId) async {

    Database db = await instance.getDatabase();

    final List<Map<String, dynamic>> map = await db.query('users', where: "id = ?", whereArgs: [userId]);

    Map seller = {
      'name' : map[0]['name'],
      'address' : map[0]['address']
    };

    return map.isNotEmpty ?
        seller : {'name' : "User", 'address' : "Address"};
  }

  Future <List<Item>> myListings(int id) async {

    Database db = await instance.getDatabase();

    final List<Map<String, dynamic>> map = await db.query('items', where: "userId = ?", whereArgs: [id]);

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

  Future <List<Item>> myPurchases (String name) async {

    Database db = await instance.getDatabase();

    final List<Map<String, dynamic>> map = await db.query('items', where: "soldTo = ?", whereArgs: [name]);

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

  Future addItemMap(Map <String, Object> item) async {

    Database db = await instance.getDatabase();

    int status = await db.insert('items', item);

    return status;
  }

  Future deleteItem(int id) async {

    Database db = await instance.getDatabase();
    
    int status = await db.delete('items', where: 'id = ?', whereArgs: [id]);

    return status;
  }

  Future truncateTable(String tableName) async {

    Database db = await instance.getDatabase();

    await db.execute('''DELETE FROM $tableName''');
    await db.execute('''VACUUM''');
  }

  Future updateItem(Item item) async {

    Database db = await instance.getDatabase();

    int status = await db.update('items', item.toMap(),
        where: 'id = ?', whereArgs: [item.id]);

    return status;
  }
}