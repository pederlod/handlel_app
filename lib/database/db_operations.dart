import 'package:sqflite/sqflite.dart';

//Basic, reusable CRUD operations for SQLite. Used by the DAO classes to preform more specific operations.

class DbOperations {
  final Database db;

  DbOperations(this.db);

  Future<int> insertData(String table, Map<String, dynamic> values) async {
    return await db.insert(table, values);
  }

  Future<int> updateData(String table, Map<String, dynamic> values,
      String where, List<dynamic> whereArgs) async {
    return await db.update(table, values, where: where, whereArgs: whereArgs);
  }

  Future<int> deleteData(
      String table, String where, List<dynamic> whereArgs) async {
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }

  Future<List<Map<String, dynamic>>> getAllRows(String table) async {
    return await db.query(table);
  }

  Future<Map<String, dynamic>?> getRowById(String table, int id) async {
    final results = await db.query(table, where: 'id = ?', whereArgs: [id]);
    return results.isNotEmpty ? results.first : null;
  }
}
