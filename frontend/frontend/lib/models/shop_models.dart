// ============================================
// lib/models/shop_models.dart
// ============================================

class Product {
  final int id;
  final String slug;
  final String name;
  final String description;
  final String? shortDescription;
  final double price;
  final double discountedPrice;
  final int discountPercentage;
  final double savings;
  final String? image;
  final List<String>? galleryImages;
  final String? categoryName;
  final int categoryId;
  final String? sku;
  final int stock;
  final bool inStock;
  final bool isFeatured;
  final bool isActive;
  final double averageRating;
  final int reviewCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Product({
    required this.id,
    required this.slug,
    required this.name,
    required this.description,
    this.shortDescription,
    required this.price,
    required this.discountedPrice,
    required this.discountPercentage,
    required this.savings,
    this.image,
    this.galleryImages,
    this.categoryName,
    required this.categoryId,
    this.sku,
    required this.stock,
    required this.inStock,
    required this.isFeatured,
    required this.isActive,
    required this.averageRating,
    required this.reviewCount,
    this.createdAt,
    this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      slug: json['slug'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      shortDescription: json['short_description'],
      price: _parseDouble(json['price']),
      discountedPrice: _parseDouble(json['discounted_price']),
      discountPercentage: json['discount_percentage'] ?? 0,
      savings: _parseDouble(json['savings']),
      image: json['image'],
      galleryImages: json['gallery_images'] != null ? List<String>.from(json['gallery_images']) : null,
      categoryName: json['category_name'],
      categoryId: json['category_id'] ?? 0,
      sku: json['sku'],
      stock: json['stock'] ?? 0,
      inStock: json['in_stock'] ?? true,
      isFeatured: json['is_featured'] ?? false,
      isActive: json['is_active'] ?? true,
      averageRating: _parseDouble(json['average_rating']),
      reviewCount: json['review_count'] ?? 0,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'slug': slug,
    'name': name,
    'description': description,
    'short_description': shortDescription,
    'price': price,
    'discount_percentage': discountPercentage,
    'stock': stock,
    'image': image,
    'sku': sku,
  };
}

class CartItem {
  final int id;
  int quantity;
  final Product product;
  final DateTime? addedAt;

  CartItem({
    required this.id,
    required this.quantity,
    required this.product,
    this.addedAt,
  });

  double get subtotal => product.price * quantity;
  double get discountedSubtotal => product.discountedPrice * quantity;
  double get discountSavings => subtotal - discountedSubtotal;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] ?? 0,
      quantity: json['quantity'] ?? 1,
      product: Product.fromJson(json['product'] ?? {}),
      addedAt: json['added_at'] != null ? DateTime.parse(json['added_at']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'product_id': product.id,
    'quantity': quantity,
  };
}

class Cart {
  final int id;
  final List<CartItem> items;
  final double totalAmount;
  final double discountedAmount;
  final double totalDiscount;
  final int totalItems;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Cart({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.discountedAmount,
    required this.totalDiscount,
    required this.totalItems,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    final itemsList = (json['items'] as List?)?.map((i) => CartItem.fromJson(i)).toList() ?? [];
    
    return Cart(
      id: json['id'] ?? 0,
      items: itemsList,
      totalAmount: Product._parseDouble(json['total_amount']),
      discountedAmount: Product._parseDouble(json['discounted_amount']),
      totalDiscount: Product._parseDouble(json['total_discount']),
      totalItems: json['total_items'] ?? 0,
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }
}

class OrderItem {
  final int id;
  final int productId;
  final String productName;
  final String? productImage;
  final int quantity;
  final double price;
  final double subtotal;

  OrderItem({
    required this.id,
    required this.productId,
    required this.productName,
    this.productImage,
    required this.quantity,
    required this.price,
    required this.subtotal,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] ?? 0,
      productId: json['product'] ?? 0,
      productName: json['product_name'] ?? '',
      productImage: json['product_image'],
      quantity: json['quantity'] ?? 0,
      price: Product._parseDouble(json['price']),
      subtotal: Product._parseDouble(json['subtotal']),
    );
  }
}

class Order {
  final int id;
  final String orderNumber;
  final List<OrderItem> items;
  final double totalAmount;
  final double discountApplied;
  final double finalAmount;
  final String status;
  final String statusDisplay;
  final String paymentStatus;
  final String paymentStatusDisplay;
  final String paymentMethod;
  final String paymentMethodDisplay;
  final String deliveryName;
  final String deliveryPhone;
  final String deliveryEmail;
  final String deliveryAddress;
  final String deliveryCity;
  final String deliveryState;
  final String deliveryZip;
  final String? notes;
  final DateTime? estimatedDelivery;
  final List<OrderStatusHistory> statusHistory;
  final DateTime createdAt;
  final DateTime updatedAt;

