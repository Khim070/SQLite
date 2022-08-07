import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../Model/model.dart';

//we use table for access the
String table = 'user';

// we create this class in order to control of create class in the option
class DatabaseConnection {
  //  we use initializeUserDB() to create Database
  Future<Database> initializeUserDB() async {
    // we use appDocDir in order to store part of database into the real devices
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    String path = await getDatabasesPath();
    //'userData.db' is the name of Database
    return openDatabase(join(path, 'userData.db'),
        onCreate: (db, version) async {
      await db
          .execute('CREATE TABLE $table(id INTEGER PRIMARY KEY, name TEXT)');
    }, version: 1);
  }

// insert data into class
  Future<void> insertUser(User user) async {
    final db = await initializeUserDB();
    await db.insert(table, user.toMap());
    print('function insert');
    print(user.name);
  }

// read data from class
  Future<List<User>> getUser() async {
    final db = await initializeUserDB();
    List<Map<String, dynamic>> qresult = await db.query(table);
    return qresult.map((e) => User.fromMap(e)).toList();
  }

// delete data in class
  Future<void> deleteuser(int id) async {
    final db = await initializeUserDB();
    await db.delete(table, where: 'id=?', whereArgs: [id]);
  }

// update data in class
  Future<void> updateUser(User user) async {
    final db = await initializeUserDB();
    await db.update(table, user.toMap(), where: 'id=?', whereArgs: [user.id]);
  }
}
