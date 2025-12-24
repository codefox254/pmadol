// ============================================
// lib/providers/about_provider.dart
// ============================================
import 'package:flutter/foundation.dart';
import '../models/about_models.dart';
import '../services/api_service.dart';

class AboutProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  AboutContent? _content;
  List<CoreValue> _coreValues = [];
  bool _isLoading = false;
  String? _error;

  AboutContent? get content => _content;
  List<CoreValue> get coreValues => _coreValues;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadAbout() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final content = await _apiService.getAboutContent();
      List<CoreValue> values = content.coreValues;

      if (values.isEmpty) {
        // fallback to dedicated core values endpoint if serializer has none
        values = await _apiService.getCoreValues();
      }

      _content = content;
      _coreValues = values..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
    } catch (e) {
      _error = e.toString();
      _content = null;
      _coreValues = [];
      if (kDebugMode) {
        print('Error loading about content: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
