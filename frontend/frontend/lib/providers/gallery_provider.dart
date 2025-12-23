import 'package:flutter/foundation.dart';
import '../models/gallery_models.dart';
import '../services/api_service.dart';

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
      _items = await ApiService().getGalleryItems();
      _items.sort((a, b) => a.order.compareTo(b.order));
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
