import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:handlel_app/models/product.dart';
import 'package:handlel_app/screens/productDetails/product_details_screen.dart';

class KassalListResultItem extends StatelessWidget {
  final Product product;

  const KassalListResultItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(productId: product.id),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CachedNetworkImage(
                imageUrl: product.imageUrl ?? 'https://via.placeholder.com/50',
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Brand: ${product.brand ?? 'Unknown'}',
                      style: const TextStyle(fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${product.currentPrice.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.favorite_border,
                        color: Colors.red, size: 20),
                    onPressed: () {
                      // Add to favorites logic
                    },
                  ),
                  IconButton(
                    icon:
                        const Icon(Icons.balance, color: Colors.blue, size: 20),
                    onPressed: () {
                      // Compare item logic
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.shopping_cart,
                        color: Colors.green, size: 20),
                    onPressed: () {
                      // Add to cart logic
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
