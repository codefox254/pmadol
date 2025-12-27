// ============================================
// lib/services/membership_service.dart
// ============================================

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/service_models.dart';

class MembershipService {
  static const String baseUrl = 'http://127.0.0.1:8000/api/services';

  // Fetch all membership plans
  static Future<List<MembershipPlan>> getMembershipPlans() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/membership-plans/'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => MembershipPlan.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load membership plans');
      }
    } catch (e) {
      throw Exception('Error fetching membership plans: $e');
    }
  }

  // Get default membership plan
  static Future<MembershipPlan?> getDefaultPlan() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/membership-plans/default_plan/'),
      );

      if (response.statusCode == 200) {
        return MembershipPlan.fromJson(json.decode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // Register new membership
  static Future<ClubMembership> registerMembership(
      ClubMembershipRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/memberships/register/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 201) {
        return ClubMembership.fromJson(json.decode(response.body));
      } else {
        final error = json.decode(response.body);
        throw Exception(error['detail'] ?? 'Registration failed');
      }
    } catch (e) {
      throw Exception('Error registering membership: $e');
    }
  }

  // Confirm M-Pesa payment
  static Future<ClubMembership> confirmPayment(
      int membershipId, String transactionId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/memberships/$membershipId/confirm_payment/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'transaction_id': transactionId}),
      );

      if (response.statusCode == 200) {
        return ClubMembership.fromJson(json.decode(response.body));
      } else {
        final error = json.decode(response.body);
        throw Exception(error['detail'] ?? 'Payment confirmation failed');
      }
    } catch (e) {
      throw Exception('Error confirming payment: $e');
    }
  }

  // Check membership status
  static Future<ClubMembership?> checkMembershipStatus(
      String membershipNumber) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/memberships/check_status/?membership_number=$membershipNumber'),
      );

      if (response.statusCode == 200) {
        return ClubMembership.fromJson(json.decode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
