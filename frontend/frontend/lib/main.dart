// ============================================
// lib/main.dart - Updated with Provider
// ============================================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/home_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/service_provider.dart';
import 'providers/shop_provider.dart';
import 'providers/blog_provider.dart';
import 'providers/gallery_provider.dart';
import 'providers/team_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/about_provider.dart';
import 'providers/enrollment_provider.dart';
import 'providers/tournament_provider.dart';
import 'home_screen.dart';
import 'about_screen.dart' as about;
import 'services_screen.dart' as services;
import 'gallery_screen.dart' as gallery;
import 'blog_screen.dart' as blog;
import 'blog_detail_screen.dart' as blog_detail;
import 'shop_screen.dart' as shop;
import 'contact_screen.dart' as contact;
import 'screens/tournaments_screen.dart' as tournaments;

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ServiceProvider()),
        ChangeNotifierProvider(create: (_) => ShopProvider()),
        ChangeNotifierProvider(create: (_) => BlogProvider()),
        ChangeNotifierProvider(create: (_) => GalleryProvider()),
        ChangeNotifierProvider(create: (_) => TeamProvider()),
        ChangeNotifierProvider(create: (_) => AboutProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => EnrollmentProvider()),
        ChangeNotifierProvider(create: (_) => TournamentProvider()),
      ],
      child: const PMadolChessApp(),
    ),
  );
}

class PMadolChessApp extends StatelessWidget {
  const PMadolChessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PMadol Chess Club',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF5886BF),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5886BF),
          primary: const Color(0xFF5886BF),
        ),
      ),
      onGenerateRoute: (settings) {
        Widget page;
        switch (settings.name) {
          case '/':
            page = const HomePage();
            break;
          case '/about':
            page = const about.AboutScreen();
            break;
          case '/services':
            final args = settings.arguments as Map<String, dynamic>?;
            final initialTab = args?['initialTab'] as int? ?? 0;
            page = services.ServicesScreen(initialTab: initialTab);
            break;
          case '/tournaments':
            page = const tournaments.TournamentsScreen();
            break;
          case '/gallery':
            page = const gallery.GalleryScreen();
            break;
          case '/blog':
            page = const blog.BlogScreen();
            break;
          case '/blog-detail':
            page = const blog_detail.BlogDetailScreen();
            break;
          case '/shop':
            page = const shop.ShopScreen();
            break;
          case '/contact':
            page = const contact.ContactScreen();
            break;
          default:
            page = const HomePage();
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
      color: const Color(0xFF283D57),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Row(
                children: [
                  Icon(Icons.phone, color: Color(0xFFA6C1E0), size: 17),
                  SizedBox(width: 8),
                  Text(
                    '+254 714 272 082',
                    style: TextStyle(color: Color(0xFFD3DBE5), fontSize: 14),
                  ),
                ],
              ),
              SizedBox(width: 20),
              Row(
                children: [
                  Icon(Icons.email, color: Color(0xFFA6C1E0), size: 14),
                  SizedBox(width: 8),
                  Text(
                    'info@pmadol.com',
                    style: TextStyle(color: Color(0xFFD3DBE5), fontSize: 14),
                  ),
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
                  Icon(
                    Icons.play_circle_fill,
                    color: Color(0xFFD3DBE5),
                    size: 14,
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.link, color: Color(0xFFD3DBE5), size: 14),
                ],
              ),
            ],
          ),
          Text(
            'Nairobi - Kenya.',
            style: TextStyle(color: Color(0xFFD3DBE5), fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationBar(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 50,
            width: 150,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/Panchol-Madol-Chess-Club-Logo.png',
                ),
                fit: BoxFit.contain,
              ),
            ),
          ),
          Row(
            children: [
              _buildNavItem(context, 'HOME', '/'),
              _buildNavItem(context, 'ABOUT', '/about'),
              _buildNavItem(context, 'SERVICES', '/services'),
              _buildNavItem(context, 'TOURNAMENTS', '/tournaments'),
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
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextButton(
        onPressed: () => Navigator.pushNamed(context, route),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? const Color(0xFF5886BF) : const Color(0xFF283D57),
            fontSize: 14,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
