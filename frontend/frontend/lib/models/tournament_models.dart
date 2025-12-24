// ============================================
// lib/models/tournament_models.dart
// ============================================

class Tournament {
  final int id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime? endDate;
  final String location;
  final String format;
  final String timeControl;
  final double? entryFee;
  final int? maxParticipants;
  final String? image;
  final String? resultsLink;
  final bool isActive;
  final int registrationCount;
  final DateTime createdAt;

  Tournament({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    this.endDate,
    required this.location,
    required this.format,
    required this.timeControl,
    this.entryFee,
    this.maxParticipants,
    this.image,
    this.resultsLink,
    required this.isActive,
    required this.registrationCount,
    required this.createdAt,
  });

  bool get isUpcoming {
    return startDate.isAfter(DateTime.now());
  }

  bool get isPast {
    final end = endDate ?? startDate;
    return end.isBefore(DateTime.now());
  }

  bool get isOngoing {
    return !isUpcoming && !isPast;
  }

  factory Tournament.fromJson(Map<String, dynamic> json) {
    return Tournament(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      startDate: DateTime.tryParse(json['start_date'] ?? '') ?? DateTime.now(),
      endDate: json['end_date'] != null ? DateTime.tryParse(json['end_date']) : null,
      location: json['location'] ?? '',
      format: json['format'] ?? 'Round Robin',
      timeControl: json['time_control'] ?? '10+0',
      entryFee: json['entry_fee'] != null 
          ? double.tryParse(json['entry_fee'].toString()) 
          : null,
      maxParticipants: json['max_participants'],
      image: json['image'],
      resultsLink: json['results_link'],
      isActive: json['is_active'] ?? true,
      registrationCount: json['registration_count'] ?? 0,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}

class TournamentRegistration {
  final int? id;
  final int tournamentId;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String chessUsername;
  final int? rating;
  final String? experience;
  final DateTime? createdAt;

  TournamentRegistration({
    this.id,
    required this.tournamentId,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.chessUsername,
    this.rating,
    this.experience,
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'tournament': tournamentId,
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'chess_username': chessUsername,
      'rating': rating,
      'experience': experience,
    };
  }

  factory TournamentRegistration.fromJson(Map<String, dynamic> json) {
    return TournamentRegistration(
      id: json['id'],
      tournamentId: json['tournament'] ?? json['tournament_id'] ?? 0,
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      chessUsername: json['chess_username'] ?? '',
      rating: json['rating'],
      experience: json['experience'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }
}

class TournamentResponse {
  final bool success;
  final String message;
  final TournamentRegistration? registration;

  TournamentResponse({
    required this.success,
    required this.message,
    this.registration,
  });

  factory TournamentResponse.fromJson(Map<String, dynamic> json) {
    return TournamentResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      registration: json['registration'] != null
          ? TournamentRegistration.fromJson(json['registration'])
          : null,
    );
  }
}
