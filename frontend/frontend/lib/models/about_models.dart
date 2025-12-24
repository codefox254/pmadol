// ============================================
// lib/models/about_models.dart
// ============================================
class CoreValue {
  final int id;
  final String title;
  final String description;
  final String? icon;
  final int displayOrder;
  final bool isActive;

  CoreValue({
    required this.id,
    required this.title,
    required this.description,
    this.icon,
    required this.displayOrder,
    required this.isActive,
  });

  factory CoreValue.fromJson(Map<String, dynamic> json) {
    return CoreValue(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'],
      displayOrder: json['display_order'] ?? 0,
      isActive: json['is_active'] ?? true,
    );
  }
}

class AboutContent {
  final int id;
  final String storyTitle;
  final String storyContent;
  final String? storyImage;
  final String missionStatement;
  final String visionStatement;
  final int foundedYear;
  final DateTime? updatedAt;
  final List<CoreValue> coreValues;

  AboutContent({
    required this.id,
    required this.storyTitle,
    required this.storyContent,
    required this.storyImage,
    required this.missionStatement,
    required this.visionStatement,
    required this.foundedYear,
    required this.updatedAt,
    required this.coreValues,
  });

  factory AboutContent.fromJson(Map<String, dynamic> json) {
    final values = (json['core_values'] as List?)
            ?.map((v) => CoreValue.fromJson(v as Map<String, dynamic>))
            .toList() ??
        [];

    return AboutContent(
      id: json['id'] ?? 0,
      storyTitle: json['story_title'] ?? 'Our Story',
      storyContent: json['story_content'] ?? '',
      storyImage: json['story_image'],
      missionStatement: json['mission_statement'] ?? '',
      visionStatement: json['vision_statement'] ?? '',
      foundedYear: json['founded_year'] ?? 0,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      coreValues: values,
    );
  }
}
