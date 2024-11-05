import 'package:flutter/material.dart';
import 'kassal_list_result_item.dart'; // Import the KassalListResultItem widget
import 'package:handlel_app/models/product.dart';
// Import your model class

class KassalListResult extends StatelessWidget {
  final List<Product> products;

  const KassalListResult({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return KassalListResultItem(product: product);
      },
    );
  }
}
