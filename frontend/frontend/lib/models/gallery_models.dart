class GalleryCategory {
  final int id;
  final String name;
  final String slug;
  final String type; // 'photo' or 'video'
  final bool isActive;
  final int itemCount;

  GalleryCategory({
    required this.id,
    required this.name,
    required this.slug,
    required this.type,
    required this.isActive,
    this.itemCount = 0,
  });

  factory GalleryCategory.fromJson(Map<String, dynamic> json) {
    return GalleryCategory(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      type: json['type'] ?? 'photo',
      isActive: json['is_active'] ?? true,
      itemCount: json['item_count'] ?? 0,
    );
  }
}

class GalleryPhoto {
  final int id;
  final String title;
  final String image;
  final String? caption;
  final int? category;
  final String categoryName;
  final DateTime? dateTaken;
  final bool isActive;
  final int displayOrder;
  final DateTime createdAt;

  GalleryPhoto({
    required this.id,
    required this.title,
    required this.image,
    this.caption,
    this.category,
    this.categoryName = 'Uncategorized',
    this.dateTaken,
    this.isActive = true,
    this.displayOrder = 0,
    required this.createdAt,
  });

  factory GalleryPhoto.fromJson(Map<String, dynamic> json) {
    return GalleryPhoto(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      caption: json['caption'],
      category: json['category'],
      categoryName: json['category_name'] ?? 'Uncategorized',
      dateTaken: json['date_taken'] != null
          ? DateTime.tryParse(json['date_taken'])
          : null,
      isActive: json['is_active'] ?? true,
      displayOrder: json['display_order'] ?? 0,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}

class GalleryVideo {
  final int id;
  final String title;
  final String videoUrl;
  final String thumbnail;
  final String? description;
  final int? category;
  final String categoryName;
  final DateTime? dateRecorded;
  final bool isActive;
  final int displayOrder;
  final DateTime createdAt;

  GalleryVideo({
    required this.id,
    required this.title,
    required this.videoUrl,
    required this.thumbnail,
    this.description,
    this.category,
    this.categoryName = 'Uncategorized',
    this.dateRecorded,
    this.isActive = true,
    this.displayOrder = 0,
    required this.createdAt,
  });

  factory GalleryVideo.fromJson(Map<String, dynamic> json) {
    return GalleryVideo(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      videoUrl: json['video_url'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      description: json['description'],
      category: json['category'],
      categoryName: json['category_name'] ?? 'Uncategorized',
      dateRecorded: json['date_recorded'] != null
          ? DateTime.tryParse(json['date_recorded'])
          : null,
      isActive: json['is_active'] ?? true,
      displayOrder: json['display_order'] ?? 0,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}
