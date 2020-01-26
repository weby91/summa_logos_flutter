import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../model/user.dart';
import '../model/devotion.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper._internal();
  final String tableUser = "user";

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();

    return _db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute('''
    create table $tableName (
        $columnRowId integer primary key autoincrement,
        $columnId integer not null,
        $columnFullName text not null,
        $columnEmail text not null,
        $columnGender text,
        $columnSocialMediaId text,
        $columnSocialMediaPicture text,
        $columnSocialMediaLink text,
        $columnRegisteredVia text not null,
        $columnAndroidId text,
        $columnIosId text,
        $columnDeviceModel text,
        $columnAppVersion text,
        $columnReadingProgress text,
        $columnFcmToken text,
        $columnDevotions text);
  ''');

    await db.execute('''
    CREATE TABLE $tableDevotion($columnRowId INTEGER PRIMARY KEY, 
      $columnId INTEGER, $columnDay INTEGER,
      $columnWeekday TEXT, $columnDate TEXT,
      $columnBook TEXT, $columnTotalRead INTEGER,
      $columnTotalShare INTEGER, $columTotalDiscussion INTEGER,
      $columnBookParam TEXT, $columnIsFinished INTEGER);
  ''');
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    if (oldVersion < newVersion) {
      db.execute("ALTER TABLE $tableDevotion ADD COLUMN $columnMonth INTEGER NULL;");
    }
  }

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "summa_logos.db");
    var ourDb = await openDatabase(path, version: 2, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return ourDb;
  }



  // =============================== User ==============================
  Future<int> upsertUser(User user) async {
    var dbClient = await db;
    var count = Sqflite.firstIntValue(await dbClient
        .rawQuery("SELECT COUNT(*) FROM $tableName WHERE id = ?", [user.id]));
    int res;
    if (count == 0) {
      res = await dbClient.insert(tableName, user.toMap());
    } else {
      res = await dbClient.update(tableName, user.toMap(),
          where: "id = ?", whereArgs: [user.id]);
    }

    return res;
  }

  Future<int> upsertDevotion(Devotion devotion) async {
    var dbClient = await db;
    var count = Sqflite.firstIntValue(await dbClient
        .rawQuery("SELECT COUNT(*) FROM $tableDevotion WHERE id = ?", [devotion.id]));
    int res;
    if (count == 0) {
      res = await dbClient.insert(tableDevotion, devotion.toMapDb());
    } else {
      res = await dbClient.update(tableDevotion, devotion.toMapDb(),
          where: "id = ?", whereArgs: [devotion.id]);
    }

    return res;
  }

  Future<int> saveUser(User user) async {
    var dbClient = await db;

    int res = await dbClient.insert(tableName, user.toMap());
    return res;
  }

  Future<Null> saveDevotionList(Devotion devotion) async {
    var dbClient = await db;
    Batch batch = dbClient.batch();
    batch.insert(tableDevotion, devotion.toMapDb());

    var result = await batch.commit(noResult: true);
//    var result = await dbClient.insert(tableDevotion, devotion.toMapDb());
//    var result = await dbClient.rawInsert(
//        'INSERT INTO $tableNote ($columnTitle, $columnDescription) VALUES (\'${note.title}\', \'${note.description}\')');

  }

  Future<List> getAllDevotions() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableDevotion");
    return result.toList();
  }

  Future<String> getLatestDevotionDate() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT date FROM $tableDevotion ORDER BY ID DESC LIMIT 1");
    return result.toString();
  }

  Future<List> getAllUsers() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableName");
    return result.toList();
  }

  Future<User> getUser(int rowId) async {
    var dbClient = await db;
    var result = await dbClient
        .rawQuery("SELECT * FROM $tableName WHERE $columnRowId = $rowId");
    if (result == null) return null;
    return new User.fromMap(result.first);
  }

  Future<int> deleteUser(int rowId) async {
    var dbClient = await db;
    return await dbClient
        .delete(tableName, where: "$columnRowId = ?", whereArgs: [rowId]);
  }

  Future<Null> deleteAllDevotions() async {
    var dbClient = await db;
    await dbClient
        .rawQuery("DELETE FROM $tableDevotion");
  }

  Future<int> updateUser(User user) async {
    var dbClient = await db;
    return await dbClient.update(tableName, user.toMap(),
        where: "id = ?", whereArgs: [user.rowId]);
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery("SELECT COUNT(*) FROM $tableName"));
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }

  Future<bool> isLoggedIn() async {
    var dbClient = await db;
    var res = await dbClient.query(tableName);
    return res.length > 0? true: false;
  }
}
