import 'package:flutter/material.dart';
import 'package:handlel_app/sharedComponents/apiCaller/api_caller.dart';
import 'package:handlel_app/models/product.dart';
import 'package:handlel_app/screens/kassalSearchList/sub/kassal_list_result.dart';

class KassalListScreen extends StatefulWidget {
  const KassalListScreen({super.key});

  @override
  KassalListScreenState createState() => KassalListScreenState();
}

class KassalListScreenState extends State<KassalListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Product>? _searchResults;
  bool _isLoading = false;

  void _searchProduct() async {
    String query = _searchController.text.trim();
    if (query.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      try {
        List<Product> results = await ApiCaller().searchProduct(query);
        setState(() {
          _searchResults = results;
        });
      } catch (e) {
        debugPrint('Error occurred while searching: $e');
      } finally {
        setState(() {
          _isLoading = false;
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
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Search Input and Button
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Enter product name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchProduct,
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Sorting and Filtering Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSortButton('Shop'),
                _buildSortButton('Price'),
                _buildSortButton('More'),
                _buildSortButton('Asc'),
              ],
            ),
            const SizedBox(height: 8),

            // Search Results
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _searchResults == null
                      ? const Center(child: Text('No results found'))
                      : KassalListResult(products: _searchResults!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortButton(String label) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        textStyle: const TextStyle(fontSize: 12),
      ),
      onPressed: () {
        // Sorting logic can be implemented here
      },
      child: Text(label),
    );
  }
}
