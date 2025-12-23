// ============================================
// lib/providers/service_provider.dart
// ============================================
import 'package:flutter/foundation.dart';
import '../models/service_models.dart';
import '../services/api_service.dart';

class ServiceProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Service> _services = [];
  bool _isLoading = false;
  String? _error;

  List<Service> get services => _services;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadServices() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _services = await _apiService.getServices();
      _error = null;
    } catch (e) {
      _error = e.toString();
      print('Error loading services: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
