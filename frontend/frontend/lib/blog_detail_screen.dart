import 'package:flutter/material.dart';

class BlogDetailScreen extends StatelessWidget {
  const BlogDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildArticleHeader(),
          _buildArticleContent(),
          _buildRelatedPosts(),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildArticleHeader() {
    return Container(
      height: 500,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/blog_detail_header.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            left: 80,
            right: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                        color: Color(0xFF5886BF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('NEWS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Icon(Icons.calendar_today, size: 16, color: Colors.white),
                    SizedBox(width: 8),
                    Text('March 23, 2025',
                      style: TextStyle(color: Colors.white, fontSize: 14)),
                    SizedBox(width: 20),
                    Icon(Icons.person, size: 16, color: Colors.white),
                    SizedBox(width: 8),
                    Text('By Admin',
                      style: TextStyle(color: Colors.white, fontSize: 14)),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'The Winner of the Private Schools Championship',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleContent() {
    return Container(
      padding: EdgeInsets.all(80),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildArticleBody(),
                SizedBox(height: 60),
                _buildShareSection(),
                SizedBox(height: 60),
                _buildCommentsSection(),
              ],
            ),
          ),
          SizedBox(width: 60),
          Expanded(
            flex: 1,
            child: _buildSidebar(),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PMadol Chess Club is proud to announce the remarkable achievement of our students in the recent Private Schools Championship. The tournament, held at the prestigious venue in Nairobi, saw participation from over 50 schools across the region.',
          style: TextStyle(
            color: Color(0xFF404957),
            fontSize: 18,
            height: 1.8,
          ),
        ),
        SizedBox(height: 30),
        Text('Outstanding Performance',
          style: TextStyle(
            color: Color(0xFF0B131E),
            fontSize: 32,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 20),
        Text(
          'Our young champion, who has been training with us for the past two years, demonstrated exceptional strategic thinking and tactical prowess throughout the tournament. The victory is a testament to the dedication of our coaching staff and the hard work of our students.',
          style: TextStyle(
            color: Color(0xFF404957),
            fontSize: 18,
            height: 1.8,
          ),
        ),
        SizedBox(height: 30),
        Container(
          height: 400,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: AssetImage('assets/images/championship_winner.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 30),
        Text('The Journey to Victory',
          style: TextStyle(
            color: Color(0xFF0B131E),
            fontSize: 32,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 20),
        Text(
          'The path to this championship was not easy. Our student faced formidable opponents in each round, including several nationally ranked players. The tournament format included both rapid and classical games, testing not only chess skills but also endurance and mental resilience.',
          style: TextStyle(
            color: Color(0xFF404957),
            fontSize: 18,
            height: 1.8,
          ),
        ),
        SizedBox(height: 20),
        Text(
          'Key highlights from the tournament included:',
          style: TextStyle(
            color: Color(0xFF404957),
            fontSize: 18,
            height: 1.8,
          ),
        ),
        SizedBox(height: 15),
        ...[
          'Undefeated record across 7 rounds',
          'Brilliant tactical combinations in the semi-final match',
          'Outstanding endgame technique in the championship game',
          'Exceptional time management under pressure',
        ].map((point) => Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.check_circle, color: Color(0xFF5886BF), size: 24),
              SizedBox(width: 15),
              Expanded(
                child: Text(point,
                  style: TextStyle(
                    color: Color(0xFF404957),
                    fontSize: 18,
                    height: 1.8,
                  ),
                ),
              ),
            ],
          ),
        )),
        SizedBox(height: 30),
        Text('What This Means for PMadol Chess Club',
          style: TextStyle(
            color: Color(0xFF0B131E),
            fontSize: 32,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 20),
        Text(
          'This victory reinforces our commitment to excellence in chess education. It demonstrates that with proper guidance, dedication, and a supportive learning environment, young players can achieve remarkable results. We are proud of all our students who participated and showed great sportsmanship throughout the tournament.',
          style: TextStyle(
            color: Color(0xFF404957),
            fontSize: 18,
            height: 1.8,
          ),
        ),
        SizedBox(height: 20),
        Text(
          'As we celebrate this achievement, we remain focused on our mission to nurture more chess talents and provide opportunities for all our students to excel in the game they love.',
          style: TextStyle(
            color: Color(0xFF404957),
            fontSize: 18,
            height: 1.8,
          ),
        ),
      ],
    );
  }

  Widget _buildShareSection() {
    return Container(
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Color(0xFFF5F9FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text('Share this article:',
            style: TextStyle(
              color: Color(0xFF0B131E),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 20),
          _buildSocialButton(Icons.facebook, Color(0xFF1877F2)),
          _buildSocialButton(Icons.chat, Color(0xFF1DA1F2)),
          _buildSocialButton(Icons.link, Color(0xFF0A66C2)),
          _buildSocialButton(Icons.email, Color(0xFF5886BF)),
        ],
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, Color color) {
    return Padding(
      padding: EdgeInsets.only(right: 10),
      child: IconButton(
        onPressed: () {},
        icon: Icon(icon, color: color),
        style: IconButton.styleFrom(
          backgroundColor: color.withOpacity(0.1),
          padding: EdgeInsets.all(12),
        ),
      ),
    );
  }

  Widget _buildCommentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Comments (3)',
          style: TextStyle(
            color: Color(0xFF0B131E),
            fontSize: 32,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 30),
        _buildComment('John Doe', 'Congratulations to the winner! This is truly inspiring.', '2 days ago'),
        _buildComment('Jane Smith', 'PMadol Chess Club continues to excel. Great work!', '1 day ago'),
        _buildComment('Chess Enthusiast', 'Looking forward to more success stories from the club.', '5 hours ago'),
        SizedBox(height: 40),
        Text('Leave a Comment',
          style: TextStyle(
            color: Color(0xFF0B131E),
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 20),
        TextField(
          decoration: InputDecoration(
            labelText: 'Your Name',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 20),
        TextField(
          decoration: InputDecoration(
            labelText: 'Your Email',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 20),
        TextField(
          decoration: InputDecoration(
            labelText: 'Your Comment',
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
          maxLines: 5,
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF5886BF),
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text('Post Comment',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildComment(String name, String comment, String time) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage('assets/images/user_avatar.jpg'),
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                        style: TextStyle(
                          color: Color(0xFF0B131E),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(time,
                        style: TextStyle(
                          color: Color(0xFF404957),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 15),
              Text(comment,
                style: TextStyle(
                  color: Color(0xFF404957),
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSidebar() {
    return Column(
      children: [
        _buildSearchWidget(),
        SizedBox(height: 30),
        _buildRecentPostsWidget(),
        SizedBox(height: 30),
        _buildCategoriesWidget(),
        SizedBox(height: 30),
        _buildTagsWidget(),
      ],
    );
  }

  Widget _buildSearchWidget() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Search',
              style: TextStyle(
                color: Color(0xFF0B131E),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 15),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search articles...',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentPostsWidget() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recent Posts',
              style: TextStyle(
                color: Color(0xFF0B131E),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 20),
            _buildRecentPostItem('James Panchol clinches 7th Le Pelley Cup', 'Mar 06, 2025'),
            _buildRecentPostItem('Official Launch of PMadol Chess Club', 'Feb 16, 2025'),
            _buildRecentPostItem('5 Essential Opening Moves', 'Feb 10, 2025'),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentPostItem(String title, String date) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
            style: TextStyle(
              color: Color(0xFF0B131E),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 5),
          Text(date,
            style: TextStyle(
              color: Color(0xFF404957),
              fontSize: 12,
            ),
          ),
          SizedBox(height: 10),
          Divider(),
        ],
      ),
    );
  }

  Widget _buildCategoriesWidget() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Categories',
              style: TextStyle(
                color: Color(0xFF0B131E),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 20),
            _buildCategoryItem('News', 12),
            _buildCategoryItem('Tournaments', 8),
            _buildCategoryItem('Tips & Tricks', 15),
            _buildCategoryItem('Announcements', 6),
            _buildCategoryItem('Success Stories', 10),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String name, int count) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name,
            style: TextStyle(
              color: Color(0xFF404957),
              fontSize: 15,
            ),
          ),
          Text('($count)',
            style: TextStyle(
              color: Color(0xFF5886BF),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagsWidget() {
    final tags = ['Chess', 'Tournament', 'Training', 'Strategy', 'Tactics', 'Endgame', 'Opening', 'Champions'];
    return Card(
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tags',
              style: TextStyle(
                color: Color(0xFF0B131E),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: tags.map((tag) => Chip(
                label: Text(tag, style: TextStyle(fontSize: 12)),
                backgroundColor: Color(0xFFF5F9FF),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRelatedPosts() {
    return Container(
      padding: EdgeInsets.all(80),
      color: Color(0xFFF5F9FF),
      child: Column(
        children: [
          Text('Related Articles',
            style: TextStyle(
              color: Color(0xFF0B131E),
              fontSize: 36,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 40),
          Row(
            children: List.generate(3, (index) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: _buildRelatedPostCard(index),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedPostCard(int index) {
    return Card(
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
              image: DecorationImage(
                image: AssetImage('assets/images/related_${index + 1}.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Related Article ${index + 1}',
                  style: TextStyle(
                    color: Color(0xFF0B131E),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10),
                Text('Mar ${20 - index}, 2025',
                  style: TextStyle(
                    color: Color(0xFF404957),
                    fontSize: 13,
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
      child: Center(
        child: Text('© 2025 PMadol Chess Club. All rights reserved.',
          style: TextStyle(color: Color(0xFFF4F6F7), fontSize: 14)),
      ),
    );
  }
}