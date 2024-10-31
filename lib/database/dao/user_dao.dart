import 'package:handlel_app/database/db_initializer.dart';
import 'package:handlel_app/database/db_operations.dart';

class UserDao {
  Future<int> insertUser(String username, String iconColor) async {
    final db = await DbInitializer().database;
    final dbOps = DbOperations(db);
    return await dbOps.insertData('user', {
      'username': username,
      'icon_color': iconColor,
    });
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await DbInitializer().database;
    final dbOps = DbOperations(db);
    return await dbOps.getAllRows('user');
  }

  Future<int> deleteUser(int id) async {
    final db = await DbInitializer().database;
    final dbOps = DbOperations(db);
    return await dbOps.deleteData('user', 'id = ?', [id]);
  }

  Future<int> updateUserName(int id, String newUsername) async {
    final db = await DbInitializer().database;
    final dbOps = DbOperations(db);
    return await dbOps.updateData(
      'user',
      {'username': newUsername},
      'id = ?',
      [id],
    );
  }

  Future<int> updateUserColor(int id, String newColor) async {
    final db = await DbInitializer().database;
    final dbOps = DbOperations(db);
    return await dbOps.updateData(
      'user',
      {'icon_color': newColor},
      'id = ?',
      [id],
    );
  }
}
