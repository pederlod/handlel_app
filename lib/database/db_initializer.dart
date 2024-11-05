import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';

class DbInitializer {
  static final DbInitializer _instance = DbInitializer._internal();
  static Database? _database;

  // Singleton pattern
  factory DbInitializer() {
    return _instance;
  }

  DbInitializer._internal();

  Future<Database> get database async {
    if (_database != null) {
      debugPrint("Database already initialized.");
      return _database!;
    }
    debugPrint("Initializing the database.");
    _database = await _initDatabase();
    debugPrint("Database initialized successfully.");
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_database.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE user (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT,
            icon_color TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute("ALTER TABLE user ADD COLUMN icon_color TEXT");
        }
      },
    );
  }
}
