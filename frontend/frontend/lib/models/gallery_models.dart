class GalleryItem {
  final int id;
  final String title;
  final String? description;
  final String image;
  final String? video;
  final String categoryName;
  final bool isVideo;
  final bool isFeatured;
  final int order;

  GalleryItem({
    required this.id,
    required this.title,
    this.description,
    required this.image,
    this.video,
    required this.categoryName,
    this.isVideo = false,
    this.isFeatured = false,
    required this.order,
  });

  factory GalleryItem.fromJson(Map<String, dynamic> json) {
    return GalleryItem(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'],
      image: json['image'] ?? '',
      video: json['video'],
      categoryName: json['category_name'] ?? json['category'] ?? 'Uncategorized',
      isVideo: json['is_video'] ?? false,
      isFeatured: json['is_featured'] ?? false,
      order: json['order'] ?? 0,
    );
  }
}
