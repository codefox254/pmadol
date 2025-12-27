// ============================================
// lib/screens/tournaments_screen.dart
// ============================================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/tournament_models.dart';
import '../providers/tournament_provider.dart';
import '../providers/home_provider.dart';
import '../config/api_config.dart';
import '../widgets/footer_widget.dart';

class TournamentsScreen extends StatefulWidget {
  const TournamentsScreen({super.key});

  @override
  State<TournamentsScreen> createState() => _TournamentsScreenState();
}

class _TournamentsScreenState extends State<TournamentsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TournamentProvider>().loadTournaments();
      context.read<HomeProvider>().loadHomeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Consumer2<TournamentProvider, HomeProvider>(
      builder: (context, tournamentProvider, homeProvider, child) {
        final homeData = homeProvider.homeData;

        return SingleChildScrollView(
          child: Column(
            children: [
              _buildPageHeader(isMobile),
              _buildTournamentsContent(tournamentProvider, isMobile),
              if (homeData != null) FooterWidget(settings: homeData.siteSettings),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPageHeader(bool isMobile) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 16),
            child: Container(
              height: isMobile ? 320 : 380,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1F3A5F), Color(0xFF0D1C2F)],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: -80,
                    right: -60,
                    child: Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.05),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -40,
                    left: -30,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.04),
                      ),
                    ),
                  ),
                  Container(color: Colors.black.withOpacity(0.18)),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 80),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('TOURNAMENTS'),
                          const SizedBox(height: 14),
                          Text(
                            'Chess Tournaments',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isMobile ? 32 : 56,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'Compete, challenge yourself, and connect with chess players from around the world',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: isMobile ? 14 : 18,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLabel(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withOpacity(0.9),
          fontSize: 12,
          letterSpacing: 1.2,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTournamentsContent(TournamentProvider provider, bool isMobile) {
    if (provider.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(80),
        child: Center(
          child: CircularProgressIndicator(color: Color(0xFF5886BF)),
        ),
      );
    }

    return Column(
      children: [
        if (provider.upcomingTournaments.isNotEmpty)
          _buildTournamentSection(
            'Upcoming Tournaments',
            provider.upcomingTournaments,
            isMobile,
          ),
        if (provider.pastTournaments.isNotEmpty)
          _buildTournamentSection(
            'Past Tournaments',
            provider.pastTournaments,
            isMobile,
            isPast: true,
          ),
        if (provider.upcomingTournaments.isEmpty && provider.pastTournaments.isEmpty)
          const Padding(
            padding: EdgeInsets.all(80),
            child: Center(
              child: Text(
                'No tournaments available at the moment',
                style: TextStyle(fontSize: 18, color: Color(0xFF707781)),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTournamentSection(
    String title,
    List<Tournament> tournaments,
    bool isMobile, {
    bool isPast = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: 60,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isPast
              ? [const Color(0xFFEAECEF), const Color(0xFFD4D8DF)]
              : [const Color(0xFFF4F7FB), const Color(0xFFEAF1F9)],
        ),
        border: const Border(
          top: BorderSide(color: Color(0xFFE0E8F3)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isMobile ? 24 : 36,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0B131E),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 60,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF5886BF),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 40),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 1 : 2,
              crossAxisSpacing: 30,
              mainAxisSpacing: 30,
              childAspectRatio: isMobile ? 1.1 : 1.15,
            ),
            itemCount: tournaments.length,
            itemBuilder: (context, index) {
              return _buildTournamentCard(
                tournaments[index],
                isMobile,
                isPast: isPast,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTournamentCard(
    Tournament tournament,
    bool isMobile, {
    bool isPast = false,
  }) {
    final imageUrl = tournament.image != null
        ? (tournament.image!.startsWith('http')
            ? tournament.image
            : '${ApiConfig.baseUrl}${tournament.image}')
        : null;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageUrl != null)
            Container(
              height: 180,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  if (!isPast)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF5886BF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Upcoming',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            )
          else
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: const Color(0xFF5886BF).withOpacity(0.1),
              ),
              child: const Center(
                child: Icon(
                  Icons.sports_rounded,
                  size: 60,
                  color: Color(0xFF5886BF),
                ),
              ),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tournament.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0B131E),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  _buildTournamentInfo('📍 ${tournament.location}', isMobile),
                  const SizedBox(height: 6),
                  _buildTournamentInfo(
                    '📅 ${DateFormat('MMM d, yyyy').format(tournament.startDate)}',
                    isMobile,
                  ),
                  const SizedBox(height: 6),
                  _buildTournamentInfo(
                    '⏱️ ${tournament.timeControl}',
                    isMobile,
                  ),
                  const SizedBox(height: 12),
                  if (tournament.entryFee != null)
                    _buildTournamentInfo(
                      'KES ${tournament.entryFee!.toStringAsFixed(0)} entry',
                      isMobile,
                      color: const Color(0xFF5886BF),
                    ),
                  const SizedBox(height: 8),
                  const Expanded(child: SizedBox.shrink()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${tournament.registrationCount} registered',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF707781),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      if (isPast && tournament.resultsLink != null)
                        ElevatedButton.icon(
                          onPressed: () async {
                            // In production, would use url_launcher
                            // For now, just show a dialog
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Tournament Results'),
                                content: Text(
                                  'Results available at:\n${tournament.resultsLink}',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Close'),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.leaderboard, size: 16),
                          label: const Text('Results'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5886BF),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        )
                      else if (!isPast)
                        ElevatedButton(
                          onPressed: () {
                            _showRegistrationDialog(tournament);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5886BF),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                          child: const Text(
                            'Register',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildTournamentInfo(String text, bool isMobile, {Color? color}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        color: color ?? const Color(0xFF707781),
        fontWeight: FontWeight.w500,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  void _showRegistrationDialog(Tournament tournament) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: _TournamentRegistrationForm(tournament: tournament),
      ),
    );
  }
}

class _TournamentRegistrationForm extends StatefulWidget {
  final Tournament tournament;

  const _TournamentRegistrationForm({required this.tournament});

  @override
  State<_TournamentRegistrationForm> createState() =>
      _TournamentRegistrationFormState();
}

class _TournamentRegistrationFormState
    extends State<_TournamentRegistrationForm> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _usernameController;
  late TextEditingController _ratingController;
  String _selectedExperience = 'Intermediate';

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _usernameController = TextEditingController();
    _ratingController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _usernameController.dispose();
    _ratingController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    final registration = TournamentRegistration(
      tournamentId: widget.tournament.id,
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      chessUsername: _usernameController.text.trim(),
      rating: int.tryParse(_ratingController.text),
      experience: _selectedExperience,
    );

    context.read<TournamentProvider>().registerForTournament(registration).then(
      (success) {
        if (success) {
          Navigator.pop(context);
          _showSuccessSnackbar();
        }
      },
    );
  }

  void _showSuccessSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          context.read<TournamentProvider>().successMessage ??
              'Successfully registered for tournament!',
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Register for ${widget.tournament.title}',
                style: TextStyle(
                  fontSize: isMobile ? 18 : 20,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0B131E),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('MMMM d, yyyy').format(widget.tournament.startDate),
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF707781),
                ),
              ),
              const SizedBox(height: 24),
              _buildFormField(
                label: 'Full Name *',
                controller: _nameController,
                hint: 'Your full name',
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Full name is required';
                  if ((value?.length ?? 0) < 3) return 'Name too short';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildFormField(
                label: 'Email *',
                controller: _emailController,
                hint: 'your@email.com',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Email is required';
                  if (!value!.contains('@')) return 'Invalid email';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildFormField(
                label: 'Phone Number *',
                controller: _phoneController,
                hint: '+254701234567',
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Phone required';
                  if ((value?.length ?? 0) < 10) return 'Invalid phone';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildFormField(
                label: 'Chess Username *',
                controller: _usernameController,
                hint: 'Your chess.com or lichess username',
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Username required';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildFormField(
                label: 'Rating (Optional)',
                controller: _ratingController,
                hint: 'Your chess rating',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              const Text(
                'Experience Level',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0B131E),
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _selectedExperience,
                items: ['Beginner', 'Intermediate', 'Advanced', 'Expert']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) {
                  setState(() => _selectedExperience = val ?? 'Intermediate');
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFE1E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFE1E8F0)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: Consumer<TournamentProvider>(
                  builder: (context, provider, _) {
                    return ElevatedButton(
                      onPressed: provider.isRegistering ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5886BF),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: provider.isRegistering
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text(
                              'Register',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0B131E),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFFB0B8C1)),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE1E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE1E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF5886BF), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }
}
