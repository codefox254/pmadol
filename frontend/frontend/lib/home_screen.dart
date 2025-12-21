import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeroSlider(),
          _buildWelcomeSection(),
          _buildStatisticsSection(),
          _buildServicesSection(),
          _buildTestimonialsSection(),
          _buildNewsSection(),
          _buildContactSection(),
          _buildContactInfoSection(),
          _buildGallerySection(),
          _buildPartnersSection(),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeroSlider() {
    return Container(
      height: 600,
      color: Colors.grey[200],
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/hero_bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('PMADOL CHESS CLUB',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    letterSpacing: 3.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 20),
                Text('Building and\nNurturing Champions',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 72,
                    fontWeight: FontWeight.w400,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF5886BF),
                    padding: EdgeInsets.symmetric(horizontal: 33, vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('BOOK A SESSION NOW',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      padding: EdgeInsets.all(80),
      color: Color(0xFFF5F9FF),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage('assets/images/P-madol-chess-club.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              height: 500,
            ),
          ),
          SizedBox(width: 60),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('WELCOME TO',
                  style: TextStyle(
                    color: Color(0xFF283D57),
                    fontSize: 14,
                    letterSpacing: 3.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 10),
                Text('PMadol Chess Club',
                  style: TextStyle(
                    color: Color(0xFF0B131E),
                    fontSize: 56,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -1,
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'We are one of Kenya\'s newest and most progressive chess clubs based in the neighbourhood of Nairobi city. Where the thrill of chess comes to life! Step into a world of strategy, intellect, and camaraderie as we invite you to embark on an extraordinary chess journey. Whether you\'re a seasoned player seeking to refine your skills or a newcomer ready to embrace the art of chess, our academy and club provide the perfect platform for growth, learning, and enjoyment.',
                  style: TextStyle(
                    color: Color(0xFF404957),
                    fontSize: 18,
                    height: 1.8,
                  ),
                ),
                SizedBox(height: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildListTile('Expertise and Excellence.'),
                    _buildListTile('Diverse Learning Opportunities.'),
                    _buildListTile('Thriving Chess Community.'),
                    _buildListTile('Experience the joy, intellectual stimulation, and personal growth that chess has to offer...'),
                  ],
                ),
                SizedBox(height: 30),
                Text(
                  'Whether you\'re looking to enhance your skills, compete at a higher level, or simply immerse yourself in a vibrant chess community, PMadol Chess Club is the perfect choice.',
                  style: TextStyle(
                    color: Color(0xFF404957),
                    fontSize: 18,
                    height: 1.8,
                  ),
                ),
                SizedBox(height: 40),
                ExpansionTile(
                  title: Text('Mission Statement:',
                    style: TextStyle(
                      color: Color(0xFF0B131E),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 24, bottom: 16),
                      child: Text(
                        'Our mission is to foster a vibrant and inclusive chess community that nurtures the intellectual and personal growth of players at all levels.',
                        style: TextStyle(
                          color: Color(0xFF404957),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                ExpansionTile(
                  title: Text('Vision Statement.',
                    style: TextStyle(
                      color: Color(0xFF0B131E),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 24, bottom: 16),
                      child: Text(
                        'To become a leading chess club that inspires excellence, nurtures talents and builds a strong inclusive community of strategic thinkers. Add core values of Pmadol chess club.',
                        style: TextStyle(
                          color: Color(0xFF404957),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF5B728F),
                    padding: EdgeInsets.symmetric(horizontal: 33, vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Learn More About Us',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: Color(0xFF5886BF), size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(text,
              style: TextStyle(
                color: Color(0xFF404957),
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return Container(
      color: Color(0xFF5886BF),
      padding: EdgeInsets.symmetric(vertical: 135, horizontal: 80),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatistic(Icons.emoji_events, '23+', 'Awards Per Year'),
          _buildStatistic(Icons.star, '9+', 'Years of Experience'),
          _buildStatistic(Icons.thumb_up, '771+', 'Students & Clients'),
          _buildStatistic(Icons.group, '12+', 'Specialists & Trainers'),
        ],
      ),
    );
  }

  Widget _buildStatistic(IconData icon, String value, String title) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Icon(icon, color: Colors.white, size: 40),
        ),
        SizedBox(height: 20),
        Text(value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 60,
            fontWeight: FontWeight.w700,
            fontFamily: 'Lora',
          ),
        ),
        SizedBox(height: 10),
        Text(title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildServicesSection() {
    return Container(
      padding: EdgeInsets.all(80),
      child: Column(
        children: [
          Text('WHAT WE OFFER',
            style: TextStyle(
              color: Color(0xFF283D57),
              fontSize: 14,
              letterSpacing: 3.5,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 10),
          Text('Our Services',
            style: TextStyle(
              color: Color(0xFF0B131E),
              fontSize: 56,
              fontWeight: FontWeight.w400,
              letterSpacing: -1,
            ),
          ),
          SizedBox(height: 30),
          Text(
            'We offer a range of services designed to cater to all your chess related needs.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF404957),
              fontSize: 18,
              height: 1.8,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Whether you\'re a beginner looking to learn the basics or an experienced player aiming to sharpen your skills, we have something for everyone.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF404957),
              fontSize: 18,
              height: 1.8,
            ),
          ),
          SizedBox(height: 60),
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            crossAxisSpacing: 30,
            mainAxisSpacing: 30,
            children: [
              _buildServiceCard('Private Lessons', 'We offer personalized chess coaching at home, ensuring those with a keen interest to learn chess'),
              _buildServiceCard('Chess in Schools', 'Offering unique combinations such as chess and mathematics, chess and reading, and insightful'),
              _buildServiceCard('Group Sessions', 'We conduct group training sessions during weekends and school holidays'),
              _buildServiceCard('Online Resources & Classes', 'Offers an unrivaled online classroom experience'),
              _buildServiceCard('Tournaments and Competitions', 'From rapid chess to classical tournaments'),
              _buildServiceCard('Mentorship Programs', 'We are Building Strategic Thinkers, Empowering Youth Through Chess, Developing Lifelong Skills'),
              _buildServiceCard('Chess Library', 'Explore our extensive collection of chess books, magazines, and resources in our club library.'),
              _buildServiceCard('Chess Equipment', 'High-quality chess equipment available for purchase or rental. We\'ve got all you need'),
              _buildServiceCard('Chess Workshops and Seminars', 'Broaden your understanding of the game'),
              _buildServiceCard('Chess Community and Networking', 'Broaden your understanding of the game'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(String title, String description) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                image: DecorationImage(
                  image: AssetImage('assets/images/service_placeholder.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                  style: TextStyle(
                    color: Color(0xFF0B131E),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10),
                Text(description,
                  style: TextStyle(
                    color: Color(0xFF404957),
                    fontSize: 14,
                    height: 1.5,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 15),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  child: Text('Read More',
                    style: TextStyle(
                      color: Color(0xFF5886BF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialsSection() {
    return Container(
      padding: EdgeInsets.all(80),
      color: Color(0xFFE9EFF7),
      child: Column(
        children: [
          Text('TESTIMONIALS',
            style: TextStyle(
              color: Color(0xFF000000),
              fontSize: 14,
              letterSpacing: 3.5,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 10),
          Text('What People Say',
            style: TextStyle(
              color: Color(0xFF000000),
              fontSize: 56,
              fontWeight: FontWeight.w400,
              height: 1,
            ),
          ),
          SizedBox(height: 60),
          Column(
            children: [
              _buildTestimonial(
                '"It\'s going to be 6months my daughter has been enrolled in this academy. And she has improved a lot. She became more confident and focused. Thanks to all the mentors for their tremendous effort. It\'s a best chess club."',
                'Parent'
              ),
              SizedBox(height: 30),
              _buildTestimonial(
                '"PMadol Club is an exceptional place for anyone passionate about chess, whether you\'re a beginner or an experienced player. The Teachers are incredibly supportive, offering guidance and encouragement to players of all levels."',
                'Student'
              ),
              SizedBox(height: 30),
              _buildTestimonial(
                '"Very good club to learn Chess, teachers are quite knowledgeable and have methodical/systematic approach for developing the students in the game of Chess. The students here have won numerous accolades."',
                'Parent'
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonial(String text, String author) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            Icon(Icons.format_quote, size: 40, color: Color(0xFF5886BF)),
            SizedBox(height: 20),
            Text(text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF0B131E),
                fontSize: 18,
                fontStyle: FontStyle.italic,
                height: 1.6,
              ),
            ),
            SizedBox(height: 20),
            Text(author,
              style: TextStyle(
                color: Color(0xFF707781),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsSection() {
    return Container(
      padding: EdgeInsets.all(80),
      child: Column(
        children: [
          Text('LATEST INSIGHT & ARTICLES',
            style: TextStyle(
              color: Color(0xFF0B131E),
              fontSize: 14,
              letterSpacing: 3.5,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 10),
          Text('News & Events',
            style: TextStyle(
              color: Color(0xFF0B131E),
              fontSize: 56,
              fontWeight: FontWeight.w400,
              height: 1,
            ),
          ),
          SizedBox(height: 60),
          Row(
            children: [
              Expanded(
                child: _buildNewsCard(
                  'The Winner of the Private Schools Championship',
                  'Mar 23,2025',
                  'The annual Kenya National Chess Championship is here, open to all player under the Chess Kenya Federation. A chance for you to showcase your skills...'
                ),
              ),
              SizedBox(width: 30),
              Expanded(
                child: _buildNewsCard(
                  'James Panchol clinches 7th Le Pelley Cup',
                  'Mar 06,2025',
                  'The annual Kenya National Chess Championship is here, open to all player under the Chess Kenya Federation. A chance for you to showcase your skills...'
                ),
              ),
              SizedBox(width: 30),
              Expanded(
                child: _buildNewsCard(
                  'Official Launch of Pmaol Chess Club',
                  'Feb 16,2025',
                  'The annual Kenya National Chess Championship is here, open to all player under the Chess Kenya Federation. A chance for you to showcase your skills...'
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard(String title, String date, String excerpt) {
    return Card(
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
              image: DecorationImage(
                image: AssetImage('assets/images/news_placeholder.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Chip(
                      label: Text('News',
                        style: TextStyle(color: Colors.white, fontSize: 12)),
                      backgroundColor: Color(0xFF5886BF),
                    ),
                    SizedBox(width: 10),
                    Text(date,
                      style: TextStyle(
                        color: Color(0xFF404957),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Text(title,
                  style: TextStyle(
                    color: Color(0xFF0B131E),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 15),
                Text(excerpt,
                  style: TextStyle(
                    color: Color(0xFF404957),
                    fontSize: 15,
                    height: 1.5,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  child: Row(
                    children: [
                      Text('Read More',
                        style: TextStyle(
                          color: Color(0xFF5886BF),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.arrow_forward, size: 16, color: Color(0xFF5886BF)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      height: 600,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/contact_bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Container(color: Color(0xFF0B131E).withOpacity(0.3)),
          Padding(
            padding: EdgeInsets.all(80),
            child: Row(
              children: [
                Expanded(flex: 2, child: Container()),
                Expanded(
                  flex: 3,
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('CONTACT US TODAY',
                            style: TextStyle(
                              color: Color(0xFF0B131E),
                              fontSize: 14,
                              letterSpacing: 3.5,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text('Get a Consultation!',
                            style: TextStyle(
                              color: Color(0xFF0B131E),
                              fontSize: 56,
                              fontWeight: FontWeight.w400,
                              height: 1,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'We are happy to answer your questions, and help you find the services you need. Please message us to get started.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF404957),
                              fontSize: 18,
                              height: 1.6,
                            ),
                          ),
                          SizedBox(height: 40),
                          _buildContactForm(),
                        ],
                      ),
                    ),
                  ),
                ),
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
                  labelText: 'First name *',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Last name *',
                  border: OutlineInputBorder(),
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
                  labelText: 'Email *',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Phone number',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        DropdownButtonFormField(
          decoration: InputDecoration(
            labelText: 'Service of Interest',
            border: OutlineInputBorder(),
          ),
          items: [
            'Select Service of Interest',
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
            labelText: 'Message *',
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
          maxLines: 4,
        ),
        SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF5886BF),
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            minimumSize: Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text('Submit',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactInfoSection() {
    return Container(
      color: Color(0xFF283D57),
      padding: EdgeInsets.all(80),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.phone, color: Color(0xFF4F78AB), size: 40),
                    SizedBox(height: 20),
                    Text('+254 714 272 082',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('info@pmadol.com',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on, color: Color(0xFF4F78AB), size: 40),
                    SizedBox(height: 20),
                    Text('Nairobi - Kenya.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.access_time, color: Color(0xFF4F78AB), size: 40),
                    SizedBox(height: 20),
                    Text('Monday - Saturday: 8AM -10PM\nSunday: 10AM - 8PM',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.share, color: Color(0xFF4F78AB), size: 40),
                    SizedBox(height: 20),
                    Text('Facebook - Instagram - Twitter - Youtube - Linkedin',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGallerySection() {
    return Container(
      padding: EdgeInsets.all(80),
      child: Column(
        children: [
          Text('PMADOL CHAMPS',
            style: TextStyle(
              color: Color(0xFF283D57),
              fontSize: 14,
              letterSpacing: 3.5,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 10),
          Text('Our Little Masters',
            style: TextStyle(
              color: Color(0xFF283D57),
              fontSize: 56,
              fontWeight: FontWeight.w400,
              height: 1,
            ),
          ),
          SizedBox(height: 60),
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            children: List.generate(12, (index) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: AssetImage('assets/images/gallery_${index + 1}.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildPartnersSection() {
    return Container(
      padding: EdgeInsets.all(80),
      color: Color(0xFFF4F6F7),
      child: Column(
        children: [
          Text('PARTNERS & REGULATERS:',
            style: TextStyle(
              color: Color(0xFF283D57),
              fontSize: 14,
              letterSpacing: 3.5,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(8, (index) {
              return Container(
                width: 150,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: AssetImage('assets/images/partner_${index + 1}.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              );
            }),
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
                      'PMadol Chess Club coaching aim to broaden the horizons of young minds through chess. Kids will be excited to understand and will be amazed by the positive experience that chess offers. Let us be your guide on this thrilling journey of intellectual stimulation, strategic thinking, and endless possibilities.',
                      style: TextStyle(
                        color: Color(0xFFF4F6F7),
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF5886BF),
                        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                      child: Text('JOIN US',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1,
                        ),
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
                    _buildFooterLink('Blog'),
                    _buildFooterLink('Shop'),
                    _buildFooterLink('Contact'),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Our Services',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildFooterLink('Private Lessons'),
                    _buildFooterLink('Chess in Schools'),
                    _buildFooterLink('Group Sessions'),
                    _buildFooterLink('Online Classes'),
                    _buildFooterLink('Tournaments'),
                    _buildFooterLink('Mentorship'),
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
                    Row(
                      children: [
                        Icon(Icons.phone, color: Color(0xFF5886BF), size: 20),
                        SizedBox(width: 10),
                        Text('+254 714 272 082',
                          style: TextStyle(color: Color(0xFFF4F6F7), fontSize: 16)),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.email, color: Color(0xFF5886BF), size: 20),
                        SizedBox(width: 10),
                        Text('info@pmadol.com',
                          style: TextStyle(color: Color(0xFFF4F6F7), fontSize: 16)),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Color(0xFF5886BF), size: 20),
                        SizedBox(width: 10),
                        Text('Nairobi - Kenya',
                          style: TextStyle(color: Color(0xFFF4F6F7), fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 50),
          Divider(color: Colors.white24),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('© 2025 PMadol Chess Club. All rights reserved.',
                style: TextStyle(color: Color(0xFFF4F6F7), fontSize: 14)),
              Row(
                children: [
                  Icon(Icons.facebook, color: Colors.white, size: 20),
                  SizedBox(width: 15),
                  Icon(Icons.camera_alt, color: Colors.white, size: 20),
                  SizedBox(width: 15),
                  Icon(Icons.chat, color: Colors.white, size: 20),
                  SizedBox(width: 15),
                  Icon(Icons.play_circle_fill, color: Colors.white, size: 20),
                  SizedBox(width: 15),
                  Icon(Icons.link, color: Colors.white, size: 20),
                ],
              ),
            ],
          ),
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