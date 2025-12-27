// ============================================
// lib/home_screen.dart - Modern Dynamic API-Driven
// ============================================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/home_provider.dart';
import 'widgets/home_sections.dart';
import 'widgets/footer_widget.dart';
import 'widgets/carousel_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    Future.microtask(() {
      context.read<HomeProvider>().loadHomeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        // Loading State
        if (homeProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF5886BF)),
          );
        }

        // Error State
        if (homeProvider.error != null) {
          return _buildErrorWidget(homeProvider);
        }

        // No Data State
        final homeData = homeProvider.homeData;
        if (homeData == null) {
          return const Center(
            child: Text(
              'No data available',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        // Success State - Render all sections
        return SingleChildScrollView(
          child: Column(
            children: [
              // Hero Section - Dynamic with carousel
              HeroSection(
                settings: homeData.siteSettings,
                heroSlides: homeData.heroSlides,
              ),

              // Statistics Section - Dynamic from API
              StatisticsSection(statistics: homeData.statistics),

              // Welcome/About Section
              _buildWelcomeSection(),

              // Services Section
              _buildServicesSection(),

              // Testimonials Section - Dynamic from API
              TestimonialsSection(testimonials: homeData.testimonials),

              // Blog/News Section
              _buildNewsSection(),

              // Contact CTA Section
              _buildContactSection(),

              // Gallery Section
              _buildGallerySection(),

              // Partners Section - Dynamic from API
              PartnersSection(partners: homeData.partners),

              // Footer - Dynamic from settings
              FooterWidget(settings: homeData.siteSettings),
            ],
          ),
        );
      },
    );
  }

  Widget _buildErrorWidget(HomeProvider provider) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: Colors.red),
            const SizedBox(height: 30),
            const Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0B131E),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              provider.error ?? 'Unknown error occurred',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: _loadData,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5886BF),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============ Section Builders ============

  Widget _buildWelcomeSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 80),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF0F4F9), Color(0xFFE8EFF7)],
        ),
      ),
      child: Column(
        children: [
          const Text(
            'WELCOME TO OUR ACADEMY',
            style: TextStyle(
              color: Color(0xFF5886BF),
              fontSize: 14,
              letterSpacing: 3.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Professional Chess Training & Development',
            style: TextStyle(
              color: Color(0xFF0B131E),
              fontSize: 48,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 40),
          const Text(
            'Discover the art of chess through personalized coaching from certified instructors. '
            'We provide comprehensive training programs for all skill levels, from beginners to advanced players.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF707781),
              fontSize: 18,
              height: 1.8,
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/about');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5886BF),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            ),
            child: const Text(
              'Learn More',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 80),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFC)],
        ),
      ),
      child: Column(
        children: [
          const Text(
            'OUR SERVICES',
            style: TextStyle(
              color: Color(0xFF5886BF),
              fontSize: 14,
              letterSpacing: 3.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'What We Offer',
            style: TextStyle(
              color: Color(0xFF0B131E),
              fontSize: 48,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildServiceCard(
                'One-on-One Coaching',
                'Personalized training sessions',
              ),
              _buildServiceCard(
                'Group Classes',
                'Learn with peers in structured classes',
              ),
              _buildServiceCard(
                'Online Lessons',
                'Train from anywhere in the world',
              ),
              _buildServiceCard(
                'Tournaments',
                'Compete in organized chess events',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(String title, String description) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F9FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF5886BF).withOpacity(0.2)),
      ),
      child: Column(
        children: [
          const Icon(Icons.sports_esports, size: 50, color: Color(0xFF5886BF)),
          const SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF0B131E),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF707781), fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsSection() {
    final homeData = context.read<HomeProvider>().homeData;
    if (homeData == null || homeData.newsUpdates.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 80),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFFFF), Color(0xFFF8FBFF)],
        ),
      ),
      child: Column(
        children: [
          const Text(
            'LATEST NEWS & UPDATES',
            style: TextStyle(
              color: Color(0xFF5886BF),
              fontSize: 14,
              letterSpacing: 3.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Stay Updated',
            style: TextStyle(
              color: Color(0xFF0B131E),
              fontSize: 48,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 60),
          NewsCarousel(newsUpdates: homeData.newsUpdates),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 80),
      color: const Color(0xFF5886BF),
      child: Column(
        children: [
          const Text(
            'Ready to Start Your Chess Journey?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 42,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 30),
          Text(
            'Join thousands of students who have improved their chess skills with us',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/services',
                    arguments: {'initialTab': 1},
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                ),
                child: const Text(
                  'Book a Session Now',
                  style: TextStyle(
                    color: Color(0xFF5886BF),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/contact');
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white, width: 2),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                ),
                child: const Text(
                  'Contact Us',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGallerySection() {
    final homeData = context.read<HomeProvider>().homeData;
    if (homeData == null || homeData.galleryImages.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 80),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFC)],
        ),
      ),
      child: Column(
        children: [
          const Text(
            'GALLERY',
            style: TextStyle(
              color: Color(0xFF5886BF),
              fontSize: 14,
              letterSpacing: 3.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Our Moments',
            style: TextStyle(
              color: Color(0xFF0B131E),
              fontSize: 48,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 60),
          GalleryCarousel(galleryImages: homeData.galleryImages),
        ],
      ),
    );
  }
}
