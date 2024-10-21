import 'package:flutter/material.dart';

// Define the light theme
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.black),
  ),
  iconTheme: const IconThemeData(color: Colors.black),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.blue,
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.black,
  ),
);

// Define the dark theme
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.blueGrey,
  scaffoldBackgroundColor: Colors.blueGrey[800],
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 38, 41, 43),
    foregroundColor: Colors.white,
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.white),
  ),
  iconTheme: const IconThemeData(color: Colors.white),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color.fromARGB(255, 38, 41, 43),
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.grey,
  ),
);
