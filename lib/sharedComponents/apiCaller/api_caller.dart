import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:handlel_app/models/product.dart'; // Ensure this imports your updated Product model
import 'package:flutter/material.dart'; // For debugPrint
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import dotenv for API key access

class ApiCaller {
  final String _baseUrl = 'https://kassal.app/api/v1/products';
  final String _apiKey = dotenv.env['API_KEY'] ?? ''; // API key from .env file

  Future<List<Product>> searchProduct(String query) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$_baseUrl?search=$query&sort=name_asc&unique=1&price_min=0.01&exclude_without_ean=1'),
        headers: {
          'Authorization': 'Bearer $_apiKey', // Add valid token
        },
      );

      debugPrint('Response status: ${response.statusCode}');
      //debugPrint('Response body: ${response.body}'); // dont fill th enetire debug console with a debug response lol.

      if (response.statusCode == 200) {
        debugPrint('API call success, parsing data...');
        final Map<String, dynamic> jsonData = json.decode(response.body);
        ApiResponse apiResponse = ApiResponse.fromJson(jsonData);
        return apiResponse.products;
      } else {
        debugPrint(
            'Failed to fetch products. Status code: ${response.statusCode}');
        return [];
      }
    } catch (error, stackTrace) {
      debugPrint('Error during product search: $error');
      debugPrint('Stack trace: $stackTrace');
      return [];
    }
  }

  Future<Product?> getProductDetailsWithStores(int productId) async {
    try {
      // First API call: Get the main product details
      final productResponse = await http.get(
        Uri.parse('$_baseUrl/id/$productId'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
        },
      );

      if (productResponse.statusCode != 200) {
        debugPrint(
            'Failed to fetch product details: ${productResponse.statusCode}');
        return null;
      }

      // Parse the main product details from the first response
      final productJson = json.decode(productResponse.body)['data'];
      Product mainProduct = Product.fromJson(productJson);

      // Check if EAN is available in the product details
      if (mainProduct.ean == null || mainProduct.ean!.isEmpty) {
        debugPrint(
            "No EAN found for product ID: $productId, skipping store-specific fetch.");
        return mainProduct;
      }

      debugPrint(
          "Fetching store instances using EAN: ${mainProduct.ean} for product ID: $productId");

      // Second API call: Get all store-specific instances of the product using EAN
      final storesResponse = await http.get(
        Uri.parse('$_baseUrl/ean/${mainProduct.ean}'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
        },
      );

      if (storesResponse.statusCode == 200) {
        final storesData =
            json.decode(storesResponse.body)['data']['products'] as List;

        // Parse each store-specific product from the 'products' list
        List<Product> storeInstances =
            storesData.map((json) => Product.fromJson(json)).toList();

        // Assign the list of store-specific instances to the main product
        mainProduct.storeInstances = storeInstances;

        debugPrint(
            'Store instances found: ${mainProduct.storeInstances!.length}');
      } else {
        debugPrint(
            'Failed to fetch store-specific instances: ${storesResponse.statusCode}');
      }

      return mainProduct;
    } catch (e) {
      debugPrint('Error fetching product details with stores: $e');
      return null;
    }
  }
}
