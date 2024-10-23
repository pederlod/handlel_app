import 'package:flutter/material.dart';
import 'shopping_list_result_item.dart'; // Import the ShoppingListResultItem widget
import 'package:handlel_app/models/product.dart';
// Import your model class

class ShoppingListResult extends StatelessWidget {
  final List<Product> products;

  const ShoppingListResult({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ShoppingListResultItem(product: product);
      },
    );
  }
}
