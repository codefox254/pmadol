import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/home_provider.dart';
import 'widgets/footer_widget.dart';

class BlogDetailScreen extends StatefulWidget {
  const BlogDetailScreen({Key? key}) : super(key: key);

  @override
  State<BlogDetailScreen> createState() => _BlogDetailScreenState();
}

class _BlogDetailScreenState extends State<BlogDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<HomeProvider>().loadHomeData());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        if (homeProvider.isLoading) return Center(child: CircularProgressIndicator(color: Color(0xFF5886BF)));
        final homeData = homeProvider.homeData;
        if (homeData == null) return Center(child: Text('No data available'));
        return SingleChildScrollView(
          child: Column(
            children: [
              _buildArticleHeader(),
              _buildArticleContent(),
              FooterWidget(settings: homeData.siteSettings),
            ],
          ),
        );
      },
    );
  }

  Widget _buildArticleHeader() => Container(
    height: 400,
    decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF5886BF), Color(0xFF283D57)])),
    padding: EdgeInsets.all(80),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(color: Color(0xFF5886BF), borderRadius: BorderRadius.circular(4)),
          child: Text('BLOG POST', style: TextStyle(color: Colors.white, fontSize: 12)),
        ),
        SizedBox(height: 20),
        Text('Sample Article Title', style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.w700)),
        SizedBox(height: 15),
        Row(
          children: [
            Icon(Icons.person, color: Colors.white70, size: 18),
            SizedBox(width: 8),
            Text('Author', style: TextStyle(color: Colors.white70)),
            SizedBox(width: 30),
            Icon(Icons.calendar_today, color: Colors.white70, size: 18),
            SizedBox(width: 8),
            Text('December 22, 2025', style: TextStyle(color: Colors.white70)),
          ],
        ),
      ],
    ),
  );

  Widget _buildArticleContent() => Container(
    padding: EdgeInsets.all(80),
    constraints: BoxConstraints(maxWidth: 900),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Article content will be displayed here dynamically from the API.',
          style: TextStyle(fontSize: 18, height: 1.8, color: Color(0xFF404957)),
        ),
      ],
    ),
  );
}