  Order({
    required this.id,
    required this.orderNumber,
    required this.items,
    required this.totalAmount,
    required this.discountApplied,
    required this.finalAmount,
    required this.status,
    required this.statusDisplay,
    required this.paymentStatus,
    required this.paymentStatusDisplay,
    required this.paymentMethod,
    required this.paymentMethodDisplay,
    required this.deliveryName,
    required this.deliveryPhone,
    required this.deliveryEmail,
    required this.deliveryAddress,
    required this.deliveryCity,
    required this.deliveryState,
    required this.deliveryZip,
    this.notes,
    this.estimatedDelivery,
    required this.statusHistory,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get canBeCancelled => status == 'pending' || status == 'processing';

  factory Order.fromJson(Map<String, dynamic> json) {
    final itemsList = (json['items'] as List?)?.map((i) => OrderItem.fromJson(i)).toList() ?? [];
    final historyList = (json['status_history'] as List?)?.map((h) => OrderStatusHistory.fromJson(h)).toList() ?? [];

    return Order(
      id: json['id'] ?? 0,
      orderNumber: json['order_number'] ?? '',
      items: itemsList,
      totalAmount: Product._parseDouble(json['total_amount']),
      discountApplied: Product._parseDouble(json['discount_applied']),
      finalAmount: Product._parseDouble(json['final_amount']),
      status: json['status'] ?? 'pending',
      statusDisplay: json['status_display'] ?? '',
      paymentStatus: json['payment_status'] ?? 'pending',
      paymentStatusDisplay: json['payment_status_display'] ?? '',
      paymentMethod: json['payment_method'] ?? 'cod',
      paymentMethodDisplay: json['payment_method_display'] ?? 'Cash on Delivery',
      deliveryName: json['delivery_name'] ?? '',
      deliveryPhone: json['delivery_phone'] ?? '',
      deliveryEmail: json['delivery_email'] ?? '',
      deliveryAddress: json['delivery_address'] ?? '',
      deliveryCity: json['delivery_city'] ?? '',
      deliveryState: json['delivery_state'] ?? '',
      deliveryZip: json['delivery_zip'] ?? '',
      notes: json['notes'],
      estimatedDelivery: json['estimated_delivery'] != null ? DateTime.parse(json['estimated_delivery']) : null,
      statusHistory: historyList,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : DateTime.now(),
    );
  }
}

class OrderStatusHistory {
  final int id;
  final int orderId;
  final String status;
  final String statusDisplay;
  final DateTime timestamp;
  final String? note;

  OrderStatusHistory({
    required this.id,
    required this.orderId,
    required this.status,
    required this.statusDisplay,
    required this.timestamp,
    this.note,
  });

  factory OrderStatusHistory.fromJson(Map<String, dynamic> json) {
    return OrderStatusHistory(
      id: json['id'] ?? 0,
      orderId: json['order'] ?? 0,
      status: json['status'] ?? '',
      statusDisplay: json['status_display'] ?? '',
      timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp']) : DateTime.now(),
      note: json['note'],
    );
  }
}

class ProductReview {
  final int id;
  final int productId;
  final int userId;
  final String userName;
  final int rating;
  final String? title;
  final String comment;
  final bool isVerifiedPurchase;
  final int helpfulCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductReview({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    required this.rating,
    this.title,
    required this.comment,
    required this.isVerifiedPurchase,
    required this.helpfulCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductReview.fromJson(Map<String, dynamic> json) {
    return ProductReview(
      id: json['id'] ?? 0,
      productId: json['product'] ?? 0,
      userId: json['user_id'] ?? 0,
      userName: json['user_name'] ?? 'Anonymous',
      rating: json['rating'] ?? 0,
      title: json['title'],
      comment: json['comment'] ?? '',
      isVerifiedPurchase: json['is_verified_purchase'] ?? false,
      helpfulCount: json['helpful_count'] ?? 0,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'product': productId,
    'rating': rating,
    'title': title,
    'comment': comment,
  };
}

class ProductCategory {
  final int id;
  final String name;
  final String slug;
  final String? description;
  final bool isActive;
  final int productCount;

  ProductCategory({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    required this.isActive,
    required this.productCount,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'],
      isActive: json['is_active'] ?? true,
      productCount: json['product_count'] ?? 0,
    );
  }
}
