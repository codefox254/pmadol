// ============================================
// lib/providers/shop_provider.dart
// ============================================
import 'package:flutter/foundation.dart';
import '../models/shop_models.dart';
import '../services/api_service.dart';

class ShopProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Product> _products = [];
  bool _isLoading = false;
  String? _error;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _products = await _apiService.getProducts();
      _error = null;
    } catch (e) {
      _error = e.toString();
      print('Error loading products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
