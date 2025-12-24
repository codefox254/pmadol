import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/gallery_models.dart';
import '../config/api_config.dart';

class GalleryProvider extends ChangeNotifier {
  List<GalleryItem> _items = [];
  bool _isLoading = false;
  String? _error;

  List<GalleryItem> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<GalleryItem> get images => _items.where((item) => !item.isVideo).toList();
  List<GalleryItem> get videos => _items.where((item) => item.isVideo).toList();
  List<GalleryItem> get featuredItems => _items.where((item) => item.isFeatured).toList();

  Future<void> loadGalleryItems() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final url = Uri.parse('${ApiConfig.apiUrl}/gallery/items/');
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final itemsList = data is List ? data : (data['results'] ?? []);
        _items = (itemsList as List)
            .map<GalleryItem>((json) => GalleryItem.fromJson(json))
            .toList();
        _items.sort((a, b) => a.order.compareTo(b.order));
        _error = null;
      } else {
        _error = 'Failed to load gallery: ${response.statusCode}';
        _items = [];
      }
    } catch (e) {
      _error = e.toString();
      _items = [];
      print('Error loading gallery items: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
