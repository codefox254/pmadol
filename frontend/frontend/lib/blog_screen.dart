import 'package:flutter/material.dart';

class BlogScreen extends StatefulWidget {
  const BlogScreen({Key? key}) : super(key: key);

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  String selectedCategory = 'All';
  final List<String> categories = ['All', 'News', 'Tournaments', 'Tips & Tricks', 'Announcements', 'Success Stories'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildPageHeader(),
          _buildFeaturedPost(),
          _buildCategoryFilter(),
          _buildBlogGrid(),
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
          image: AssetImage('assets/images/blog_header.jpg'),
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
                Text('LATEST INSIGHTS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    letterSpacing: 3.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 15),
                Text('News & Blog',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 56,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 20),
                Text('Stay updated with chess news, tips, and stories',
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

  Widget _buildFeaturedPost() {
    return Container(
      padding: EdgeInsets.all(80),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                height: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                  image: DecorationImage(
                    image: AssetImage('assets/images/featured_post.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                        color: Color(0xFF5886BF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('FEATURED',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text('The Winner of the Private Schools Championship',
                      style: TextStyle(
                        color: Color(0xFF0B131E),
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 16, color: Color(0xFF404957)),
                        SizedBox(width: 8),
                        Text('Mar 23, 2025',
                          style: TextStyle(color: Color(0xFF404957), fontSize: 14)),
                        SizedBox(width: 20),
                        Icon(Icons.person, size: 16, color: Color(0xFF404957)),
                        SizedBox(width: 8),
                        Text('Admin',
                          style: TextStyle(color: Color(0xFF404957), fontSize: 14)),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      'The annual Kenya National Chess Championship is here, open to all players under the Chess Kenya Federation. A chance for you to showcase your skills, compete with the best, and earn recognition in the chess community.',
                      style: TextStyle(
                        color: Color(0xFF404957),
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/blog-detail');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF5886BF),
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('Read Full Article',
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 15,
        children: categories.map((category) {
          final isSelected = selectedCategory == category;
          return FilterChip(
            label: Text(category,
              style: TextStyle(
                color: isSelected ? Colors.white : Color(0xFF404957),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                selectedCategory = category;
              });
            },
            backgroundColor: Colors.white,
            selectedColor: Color(0xFF5886BF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Color(0xFF5886BF)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBlogGrid() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 80, vertical: 40),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 30,
          mainAxisSpacing: 30,
          childAspectRatio: 0.75,
        ),
        itemCount: 12,
        itemBuilder: (context, index) {
          return _buildBlogCard(index);
        },
      ),
    );
  }

  Widget _buildBlogCard(int index) {
    final List<String> categories = ['News', 'Tournament', 'Tips', 'Announcement'];
    final List<String> titles = [
      'James Panchol clinches 7th Le Pelley Cup',
      'Official Launch of PMadol Chess Club',
      '5 Essential Opening Moves Every Beginner Should Know',
      'How Chess Improves Academic Performance',
      'Upcoming Tournament Schedule for 2025',
      'Meet Our New Chess Master Coach',
      'The Benefits of Online Chess Training',
      'Success Story: From Beginner to Champion',
      'Chess and Mathematics: The Perfect Combination',
      'PMadol Club Wins Regional Championship',
      'New Chess Library Resources Available',
      'Holiday Chess Camp Registration Open',
    ];

    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/blog-detail');
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                image: DecorationImage(
                  image: AssetImage('assets/images/blog_${index + 1}.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Chip(
                          label: Text(categories[index % categories.length],
                            style: TextStyle(color: Colors.white, fontSize: 12)),
                          backgroundColor: Color(0xFF5886BF),
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.calendar_today, size: 14, color: Color(0xFF404957)),
                        SizedBox(width: 5),
                        Text('Mar ${23 - index}, 2025',
                          style: TextStyle(
                            color: Color(0xFF404957),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Text(titles[index],
                      style: TextStyle(
                        color: Color(0xFF0B131E),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'The annual Kenya National Chess Championship is here, open to all players under the Chess Kenya Federation. A chance for you to showcase your skills...',
                      style: TextStyle(
                        color: Color(0xFF404957),
                        fontSize: 14,
                        height: 1.5,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Spacer(),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 15,
                          backgroundImage: AssetImage('assets/images/author_avatar.jpg'),
                        ),
                        SizedBox(width: 10),
                        Text('Admin',
                          style: TextStyle(
                            color: Color(0xFF404957),
                            fontSize: 13,
                          ),
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/blog-detail');
                          },
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
                  ],
                ),
              ),
            ),
          ],
        ),
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