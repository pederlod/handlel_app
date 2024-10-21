import 'package:flutter/material.dart';

class ShoppingListScreen extends StatelessWidget {
  const ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Your shopping list is empty!',
        style: TextStyle(fontSize: 18.0),
      ),
    );
  }
}
