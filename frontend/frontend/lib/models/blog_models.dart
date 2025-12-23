// ============================================
// lib/models/blog_models.dart
// ============================================
class BlogPost {
  final int id;
  final String title;
  final String slug;
  final String authorName;
  final String? categoryName;
  final String excerpt;
  final String featuredImage;
  final bool isFeatured;
  final int views;
  final int commentsCount;
  final int likesCount;
  final String publishedAt;

  BlogPost({
    required this.id,
    required this.title,
    required this.slug,
    required this.authorName,
    this.categoryName,
    required this.excerpt,
    required this.featuredImage,
    required this.isFeatured,
    required this.views,
    required this.commentsCount,
    required this.likesCount,
    required this.publishedAt,
  });

  factory BlogPost.fromJson(Map<String, dynamic> json) {
    return BlogPost(
      id: json['id'],
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      authorName: json['author_name'] ?? '',
      categoryName: json['category_name'],
      excerpt: json['excerpt'] ?? '',
      featuredImage: json['featured_image'] ?? '',
      isFeatured: json['is_featured'] ?? false,
      views: json['views'] ?? 0,
      commentsCount: json['comments_count'] ?? 0,
      likesCount: json['likes_count'] ?? 0,
      publishedAt: json['published_at'] ?? '',
    );
  }
}

