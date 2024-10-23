import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:handlel_app/models/product.dart';

class ShoppingListResultItem extends StatelessWidget {
  final Product product;

  const ShoppingListResultItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Caching the image and handling potential errors or missing image URLs
          CachedNetworkImage(
            imageUrl: product.imageUrl ??
                'https://via.placeholder.com/150', // Fallback to a placeholder
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) =>
                const Icon(Icons.error), // Error icon for invalid URLs
            fit: BoxFit.cover,
            height: 100, // Fixed image height
            width: double.infinity, // Full width for a uniform layout
          ),
          ListTile(
            title: Text(product.name),
            subtitle: Text(
                'Brand: ${product.brand}\nPrice: \$${product.currentPrice.toStringAsFixed(2)}'),
            trailing: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                // Action when clicking on the cart icon
              },
            ),
          ),
        ],
      ),
    );
  }
}
