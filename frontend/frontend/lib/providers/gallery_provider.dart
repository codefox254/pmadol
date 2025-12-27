import 'package:flutter/foundation.dart';
import '../models/gallery_models.dart';
import '../services/api_service.dart';
import '../config/api_config.dart';

class GalleryProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<GalleryCategory> _categories = [];
  List<GalleryPhoto> _photos = [];
  List<GalleryVideo> _videos = [];
  GalleryCategory? _selectedCategory;
  bool _isLoading = false;
  String? _error;

  List<GalleryCategory> get categories => _categories;
  List<GalleryPhoto> get photos => _photos;
  List<GalleryVideo> get videos => _videos;
  GalleryCategory? get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadCategories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _apiService.get(
        '${ApiConfig.apiUrl}/gallery/categories/',
      );
      final list = (data is Map && data.containsKey('results'))
          ? data['results']
          : (data is List ? data : []);

      _categories = (list as List)
          .map((json) => GalleryCategory.fromJson(json as Map<String, dynamic>))
          .toList();

      _error = null;
    } catch (e) {
      _error = 'Failed to load categories: $e';
      if (kDebugMode) print('Error loading categories: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadPhotos({String? categorySlug}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final endpoint = categorySlug != null
          ? '${ApiConfig.apiUrl}/gallery/photos/by_category/?category=$categorySlug'
          : '${ApiConfig.apiUrl}/gallery/photos/';

      final data = await _apiService.get(endpoint);
      final list = (data is Map && data.containsKey('results'))
          ? data['results']
          : (data is List ? data : []);

      _photos = (list as List)
          .map((json) => GalleryPhoto.fromJson(json as Map<String, dynamic>))
          .toList();

      _error = null;
    } catch (e) {
      _error = 'Failed to load photos: $e';
      if (kDebugMode) print('Error loading photos: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadVideos({String? categorySlug}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final endpoint = categorySlug != null
          ? '${ApiConfig.apiUrl}/gallery/videos/by_category/?category=$categorySlug'
          : '${ApiConfig.apiUrl}/gallery/videos/';

      final data = await _apiService.get(endpoint);
      final list = (data is Map && data.containsKey('results'))
          ? data['results']
          : (data is List ? data : []);

      _videos = (list as List)
          .map((json) => GalleryVideo.fromJson(json as Map<String, dynamic>))
          .toList();

      _error = null;
    } catch (e) {
      _error = 'Failed to load videos: $e';
      if (kDebugMode) print('Error loading videos: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectCategory(GalleryCategory? category) {
    _selectedCategory = category;
    if (category != null) {
      if (category.type == 'photo') {
        loadPhotos(categorySlug: category.slug);
      } else {
        loadVideos(categorySlug: category.slug);
      }
    }
    notifyListeners();
  }

  void clearSelection() {
    _selectedCategory = null;
    _photos = [];
    _videos = [];
    notifyListeners();
  }
}
