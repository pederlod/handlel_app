import 'package:flutter/material.dart';
import 'package:handlel_app/screens/kassalSearchList/kassal_search_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart'; // For storing login info
import 'sub/random_color.dart';
import 'package:handlel_app/database/dao/user_dao.dart';

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({super.key});

  @override
  CreateUserScreenState createState() => CreateUserScreenState();
}

class CreateUserScreenState extends State<CreateUserScreen> {
  final UserDao _userDao = UserDao();
  final TextEditingController _usernameController = TextEditingController();

  // Store the newly created user as the logged-in user
  Future<void> _loginUser(Map<String, dynamic> user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('loggedInUserId', user['id']);
    await prefs.setString('loggedInUsername', user['username']);
    await prefs.setString('loggedInIconColor',
        user['icon_color'] ?? '#808080'); // Default to grey if null

    // Check if the widget is still mounted before using the context
    if (!mounted) return;

    // Show the SnackBar once it's safe to use the context
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Logged in as ${user['username']}')),
    );

    // Navigate to the ShoppingList screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const KassalListScreen()),
    );
  }

  void _saveUser() async {
    String username = _usernameController.text;

    if (username.isNotEmpty) {
      String iconColor = generateRandomColor(); // Generate a random color
      int userId = await _userDao.insertUser(username, iconColor); // Save user

      // Retrieve the new user data
      Map<String, dynamic> newUser = {
        'id': userId,
        'username': username,
        'icon_color': iconColor,
      };

      // Automatically log in the new user
      await _loginUser(newUser);

      // Clear the text field
      _usernameController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username cannot be empty')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create User'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveUser,
                child: const Text('Create User'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
