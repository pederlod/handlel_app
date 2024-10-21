import 'dart:math';
import 'package:flutter/material.dart';

// Generate a random color
String generateRandomColor() {
  final random = Random();
  Color randomColor = Color.fromARGB(
    255, // Full opacity
    random.nextInt(256), // Red (0-255)
    random.nextInt(256), // Green (0-255)
    random.nextInt(256), // Blue (0-255)
  );

  // Convert the color to a hex string (without the alpha value)
  return '#${randomColor.value.toRadixString(16).padLeft(8, '0').substring(2)}';
}
