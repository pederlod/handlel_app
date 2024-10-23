import 'package:flutter/material.dart';
import 'package:handlel_app/database/db_helper.dart';

class UserDatabaseHelper {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Fetch all users from the database
  Future<List<Map<String, dynamic>>> fetchUsers() async {
    List<Map<String, dynamic>> users = await _dbHelper.getUsers();

    // Check if any user's icon_color is null and set it to grey
    for (var user in users) {
      if (user['icon_color'] == null || user['icon_color'].isEmpty) {
        await _dbHelper.updateUserColor(
            user['id'], '#808080'); // Set to grey in the database
      }
    }

    return users;
  }

  // Delete a user from the database
  Future<void> deleteUser(int userId) async {
    await _dbHelper.deleteUser(userId);
  }

  // Convert hex color string to Color
  Color hexToColor(String hexString) {
    return Color(
        int.parse('FF${hexString.substring(1)}', radix: 16)); // Add alpha value
  }

  // Update the username of a user
  Future<void> updateUserName(int userId, String newUsername) async {
    await _dbHelper.updateUserName(
        userId, newUsername); // Use the method from db_helper
  }
}
