class Product {
  final int id;
  final String name;
  final String brand;
  final String url;
  final double currentPrice;
  final String? imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.url,
    required this.currentPrice,
    this.imageUrl, // imageUrl can be null
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      brand: json['brand'] ??
          'Unknown', // Default to 'Unknown' if brand is missing
      url: json['url'],
      currentPrice: json['current_price'] != null
          ? (json['current_price'] as num).toDouble()
          : 0.0, // Fallback for missing or invalid prices
      imageUrl: json['image'], // May be null, and we handle that in the UI
    );
  }
}

class ApiResponse {
  final List<Product> products;

  ApiResponse({required this.products});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    var productsList = (json['data'] as List)
        .map((productJson) => Product.fromJson(productJson))
        .toList();
    return ApiResponse(products: productsList);
  }
}
