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
            '$_baseUrl?search=$query&sort=name_asc&unique=1&price_min=0.01'), // Adjust query params
        headers: {
          'Authorization': 'Bearer $_apiKey', // Add valid token
        },
      );

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

  Future<Product?> getProductDetails(int productId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/id/$productId'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Product.fromJson(jsonData['data']);
      } else {
        debugPrint('Failed to fetch product details: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching product details: $e');
      return null;
    }
  }
}
