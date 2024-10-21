import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// This provider is to give acces to the currently logged in user.

class UserProvider extends ChangeNotifier {
  Map<String, dynamic>? _loggedInUser;

  // Getter to access the current logged-in user
  Map<String, dynamic>? get loggedInUser => _loggedInUser;

  // Initialize the provider by loading the user from SharedPreferences
  Future<void> loadUserFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int? userId = prefs.getInt('loggedInUserId');
    String? username = prefs.getString('loggedInUsername');
    String? iconColor = prefs.getString('loggedInIconColor');

    if (userId != null && username != null) {
      _loggedInUser = {
        'id': userId,
        'username': username,
        'icon_color': iconColor ?? '#808080', // Default to grey if missing
      };
    } else {
      _loggedInUser = null; // No user is logged in
    }

    // Notify listeners about the change in user data
    notifyListeners();
  }

  // Log in a user and store the user in SharedPreferences
  Future<void> logInUser(Map<String, dynamic> user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('loggedInUserId', user['id']);
    await prefs.setString('loggedInUsername', user['username']);
    await prefs.setString('loggedInIconColor',
        user['icon_color'] ?? '#808080'); // Default to grey if missing

    // Update the provider state
    _loggedInUser = user;
    notifyListeners();
  }

  // Log out the user and remove data from SharedPreferences
  Future<void> logOutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('loggedInUserId');
    await prefs.remove('loggedInUsername');
    await prefs.remove('loggedInIconColor');

    // Update the provider state
    _loggedInUser = null;
    notifyListeners();
  }
}
