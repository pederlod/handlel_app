import 'package:flutter/material.dart';
import 'package:handlel_app/database/dao/user_dao.dart';

class UserDatabaseHelper {
  final UserDao _userDao = UserDao();

  // Fetch all users from the database
  Future<List<Map<String, dynamic>>> fetchUsers() async {
    List<Map<String, dynamic>> users = await _userDao.getUsers();

    // Check if any user's icon_color is null and set it to grey
    for (var user in users) {
      if (user['icon_color'] == null || user['icon_color'].isEmpty) {
        await _userDao.updateUserColor(
            user['id'], '#808080'); // Set to grey in the database
      }
    }

    return users;
  }

  // Delete a user from the database
  Future<void> deleteUser(int userId) async {
    await _userDao.deleteUser(userId);
  }

  // Convert hex color string to Color
  Color hexToColor(String hexString) {
    return Color(
        int.parse('FF${hexString.substring(1)}', radix: 16)); // Add alpha value
  }

  // Update the username of a user
  Future<void> updateUserName(int userId, String newUsername) async {
    await _userDao.updateUserName(
        userId, newUsername); // Use the method from db_helper
  }
}
