import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'sub/user_options_menu.dart';
import 'sub/user_database_helper.dart';
import 'package:handlel_app/providers/user_provider.dart'; // Import the UserProvider

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  UserListState createState() => UserListState();
}

class UserListState extends State<UserList> {
  final UserDatabaseHelper _userDatabaseHelper = UserDatabaseHelper();
  List<Map<String, dynamic>> _users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  // Fetch all users and update the state
  void _fetchUsers() async {
    List<Map<String, dynamic>> users = await _userDatabaseHelper.fetchUsers();
    setState(() {
      _users = users;
    });
  }

  void _renameUser(int userId, String newUsername) async {
    await _userDatabaseHelper.updateUserName(
        userId, newUsername); // Use _userDatabaseHelper
    _fetchUsers(); // Refresh the list after renaming
    if (!mounted) {
      return; // Ensure the widget is still mounted before showing the snackbar
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User renamed to $newUsername')),
    );
  }

  void _deleteUser(int userId) async {
    await _userDatabaseHelper.deleteUser(userId); // Use _userDatabaseHelper
    _fetchUsers(); // Refresh the list after deletion
    if (!mounted) {
      return; // Ensure the widget is still mounted before showing the snackbar
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User deleted successfully')),
    );
  }

  // Show a confirmation dialog for logging in as a selected user
  void _showLoginDialog(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Log in as this user?"),
          content: Text("Do you want to log in as ${user['username']}?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                // Set the selected user as the logged-in user globally via UserProvider
                Provider.of<UserProvider>(context, listen: false)
                    .logInUser(user);

                Navigator.of(context).pop(); // Close the dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Logged in as ${user['username']}')),
                );
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _users.isEmpty
              ? const Center(child: Text('No users found.'))
              : Expanded(
                  child: ListView.builder(
                    itemCount: _users.length,
                    itemBuilder: (context, index) {
                      final user = _users[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              _getUserIconColor(user['icon_color']),
                          child: Text(
                            user['username'][0]
                                .toUpperCase(), // First letter of username
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(user['username']),
                        subtitle: Text('ID: ${user['id']}'),
                        onTap: () {
                          _showLoginDialog(user);
                        },
                        trailing: UserOptionsMenu(
                          userId: user['id'],
                          username: user['username'],
                          onDelete: () => _deleteUser(user['id']),
                          onRename: (newUsername) =>
                              _renameUser(user['id'], newUsername),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }

  // Convert hex color string to Color
  Color _getUserIconColor(String? hexString) {
    if (hexString == null || hexString.isEmpty) {
      return Colors.grey; // Default to grey if no color is set
    }
    return Color(int.parse('FF${hexString.substring(1)}',
        radix: 16)); // Convert hex to Color
  }
}
