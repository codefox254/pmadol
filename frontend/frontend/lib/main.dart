import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'about_screen.dart' as about;
import 'services_screen.dart' as services;
import 'gallery_screen.dart' as gallery;
import 'blog_screen.dart' as blog;
import 'blog_detail_screen.dart' as blog_detail;
import 'shop_screen.dart' as shop;
import 'contact_screen.dart' as contact;

void main() {
  runApp(const PMadolChessApp());
}

class PMadolChessApp extends StatelessWidget {
  const PMadolChessApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PMadol Chess Club',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF5886BF),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF5886BF),
          primary: Color(0xFF5886BF),
        ),
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        Widget page;
        switch (settings.name) {
          case '/':
            page = HomePage();
            break;
          case '/about':
            page = about.AboutScreen();
            break;
          case '/services':
            page = services.ServicesScreen();
            break;
          case '/gallery':
            page = gallery.GalleryScreen();
            break;
          case '/blog':
            page = blog.BlogScreen();
            break;
          case '/blog-detail':
            page = blog_detail.BlogDetailScreen();
            break;
          case '/shop':
            page = shop.ShopScreen();
            break;
          case '/contact':
            page = contact.ContactScreen();
            break;
          default:
            page = HomePage();
        }
        return MaterialPageRoute(
          builder: (context) => MainLayout(child: page),
          settings: settings,
        );
      },
    );
  }
}

class MainLayout extends StatelessWidget {
  final Widget child;
  
  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildTopBar(context),
          _buildNavigationBar(context),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      color: Color(0xFF283D57),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Row(
                children: [
                  Icon(Icons.phone, color: Color(0xFFA6C1E0), size: 17),
                  SizedBox(width: 8),
                  Text('+254 714 272 082', 
                    style: TextStyle(color: Color(0xFFD3DBE5), fontSize: 14)),
                ],
              ),
              SizedBox(width: 20),
              Row(
                children: [
                  Icon(Icons.email, color: Color(0xFFA6C1E0), size: 14),
                  SizedBox(width: 8),
                  Text('info@pmadol.com', 
                    style: TextStyle(color: Color(0xFFD3DBE5), fontSize: 14)),
                ],
              ),
              SizedBox(width: 20),
              Row(
                children: [
                  Icon(Icons.facebook, color: Color(0xFFD3DBE5), size: 14),
                  SizedBox(width: 10),
                  Icon(Icons.camera_alt, color: Color(0xFFD3DBE5), size: 14),
                  SizedBox(width: 10),
                  Icon(Icons.chat, color: Color(0xFFD3DBE5), size: 14),
                  SizedBox(width: 10),
                  Icon(Icons.play_circle_fill, color: Color(0xFFD3DBE5), size: 14),
                  SizedBox(width: 10),
                  Icon(Icons.link, color: Color(0xFFD3DBE5), size: 14),
                ],
              ),
            ],
          ),
          Text('Nairobi - Kenya.',
            style: TextStyle(color: Color(0xFFD3DBE5), fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildNavigationBar(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 80, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 50,
            width: 150,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Panchol-Madol-Chess-Club-Logo.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
          Row(
            children: [
              _buildNavItem(context, 'HOME', '/'),
              _buildNavItem(context, 'ABOUT', '/about'),
              _buildNavItem(context, 'SERVICES', '/services'),
              _buildNavItem(context, 'GALLERY', '/gallery'),
              _buildNavItem(context, 'BLOG', '/blog'),
              _buildNavItem(context, 'SHOP', '/shop'),
              _buildNavItem(context, 'CONTACT', '/contact'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String title, String route) {
    final isActive = ModalRoute.of(context)?.settings.name == route;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: TextButton(
        onPressed: () => Navigator.pushNamed(context, route),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? Color(0xFF5886BF) : Color(0xFF283D57),
            fontSize: 14,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}