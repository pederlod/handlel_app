import 'package:flutter/material.dart';
import 'package:handlel_app/sharedComponents/apiCaller/api_caller.dart'; // Import the API caller
import 'package:handlel_app/models/product.dart'; // Import the Product model
import 'package:handlel_app/screens/kassalSearchList/sub/kassal_list_result.dart'; // Import your container widget to show results

class KassalSearchInput extends StatefulWidget {
  const KassalSearchInput({super.key});

  @override
  KassalSearchInputState createState() => KassalSearchInputState();
}

class KassalSearchInputState extends State<KassalSearchInput> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _searchResults = []; // Store search results
  bool _isLoading = false; // To track loading state

  void _searchProduct() async {
    String query = _searchController.text.trim();
    if (query.isNotEmpty) {
      setState(() {
        _isLoading = true; // Show loading indicator while searching
      });

      try {
        // Call the API and fetch the search results
        List<Product> results = await ApiCaller().searchProduct(query);
        setState(() {
          _searchResults = results; // Update the search results
        });
      } catch (e) {
        debugPrint('Error during search: $e');
      } finally {
        setState(() {
          _isLoading = false; // Hide loading indicator when done
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Enter product name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _searchProduct, // Trigger the API call on button press
              child: const Text('Search'),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator() // Show loading indicator
                : Expanded(
                    child: _searchResults.isNotEmpty
                        ? KassalListResult(
                            products: _searchResults) // Show results
                        : const Center(
                            child: Text(
                                'No results found')), // Show message if no results
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
