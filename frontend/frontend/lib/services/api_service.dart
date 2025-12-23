// ============================================
// lib/services/api_service.dart
// ============================================
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import '../models/home_models.dart';
import '../models/blog_models.dart';
import '../models/service_models.dart';
import '../models/shop_models.dart';
import '../models/gallery_models.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String? _accessToken;
  
  // Get stored token
  Future<String?> getToken() async {
    if (_accessToken != null) return _accessToken;
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('access_token');
    return _accessToken;
  }

  // Save token
  Future<void> saveToken(String token) async {
    _accessToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }

  // Clear token
  Future<void> clearToken() async {
    _accessToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }

  // Generic GET request
  Future<dynamic> get(String url, {bool requiresAuth = false}) async {
    try {
      final headers = {'Content-Type': 'application/json'};
      
      if (requiresAuth) {
        final token = await getToken();
        if (token != null) {
          headers['Authorization'] = 'Bearer $token';
        }
      }

      final response = await http.get(Uri.parse(url), headers: headers);
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('API Error: $e');
      rethrow;
    }
  }

  // Generic POST request
  Future<dynamic> post(String url, Map<String, dynamic> data, {bool requiresAuth = false}) async {
    try {
      final headers = {'Content-Type': 'application/json'};
      
      if (requiresAuth) {
        final token = await getToken();
        if (token != null) {
          headers['Authorization'] = 'Bearer $token';
        }
      }

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(data),
      );
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      print('API Error: $e');
      rethrow;
    }
  }

  // ===== CORE ENDPOINTS =====
  
  Future<HomePageData> getHomePageData() async {
    final data = await get(ApiConfig.homepage);
    return HomePageData.fromJson(data);
  }

  Future<SiteSettings> getSiteSettings() async {
    final data = await get(ApiConfig.siteSettings);
    return SiteSettings.fromJson(data);
  }

  Future<Statistics> getStatistics() async {
    final data = await get(ApiConfig.statistics);
    return Statistics.fromJson(data);
  }

  Future<List<Testimonial>> getTestimonials({bool featured = false}) async {
    final url = featured ? ApiConfig.testimonialsFeatured : ApiConfig.testimonials;
    final data = await get(url);
    return (data as List).map((json) => Testimonial.fromJson(json)).toList();
  }

  Future<List<Partner>> getPartners() async {
    final data = await get(ApiConfig.partners);
    return (data as List).map((json) => Partner.fromJson(json)).toList();
  }

  // ===== BLOG ENDPOINTS =====
  
  Future<List<BlogPost>> getBlogPosts({bool featured = false}) async {
    final url = featured ? ApiConfig.blogFeatured : ApiConfig.blogPosts;
    final data = await get(url);
    
    if (data is Map && data.containsKey('results')) {
      return (data['results'] as List).map((json) => BlogPost.fromJson(json)).toList();
    }
    return (data as List).map((json) => BlogPost.fromJson(json)).toList();
  }

  // ===== AUTH ENDPOINTS =====
  
  Future<Map<String, dynamic>> login(String username, String password) async {
    final data = await post(ApiConfig.authLogin, {
      'username': username,
      'password': password,
    });
    
    if (data['access'] != null) {
      await saveToken(data['access']);
    }
    
    return data;
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    return await post(ApiConfig.authRegister, userData);
  }

  Future<void> logout() async {
    await clearToken();
  }

  // ===== CONTACT ENDPOINT =====
  
  Future<void> sendContactMessage(Map<String, dynamic> data) async {
    await post(ApiConfig.contactMessage, data);
  }

  // ===== SERVICES ENDPOINT =====
  
  Future<List<Service>> getServices() async {
    final data = await get(ApiConfig.services);
    return (data as List).map((json) => Service.fromJson(json)).toList();
  }

  // ===== SHOP ENDPOINTS =====
  
  Future<List<Product>> getProducts() async {
    final data = await get(ApiConfig.products);
    return (data as List).map((json) => Product.fromJson(json)).toList();
  }

  // ===== GALLERY ENDPOINTS =====
  
  Future<List<GalleryItem>> getGalleryItems() async {
    final data = await get(ApiConfig.galleryItems);
    return (data as List).map((json) => GalleryItem.fromJson(json)).toList();
  }
}
