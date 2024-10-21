import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  // Singleton pattern: ensure only one instance of the database is created.
  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  // Add debugPrint here to trace the getter execution
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
      version: 2, // Update version number to trigger upgrade
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE user (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          username TEXT,
          icon_color TEXT  // Add the icon_color field here
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

// Insert a new user into the database with a random icon color
  Future<int> insertUser(String username, String iconColor) async {
    final db = await database;
    return await db.insert('user', {
      'username': username,
      'icon_color': iconColor // Store the color in hex format
    });
  }

  // Retrieve all users from the user table
  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query('user'); // Fetch all rows from the 'user' table
  }

  // Delete a user by ID
  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete('user', where: 'id = ?', whereArgs: [id]);
  }

  // Method to update the user's username in the database
  Future<int> updateUserName(int id, String newUsername) async {
    final db = await database;
    return await db.update(
      'user',
      {'username': newUsername},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateUserColor(int id, String newColor) async {
    final db = await database;
    return await db.update(
      'user',
      {'icon_color': newColor}, // Update the icon_color field
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
