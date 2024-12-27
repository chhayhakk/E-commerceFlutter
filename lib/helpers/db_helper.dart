import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _database;

  //Initialize Database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'e-commerce_flutter.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  FutureOr<void> _createDB(Database db, int version) async {
    await db.execute(
        """CREATE TABLE tbl_users (id INTEGER PRIMARY KEY AUTOINCREMENT,username TEXT,email TEXT UNIQUE, password TEXT, address TEXT, phone TEXT, profile TEXT, gender TEXT ,isLogedIn INTEGER DEFAULT 0)""");
  }

  Future<int> createUser(String email, String password) async {
    final db = await database;
    return await db.insert(
      'tbl_users',
      {'email': email, 'password': password, 'isLogedIn': 0},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateProfile(int userId, String username, String phone,
      String gender, String profile) async {
    final db = await database;
    await db.update(
      'tbl_users',
      {
        'username': username,
        'phone': phone,
        'gender': gender,
        'isLogedIn': 1,
        'profile': profile,
      },
      where: 'id = ?',
      whereArgs: [userId],
    );
  }
}
