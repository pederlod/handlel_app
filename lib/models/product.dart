import 'package:flutter/material.dart'; // For debugPrint

class Product {
  final int id;
  final String name;
  final String? ean;
  final String? brand;
  final String url;
  final double currentPrice;
  final String? imageUrl;
  final String? description;
  List<Product>? storeInstances;
  final double? currentUnitPrice;
  final double? weight;
  final String? weightUnit;
  final List<Map<String, dynamic>>? nutrition;
  final List<Map<String, dynamic>>? allergens;
  final List<Map<String, dynamic>>? priceHistory;
  final String? createdAt;
  final String? updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.ean,
    this.brand,
    required this.url,
    required this.currentPrice,
    this.imageUrl,
    this.description,
    this.storeInstances,
    this.currentUnitPrice,
    this.weight,
    this.weightUnit,
    this.nutrition,
    this.allergens,
    this.priceHistory,
    this.createdAt,
    this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Parse current_price as before
    double parsedCurrentPrice;
    double? parsedCurrentUnitPrice;
    if (json['current_price'] is Map<String, dynamic>) {
      parsedCurrentPrice = (json['current_price']['price'] as num).toDouble();
      parsedCurrentUnitPrice = json['current_price']['unit_price'] != null
          ? (json['current_price']['unit_price'] as num).toDouble()
          : null;
    } else if (json['current_price'] is num) {
      parsedCurrentPrice = (json['current_price'] as num).toDouble();
    } else {
      parsedCurrentPrice = 0.0;
    }

    // Helper function to safely parse List<Map<String, dynamic>>?
    List<Map<String, dynamic>>? parseListOfMaps(dynamic data) {
      if (data is List) {
        return data.whereType<Map<String, dynamic>>().toList();
      }
      return null;
    }

    return Product(
      id: json['id'],
      name: json['name'],
      ean: json['ean'],
      brand: json['brand'],
      url: json['url'],
      currentPrice: parsedCurrentPrice,
      currentUnitPrice: parsedCurrentUnitPrice,
      imageUrl: json['image'],
      description: json['description'],
      weight:
          json['weight'] != null ? (json['weight'] as num).toDouble() : null,
      weightUnit: json['weight_unit'],
      nutrition: parseListOfMaps(json['nutrition']),
      allergens: parseListOfMaps(json['allergens']),
      priceHistory: parseListOfMaps(json['price_history']),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class ApiResponse {
  final List<Product> products;

  ApiResponse({required this.products});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    // Check if 'data' exists and is a List
    if (json['data'] is List) {
      var productsList = (json['data'] as List)
          .map((productJson) {
            try {
              // Ensure each item is a Map before trying to parse it as a Product
              if (productJson is Map<String, dynamic>) {
                return Product.fromJson(productJson);
              } else {
                debugPrint('Unexpected product data format: $productJson');
                return null; // Skip this item if it’s not a valid Map
              }
            } catch (e) {
              debugPrint('Error parsing product: $e');
              return null; // Skip this item on error
            }
          })
          .whereType<Product>()
          .toList(); // Filter out null items

      return ApiResponse(products: productsList);
    } else {
      debugPrint('Expected a list for "data" but got ${json['data']}.');
      return ApiResponse(
          products: []); // Return empty list if "data" is not a list
    }
  }
}
