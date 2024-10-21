import 'package:flutter/material.dart';
import 'package:handlel_app/screens/createUser/create_user_screen.dart';
import 'package:provider/provider.dart';
import 'package:handlel_app/providers/user_provider.dart';
import 'settings_dropdown.dart'; // Import the settings dropdown

class TopBar extends StatelessWidget {
  final VoidCallback onUserIconTapped; // Add callback to notify about the tap

  const TopBar({super.key, required this.onUserIconTapped});

  @override
  Widget build(BuildContext context) {
    final loggedInUser = Provider.of<UserProvider>(context).loggedInUser;

    return AppBar(
      title: const Text('Shopping List App'),
      actions: [
        // Add cogwheel icon (settings) with a PopupMenuButton
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: PopupMenuButton<int>(
            icon: const Icon(Icons.settings), // Cogwheel icon
            offset: const Offset(100, 50), // Adjust the offset
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<int>(
                value: 1, // Placeholder
                child: SettingsDropdown(), // Settings dropdown menu
              ),
            ],
          ),
        ),

        // User icon (if logged in) or account icon (if not logged in)
        if (loggedInUser != null) ...[
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: onUserIconTapped, // Call the callback when tapped
              child: CircleAvatar(
                backgroundColor: _getUserIconColor(loggedInUser['icon_color']),
                child: Text(
                  loggedInUser['username'][0].toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ] else ...[
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                // Navigate to login screen when no user is logged in
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreateUserScreen()),
                );
              },
              child: const Icon(Icons.account_circle),
            ),
          ),
        ],
      ],
    );
  }

  // Convert hex color string to Color
  Color _getUserIconColor(String? hexString) {
    if (hexString == null || hexString.isEmpty) {
      return Colors.grey;
    }
    return Color(int.parse('FF${hexString.substring(1)}', radix: 16));
  }
}
