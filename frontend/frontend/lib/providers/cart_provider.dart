// ============================================
// lib/providers/cart_provider.dart
// Enhanced Cart Provider
// ============================================
import 'package:flutter/foundation.dart';
import '../models/shop_models.dart';
import '../services/api_service.dart';
import '../config/api_config.dart';

class CartProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  Cart? _cart;
  bool _isLoading = false;
  String? _error;

  // Getters
  Cart? get cart => _cart;
  List<CartItem> get items => _cart?.items ?? [];
  double get totalAmount => _cart?.totalAmount ?? 0.0;
  double get discountedAmount => _cart?.discountedAmount ?? 0.0;
  double get totalDiscount => _cart?.totalDiscount ?? 0.0;
  int get totalItems => _cart?.totalItems ?? 0;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isEmpty => items.isEmpty;

  Future<void> loadCart() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.get(
        '${ApiConfig.apiUrl}/shop/cart/retrieve_cart/',
        requiresAuth: true,
      );
      _cart = Cart.fromJson(response);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _cart = null;
      print('Error loading cart: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addToCart(int productId, {int quantity = 1}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.post(
        '${ApiConfig.apiUrl}/shop/cart/add_item/',
        data: {
          'product_id': productId,
          'quantity': quantity,
        },
        requiresAuth: true,
      );

      // Update cart after adding item
      await loadCart();
      _error = null;
      return true;
    } catch (e) {
      final message = e.toString().contains('401')
          ? 'Login required to add items to cart'
          : e.toString();
      _error = message;
      print('Error adding to cart: $message');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateCartItem(int itemId, int quantity) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (quantity < 1) {
        throw Exception('Quantity must be at least 1');
      }

      final response = await _apiService.post(
        '${ApiConfig.apiUrl}/shop/cart/update_item/',
        data: {
          'item_id': itemId,
          'quantity': quantity,
        },
        requiresAuth: true,
      );

      // Update cart
      await loadCart();
      _error = null;
      return true;
    } catch (e) {
      final message = e.toString().contains('401')
          ? 'Login required to update cart'
          : e.toString();
      _error = message;
      print('Error updating cart item: $message');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> removeFromCart(int itemId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.delete(
        '${ApiConfig.apiUrl}/shop/cart/remove_item/?item_id=$itemId',
        requiresAuth: true,
      );

      // Update cart
      await loadCart();
      _error = null;
      return true;
    } catch (e) {
      final message = e.toString().contains('401')
          ? 'Login required to update cart'
          : e.toString();
      _error = message;
      print('Error removing from cart: $message');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> clearCart() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.post(
        '${ApiConfig.apiUrl}/shop/cart/clear/',
        data: {},
        requiresAuth: true,
      );

      // Clear cart
      _cart = null;
      _error = null;
      return true;
    } catch (e) {
      final message = e.toString().contains('401')
          ? 'Login required to update cart'
          : e.toString();
      _error = message;
      print('Error clearing cart: $message');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
