// ============================================
// lib/about_screen.dart - API-Driven About Page
// ============================================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/home_provider.dart';
import 'providers/about_provider.dart';
import 'providers/team_provider.dart';
import 'widgets/footer_widget.dart';
import 'config/api_config.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    Future.microtask(() {
      context.read<HomeProvider>().loadHomeData();
      context.read<AboutProvider>().loadAbout();
      context.read<TeamProvider>().loadTeamMembers();
    });
  }

  String? _resolveImageUrl(String? path) {
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('http')) return path;
    return '${ApiConfig.baseUrl}$path';
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Consumer3<HomeProvider, AboutProvider, TeamProvider>(
      builder: (context, homeProvider, aboutProvider, teamProvider, child) {
        // Combined loading state
        if (homeProvider.isLoading || aboutProvider.isLoading) {
          return Center(
            child: CircularProgressIndicator(color: Color(0xFF5886BF)),
          );
        }

        // Error state
        if (homeProvider.error != null || aboutProvider.error != null) {
          return _buildErrorWidget();
        }

        final homeData = homeProvider.homeData;
        final aboutContent = aboutProvider.content;

        if (homeData == null) {
          return Center(child: Text('No site data available'));
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              _buildPageHeader(
                homeData.siteSettings,
                aboutContent,
                aboutProvider.coreValues,
                teamProvider.members,
                isMobile,
              ),
              if (aboutContent != null) ...[
                _buildAboutContent(aboutContent, teamProvider, isMobile),
                _buildMissionVision(aboutContent, isMobile),
              ],
              _buildCoreValues(aboutProvider.coreValues, isMobile),
              _buildTeamSection(teamProvider, isMobile),
              FooterWidget(settings: homeData.siteSettings),
            ],
          ),
        );
      },
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 80, color: Colors.red.shade400),
              SizedBox(height: 20),
              Text(
                'Failed to load content',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _loadData,
                icon: Icon(Icons.refresh),
                label: Text('Retry'),
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF5886BF)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionShell({
    required String label,
    required String title,
    String? subtitle,
    required Widget child,
    required bool isMobile,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 60,
        horizontal: isMobile ? 20 : 80,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(label),
          SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              color: Color(0xFF0B131E),
              fontSize: isMobile ? 26 : 40,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (subtitle != null && subtitle.isNotEmpty) ...[
            SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                color: Color(0xFF707781),
                fontSize: isMobile ? 14 : 15,
              ),
            ),
          ],
          SizedBox(height: isMobile ? 24 : 32),
          child,
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xFF5886BF).withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Color(0xFF5886BF).withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Color(0xFF2E4E79),
          fontSize: 12,
          letterSpacing: 1.2,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildPageHeader(
    dynamic settings,
    dynamic aboutContent,
    List<dynamic> coreValues,
    List<dynamic> teamMembers,
    bool isMobile,
  ) {
    final heroImage = _resolveImageUrl(aboutContent?.storyImage);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 700),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 16),
            child: Container(
              height: isMobile ? 380 : 440,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1F3A5F), Color(0xFF0D1C2F)],
                ),
                image: heroImage != null
                    ? DecorationImage(
                        image: NetworkImage(heroImage),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.45),
                          BlendMode.darken,
                        ),
                      )
                    : null,
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
                          _buildLabel('ABOUT'),
                          SizedBox(height: 14),
                          Text(
                            settings.siteName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isMobile ? 32 : 56,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: 14),
                          Text(
                            settings.tagline,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: isMobile ? 14 : 18,
                              height: 1.6,
                            ),
                          ),
                          SizedBox(height: 18),
                          if (aboutContent != null)
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: isMobile ? double.infinity : 780),
                              child: Text(
                                aboutContent.storyContent,
                                maxLines: isMobile ? 3 : 4,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: isMobile ? 13 : 15,
                                  height: 1.6,
                                ),
                              ),
                            ),
                          SizedBox(height: 22),
                          _buildHighlightChips(aboutContent, coreValues, teamMembers, isMobile),
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

  Widget _buildHighlightChips(
    dynamic aboutContent,
    List<dynamic> coreValues,
    List<dynamic> teamMembers,
    bool isMobile,
  ) {
    final chips = <String>[];

    if (aboutContent != null && aboutContent.foundedYear > 0) {
      chips.add('Founded ${aboutContent.foundedYear}');
    }
    if (teamMembers.isNotEmpty) {
      chips.add('${teamMembers.length}+ team members');
    }
    if (coreValues.isNotEmpty) {
      chips.add('${coreValues.length} core values');
    }

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: chips
          .map(
            (c) => Container(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.15)),
              ),
              child: Text(
                c,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 12 : 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildAboutContent(aboutContent, TeamProvider teamProvider, bool isMobile) {
    final String? imageUrl = aboutContent.storyImage != null
        ? (aboutContent.storyImage!.startsWith('http')
            ? aboutContent.storyImage
            : '${ApiConfig.baseUrl}${aboutContent.storyImage}')
        : null;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF4F7FB), Color(0xFFEAF1F9)],
        ),
        border: Border(
          top: BorderSide(color: Color(0xFFE0E8F3)),
          bottom: BorderSide(color: Color(0xFFE0E8F3)),
        ),
      ),
      child: _buildSectionShell(
        label: 'ABOUT',
        title: aboutContent.storyTitle,
        subtitle: 'Framed overview with live content from your admin API.',
        isMobile: isMobile,
        child: Column(
          children: [
            if (isMobile) ...[
              _buildFramedCard(
                child: _buildStoryText(aboutContent.storyContent, isMobile),
              ),
              SizedBox(height: 20),
              if (imageUrl != null)
                _buildFramedCard(
                  child: _buildStoryImage(imageUrl, isMobile),
                ),
            ] else ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildFramedCard(
                      child: _buildStoryText(aboutContent.storyContent, isMobile),
                    ),
                  ),
                  if (imageUrl != null) ...[
                    SizedBox(width: 30),
                    Expanded(
                      child: _buildFramedCard(
                        child: _buildStoryImage(imageUrl, isMobile),
                      ),
                    ),
                  ],
                ],
              ),
            ],
            SizedBox(height: 24),
            _buildFactsRow(aboutContent, teamProvider, isMobile),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryText(String content, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          content,
          style: TextStyle(
            color: Color(0xFF707781),
            fontSize: isMobile ? 15 : 16,
            height: 1.8,
          ),
        ),
      ],
    );
  }

  Widget _buildStoryImage(String imageUrl, bool isMobile) {
    return Container(
      height: isMobile ? 300 : 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildFramedCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Color(0xFFE1E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      padding: EdgeInsets.all(22),
      child: child,
    );
  }

  Widget _buildFactsRow(aboutContent, TeamProvider teamProvider, bool isMobile) {
    final facts = [
      _Fact(label: 'Founded', value: aboutContent.foundedYear > 0 ? '${aboutContent.foundedYear}' : '—'),
      _Fact(label: 'Team', value: teamProvider.members.isNotEmpty ? '${teamProvider.members.length}+ people' : 'Growing'),
      _Fact(label: 'Mission', value: 'Mission & Vision framed below'),
    ];

    return Wrap(
      spacing: isMobile ? 12 : 16,
      runSpacing: 12,
      children: facts.map((f) => _buildFactCard(f, isMobile)).toList(),
    );
  }

  Widget _buildFactCard(_Fact fact, bool isMobile) {
    return Container(
      width: isMobile ? double.infinity : 200,
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE1E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fact.label,
            style: TextStyle(
              color: Color(0xFF2E4E79),
              fontSize: 12,
              letterSpacing: 1.1,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 6),
          Text(
            fact.value,
            style: TextStyle(
              color: Color(0xFF0B131E),
              fontSize: isMobile ? 16 : 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionVision(aboutContent, bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF5886BF), Color(0xFF3D5A8F)],
        ),
      ),
      child: _buildSectionShell(
        label: 'DIRECTION',
        title: 'Mission & Vision',
        subtitle: 'Framed cards pull their text from the API so admins control the messaging.',
        isMobile: isMobile,
        child: isMobile
            ? Column(
                children: [
                  _buildMissionVisionCard(
                    'MISSION',
                    aboutContent.missionStatement,
                    Icons.flag,
                    isMobile,
                  ),
                  SizedBox(height: 20),
                  _buildMissionVisionCard(
                    'VISION',
                    aboutContent.visionStatement,
                    Icons.visibility,
                    isMobile,
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: _buildMissionVisionCard(
                      'MISSION',
                      aboutContent.missionStatement,
                      Icons.flag,
                      isMobile,
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: _buildMissionVisionCard(
                      'VISION',
                      aboutContent.visionStatement,
                      Icons.visibility,
                      isMobile,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildMissionVisionCard(String title, String content, IconData icon, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 30 : 40),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: isMobile ? 32 : 40),
          SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 18 : 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 15),
          Text(
            content,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: isMobile ? 14 : 15,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoreValues(List<dynamic> values, bool isMobile) {
    if (values.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFC)],
        ),
        border: Border(top: BorderSide(color: Color(0xFFE0E8F3))),
      ),
      child: _buildSectionShell(
        label: 'VALUES',
        title: 'What Guides Us',
        subtitle: 'Cards stay in the same grid but pull text/icons from the API.',
        isMobile: isMobile,
        child: Wrap(
          spacing: isMobile ? 20 : 30,
          runSpacing: isMobile ? 20 : 30,
          alignment: WrapAlignment.center,
          children: values.map((v) {
            IconData icon = Icons.star;
            switch (v.icon?.toLowerCase()) {
              case 'integrity':
              case 'handshake':
                icon = Icons.handshake;
                break;
              case 'community':
              case 'people':
                icon = Icons.people;
                break;
              case 'innovation':
              case 'lightbulb':
                icon = Icons.lightbulb;
                break;
              default:
                icon = Icons.star;
            }
            return _buildValueCard(v.title, v.description, icon, isMobile);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildValueCard(String title, String description, IconData icon, bool isMobile) {
    return Container(
      width: isMobile ? double.infinity : 220,
      padding: EdgeInsets.all(isMobile ? 25 : 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: isMobile ? 50 : 60,
            height: isMobile ? 50 : 60,
            decoration: BoxDecoration(
              color: Color(0xFF5886BF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(isMobile ? 25 : 30),
            ),
            child: Icon(icon, color: Color(0xFF5886BF), size: isMobile ? 25 : 30),
          ),
          SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF0B131E),
              fontSize: isMobile ? 16 : 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 15),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF707781),
              fontSize: isMobile ? 13 : 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamSection(TeamProvider teamProvider, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 50 : 80,
        horizontal: isMobile ? 20 : 80,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF0F4F9), Color(0xFFE8EFF7)],
        ),
      ),
      child: Column(
        children: [
          Text(
            'OUR TEAM',
            style: TextStyle(
              color: Color(0xFF5886BF),
              fontSize: isMobile ? 12 : 14,
              letterSpacing: 3.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Expert Coaches & Instructors',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF0B131E),
              fontSize: isMobile ? 28 : 48,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: isMobile ? 40 : 60),
          if (teamProvider.isLoading) ...[
            Center(child: CircularProgressIndicator(color: Color(0xFF5886BF)))
          ] else if (teamProvider.error != null) ...[
            Text(
              'Failed to load team',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          ] else ...[
            Wrap(
              spacing: isMobile ? 20 : 30,
              runSpacing: isMobile ? 20 : 30,
              alignment: WrapAlignment.center,
              children: teamProvider.members
                  .map((m) => _buildTeamMemberCard(
                        m.name,
                        m.roleDisplay,
                        m.qualifications ?? m.rating ?? '',
                        m.photo,
                        isMobile,
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTeamMemberCard(String name, String role, String title, String? photo, bool isMobile) {
    final String? photoUrl = (photo != null && photo.isNotEmpty)
        ? (photo.startsWith('http') ? photo : '${ApiConfig.baseUrl}$photo')
        : null;

    return Container(
      width: isMobile ? double.infinity : 240,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: isMobile ? 180 : 200,
            decoration: BoxDecoration(
              color: Color(0xFF5886BF).withOpacity(0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              image: photoUrl != null
                  ? DecorationImage(
                      image: NetworkImage(photoUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: photoUrl == null
                ? Icon(Icons.person, size: isMobile ? 60 : 80, color: Color(0xFF5886BF))
                : null,
          ),
          Padding(
            padding: EdgeInsets.all(isMobile ? 16 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF0B131E),
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  role,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF5886BF),
                    fontSize: isMobile ? 13 : 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (title.isNotEmpty) ...[
                  SizedBox(height: 8),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF707781),
                      fontSize: isMobile ? 12 : 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Fact {
  final String label;
  final String value;

  const _Fact({required this.label, required this.value});
}
