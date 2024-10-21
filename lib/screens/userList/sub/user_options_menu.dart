import 'package:flutter/material.dart';

class UserOptionsMenu extends StatelessWidget {
  final int userId;
  final String username;
  final VoidCallback onDelete;
  final Function(String) onRename; // Callback to rename the user

  const UserOptionsMenu({
    super.key,
    required this.userId,
    required this.username,
    required this.onDelete,
    required this.onRename, // Add callback for renaming
  });

  // Show a confirmation dialog before deleting a user
  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete User"),
          content: Text("Are you sure you want to delete $username?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                onDelete(); // Call the delete function
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  // Show a dialog to rename the user
  void _showRenameDialog(BuildContext context) {
    final TextEditingController renameController =
        TextEditingController(text: username);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Rename User"),
          content: TextField(
            controller: renameController,
            decoration: const InputDecoration(
              labelText: 'New username',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                String newUsername = renameController.text.trim();
                if (newUsername.isNotEmpty) {
                  Navigator.of(context).pop(); // Close the dialog
                  onRename(newUsername); // Call the rename function
                }
              },
              child: const Text("Rename"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      onSelected: (int result) {
        if (result == 1) {
          _showRenameDialog(context); // Show rename dialog
        } else if (result == 2) {
          _showDeleteConfirmation(context); // Show delete confirmation dialog
        }
      },
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem<int>(
          value: 1,
          child: Row(
            children: [
              Icon(Icons.edit, color: Colors.blue),
              SizedBox(width: 8),
              Text('Rename User'),
            ],
          ),
        ),
        const PopupMenuItem<int>(
          value: 2,
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red),
              SizedBox(width: 8),
              Text('Delete User'),
            ],
          ),
        ),
      ],
    );
  }
}
