// ============================================
// lib/providers/order_provider.dart
// Enhanced Order Provider
// ============================================
import 'package:flutter/foundation.dart';
import '../models/shop_models.dart';
import '../services/api_service.dart';
import '../config/api_config.dart';

class OrderProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Order> _orders = [];
  Order? _selectedOrder;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Order> get orders => _orders;
  Order? get selectedOrder => _selectedOrder;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get totalOrders => _orders.length;

  Future<void> loadOrders() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.get('${ApiConfig.apiUrl}/shop/orders/');
      final data = response['results'] ?? response as List;
      _orders = (data is List)
          ? data.map<Order>((o) => Order.fromJson(o)).toList()
          : [];
      _error = null;
    } catch (e) {
      _error = e.toString();
      print('Error loading orders: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createOrder({
    required String deliveryName,
    required String deliveryPhone,
    required String deliveryEmail,
    required String deliveryAddress,
    required String deliveryCity,
    required String deliveryState,
    required String deliveryZip,
    required String paymentMethod,
    String notes = '',
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Validate required fields
      if (deliveryName.isEmpty ||
          deliveryPhone.isEmpty ||
          deliveryEmail.isEmpty ||
          deliveryAddress.isEmpty ||
          deliveryCity.isEmpty ||
          deliveryState.isEmpty ||
          deliveryZip.isEmpty) {
        throw Exception('All delivery fields are required');
      }

      // Validate email
      if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
          .hasMatch(deliveryEmail)) {
        throw Exception('Invalid email address');
      }

      final response = await _apiService.post(
        '${ApiConfig.apiUrl}/shop/orders/',
        data: {
          'delivery_name': deliveryName,
          'delivery_phone': deliveryPhone,
          'delivery_email': deliveryEmail,
          'delivery_address': deliveryAddress,
          'delivery_city': deliveryCity,
          'delivery_state': deliveryState,
          'delivery_zip': deliveryZip,
          'payment_method': paymentMethod,
          'notes': notes,
        },
      );

      final order = Order.fromJson(response);
      _orders.insert(0, order);
      _selectedOrder = order;
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      print('Error creating order: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadOrderDetails(int orderId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.get('${ApiConfig.apiUrl}/shop/orders/$orderId/');
      _selectedOrder = Order.fromJson(response);
      _error = null;
    } catch (e) {
      _error = e.toString();
      print('Error loading order details: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> trackOrder(int orderId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.get('${ApiConfig.apiUrl}/shop/orders/$orderId/track/');
      _selectedOrder = Order.fromJson(response['order']);
      _error = null;
    } catch (e) {
      _error = e.toString();
      print('Error tracking order: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> cancelOrder(int orderId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.post(
        '${ApiConfig.apiUrl}/shop/orders/$orderId/cancel/',
        data: {},
      );

      // Update selected order
      _selectedOrder = Order.fromJson(response['order']);

      // Update in orders list
      final index = _orders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        _orders[index] = _selectedOrder!;
      }

      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      print('Error cancelling order: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Order? getOrderById(int orderId) {
    try {
      return _orders.firstWhere((o) => o.id == orderId);
    } catch (e) {
      return null;
    }
  }

  List<Order> getOrdersByStatus(String status) {
    return _orders.where((o) => o.status == status).toList();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearSelection() {
    _selectedOrder = null;
    notifyListeners();
  }
}
