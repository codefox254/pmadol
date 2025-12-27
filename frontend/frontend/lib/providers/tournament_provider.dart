// ============================================
// lib/providers/tournament_provider.dart
// ============================================
import 'package:flutter/foundation.dart';
import '../models/tournament_models.dart';
import '../services/api_service.dart';
import '../config/api_config.dart';

class TournamentProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Tournament> _tournaments = [];
  List<Tournament> _upcomingTournaments = [];
  List<Tournament> _ongoingTournaments = [];
  List<Tournament> _completedTournaments = [];
  bool _isLoading = false;
  bool _isRegistering = false;
  String? _error;
  String? _successMessage;

  List<Tournament> get tournaments => _tournaments;
  List<Tournament> get upcomingTournaments => _upcomingTournaments;
  List<Tournament> get ongoingTournaments => _ongoingTournaments;
  List<Tournament> get completedTournaments => _completedTournaments;
  bool get isLoading => _isLoading;
  bool get isRegistering => _isRegistering;
  String? get error => _error;
  String? get successMessage => _successMessage;

  Future<void> loadTournaments() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _apiService.get(
        '${ApiConfig.apiUrl}/tournaments/tournaments/',
      );
      final list = (data is Map && data.containsKey('results'))
          ? data['results']
          : (data is List ? data : []);

      _tournaments = (list as List)
          .map((json) => Tournament.fromJson(json as Map<String, dynamic>))
          .toList();

      // Sort by date
      _tournaments.sort((a, b) => a.startDate.compareTo(b.startDate));

      // Separate into upcoming, ongoing, and completed
      _upcomingTournaments = _tournaments.where((t) => t.isUpcoming).toList();
      _ongoingTournaments = _tournaments.where((t) => t.isOngoing).toList();
      _completedTournaments = _tournaments.where((t) => t.isPast).toList();

      _error = null;
    } catch (e) {
      _error = 'Failed to load tournaments: $e';
      if (kDebugMode) print('Error loading tournaments: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> registerForTournament(
    TournamentRegistration registration,
  ) async {
    _isRegistering = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.post(
        '${ApiConfig.apiUrl}/tournaments/registrations/',
        data: registration.toJson(),
      );

      if (response is Map) {
        final tournamentResponse = TournamentResponse.fromJson(
          response as Map<String, dynamic>,
        );
        if (tournamentResponse.success) {
          _successMessage = tournamentResponse.message;
          // Reload tournaments to update registration count
          await loadTournaments();
          return true;
        } else {
          _error = tournamentResponse.message;
          return false;
        }
      }
      return false;
    } catch (e) {
      _error = 'Failed to register for tournament: $e';
      if (kDebugMode) print('Error registering: $e');
      return false;
    } finally {
      _isRegistering = false;
      notifyListeners();
    }
  }

  void clearMessages() {
    _error = null;
    _successMessage = null;
    notifyListeners();
  }
}
