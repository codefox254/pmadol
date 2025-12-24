import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/blog_provider.dart';
import 'providers/home_provider.dart';
import 'widgets/footer_widget.dart';
import 'config/api_config.dart';

class BlogScreen extends StatefulWidget {
  const BlogScreen({Key? key}) : super(key: key);

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    Future.microtask(() {
      context.read<BlogProvider>().loadPosts();
      context.read<HomeProvider>().loadHomeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<BlogProvider, HomeProvider>(
      builder: (context, blogProvider, homeProvider, child) {
        if (blogProvider.isLoading || homeProvider.isLoading) {
          return Center(child: CircularProgressIndicator(color: Color(0xFF5886BF)));
        }

        final posts = blogProvider.posts;
        final homeData = homeProvider.homeData;
        
        if (homeData == null) {
          return Center(child: Text('No data available'));
        }

        final filteredPosts = selectedCategory == 'All'
            ? posts
            : posts.where((p) => p.categoryName == selectedCategory).toList();

        return SingleChildScrollView(
          child: Column(
            children: [
              _buildPageHeader(),
              if (blogProvider.featuredPosts.isNotEmpty) _buildFeaturedPost(blogProvider.featuredPosts.first),
              _buildCategoryFilter(posts),
              _buildBlogGrid(filteredPosts),
              FooterWidget(settings: homeData.siteSettings),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPageHeader() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF5886BF), Color(0xFF283D57)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('LATEST INSIGHTS', style: TextStyle(color: Colors.white, fontSize: 14, letterSpacing: 3.5)),
            SizedBox(height: 15),
            Text('Blog', style: TextStyle(color: Colors.white, fontSize: 56)),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedPost(dynamic post) {
    return Container(
      margin: EdgeInsets.all(80),
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage('${ApiConfig.baseUrl}${post.featuredImage}'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
          ),
        ),
        padding: EdgeInsets.all(40),
        alignment: Alignment.bottomLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: Color(0xFF5886BF), borderRadius: BorderRadius.circular(4)),
              child: Text('FEATURED', style: TextStyle(color: Colors.white, fontSize: 12)),
            ),
            SizedBox(height: 15),
            Text(post.title, style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w700)),
            SizedBox(height: 10),
            Text(post.excerpt, style: TextStyle(color: Colors.white70, fontSize: 16), maxLines: 2),
            SizedBox(height: 15),
            Row(
              children: [
                Icon(Icons.person, color: Colors.white70, size: 16),
                SizedBox(width: 5),
                Text(post.authorName, style: TextStyle(color: Colors.white70)),
                SizedBox(width: 20),
                Icon(Icons.calendar_today, color: Colors.white70, size: 16),
                SizedBox(width: 5),
                Text(post.publishedAt, style: TextStyle(color: Colors.white70)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilter(List posts) {
    final categories = ['All', ...posts.map((p) => p.categoryName ?? 'Other').toSet()];
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 80),
      color: Color(0xFFF8FAFC),
      child: Wrap(
        spacing: 15,
        alignment: WrapAlignment.center,
        children: categories.map((cat) {
          final isSelected = selectedCategory == cat;
          return GestureDetector(
            onTap: () => setState(() => selectedCategory = cat),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFF5886BF) : Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(cat, style: TextStyle(color: isSelected ? Colors.white : Color(0xFF404957))),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBlogGrid(List posts) {
    if (posts.isEmpty) {
      return Container(padding: EdgeInsets.all(80), child: Center(child: Text('No posts available')));
    }

    return Container(
      padding: EdgeInsets.all(80),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 30,
          mainAxisSpacing: 30,
          childAspectRatio: 0.7,
        ),
        itemCount: posts.length,
        itemBuilder: (context, index) => _buildBlogCard(posts[index]),
      ),
    );
  }

  Widget _buildBlogCard(dynamic post) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              image: DecorationImage(
                image: NetworkImage('${ApiConfig.baseUrl}${post.featuredImage}'),
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
                  if (post.categoryName != null)
                    Text(post.categoryName, style: TextStyle(color: Color(0xFF5886BF), fontSize: 12)),
                  SizedBox(height: 8),
                  Text(post.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600), maxLines: 2),
                  SizedBox(height: 8),
                  Expanded(child: Text(post.excerpt, style: TextStyle(color: Color(0xFF707781)), maxLines: 3)),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.visibility, size: 16, color: Color(0xFF707781)),
                      SizedBox(width: 5),
                      Text('${post.views}', style: TextStyle(color: Color(0xFF707781))),
                      SizedBox(width: 15),
                      Icon(Icons.comment, size: 16, color: Color(0xFF707781)),
                      SizedBox(width: 5),
                      Text('${post.commentsCount}', style: TextStyle(color: Color(0xFF707781))),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
