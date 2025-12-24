// ============================================
// lib/models/team_models.dart
// ============================================
class TeamMember {
  final int? id;
  final String name;
  final String role;
  final String roleDisplay;
  final String bio;
  final String? photo;
  final String? qualifications;
  final String? rating;
  final String? email;
  final String? phone;
  final bool isActive;
  final int displayOrder;

  TeamMember({
    this.id,
    required this.name,
    required this.role,
    required this.roleDisplay,
    required this.bio,
    this.photo,
    this.qualifications,
    this.rating,
    this.email,
    this.phone,
    required this.isActive,
    required this.displayOrder,
  });

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      id: json['id'],
      name: json['name'] ?? '',
      role: json['role'] ?? 'coach',
      roleDisplay: json['role_display'] ?? 'Coach',
      bio: json['bio'] ?? '',
      photo: json['photo'],
      qualifications: json['qualifications'],
      rating: json['rating'],
      email: json['email'],
      phone: json['phone'],
      isActive: json['is_active'] ?? true,
      displayOrder: json['display_order'] ?? 0,
    );
  }
}
