// ============================================
// lib/models/home_models.dart
// ============================================
class HomePageData {
  final SiteSettings siteSettings;
  final Statistics statistics;
  final List<Testimonial> testimonials;
  final List<Partner> partners;
  final List<HeroSlide> heroSlides;

  HomePageData({
    required this.siteSettings,
    required this.statistics,
    required this.testimonials,
    required this.partners,
    required this.heroSlides,
  });

  factory HomePageData.fromJson(Map<String, dynamic> json) {
    return HomePageData(
      siteSettings: SiteSettings.fromJson(json['site_settings'] ?? {}),
      statistics: Statistics.fromJson(json['statistics'] ?? {}),
      testimonials: List<Testimonial>.from(
        (json['testimonials'] as List?)?.map((x) => Testimonial.fromJson(x)) ?? [],
      ),
      partners: List<Partner>.from(
        (json['partners'] as List?)?.map((x) => Partner.fromJson(x)) ?? [],
      ),
      heroSlides: List<HeroSlide>.from(
        (json['hero_slides'] as List?)?.map((x) => HeroSlide.fromJson(x)) ?? [],
      ),
    );
  }
}

class HeroSlide {
  final int? id;
  final String title;
  final String subtitle;
  final String image;
  final bool isActive;
  final int displayOrder;

  HeroSlide({
    this.id,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.isActive,
    required this.displayOrder,
  });

  factory HeroSlide.fromJson(Map<String, dynamic> json) {
    return HeroSlide(
      id: json['id'],
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      image: json['image'] ?? '',
      isActive: json['is_active'] ?? true,
      displayOrder: json['display_order'] ?? 0,
    );
  }
}

class SiteSettings {
  final int? id;
  final String siteName;
  final String tagline;
  final String? logo;
  final String? favicon;
  final String primaryColor;
  final String secondaryColor;
  final String phone;
  final String email;
  final String address;
  final String workingHours;
  final String? facebookUrl;
  final String? instagramUrl;
  final String? twitterUrl;
  final String? youtubeUrl;
  final String? linkedinUrl;
  final String? mapUrl;

  SiteSettings({
    this.id,
    required this.siteName,
    required this.tagline,
    this.logo,
    this.favicon,
    required this.primaryColor,
    required this.secondaryColor,
    required this.phone,
    required this.email,
    required this.address,
    required this.workingHours,
    this.facebookUrl,
    this.instagramUrl,
    this.twitterUrl,
    this.youtubeUrl,
    this.linkedinUrl,
    this.mapUrl,
  });

  factory SiteSettings.fromJson(Map<String, dynamic> json) {
    return SiteSettings(
      id: json['id'],
      siteName: json['site_name'] ?? 'PMadol Chess Club',
      tagline: json['tagline'] ?? 'Building and Nurturing Champions',
      logo: json['logo'],
      favicon: json['favicon'],
      primaryColor: json['primary_color'] ?? '#5886BF',
      secondaryColor: json['secondary_color'] ?? '#283D57',
      phone: json['phone'] ?? '+254 714 272 082',
      email: json['email'] ?? 'info@pmadol.com',
      address: json['address'] ?? 'Nairobi - Kenya',
      workingHours: json['working_hours'] ?? 'Monday - Saturday: 8AM - 10PM',
      facebookUrl: json['facebook_url'],
      instagramUrl: json['instagram_url'],
      twitterUrl: json['twitter_url'],
      youtubeUrl: json['youtube_url'],
      linkedinUrl: json['linkedin_url'],
      mapUrl: json['map_url'],
    );
  }
}

class Statistics {
  final int? id;
  final int awardsCount;
  final int yearsExperience;
  final int studentsCount;
  final int trainersCount;

  Statistics({
    this.id,
    required this.awardsCount,
    required this.yearsExperience,
    required this.studentsCount,
    required this.trainersCount,
  });

  factory Statistics.fromJson(Map<String, dynamic> json) {
    return Statistics(
      id: json['id'],
      awardsCount: json['awards_count'] ?? 23,
      yearsExperience: json['years_experience'] ?? 9,
      studentsCount: json['students_count'] ?? 771,
      trainersCount: json['trainers_count'] ?? 12,
    );
  }
}

class Testimonial {
  final int? id;
  final String author;
  final String role;
  final String roleDisplay;
  final String content;
  final int rating;
  final String? photo;
  final bool isFeatured;

  Testimonial({
    this.id,
    required this.author,
    required this.role,
    required this.roleDisplay,
    required this.content,
    required this.rating,
    this.photo,
    required this.isFeatured,
  });

  factory Testimonial.fromJson(Map<String, dynamic> json) {
    return Testimonial(
      id: json['id'],
      author: json['author'] ?? 'Anonymous',
      role: json['role'] ?? 'parent',
      roleDisplay: json['role_display'] ?? 'Parent',
      content: json['content'] ?? '',
      rating: json['rating'] ?? 5,
      photo: json['photo'],
      isFeatured: json['is_featured'] ?? false,
    );
  }
}

class Partner {
  final int? id;
  final String name;
  final String logo;
  final String? website;
  final String? description;

  Partner({
    this.id,
    required this.name,
    required this.logo,
    this.website,
    this.description,
  });

  factory Partner.fromJson(Map<String, dynamic> json) {
    return Partner(
      id: json['id'],
      name: json['name'] ?? 'Partner',
      logo: json['logo'] ?? '',
      website: json['website'],
      description: json['description'],
    );
  }
}
