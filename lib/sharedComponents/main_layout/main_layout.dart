import 'package:flutter/material.dart';
import 'package:handlel_app/screens/browseFavorites/browse_favorites_screen.dart';
import 'package:handlel_app/screens/browseProductGroups/browser_product_groups_screen.dart';
import 'package:handlel_app/screens/shoppingList/shopping_list_screen.dart';
import 'sub/bottom_nav_bar.dart'; // Import the BottomNavBar component
import 'sub/top_bar.dart'; // Import the TopBar component
import '../../screens/kassalSearchList/kassal_search_list_screen.dart';
import '../../screens/userList/user_list.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  MainLayoutState createState() => MainLayoutState();
}

class MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  // List of pages to display based on bottom nav selection
  final List<Widget> _pages = [
    const KassalListScreen(), // Index 0
    const UserList(), // Index 1
    const BrowseFavoritesScreen(), // Index 2
    const BrowserProductGroupsScreen(), // Index 3
    const ShoppingListScreen(), // Index 4
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update selected index when a tab is tapped
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        // Pass the _onItemTapped function to TopBar so it can change the tab
        child: TopBar(onUserIconTapped: () => _onItemTapped(1)),
      ),
      body: _pages[_selectedIndex], // Display the correct page
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
