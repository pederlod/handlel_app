import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:handlel_app/providers/theme_provider.dart'; // Import ThemeProvider

class SettingsDropdown extends StatelessWidget {
  const SettingsDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return InkWell(
      onTap: () {
        themeProvider.toggleTheme(
            !isDarkMode); // Toggle theme when entire area is tapped
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 16.0), // Add padding for a larger tappable area
        child: Row(
          children: [
            Icon(
              isDarkMode
                  ? Icons.wb_sunny
                  : Icons
                      .nightlight_round, // Sun for dark mode, Moon for light mode
              color: isDarkMode
                  ? Colors.yellow
                  : Colors.blueGrey, // Yellow for sun, BlueGrey for moon
            ),
            const SizedBox(width: 10), // Space between icon and text
            Text(
              isDarkMode ? "Light Mode" : "Dark Mode",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium, // Use theme-aware text style
            ),
          ],
        ),
      ),
    );
  }
}
