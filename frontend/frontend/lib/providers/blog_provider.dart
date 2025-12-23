// ============================================
// lib/providers/blog_provider.dart
// ============================================
import 'package:flutter/foundation.dart';
import '../models/blog_models.dart';
import '../services/api_service.dart';

class BlogProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<BlogPost> _posts = [];
  bool _isLoading = false;
  String? _error;

  List<BlogPost> get posts => _posts;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  List<BlogPost> get featuredPosts => _posts.where((p) => p.isFeatured).toList();

  Future<void> loadPosts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _posts = await _apiService.getBlogPosts();
      _error = null;
    } catch (e) {
      _error = e.toString();
      print('Error loading blog posts: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
