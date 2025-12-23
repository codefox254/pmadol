// ============================================
// lib/models/core_models.dart
// ============================================
class SiteSettings {
  final String siteName;
  final String tagline;
  final String? logo;
  final String phone;
  final String email;
  final String address;
  final String workingHours;

  SiteSettings({
    required this.siteName,
    required this.tagline,
    this.logo,
    required this.phone,
    required this.email,
    required this.address,
    required this.workingHours,
  });

  factory SiteSettings.fromJson(Map<String, dynamic> json) {
    return SiteSettings(
      siteName: json['site_name'] ?? 'PMadol Chess Club',
      tagline: json['tagline'] ?? '',
      logo: json['logo'],
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      workingHours: json['working_hours'] ?? '',
    );
  }
}

class Statistics {
  final int awardsCount;
  final int yearsExperience;
  final int studentsCount;
  final int trainersCount;

  Statistics({
    required this.awardsCount,
    required this.yearsExperience,
    required this.studentsCount,
    required this.trainersCount,
  });

  factory Statistics.fromJson(Map<String, dynamic> json) {
    return Statistics(
      awardsCount: json['awards_count'] ?? 0,
      yearsExperience: json['years_experience'] ?? 0,
      studentsCount: json['students_count'] ?? 0,
      trainersCount: json['trainers_count'] ?? 0,
    );
  }
}

class Testimonial {
  final int id;
  final String author;
  final String roleDisplay;
  final String content;
  final int rating;
  final String? photo;
  final bool isFeatured;

  Testimonial({
    required this.id,
    required this.author,
    required this.roleDisplay,
    required this.content,
    required this.rating,
    this.photo,
    required this.isFeatured,
  });

  factory Testimonial.fromJson(Map<String, dynamic> json) {
    return Testimonial(
      id: json['id'],
      author: json['author'] ?? '',
      roleDisplay: json['role_display'] ?? '',
      content: json['content'] ?? '',
      rating: json['rating'] ?? 5,
      photo: json['photo'],
      isFeatured: json['is_featured'] ?? false,
    );
  }
}

class Partner {
  final int id;
  final String name;
  final String logo;
  final String? website;

  Partner({
    required this.id,
    required this.name,
    required this.logo,
    this.website,
  });

  factory Partner.fromJson(Map<String, dynamic> json) {
    return Partner(
      id: json['id'],
      name: json['name'] ?? '',
      logo: json['logo'] ?? '',
      website: json['website'],
    );
  }
}

class HomePageData {
  final SiteSettings siteSettings;
  final Statistics statistics;
  final List<Testimonial> testimonials;
  final List<Partner> partners;

  HomePageData({
    required this.siteSettings,
    required this.statistics,
    required this.testimonials,
    required this.partners,
  });

  factory HomePageData.fromJson(Map<String, dynamic> json) {
    return HomePageData(
      siteSettings: SiteSettings.fromJson(json['site_settings']),
      statistics: Statistics.fromJson(json['statistics']),
      testimonials: (json['testimonials'] as List)
          .map((t) => Testimonial.fromJson(t))
          .toList(),
      partners: (json['partners'] as List)
          .map((p) => Partner.fromJson(p))
          .toList(),
    );
  }
}