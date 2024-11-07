import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:handlel_app/database/dao/user_dao.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sharedComponents/main_layout/main_layout.dart';
import 'screens/createUser/create_user_screen.dart';
import 'providers/user_provider.dart';
import 'providers/theme_provider.dart';
import 'sharedComponents/theme.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart'; // .env file for secure keys

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize sqflite for desktop platforms only
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  await dotenv.load(
      fileName: "assets/.env"); // Load the .env file with api secure key

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider()
            ..loadUserFromPreferences(), // Load user on app start
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider()
            ..loadThemeFromPreferences(), // Load theme on app start
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _getInitialScreen() async {
    final userDao = UserDao();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if a user is logged in from SharedPreferences
    int? loggedInUserId = prefs.getInt('loggedInUserId');

    // Check if there are users in the database
    List<Map<String, dynamic>> users = await userDao.getUsers();

    if (users.isEmpty) {
      // No users in the database -> Go to LoginScreen
      return const CreateUserScreen();
    } else if (loggedInUserId == null) {
      // Users exist, but no one is logged in -> Go to UserListScreen
      return const MainLayout(); // Show MainLayout, UserListScreen will be one of the tabs
    } else {
      // A user is logged in -> Go to ShoppingList (or keep MainLayout)
      return const MainLayout(); // Show MainLayout with ShoppingList as the first tab
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Shopping List App',
          theme: lightTheme, // Define the light theme
          darkTheme: darkTheme, // Define the dark theme
          themeMode:
              themeProvider.themeMode, // Use theme mode from ThemeProvider
          home: FutureBuilder<Widget>(
            future: _getInitialScreen(),
            builder: (context, snapshot) {
              // Show a loading indicator while waiting for the future to complete
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              // If an error occurs, show a basic error message
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text('Error: ${snapshot.error}'),
                  ),
                );
              }

              // Once the future completes, show the initial screen
              if (snapshot.hasData) {
                return snapshot.data!;
              }

              return const Scaffold(
                body: Center(child: Text('Something went wrong!')),
              );
            },
          ),
        );
      },
    );
  }
}
