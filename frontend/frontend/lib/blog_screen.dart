import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/blog_provider.dart';
import 'providers/home_provider.dart';
import 'widgets/footer_widget.dart';
import 'config/api_config.dart';
import 'models/blog_models.dart';

class BlogScreen extends StatefulWidget {
  const BlogScreen({super.key});

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  String selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();

  String? _resolveImageUrl(String? path) {
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('http')) return path;
    return '${ApiConfig.baseUrl}$path';
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadData() {
    Future.microtask(() {
      context.read<BlogProvider>().loadPosts();
      context.read<HomeProvider>().loadHomeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Consumer2<BlogProvider, HomeProvider>(
      builder: (context, blogProvider, homeProvider, child) {
        final homeData = homeProvider.homeData;

        return SingleChildScrollView(
          child: Column(
            children: [
              _buildPageHeader(),
              _buildSearchBar(isMobile, blogProvider),
              _buildCategoryFilter(isMobile, blogProvider),
              if (blogProvider.posts.isNotEmpty && !blogProvider.isLoading)
                _buildFeaturedPost(isMobile, blogProvider.posts.first),
              _buildBlogGrid(isMobile, blogProvider),
              if (homeData != null) FooterWidget(settings: homeData.siteSettings),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPageHeader() {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF5886BF), Color(0xFF283D57)],
        ),
      ),
      child: Stack(
        children: [
          Container(color: Colors.black.withOpacity(0.2)),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'LATEST INSIGHTS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    letterSpacing: 3.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Blog',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 56,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Chess tips, tutorials, and community stories',
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

  Widget _buildSearchBar(bool isMobile, BlogProvider blogProvider) {
    final horizontalPadding = isMobile ? 16.0 : 80.0;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: horizontalPadding),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE8EFF7)),
        ),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Icon(Icons.search, color: Color(0xFF707781), size: 20),
            ),
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search blog posts...',
                  hintStyle: TextStyle(color: Color(0xFFB0B8C1)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
                onChanged: (query) {
                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilter(bool isMobile, BlogProvider blogProvider) {
    final posts = blogProvider.posts;
    final categories = ['All', ...posts.map((p) => p.categoryName ?? 'Other').toSet()];

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 20 : 30,
        horizontal: isMobile ? 16 : 80,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Wrap(
          spacing: isMobile ? 10 : 15,
          children: categories.map((category) {
            final isSelected = selectedCategory == category;
            return GestureDetector(
              onTap: () {
                setState(() => selectedCategory = category);
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16 : 24,
                  vertical: isMobile ? 10 : 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF5886BF) : Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF5886BF) : const Color(0xFFE8EFF7),
                  ),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF404957),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    fontSize: isMobile ? 12 : 14,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildFeaturedPost(bool isMobile, BlogPost post) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 80,
        vertical: 20,
      ),
      height: isMobile ? 250 : 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: post.featuredImage.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(_resolveImageUrl(post.featuredImage)!),
                      fit: BoxFit.cover,
                    )
                  : null,
              color: const Color(0xFFF8FAFC),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
          Positioned(
            top: isMobile ? 12 : 20,
            right: isMobile ? 12 : 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF5886BF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Featured',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: isMobile ? 12 : 20,
            left: isMobile ? 12 : 20,
            right: isMobile ? 12 : 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  post.categoryName ?? 'News',
                  style: TextStyle(
                    color: const Color(0xFFFFD700),
                    fontSize: isMobile ? 11 : 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  post.title.isNotEmpty ? post.title : 'Untitled',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isMobile ? 16 : 24,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  post.excerpt.isNotEmpty ? post.excerpt : 'Read more... ',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: isMobile ? 12 : 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlogGrid(bool isMobile, BlogProvider blogProvider) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 80,
        vertical: 40,
      ),
      child: Consumer<BlogProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF5886BF)),
            );
          }

          if (provider.error != null && provider.error!.isNotEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Text(
                  'Error loading posts: ${provider.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          List<BlogPost> filteredPosts = selectedCategory == 'All'
              ? provider.posts
              : provider.posts
                  .where((p) => p.categoryName == selectedCategory)
                  .toList();

          if (_searchController.text.isNotEmpty) {
            final q = _searchController.text.toLowerCase();
            filteredPosts = filteredPosts
                .where((p) =>
                    p.title.toLowerCase().contains(q) ||
                    p.excerpt.toLowerCase().contains(q))
                .toList();
          }

          if (filteredPosts.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Text(
                  'No blog posts found',
                  style: TextStyle(fontSize: 18, color: Color(0xFF707781)),
                ),
              ),
            );
          }

          final gridColumns =
              isMobile ? 1 : (MediaQuery.of(context).size.width > 1200 ? 3 : 2);

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: gridColumns,
              crossAxisSpacing: isMobile ? 12 : 25,
              mainAxisSpacing: isMobile ? 12 : 25,
              childAspectRatio: isMobile ? 0.85 : 0.9,
            ),
            itemCount: filteredPosts.length,
            itemBuilder: (context, index) {
              return _buildBlogCard(filteredPosts[index], isMobile);
            },
          );
        },
      ),
    );
  }

  Widget _buildBlogCard(BlogPost post, bool isMobile) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Read: ${post.title}')),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: isMobile ? 180 : 220,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                color: const Color(0xFFF8FAFC),
                image: post.featuredImage.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(_resolveImageUrl(post.featuredImage)!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: post.featuredImage.isEmpty
                  ? Center(
                      child: Icon(
                        Icons.article_outlined,
                        size: 50,
                        color: const Color(0xFF707781).withOpacity(0.3),
                      ),
                    )
                  : null,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (post.categoryName != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF5886BF).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              post.categoryName!,
                              style: const TextStyle(
                                color: Color(0xFF5886BF),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        const SizedBox(width: 10),
                        Text(
                          _formatDate(post.publishedAt),
                          style: const TextStyle(
                            color: Color(0xFF707781),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Text(
                        post.title.isNotEmpty ? post.title : 'Untitled',
                        style: TextStyle(
                          color: const Color(0xFF0B131E),
                          fontSize: isMobile ? 15 : 17,
                          fontWeight: FontWeight.w700,
                          height: 1.3,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      post.excerpt,
                      style: const TextStyle(
                        color: Color(0xFF707781),
                        fontSize: 13,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'By ${post.authorName.isNotEmpty ? post.authorName : 'Author'}',
                          style: const TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 12,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF5886BF).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Read More →',
                            style: TextStyle(
                              color: Color(0xFF5886BF),
                              fontSize: 12,
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

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inDays == 0) return 'Today';
      if (diff.inDays == 1) return 'Yesterday';
      if (diff.inDays < 7) return '${diff.inDays} days ago';
      if (diff.inDays < 30) return '${(diff.inDays / 7).floor()} weeks ago';

      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return '';
    }
  }
}
