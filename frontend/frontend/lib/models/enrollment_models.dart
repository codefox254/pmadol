// ============================================
// lib/models/enrollment_models.dart
// ============================================

class PaymentInfo {
  final int id;
  final double amount;
  final String mpesaNumber;
  final String mpesaName;
  final bool isActive;

  PaymentInfo({
    required this.id,
    required this.amount,
    required this.mpesaNumber,
    required this.mpesaName,
    required this.isActive,
  });

  factory PaymentInfo.fromJson(Map<String, dynamic> json) {
    return PaymentInfo(
      id: json['id'] ?? 0,
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      mpesaNumber: json['mpesa_number'] ?? '',
      mpesaName: json['mpesa_name'] ?? '',
      isActive: json['is_active'] ?? true,
    );
  }
}

class Enrollment {
  final int? id;
  final int serviceId;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String mpesaMessage;
  final bool subscribedToNewsletter;
  final DateTime? createdAt;
  final String? approvalStatus; // pending, approved, rejected

  Enrollment({
    this.id,
    required this.serviceId,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.mpesaMessage,
    required this.subscribedToNewsletter,
    this.createdAt,
    this.approvalStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      'service': serviceId,
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'mpesa_message': mpesaMessage,
      'subscribed_to_newsletter': subscribedToNewsletter,
    };
  }

  factory Enrollment.fromJson(Map<String, dynamic> json) {
    return Enrollment(
      id: json['id'],
      serviceId: json['service'] ?? json['service_id'] ?? 0,
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      mpesaMessage: json['mpesa_message'] ?? '',
      subscribedToNewsletter: json['subscribed_to_newsletter'] ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      approvalStatus: json['approval_status'],
    );
  }
}

class EnrollmentResponse {
  final bool success;
  final String message;
  final Enrollment? enrollment;

  EnrollmentResponse({
    required this.success,
    required this.message,
    this.enrollment,
  });

  factory EnrollmentResponse.fromJson(Map<String, dynamic> json) {
    return EnrollmentResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      enrollment: json['enrollment'] != null
          ? Enrollment.fromJson(json['enrollment'])
          : null,
    );
  }
}
