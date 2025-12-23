// ============================================
// lib/models/service_models.dart
// ============================================

class Service {
  final int id;
  final String name;
  final String description;
  final String? icon;
  final String? image;
  final double? price;
  final String duration;
  final bool isActive;
  final int order;

  Service({
    required this.id,
    required this.name,
    required this.description,
    this.icon,
    this.image,
    this.price,
    required this.duration,
    required this.isActive,
    required this.order,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'],
      image: json['image'],
      price: json['price'] != null ? double.tryParse(json['price'].toString()) : null,
      duration: json['duration'] ?? '',
      isActive: json['is_active'] ?? true,
      order: json['order'] ?? 0,
    );
  }
}
