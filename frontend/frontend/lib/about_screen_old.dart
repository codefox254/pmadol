// ============================================
// lib/about_screen.dart - Modern Dynamic API-Driven
// ============================================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/home_provider.dart';
import 'widgets/footer_widget.dart';
import 'providers/team_provider.dart';
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
      context.read<TeamProvider>().loadTeamMembers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        if (homeProvider.isLoading) {
          return Center(
            child: CircularProgressIndicator(color: Color(0xFF5886BF)),
          );
        }

        if (homeProvider.error != null) {
          return _buildErrorWidget();
        }

        final homeData = homeProvider.homeData;
        if (homeData == null) {
          return Center(child: Text('No data available'));
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              _buildPageHeader(homeData.siteSettings),
              _buildAboutContent(),
              _buildMissionVision(),
              _buildCoreValues(),
              _buildTeamSection(),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.red),
            SizedBox(height: 20),
            Text('Failed to load content', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadData,
              child: Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageHeader(dynamic settings) {
    return Container(
      height: 350,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/about_header.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Container(color: Colors.black.withOpacity(0.6)),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'OUR STORY',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    letterSpacing: 3.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  settings.siteName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 52,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  settings.tagline,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutContent() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 80, horizontal: 80),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF0F4F9),
            Color(0xFFE8EFF7),
          ],
        ),
      ),
      child: Column(
        children: [
          Text(
            'WHO WE ARE',
            style: TextStyle(
              color: Color(0xFF5886BF),
              fontSize: 14,
              letterSpacing: 3.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Dedicated to Chess Excellence',
            style: TextStyle(
              color: Color(0xFF0B131E),
              fontSize: 48,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 40),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Our Journey',
                      style: TextStyle(
                        color: Color(0xFF283D57),
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Since our founding, PMadol Chess Club has been dedicated to developing '
                      'world-class chess players and promoting the game at all levels. Our comprehensive '
                      'programs and experienced coaches have helped hundreds of students achieve their chess goals.',
                      style: TextStyle(
                        color: Color(0xFF707781),
                        fontSize: 16,
                        height: 1.8,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'We believe chess develops critical thinking, strategic planning, and discipline. '
                      'Our mission is to make quality chess education accessible to everyone.',
                      style: TextStyle(
                        color: Color(0xFF707781),
                        fontSize: 16,
                        height: 1.8,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 60),
              Expanded(
                child: Container(
                  height: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: AssetImage('assets/images/hero_bg.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMissionVision() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 80, horizontal: 80),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFF5886BF),
            Color(0xFF3D5A8F),
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: _buildMissionVisionCard(
              'MISSION',
              'To provide world-class chess education that develops strategic thinking, discipline, '
              'and competitive excellence in our students.',
              Icons.flag,
            ),
          ),
          SizedBox(width: 40),
          Expanded(
            child: _buildMissionVisionCard(
              'VISION',
              'To be the leading chess academy in East Africa, recognized for producing champions '
              'and fostering a vibrant chess community.',
              Icons.visibility,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionVisionCard(String title, String content, IconData icon) {
    return Container(
      padding: EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 40),
          SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 15),
          Text(
            content,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 15,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoreValues() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 80, horizontal: 80),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFFFFF),
            Color(0xFFF8FAFC),
          ],
        ),
      ),
      child: Column(
        children: [
          Text(
            'OUR VALUES',
            style: TextStyle(
              color: Color(0xFF5886BF),
              fontSize: 14,
              letterSpacing: 3.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'What Guides Us',
            style: TextStyle(
              color: Color(0xFF0B131E),
              fontSize: 48,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 60),
          Wrap(
            spacing: 30,
            runSpacing: 30,
            children: [
              _buildValueCard(
                'Excellence',
                'Pursuing the highest standards in everything we do',
                Icons.star,
              ),
              _buildValueCard(
                'Integrity',
                'Operating with honesty and strong moral principles',
                Icons.handshake,
              ),
              _buildValueCard(
                'Community',
                'Building a supportive network of chess enthusiasts',
                Icons.people,
              ),
              _buildValueCard(
                'Innovation',
                'Embracing new methods and technologies in teaching',
                Icons.lightbulb,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildValueCard(String title, String description, IconData icon) {
    return Container(
      width: 220,
      padding: EdgeInsets.all(30),
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
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Color(0xFF5886BF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(icon, color: Color(0xFF5886BF), size: 30),
          ),
          SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF0B131E),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 15),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF707781),
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamSection() {
    return Consumer<TeamProvider>(
      builder: (context, teamProvider, child) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 80, horizontal: 80),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFF0F4F9),
                Color(0xFFE8EFF7),
              ],
            ),
          ),
          child: Column(
            children: [
              Text(
                'OUR TEAM',
                style: TextStyle(
                  color: Color(0xFF5886BF),
                  fontSize: 14,
                  letterSpacing: 3.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Expert Coaches & Instructors',
                style: TextStyle(
                  color: Color(0xFF0B131E),
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 60),
              if (teamProvider.isLoading) ...[
                Center(
                  child: CircularProgressIndicator(color: Color(0xFF5886BF)),
                )
              ] else if (teamProvider.error != null) ...[
                Text(
                  'Failed to load team',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ] else ...[
                Wrap(
                  spacing: 30,
                  runSpacing: 30,
                  alignment: WrapAlignment.center,
                  children: teamProvider.members.map((m) => _buildTeamMemberCard(
                    m.name,
                    m.roleDisplay,
                    m.qualifications ?? m.rating ?? '',
                    m.photo,
                  )).toList(),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildTeamMemberCard(String name, String role, String title, [String? photo]) {
    return Container(
      width: 240,
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
            height: 200,
            decoration: BoxDecoration(
              color: Color(0xFF5886BF).withOpacity(0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              image: (photo != null && photo.isNotEmpty)
                  ? DecorationImage(
                      image: NetworkImage(photo.startsWith('http') ? photo : '${ApiConfig.baseUrl}$photo'),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: (photo == null || photo.isEmpty)
                ? Icon(Icons.person, size: 80, color: Color(0xFF5886BF))
                : null,
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: Color(0xFF0B131E),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  role,
                  style: TextStyle(
                    color: Color(0xFF5886BF),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: Color(0xFF707781),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
