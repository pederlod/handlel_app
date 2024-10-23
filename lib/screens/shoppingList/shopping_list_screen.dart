import 'package:flutter/material.dart';
import 'package:handlel_app/sharedComponents/apiCaller/api_caller.dart';
import 'package:handlel_app/models/product.dart';
import 'package:handlel_app/screens/shoppingList/sub/shopping_list_result.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  ShoppingListScreenState createState() => ShoppingListScreenState();
}

class ShoppingListScreenState extends State<ShoppingListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Product>? _searchResults; // To store search results
  bool _isLoading = false;

  void _searchProduct() async {
    String query = _searchController.text.trim();
    if (query.isNotEmpty) {
      setState(() {
        _isLoading = true; // Show a loading indicator while searching
      });

      try {
        // Perform API search
        List<Product> results = await ApiCaller().searchProduct(query);
        setState(() {
          _searchResults = results;
        });
      } catch (e) {
        debugPrint('Error occurred while searching: $e');
      } finally {
        setState(() {
          _isLoading = false; // Stop loading after search completes
        });
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search input field
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Enter product name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Search button
            ElevatedButton(
              onPressed: _searchProduct,
              child: const Text('Search'),
            ),
            const SizedBox(height: 16),
            // Display search results or a loading indicator
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _searchResults == null
                      ? const Center(child: Text('No results found'))
                      : ShoppingListResult(products: _searchResults!),
            ),
          ],
        ),
      ),
    );
  }
}
