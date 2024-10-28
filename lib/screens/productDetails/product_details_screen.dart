import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:handlel_app/sharedComponents/apiCaller/api_caller.dart';
import 'package:handlel_app/models/product.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  ProductDetailsScreenState createState() => ProductDetailsScreenState();
}

class ProductDetailsScreenState extends State<ProductDetailsScreen> {
  Product? _product;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchProductDetails();
  }

  Future<void> _fetchProductDetails() async {
    try {
      _product = await ApiCaller().getProductDetails(widget.productId);
      setState(() {
        _isLoading = false;
        _hasError = _product == null;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  Widget _buildNutritionInfo(List<Map<String, dynamic>>? nutrition) {
    if (nutrition == null || nutrition.isEmpty) {
      return const Text('No nutrition information available.');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: nutrition.map((item) {
        return Text(
            '${item['display_name']}: ${item['amount']} ${item['unit']}');
      }).toList(),
    );
  }

  Widget _buildPriceHistory(List<Map<String, dynamic>>? history) {
    if (history == null || history.isEmpty) {
      return const Text('No price history available.');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: history.map((item) {
        return Text('${item['date']}: ${item['price']} kr');
      }).toList(),
    );
  }

  Widget _buildAllergenInfo(List<Map<String, dynamic>>? allergens) {
    if (allergens == null || allergens.isEmpty) {
      return const Text('No allergen information available.');
    }

    // Filter allergens to only include those with "contains": "YES"
    final presentAllergens = allergens
        .where((allergen) => allergen['contains'] == 'YES')
        .map((allergen) => allergen['display_name'])
        .toList();

    if (presentAllergens.isEmpty) {
      return const Text('No allergens present.');
    }

    return Text('Allergens: ${presentAllergens.join(', ')}');
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_hasError || _product == null) {
      return const Scaffold(
        body: Center(child: Text('Failed to load product details')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(_product!.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                color: Colors.white, // Background color around the image
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, // Padding on the sides
                    vertical: 8), // Padding on the top and bottom
                child: CachedNetworkImage(
                  imageUrl:
                      _product!.imageUrl ?? 'https://via.placeholder.com/150',
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.contain,
                  width: MediaQuery.of(context).size.width *
                      0.9, // 90% of screen width
                  height: 200, // Minimum height for the image
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _product!.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Brand: ${_product!.brand ?? 'Unknown'}'),
            Text('Price: ${_product!.currentPrice} kr'),
            if (_product!.currentUnitPrice != null)
              Text('Unit Price: ${_product!.currentUnitPrice} kr'),
            if (_product!.weight != null && _product!.weightUnit != null)
              Text('Weight: ${_product!.weight} ${_product!.weightUnit}'),
            const SizedBox(height: 16),
            Text(_product!.description ?? 'No description available.'),
            const SizedBox(height: 16),
            Text('Nutrition Information:',
                style: Theme.of(context).textTheme.headlineSmall),
            _buildNutritionInfo(_product!.nutrition),
            const SizedBox(height: 16),
            _buildAllergenInfo(_product!.allergens),
            const SizedBox(height: 16),
            Text('Price History:',
                style: Theme.of(context).textTheme.headlineSmall),
            _buildPriceHistory(_product!.priceHistory),
            const SizedBox(height: 16),
            Text('Created At: ${_product!.createdAt ?? 'N/A'}'),
            Text('Updated At: ${_product!.updatedAt ?? 'N/A'}'),
          ],
        ),
      ),
    );
  }
}
