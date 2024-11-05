import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onItemTapped, // Call the provided function when an item is tapped
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.search_outlined),
          label: 'Find product',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Users',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'Shopping List',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'favorites',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.balance_rounded),
          label: 'groups',
        ),
      ],
    );
  }
}
