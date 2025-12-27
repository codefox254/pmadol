// ============================================
// lib/models/service_models.dart
// ============================================

class Service {
  final int id;
  final String name;
  final String category;
  final String categoryDisplay;
  final String description;
  final List<String> features;
  final String? image;
  final double price;
  final String duration;
  final bool isActive;
  final bool isFeatured;
  final int displayOrder;
  final String? createdAt;

  Service({
    required this.id,
    required this.name,
    required this.category,
    required this.categoryDisplay,
    required this.description,
    required this.features,
    this.image,
    required this.price,
    required this.duration,
    required this.isActive,
    required this.isFeatured,
    required this.displayOrder,
    this.createdAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    List<String> featuresList = [];
    if (json['features'] != null) {
      if (json['features'] is List) {
        featuresList = List<String>.from(json['features']);
      }
    }

    return Service(
      id: json['id'],
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      categoryDisplay: json['category_display'] ?? '',
      description: json['description'] ?? '',
      features: featuresList,
      image: json['image'],
      price: json['price'] != null ? double.tryParse(json['price'].toString()) ?? 0.0 : 0.0,
      duration: json['duration'] ?? '',
      isActive: json['is_active'] ?? true,
      isFeatured: json['is_featured'] ?? false,
      displayOrder: json['display_order'] ?? 0,
      createdAt: json['created_at'],
    );
  }
}

class MembershipPlan {
  final int id;
  final String name;
  final String planType;
  final String planTypeDisplay;
  final double price;
  final String description;
  final List<String> features;
  final bool isActive;
  final bool isDefault;
  final int displayOrder;
  final String? createdAt;

  MembershipPlan({
    required this.id,
    required this.name,
    required this.planType,
    required this.planTypeDisplay,
    required this.price,
    required this.description,
    required this.features,
    required this.isActive,
    required this.isDefault,
    required this.displayOrder,
    this.createdAt,
  });

  factory MembershipPlan.fromJson(Map<String, dynamic> json) {
    List<String> featuresList = [];
    if (json['features'] != null) {
      if (json['features'] is List) {
        featuresList = List<String>.from(json['features']);
      }
    }

    return MembershipPlan(
      id: json['id'],
      name: json['name'] ?? '',
      planType: json['plan_type'] ?? '',
      planTypeDisplay: json['plan_type_display'] ?? '',
      price: json['price'] != null ? double.tryParse(json['price'].toString()) ?? 0.0 : 0.0,
      description: json['description'] ?? '',
      features: featuresList,
      isActive: json['is_active'] ?? true,
      isDefault: json['is_default'] ?? false,
      displayOrder: json['display_order'] ?? 0,
      createdAt: json['created_at'],
    );
  }
}

class ClubMembershipRequest {
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final int age;
  final String location;
  final String memberType;
  final int membershipPlanId;
  final bool isChildRegistration;
  final String? parentName;
  final String? parentEmail;
  final String? parentPhone;
  final String mpesaPhoneNumber;
  final double paymentAmount;
  final bool consentGiven;
  final bool privacyAccepted;
  final bool newsletterSubscription;

  ClubMembershipRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.age,
    required this.location,
    required this.memberType,
    required this.membershipPlanId,
    this.isChildRegistration = false,
    this.parentName,
    this.parentEmail,
    this.parentPhone,
    required this.mpesaPhoneNumber,
    required this.paymentAmount,
    required this.consentGiven,
    required this.privacyAccepted,
    this.newsletterSubscription = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone_number': phoneNumber,
      'age': age,
      'location': location,
      'member_type': memberType,
      'membership_plan': membershipPlanId,
      'is_child_registration': isChildRegistration,
      'parent_name': parentName,
      'parent_email': parentEmail,
      'parent_phone': parentPhone,
      'mpesa_phone_number': mpesaPhoneNumber,
      'payment_amount': paymentAmount,
      'consent_given': consentGiven,
      'privacy_accepted': privacyAccepted,
      'newsletter_subscription': newsletterSubscription,
    };
  }
}

class ClubMembership {
  final int id;
  final String membershipNumber;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final int age;
  final String location;
  final String memberType;
  final String memberTypeDisplay;
  final String? membershipPlanName;
  final String paymentStatus;
  final String paymentStatusDisplay;
  final String registrationStatus;
  final String registrationStatusDisplay;
  final String registrationDate;
  final String? mpesaTransactionId;

  ClubMembership({
    required this.id,
    required this.membershipNumber,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.age,
    required this.location,
    required this.memberType,
    required this.memberTypeDisplay,
    this.membershipPlanName,
    required this.paymentStatus,
    required this.paymentStatusDisplay,
    required this.registrationStatus,
    required this.registrationStatusDisplay,
    required this.registrationDate,
    this.mpesaTransactionId,
  });

  factory ClubMembership.fromJson(Map<String, dynamic> json) {
    return ClubMembership(
      id: json['id'],
      membershipNumber: json['membership_number'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      age: json['age'] ?? 0,
      location: json['location'] ?? '',
      memberType: json['member_type'] ?? '',
      memberTypeDisplay: json['member_type_display'] ?? '',
      membershipPlanName: json['membership_plan_name'],
      paymentStatus: json['payment_status'] ?? '',
      paymentStatusDisplay: json['payment_status_display'] ?? '',
      registrationStatus: json['registration_status'] ?? '',
      registrationStatusDisplay: json['registration_status_display'] ?? '',
      registrationDate: json['registration_date'] ?? '',
      mpesaTransactionId: json['mpesa_transaction_id'],
    );
  }
}
