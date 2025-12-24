// ============================================
// lib/providers/shop_provider.dart
// Enhanced Shop Provider
// ============================================
import 'package:flutter/foundation.dart';
import '../models/shop_models.dart';
import '../services/api_service.dart';
import '../config/api_config.dart';

class ShopProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  // Products
  List<Product> _products = [];
  List<Product> _featuredProducts = [];
  List<ProductCategory> _categories = [];
  Product? _selectedProduct;
  
  // Reviews
  List<ProductReview> _productReviews = [];
  
  // State
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _sortOption = 'popular';

  // Getters
  List<Product> get products => _products;
  List<Product> get featuredProducts => _featuredProducts;
  List<ProductCategory> get categories => _categories;
  Product? get selectedProduct => _selectedProduct;
  List<ProductReview> get productReviews => _productReviews;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  String get sortOption => _sortOption;

  Future<void> loadProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.get('${ApiConfig.apiUrl}/shop/products/');
      final data = response['results'] ?? response as List;
      _products = (data is List)
          ? data.map<Product>((p) => Product.fromJson(p)).toList()
          : [];
      _error = null;
    } catch (e) {
      _error = e.toString();
      print('Error loading products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadFeaturedProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.get('${ApiConfig.apiUrl}/shop/products/featured/');
      final data = response as List;
      _featuredProducts = data.map<Product>((p) => Product.fromJson(p)).toList();
      _error = null;
    } catch (e) {
      _error = e.toString();
      print('Error loading featured products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCategories() async {
    try {
      final response = await _apiService.get('${ApiConfig.apiUrl}/shop/categories/');
      final data = response['results'] ?? response as List;
      _categories = (data is List)
          ? data.map<ProductCategory>((c) => ProductCategory.fromJson(c)).toList()
          : [];
      _error = null;
    } catch (e) {
      _error = e.toString();
      print('Error loading categories: $e');
    }
    notifyListeners();
  }

  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      _searchQuery = '';
      _products = [];
      notifyListeners();
      return;
    }

    if (query.length < 2) {
      _error = 'Search query must be at least 2 characters';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    _searchQuery = query;
    notifyListeners();

    try {
      final response = await _apiService.get(
        '${ApiConfig.apiUrl}/shop/products/search/',
        queryParams: {'q': query}
      );
      final data = response['results'] ?? response as List;
      _products = (data is List)
          ? data.map<Product>((p) => Product.fromJson(p)).toList()
          : [];
      _error = null;
    } catch (e) {
      _error = e.toString();
      print('Error searching products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> filterByCategory(String categorySlug) async {
    _selectedCategory = categorySlug;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.get(
        '${ApiConfig.apiUrl}/shop/products/by_category/',
        queryParams: {'category': categorySlug}
      );
      final data = response['results'] ?? response as List;
      _products = (data is List)
          ? data.map<Product>((p) => Product.fromJson(p)).toList()
          : [];
      _error = null;
    } catch (e) {
      _error = e.toString();
      print('Error filtering by category: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadProductDetails(String slug) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.get('${ApiConfig.apiUrl}/shop/products/$slug/');
      _selectedProduct = Product.fromJson(response);
      _error = null;
    } catch (e) {
      _error = e.toString();
      print('Error loading product details: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadProductReviews(int productId) async {
    try {
      final response = await _apiService.get(
        '${ApiConfig.apiUrl}/shop/reviews/',
        queryParams: {'product': productId.toString()}
      );
      final data = response is List
          ? response
          : (response['results'] ?? []);
      _productReviews = (data as List)
          .map<ProductReview>((r) => ProductReview.fromJson(r))
          .toList();
      _error = null;
    } catch (e) {
      _error = e.toString();
      print('Error loading reviews: $e');
    }
    notifyListeners();
  }

  void sortProducts(String option) {
    _sortOption = option;
    
    switch (option) {
      case 'price_low':
        _products.sort((a, b) => a.discountedPrice.compareTo(b.discountedPrice));
        break;
      case 'price_high':
        _products.sort((a, b) => b.discountedPrice.compareTo(a.discountedPrice));
        break;
      case 'rating':
        _products.sort((a, b) => b.averageRating.compareTo(a.averageRating));
        break;
      case 'newest':
        _products.sort((a, b) => b.createdAt?.compareTo(a.createdAt ?? DateTime.now()) ?? 0);
        break;
      default:
        // popular
        _products.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
    }
    
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _selectedProduct = null;
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
