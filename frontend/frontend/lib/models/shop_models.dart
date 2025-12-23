// ============================================
// lib/models/shop_models.dart
// ============================================

class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final String? image;
  final String? categoryName;
  final int stockQuantity;
  final bool isAvailable;
  final bool isFeatured;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.image,
    this.categoryName,
    required this.stockQuantity,
    required this.isAvailable,
    required this.isFeatured,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] != null ? double.tryParse(json['price'].toString()) ?? 0.0 : 0.0,
      image: json['image'],
      categoryName: json['category_name'],
      stockQuantity: json['stock_quantity'] ?? 0,
      isAvailable: json['is_available'] ?? true,
      isFeatured: json['is_featured'] ?? false,
    );
  }
}
