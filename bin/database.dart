import 'dart:async';

import 'package:sqlite3/sqlite3.dart';

class DatabaseHelper {
  late Database _database;

  Future<void> open() async {
    _database = sqlite3.open('database.db');
    _createTable();
  }

  Future<void> _createTable() async {
    _database.execute(
        'CREATE TABLE IF NOT EXISTS files (id INTEGER PRIMARY KEY AUTOINCREMENT, filename TEXT, data BLOB)');
  }

  Future<void> insertFile(String filename, List<int> data) async {
    _database.execute(
        'INSERT INTO files (filename, data) VALUES (?, ?)', [filename, data]);
  }

  Future<List<int>?> getFileBytesFromDatabase(String filename) async {
    final result = _database
        .select('SELECT data FROM files WHERE filename = ?', [filename]);
    if (result != null && result.isNotEmpty) {
      final row = result.first;
      return row['data'] as List<int>;
    }
    return null;
  }
}
