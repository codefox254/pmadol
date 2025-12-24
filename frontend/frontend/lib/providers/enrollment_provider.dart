// ============================================
// lib/providers/enrollment_provider.dart
// ============================================
import 'package:flutter/foundation.dart';
import '../models/enrollment_models.dart';
import '../services/api_service.dart';
import '../config/api_config.dart';

class EnrollmentProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  PaymentInfo? _paymentInfo;
  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _error;
  String? _successMessage;

  PaymentInfo? get paymentInfo => _paymentInfo;
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  String? get error => _error;
  String? get successMessage => _successMessage;

  Future<void> loadPaymentInfo() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _apiService.get('${ApiConfig.apiUrl}/services/payment-info/');
      if (data is Map) {
        _paymentInfo = PaymentInfo.fromJson(data);
      }
    } catch (e) {
      _error = 'Failed to load payment information: $e';
      if (kDebugMode) print('Error loading payment info: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> submitEnrollment(Enrollment enrollment) async {
    _isSubmitting = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.post(
        '${ApiConfig.apiUrl}/services/enrollments/',
        data: enrollment.toJson(),
      );

      if (response is Map) {
        final enrollmentResponse = EnrollmentResponse.fromJson(response);
        if (enrollmentResponse.success) {
          _successMessage = enrollmentResponse.message;
          return true;
        } else {
          _error = enrollmentResponse.message;
          return false;
        }
      }
      return false;
    } catch (e) {
      _error = 'Failed to submit enrollment: $e';
      if (kDebugMode) print('Error submitting enrollment: $e');
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  void clearMessages() {
    _error = null;
    _successMessage = null;
    notifyListeners();
  }
}
