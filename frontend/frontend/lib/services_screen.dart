import 'package:flutter/material.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildPageHeader(),
          _buildServicesIntro(),
          _buildServicesGrid(),
          _buildPricingSection(),
          _buildCTASection(),
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
          image: AssetImage('assets/images/services_header.jpg'),
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
                Text('WHAT WE OFFER',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    letterSpacing: 3.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 15),
                Text('Our Services',
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

  Widget _buildServicesIntro() {
    return Container(
      padding: EdgeInsets.all(80),
      child: Column(
        children: [
          Text(
            'We offer a comprehensive range of chess services designed to cater to players of all skill levels. From beginner basics to advanced tournament preparation, our expert coaches provide personalized instruction that helps you achieve your chess goals.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF404957),
              fontSize: 20,
              height: 1.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesGrid() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 80, vertical: 40),
      child: GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        crossAxisSpacing: 30,
        mainAxisSpacing: 30,
        childAspectRatio: 0.75,
        children: [
          _buildDetailedServiceCard(
            Icons.person,
            'Private Lessons',
            'One-on-one personalized chess coaching',
            'Get individualized attention from our expert coaches. We tailor lessons to your skill level and learning pace, focusing on areas that need improvement. Perfect for rapid skill development.',
            ['Customized learning plan', 'Flexible scheduling', 'Progress tracking', 'Game analysis'],
          ),
          _buildDetailedServiceCard(
            Icons.school,
            'Chess in Schools',
            'Comprehensive school chess programs',
            'We bring chess education to schools with structured curricula combining chess with mathematics and reading skills. Our programs enhance critical thinking and academic performance.',
            ['Curriculum development', 'Trained instructors', 'Student assessments', 'School tournaments'],
          ),
          _buildDetailedServiceCard(
            Icons.groups,
            'Group Sessions',
            'Interactive group training',
            'Join our weekend and holiday group sessions where players learn together, share strategies, and build friendships. Group dynamics create a motivating learning environment.',
            ['Weekend classes', 'Holiday camps', 'Peer learning', 'Team building'],
          ),
          _buildDetailedServiceCard(
            Icons.laptop,
            'Online Classes',
            'Virtual chess training',
            'Access world-class chess education from anywhere. Our online platform provides interactive lessons, practice puzzles, and live coaching sessions with screen sharing and analysis tools.',
            ['Live interactive sessions', 'Recorded lessons', 'Online tournaments', 'Digital resources'],
          ),
          _buildDetailedServiceCard(
            Icons.emoji_events,
            'Tournaments',
            'Competitive chess events',
            'Participate in regular tournaments ranging from rapid chess to classical formats. Gain valuable competitive experience and earn ratings under official chess federations.',
            ['Regular competitions', 'Rating opportunities', 'Prize categories', 'All skill levels'],
          ),
          _buildDetailedServiceCard(
            Icons.supervised_user_circle,
            'Mentorship Programs',
            'Long-term player development',
            'Our mentorship programs provide ongoing guidance beyond regular lessons. Mentors help develop strategic thinking, competitive mindset, and lifelong chess appreciation.',
            ['Experienced mentors', 'Career guidance', 'College prep support', 'Life skills development'],
          ),
          _buildDetailedServiceCard(
            Icons.library_books,
            'Chess Library',
            'Extensive learning resources',
            'Access our comprehensive collection of chess books, magazines, and digital resources. From opening theory to endgame studies, find materials for every aspect of the game.',
            ['Classic chess books', 'Modern publications', 'Magazine archives', 'Video library'],
          ),
          _buildDetailedServiceCard(
            Icons.shopping_bag,
            'Chess Equipment',
            'Quality chess gear',
            'Purchase or rent high-quality chess sets, clocks, and accessories. We stock tournament-standard equipment and unique collector\'s items for enthusiasts.',
            ['Tournament sets', 'Digital clocks', 'Chess boards', 'Books & accessories'],
          ),
          _buildDetailedServiceCard(
            Icons.event,
            'Workshops & Seminars',
            'Specialized learning sessions',
            'Attend intensive workshops on specific topics like opening theory, endgame techniques, or tactical patterns. Guest speakers and grandmasters share insights and strategies.',
            ['Expert speakers', 'Focused topics', 'Interactive sessions', 'Certificate programs'],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedServiceCard(IconData icon, String title, String subtitle, String description, List<String> features) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              gradient: LinearGradient(
                colors: [Color(0xFF5886BF), Color(0xFF4F78AB)],
              ),
            ),
            child: Center(
              child: Icon(icon, size: 80, color: Colors.white),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                    style: TextStyle(
                      color: Color(0xFF0B131E),
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(subtitle,
                    style: TextStyle(
                      color: Color(0xFF5886BF),
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(description,
                    style: TextStyle(
                      color: Color(0xFF404957),
                      fontSize: 14,
                      height: 1.5,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 15),
                  ...features.take(3).map((feature) => Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Color(0xFF5886BF), size: 16),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(feature,
                            style: TextStyle(
                              color: Color(0xFF404957),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
                  Spacer(),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    child: Text('Learn More →',
                      style: TextStyle(
                        color: Color(0xFF5886BF),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingSection() {
    return Container(
      padding: EdgeInsets.all(80),
      color: Color(0xFFF5F9FF),
      child: Column(
        children: [
          Text('PRICING PLANS',
            style: TextStyle(
              color: Color(0xFF283D57),
              fontSize: 14,
              letterSpacing: 3.5,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 15),
          Text('Choose Your Package',
            style: TextStyle(
              color: Color(0xFF0B131E),
              fontSize: 48,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 60),
          Row(
            children: [
              Expanded(child: _buildPricingCard('Beginner', '5,000 KES', 'per month', ['4 group sessions', '1 hour each', 'Basic materials', 'Certificate'])),
              SizedBox(width: 30),
              Expanded(child: _buildPricingCard('Intermediate', '8,000 KES', 'per month', ['4 private lessons', '1.5 hours each', 'Game analysis', 'Tournament entry', 'Advanced materials'], isPopular: true)),
              SizedBox(width: 30),
              Expanded(child: _buildPricingCard('Advanced', '12,000 KES', 'per month', ['8 private lessons', '2 hours each', 'Personalized training', 'Tournament coaching', 'All materials', 'Mentorship'])),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPricingCard(String name, String price, String period, List<String> features, {bool isPopular = false}) {
    return Card(
      elevation: isPopular ? 8 : 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: isPopular ? BorderSide(color: Color(0xFF5886BF), width: 2) : BorderSide.none,
      ),
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          children: [
            if (isPopular)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                  color: Color(0xFF5886BF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('POPULAR',
                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            SizedBox(height: 20),
            Text(name,
              style: TextStyle(
                color: Color(0xFF0B131E),
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 20),
            Text(price,
              style: TextStyle(
                color: Color(0xFF5886BF),
                fontSize: 48,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(period,
              style: TextStyle(
                color: Color(0xFF404957),
                fontSize: 16,
              ),
            ),
            SizedBox(height: 30),
            ...features.map((feature) => Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Color(0xFF5886BF), size: 20),
                  SizedBox(width: 10),
                  Text(feature,
                    style: TextStyle(color: Color(0xFF404957), fontSize: 16)),
                ],
              ),
            )),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: isPopular ? Color(0xFF5886BF) : Color(0xFF5B728F),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Get Started',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCTASection() {
    return Container(
      padding: EdgeInsets.all(80),
      color: Color(0xFF5886BF),
      child: Column(
        children: [
          Text('Ready to Begin Your Chess Journey?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 42,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 20),
          Text('Contact us today to book your first session or learn more about our services',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('BOOK A SESSION NOW',
              style: TextStyle(
                color: Color(0xFF5886BF),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
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
      child: Center(
        child: Text('© 2025 PMadol Chess Club. All rights reserved.',
          style: TextStyle(color: Color(0xFFF4F6F7), fontSize: 14)),
      ),
    );
  }
}