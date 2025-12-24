// ============================================
// lib/providers/team_provider.dart
// ============================================
import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../models/team_models.dart';

class TeamProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<TeamMember> _members = [];
  bool _isLoading = false;
  String? _error;

  List<TeamMember> get members => _members;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadTeamMembers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _members = await _apiService.getTeamMembers();
      _error = null;
    } catch (e) {
      _error = e.toString();
      _members = [];
      if (kDebugMode) {
        print('Error loading team members: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
