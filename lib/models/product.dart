class Product {
  final int id;
  final String name;
  final String? brand;
  final String url;
  final double currentPrice;
  final String? imageUrl;
  final String? description;
  final List<Map<String, dynamic>>? allergens; // Changed to Map structure
  final List<Map<String, dynamic>>? nutrition;
  final List<Map<String, dynamic>>? priceHistory;
  final String? createdAt;
  final String? updatedAt;
  final double? currentUnitPrice;
  final double? weight;
  final String? weightUnit;

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.url,
    required this.currentPrice,
    this.imageUrl,
    this.description,
    this.allergens,
    this.nutrition,
    this.priceHistory,
    this.createdAt,
    this.updatedAt,
    this.currentUnitPrice,
    this.weight,
    this.weightUnit,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      brand: json['brand'] ?? 'Unknown',
      url: json['url'],
      currentPrice: (json['current_price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['image'],
      description: json['description'],
      allergens: (json['allergens'] as List<dynamic>?)
          ?.map((allergen) => {
                'display_name': allergen['display_name'],
                'contains': allergen['contains'],
              })
          .toList(),
      nutrition: (json['nutrition'] as List<dynamic>?)
          ?.map((item) => {
                'display_name': item['display_name'],
                'amount': item['amount'],
                'unit': item['unit'],
              })
          .toList(),
      priceHistory: (json['price_history'] as List<dynamic>?)
          ?.map((item) => {
                'price': item['price'],
                'date': item['date'],
              })
          .toList(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      currentUnitPrice: (json['current_unit_price'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      weightUnit: json['weight_unit'],
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
