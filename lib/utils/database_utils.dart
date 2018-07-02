import 'dart:async';
import 'dart:io';

import 'package:notodo_app_3challenge/models/nodo_item.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const String tableName = "table_notodo";
  static const String columnId = "id";
  static const String columnItemName = "item_name";
  static const String columnDateCreated = "date_created";

  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;
  static Database _db;

  Future<Database> get getDb async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "no_todo_db.db");
    var dbCreated = await openDatabase(path, version: 1, onCreate: _onCreate);
    return dbCreated;
  }

  void _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $tableName("
        "$columnId INTEGER PRIMARY KEY, "
        "$columnItemName TEXT, "
        "$columnDateCreated TEXT);");
  }

  Future<int> saveItem(NoDoItem item) async {
    var dbClient = await getDb;
    int rowsSaved = await dbClient.insert(tableName, item.toMap());
    return rowsSaved;
  }

  Future<List> getItems() async {
    var dbClient = await getDb;
    var result = await dbClient.rawQuery("SELECT * FROM $tableName");
    return result.toList();
  }

  Future<int> getCount() async {
    var dbClient = await getDb;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery("SELECT COUNT (*) FROM $tableName"));
  }

  Future<NoDoItem> getItem(int itemId) async {
    var dbClient = await getDb;
    var item = await dbClient
        .rawQuery("SELECT * FROM ${tableName} WHERE $columnId=$itemId");
    if (item.length == 0) return null;
    return new NoDoItem.fromMap(item.first);
  }

  Future<int> deleteItem(int id) async {
    var db = await getDb;
    int rowsDeleted =
        await db.delete(tableName, where: "$columnId = ?", whereArgs: [id]);
    return rowsDeleted;
  }

  Future<int> updateItem(NoDoItem item) async {
    int id = item.id;
    print("id of the item is $id");
    var db = await getDb;
    int rowsUpdated = await db.update("$tableName", item.toMap(),
        where: "$columnId  = ?", whereArgs: [item.id]);
    return rowsUpdated;
  }

  Future close() async {
    var dbClient = await getDb;
    dbClient.close();
  }
}
