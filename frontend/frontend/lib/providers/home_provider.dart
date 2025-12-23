// ============================================
// lib/providers/home_provider.dart
// ============================================
import 'package:flutter/foundation.dart';
import '../models/home_models.dart';
import '../services/api_service.dart';

class HomeProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  HomePageData? _homeData;
  bool _isLoading = false;
  String? _error;

  HomePageData? get homeData => _homeData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadHomeData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _homeData = await _apiService.getHomePageData();
      _error = null;
    } catch (e) {
      _error = e.toString();
      print('Error loading home data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
