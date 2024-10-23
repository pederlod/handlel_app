import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:handlel_app/models/product.dart'; // Ensure this imports your updated Product model
import 'package:flutter/material.dart'; // For debugPrint

class ApiCaller {
  final String _baseUrl = 'https://kassal.app/api/v1/products';
  final String _apiKey = 'iK1D2q6S3OOjOwYcbbZMqwNvqQf5LdA62KzoKvqj'; // API key

  Future<List<Product>> searchProduct(String query) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$_baseUrl?search=$query&sort=price_asc'), // Adjust query params
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
}
