import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildPageHeader(),
          _buildAboutContent(),
          _buildMissionVision(),
          _buildCoreValues(),
          _buildTeamSection(),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildPageHeader() {
    return Container(
      height: 300,
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
                Text('ABOUT US',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    letterSpacing: 3.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 15),
                Text('PMadol Chess Club',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 56,
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

  Widget _buildAboutContent() {
    return Container(
      padding: EdgeInsets.all(80),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('OUR STORY',
                  style: TextStyle(
                    color: Color(0xFF283D57),
                    fontSize: 14,
                    letterSpacing: 3.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 15),
                Text('Building Champions Since 2016',
                  style: TextStyle(
                    color: Color(0xFF0B131E),
                    fontSize: 48,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -1,
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'PMadol Chess Club was founded with a vision to create a nurturing environment where chess enthusiasts of all ages could develop their skills, strategic thinking, and passion for the game. Over the years, we have grown into one of Kenya\'s most progressive chess clubs.',
                  style: TextStyle(
                    color: Color(0xFF404957),
                    fontSize: 18,
                    height: 1.8,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Our journey began in the heart of Nairobi, with a small group of dedicated chess players who shared a common dream – to make chess accessible to everyone. Today, we are proud to have trained hundreds of students, won numerous accolades, and built a vibrant community of strategic thinkers.',
                  style: TextStyle(
                    color: Color(0xFF404957),
                    fontSize: 18,
                    height: 1.8,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 60),
          Expanded(
            child: Container(
              height: 500,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage('assets/images/about_story.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionVision() {
    return Container(
      padding: EdgeInsets.all(80),
      color: Color(0xFFF5F9FF),
      child: Row(
        children: [
          Expanded(
            child: Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.flag, color: Color(0xFF5886BF), size: 50),
                    SizedBox(height: 20),
                    Text('Our Mission',
                      style: TextStyle(
                        color: Color(0xFF0B131E),
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'To foster a vibrant and inclusive chess community that nurtures the intellectual and personal growth of players at all levels. We are committed to providing high-quality coaching, organizing competitive tournaments, and creating opportunities for lifelong learning through the game of chess.',
                      style: TextStyle(
                        color: Color(0xFF404957),
                        fontSize: 16,
                        height: 1.8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 30),
          Expanded(
            child: Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.visibility, color: Color(0xFF5886BF), size: 50),
                    SizedBox(height: 20),
                    Text('Our Vision',
                      style: TextStyle(
                        color: Color(0xFF0B131E),
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'To become a leading chess club in East Africa that inspires excellence, nurtures talents, and builds a strong inclusive community of strategic thinkers. We envision a future where chess is accessible to all, empowering individuals with critical thinking skills and fostering a culture of continuous improvement.',
                      style: TextStyle(
                        color: Color(0xFF404957),
                        fontSize: 16,
                        height: 1.8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoreValues() {
    return Container(
      padding: EdgeInsets.all(80),
      child: Column(
        children: [
          Text('OUR PRINCIPLES',
            style: TextStyle(
              color: Color(0xFF283D57),
              fontSize: 14,
              letterSpacing: 3.5,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 15),
          Text('Core Values',
            style: TextStyle(
              color: Color(0xFF0B131E),
              fontSize: 48,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 60),
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 30,
            mainAxisSpacing: 30,
            childAspectRatio: 1.2,
            children: [
              _buildValueCard(Icons.school, 'Excellence', 'We strive for the highest standards in coaching, competition, and personal development.'),
              _buildValueCard(Icons.diversity_3, 'Inclusivity', 'We welcome players of all ages, backgrounds, and skill levels in our community.'),
              _buildValueCard(Icons.handshake, 'Integrity', 'We promote fair play, honesty, and respect in every game and interaction.'),
              _buildValueCard(Icons.psychology, 'Innovation', 'We embrace new teaching methods and technologies to enhance learning.'),
              _buildValueCard(Icons.groups, 'Community', 'We foster strong relationships and mutual support among all members.'),
              _buildValueCard(Icons.trending_up, 'Growth', 'We encourage continuous learning and improvement at every level.'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildValueCard(IconData icon, String title, String description) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Color(0xFF5886BF), size: 50),
            SizedBox(height: 20),
            Text(title,
              style: TextStyle(
                color: Color(0xFF0B131E),
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 15),
            Text(description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF404957),
                fontSize: 15,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamSection() {
    return Container(
      padding: EdgeInsets.all(80),
      color: Color(0xFFF5F9FF),
      child: Column(
        children: [
          Text('MEET THE TEAM',
            style: TextStyle(
              color: Color(0xFF283D57),
              fontSize: 14,
              letterSpacing: 3.5,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 15),
          Text('Our Expert Coaches',
            style: TextStyle(
              color: Color(0xFF0B131E),
              fontSize: 48,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 60),
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            crossAxisSpacing: 30,
            mainAxisSpacing: 30,
            children: List.generate(8, (index) {
              return _buildTeamMember('Coach ${index + 1}', 'Chess Master');
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMember(String name, String role) {
    return Card(
      elevation: 3,
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
                image: DecorationImage(
                  image: AssetImage('assets/images/coach_placeholder.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                Text(name,
                  style: TextStyle(
                    color: Color(0xFF0B131E),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 5),
                Text(role,
                  style: TextStyle(
                    color: Color(0xFF404957),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      color: Color(0xFF0B131E),
      padding: EdgeInsets.all(80),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 60,
                      width: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/Panchol-Madol-Chess-Club-Logo.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Text(
                      'PMadol Chess Club coaching aim to broaden the horizons of young minds through chess.',
                      style: TextStyle(
                        color: Color(0xFFF4F6F7),
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 60),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Quick Links',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildFooterLink('Home'),
                    _buildFooterLink('About Us'),
                    _buildFooterLink('Services'),
                    _buildFooterLink('Gallery'),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Contact Info',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text('+254 714 272 082',
                      style: TextStyle(color: Color(0xFFF4F6F7), fontSize: 16)),
                    SizedBox(height: 10),
                    Text('info@pmadol.com',
                      style: TextStyle(color: Color(0xFFF4F6F7), fontSize: 16)),
                    SizedBox(height: 10),
                    Text('Nairobi - Kenya',
                      style: TextStyle(color: Color(0xFFF4F6F7), fontSize: 16)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 50),
          Divider(color: Colors.white24),
          SizedBox(height: 20),
          Text('© 2025 PMadol Chess Club. All rights reserved.',
            style: TextStyle(color: Color(0xFFF4F6F7), fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildFooterLink(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Text(text,
        style: TextStyle(color: Color(0xFFF4F6F7), fontSize: 16)),
    );
  }
}