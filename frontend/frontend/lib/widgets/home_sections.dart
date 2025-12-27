// ============================================
// lib/widgets/home_sections.dart
// ============================================
import 'dart:async';
import 'package:flutter/material.dart';
import '../models/home_models.dart';
import '../config/api_config.dart';

// Statistics Section
class StatisticsSection extends StatelessWidget {
  final Statistics statistics;

  const StatisticsSection({super.key, required this.statistics});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF5886BF),
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 80),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatisticCard(
                Icons.emoji_events,
                '${statistics.awardsCount}+',
                'Awards Per Year',
              ),
              _buildStatisticCard(
                Icons.star,
                '${statistics.yearsExperience}+',
                'Years of Experience',
              ),
              _buildStatisticCard(
                Icons.thumb_up,
                '${statistics.studentsCount}+',
                'Students & Clients',
              ),
              _buildStatisticCard(
                Icons.group,
                '${statistics.trainersCount}+',
                'Specialists & Trainers',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticCard(IconData icon, String value, String title) {
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
        const SizedBox(height: 20),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 48,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
      ],
    );
  }
}

// Testimonials Section
class TestimonialsSection extends StatelessWidget {
  final List<Testimonial> testimonials;

  const TestimonialsSection({super.key, required this.testimonials});

  @override
  Widget build(BuildContext context) {
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
            'TESTIMONIALS',
            style: TextStyle(
              color: Color(0xFF5886BF),
              fontSize: 14,
              letterSpacing: 3.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'What Our Community Says',
            style: TextStyle(
              color: Color(0xFF0B131E),
              fontSize: 48,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 60),
          if (testimonials.isEmpty)
            const Center(
              child: Text(
                'No testimonials available',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          else
            Column(
              children: testimonials.map((testimonial) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: _buildTestimonialCard(testimonial),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildTestimonialCard(Testimonial testimonial) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Row(
              children: List.generate(
                5,
                (index) => Icon(
                  index < testimonial.rating ? Icons.star : Icons.star_border,
                  color: const Color(0xFF5886BF),
                  size: 16,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Icon(Icons.format_quote, size: 40, color: Color(0xFF5886BF)),
            const SizedBox(height: 20),
            Text(
              testimonial.content,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF0B131E),
                fontSize: 18,
                fontStyle: FontStyle.italic,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 25),
            Text(
              testimonial.author,
              style: const TextStyle(
                color: Color(0xFF283D57),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              testimonial.roleDisplay,
              style: const TextStyle(color: Color(0xFF707781), fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

// Partners Section
class PartnersSection extends StatelessWidget {
  final List<Partner> partners;

  const PartnersSection({super.key, required this.partners});

  @override
  Widget build(BuildContext context) {
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
            'OUR PARTNERS & REGULATORS',
            style: TextStyle(
              color: Color(0xFF283D57),
              fontSize: 14,
              letterSpacing: 3.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 60),
          if (partners.isEmpty)
            const Center(
              child: Text(
                'No partners available',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          else
            Wrap(
              spacing: 30,
              runSpacing: 30,
              alignment: WrapAlignment.center,
              children: partners.map<Widget>((partner) {
                return _buildPartnerCard(partner);
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildPartnerCard(Partner partner) {
    return Container(
      width: 180,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: partner.logo.isNotEmpty
            ? Image.network(
                partner.logo.startsWith('http')
                    ? partner.logo
                    : '${ApiConfig.baseUrl}${partner.logo}',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.business,
                          size: 40,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          partner.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.business, size: 40, color: Colors.grey),
                    const SizedBox(height: 8),
                    Text(
                      partner.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

// Hero Section with fading carousel background
class HeroSection extends StatefulWidget {
  final SiteSettings settings;
  final List<HeroSlide> heroSlides;

  const HeroSection({
    super.key,
    required this.settings,
    required this.heroSlides,
  });

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  late final PageController _pageController;
  int _currentIndex = 0;
  Timer? _timer;

  List<HeroSlide> get _slides => widget.heroSlides.isNotEmpty
      ? widget.heroSlides
      : [
          HeroSlide(
            title: widget.settings.siteName.toUpperCase(),
            subtitle: widget.settings.tagline,
            image: '',
            isActive: true,
            displayOrder: 0,
          ),
        ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoPlay();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _timer?.cancel();
    if (_slides.length <= 1) return;
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      final nextIndex = (_currentIndex + 1) % _slides.length;
      if (mounted) {
        _pageController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 600,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background carousel with fade transition
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _slides.length,
            itemBuilder: (context, index) {
              final slide = _slides[index];
              final hasImage = slide.image.isNotEmpty;
              final background = hasImage
                  ? NetworkImage(
                      slide.image.startsWith('http')
                          ? slide.image
                          : '${ApiConfig.baseUrl}${slide.image}',
                    )
                  : const AssetImage('assets/images/hero_bg.jpg')
                        as ImageProvider;

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 800),
                child: Container(
                  key: ValueKey(slide.image + slide.title),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: background,
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(color: Colors.black.withOpacity(0.5)),
                ),
              );
            },
          ),

          // Content overlay
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.settings.siteName.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      letterSpacing: 3.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 25),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: Text(
                      _slides[_currentIndex].title.isNotEmpty
                          ? _slides[_currentIndex].title
                          : widget.settings.tagline,
                      key: ValueKey(
                        '${_slides[_currentIndex].title}-$_currentIndex',
                      ),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 64,
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: Container(
                      key: ValueKey(
                        '${_slides[_currentIndex].subtitle}-$_currentIndex',
                      ),
                      constraints: const BoxConstraints(maxWidth: 700),
                      child: Text(
                        _slides[_currentIndex].subtitle.isNotEmpty
                            ? _slides[_currentIndex].subtitle
                            : widget.settings.tagline,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/services',
                        arguments: {'initialTab': 1},
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5886BF),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'BOOK A SESSION NOW',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildIndicators(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_slides.length, (index) {
        final isActive = _currentIndex == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          height: 8,
          width: isActive ? 28 : 10,
          decoration: BoxDecoration(
            color: isActive
                ? const Color(0xFF5886BF)
                : Colors.white.withOpacity(0.6),
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }),
    );
  }
}
