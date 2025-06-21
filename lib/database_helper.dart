import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database?> get database async {
    if (kIsWeb) return null;
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'user_profile.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE user_profile (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT,
            date_of_birth TEXT,
            city TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion == 1) {
          await db.execute('ALTER TABLE user_profile ADD COLUMN city TEXT');
        }
      },
    );
  }

  // Save profile with city
  static Future<void> saveProfile(String username, String dob, String city) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username);
      await prefs.setString('date_of_birth', dob);
      await prefs.setString('city', city);
      return;
    }

    final db = await database;
    if (db == null) return;

    final existing = await db.query('user_profile', limit: 1);
    final data = {
      'username': username,
      'date_of_birth': dob,
      'city': city,
    };

    if (existing.isNotEmpty) {
      await db.update('user_profile', data, where: 'id = ?', whereArgs: [existing.first['id']]);
    } else {
      await db.insert('user_profile', data);
    }
  }

  // Get profile with default city = Mumbai
  static Future<Map<String, String>> getProfile() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      return {
        'username': prefs.getString('username') ?? 'Guest',
        'date_of_birth': prefs.getString('date_of_birth') ?? '',
        'city': prefs.getString('city') ?? 'Mumbai',
      };
    }

    final db = await database;
    if (db == null) return {'username': 'Guest', 'date_of_birth': '', 'city': 'Mumbai'};

    final result = await db.query('user_profile', limit: 1);
    if (result.isNotEmpty) {
      return {
        'username': result[0]['username'] as String,
        'date_of_birth': result[0]['date_of_birth'] as String,
        'city': result[0]['city'] as String? ?? 'Mumbai',
      };
    }
    return {'username': 'Guest', 'date_of_birth': '', 'city': 'Mumbai'};
  }

  static Future<void> clearProfile() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('username');
      await prefs.remove('date_of_birth');
      await prefs.remove('city');
      return;
    }

    final db = await database;
    if (db != null) {
      await db.delete('user_profile');
    }
  }
}
