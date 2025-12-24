// ============================================
// lib/providers/auth_provider.dart
// Enhanced Authentication Provider
// ============================================
import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

class User {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String? phone;
  final String? avatar;
  final String userType;
  final bool isVerified;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.avatar,
    required this.userType,
    required this.isVerified,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      phone: json['phone'],
      avatar: json['avatar'],
      userType: json['user_type'] ?? 'customer',
      isVerified: json['is_verified'] ?? false,
    );
  }

  String get fullName => '$firstName $lastName'.trim();
}

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _error;
  User? _user;
  String? _token;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get error => _error;
  User? get user => _user;
  String? get token => _token;

  Future<void> checkAuth() async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _apiService.getToken();
      _isAuthenticated = token != null;
      _token = token;
      
      if (_isAuthenticated) {
        try {
          // Fetch user data if needed
        } catch (e) {
          print('Error fetching user data: $e');
        }
      }
    } catch (e) {
      _error = e.toString();
      _isAuthenticated = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register({
    required String username,
    required String email,
    required String password,
    required String password2,
    required String firstName,
    required String lastName,
    String phone = '',
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (password != password2) {
        throw Exception('Passwords do not match');
      }

      if (username.isEmpty || email.isEmpty || password.length < 8) {
        throw Exception('Please fill all fields correctly');
      }

      final response = await _apiService.post(
        '/api/accounts/register/',
        data: {
          'username': username,
          'email': email,
          'password': password,
          'password2': password2,
          'first_name': firstName,
          'last_name': lastName,
          'phone': phone,
          'user_type': 'customer',
        },
      );

      _user = User.fromJson(response);
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (username.isEmpty || password.isEmpty) {
        throw Exception('Username and password are required');
      }

      final response = await _apiService.login(username, password);
      
      _token = response['token'];
      _user = User.fromJson(response['user']);
      _isAuthenticated = true;
      _error = null;
      
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isAuthenticated = false;
      _user = null;
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _apiService.logout();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isAuthenticated = false;
      _user = null;
      _token = null;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = <String, dynamic>{};
      if (firstName != null) data['first_name'] = firstName;
      if (lastName != null) data['last_name'] = lastName;
      if (phone != null) data['phone'] = phone;

      final response = await _apiService.put(
        '/api/accounts/profile/',
        data: data,
      );

      _user = User.fromJson(response);
      return true;
    } catch (e) {
      _error = e.toString();
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