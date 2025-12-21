import 'package:flutter/material.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildPageHeader(),
          _buildContactContent(),
          _buildMapSection(),
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
          image: AssetImage('assets/images/contact_header.jpg'),
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
                Text('GET IN TOUCH',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    letterSpacing: 3.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 15),
                Text('Contact Us',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 56,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 20),
                Text('We\'d love to hear from you',
                  style: TextStyle(
                    color: Colors.white,
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

  Widget _buildContactContent() {
    return Container(
      padding: EdgeInsets.all(80),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Send Us a Message',
                  style: TextStyle(
                    color: Color(0xFF0B131E),
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Have questions about our services, want to schedule a session, or just want to say hello? Fill out the form below and we\'ll get back to you as soon as possible.',
                  style: TextStyle(
                    color: Color(0xFF404957),
                    fontSize: 16,
                    height: 1.6,
                  ),
                ),
                SizedBox(height: 40),
                _buildContactForm(),
              ],
            ),
          ),
          SizedBox(width: 80),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                _buildContactInfoCard(),
                SizedBox(height: 30),
                _buildSocialMediaCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactForm() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'First Name *',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                ),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Last Name *',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Email Address *',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                ),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Service of Interest',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          ),
          items: [
            'Select Service',
            'Private Lessons',
            'Chess in Schools',
            'Group Sessions',
            'Online Resources & Classes',
            'Tournaments and Competitions',
            'Mentorship Programs',
            'Chess Library',
            'Chess Equipment',
            'Chess Workshops and Seminars',
            'Chess Community and Networking',
          ].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) {},
        ),
        SizedBox(height: 20),
        TextField(
          decoration: InputDecoration(
            labelText: 'Your Message *',
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          ),
          maxLines: 6,
        ),
        SizedBox(height: 30),
        Row(
          children: [
            Checkbox(
              value: false,
              onChanged: (value) {},
            ),
            Expanded(
              child: Text(
                'I agree to the Terms & Conditions and Privacy Policy',
                style: TextStyle(
                  color: Color(0xFF404957),
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 30),
        ElevatedButton.icon(
          onPressed: () {},
          icon: Icon(Icons.send),
          label: Text('Send Message',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF5886BF),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            minimumSize: Size(double.infinity, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Contact Information',
              style: TextStyle(
                color: Color(0xFF0B131E),
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 30),
            _buildContactInfoItem(Icons.location_on, 'Address', 'Nairobi, Kenya'),
            SizedBox(height: 20),
            _buildContactInfoItem(Icons.phone, 'Phone', '+254 714 272 082'),
            SizedBox(height: 20),
            _buildContactInfoItem(Icons.email, 'Email', 'info@pmadol.com'),
            SizedBox(height: 20),
            _buildContactInfoItem(Icons.access_time, 'Working Hours', 
              'Mon-Sat: 8AM - 10PM\nSunday: 10AM - 8PM'),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfoItem(IconData icon, String title, String info) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Color(0xFFF5F9FF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Color(0xFF5886BF), size: 24),
        ),
        SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                style: TextStyle(
                  color: Color(0xFF404957),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 5),
              Text(info,
                style: TextStyle(
                  color: Color(0xFF0B131E),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSocialMediaCard() {
    return Card(
      elevation: 4,
      color: Color(0xFF5886BF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            Text('Follow Us',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Stay connected with us on social media for the latest updates, news, and chess tips.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.6,
              ),
            ),
            SizedBox(height: 30),
            Wrap(
              spacing: 15,
              runSpacing: 15,
              alignment: WrapAlignment.center,
              children: [
                _buildSocialButton(Icons.facebook, 'Facebook'),
                _buildSocialButton(Icons.camera_alt, 'Instagram'),
                _buildSocialButton(Icons.chat, 'Twitter'),
                _buildSocialButton(Icons.play_circle_fill, 'YouTube'),
                _buildSocialButton(Icons.link, 'LinkedIn'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Color(0xFF5886BF), size: 28),
        ),
        SizedBox(height: 8),
        Text(label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildMapSection() {
    return Container(
      height: 400,
      color: Color(0xFFF5F9FF),
      child: Stack(
        children: [
          // Placeholder for map - replace with actual map integration
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/map_placeholder.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_on, color: Color(0xFF5886BF), size: 40),
                  SizedBox(height: 10),
                  Text('Visit Our Location',
                    style: TextStyle(
                      color: Color(0xFF0B131E),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text('Nairobi, Kenya',
                    style: TextStyle(
                      color: Color(0xFF404957),
                      fontSize: 16,
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

  Widget _buildFooter() {
    return Container(
      color: Color(0xFF0B131E),
      padding: EdgeInsets.all(80),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFooterStat(Icons.schedule, 'Quick Response', 'Within 24 hours'),
              _buildFooterStat(Icons.support_agent, 'Expert Support', 'Dedicated team'),
              _buildFooterStat(Icons.verified, 'Trusted Service', '9+ years experience'),
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

  Widget _buildFooterStat(IconData icon, String title, String subtitle) {
    return Column(
      children: [
        Icon(icon, color: Color(0xFF5886BF), size: 50),
        SizedBox(height: 15),
        Text(title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 5),
        Text(subtitle,
          style: TextStyle(
            color: Color(0xFFF4F6F7),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}