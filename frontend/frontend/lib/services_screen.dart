import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/service_provider.dart';
import 'providers/home_provider.dart';
import 'providers/enrollment_provider.dart';
import 'widgets/footer_widget.dart';
import 'config/api_config.dart';
import 'models/service_models.dart';
import 'models/enrollment_models.dart';

class ServicesScreen extends StatefulWidget {
  final int initialTab;

  const ServicesScreen({super.key, this.initialTab = 0});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final ValueNotifier<int?> _enrollmentServiceId = ValueNotifier<int?>(null);

  static const List<Map<String, String>> _coreServices = [
    {
      'title': 'Private Lessons',
      'description':
          'Personalized chess coaching at home for learners who want focused attention and faster improvement.',
      'icon': 'person',
    },
    {
      'title': 'Chess in Schools',
      'description':
          'Integrating chess with academics—math, reading, and critical thinking—for school programs.',
      'icon': 'school',
    },
    {
      'title': 'Group Sessions',
      'description':
          'Weekend and holiday group trainings that blend teamwork, sparring, and friendly competition.',
      'icon': 'groups',
    },
    {
      'title': 'Online Resources & Classes',
      'description':
          'Live virtual classrooms with drills, homework, and on-demand resources that fit any schedule.',
      'icon': 'laptop',
    },
    {
      'title': 'Tournaments and Competitions',
      'description':
          'From rapid to classical tournaments with structured pairings and post-game analysis.',
      'icon': 'emoji_events',
    },
    {
      'title': 'Mentorship Programs',
      'description':
          'Building strategic thinkers through guided mentorship that nurtures confidence and discipline.',
      'icon': 'psychology',
    },
    {
      'title': 'Chess Library',
      'description':
          'A curated collection of books, magazines, and annotated games available in our club library.',
      'icon': 'menu_book',
    },
    {
      'title': 'Chess Equipment',
      'description':
          'Quality boards, clocks, and sets for rent or purchase—everything you need to play and train.',
      'icon': 'shopping_bag',
    },
    {
      'title': 'Chess Workshops & Seminars',
      'description':
          'Deep-dive workshops led by titled players to stretch tactical and strategic muscles.',
      'icon': 'lightbulb',
    },
    {
      'title': 'Chess Community & Networking',
      'description':
          'A welcoming community for sparring partners, study groups, and lifelong chess friendships.',
      'icon': 'diversity_3',
    },
  ];

  static const Set<String> _enrollableServiceNames = {
    'Private Lessons',
    'Group Sessions',
    'Online Resources & Classes',
    'Tournaments and Competitions',
    'Mentorship Programs',
    'Become Team Member',
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Widget _buildTabSwitcher(bool isMobile) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 40),
      child: const TabBar(
        labelColor: Color(0xFF0B131E),
        indicatorColor: Color(0xFF5886BF),
        indicatorWeight: 3,
        tabs: [
          Tab(text: 'Our Services'),
          Tab(text: 'Enroll'),
        ],
      ),
    );
  }

  Widget _buildServicesTab({
    required List services,
    required dynamic homeData,
    required bool isMobile,
    required bool isTablet,
  }) {
    final serviceItems = _composeServices(services);

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildServicesIntro(isMobile),
          _buildOfferingsSection(isMobile),
          _buildServicesGrid(serviceItems, isMobile, isTablet),
          _buildWhyChooseUs(isMobile),
          _buildCTASection(
            isMobile,
            onBookSession: () {
              DefaultTabController.of(context).animateTo(1);
            },
          ),
          FooterWidget(settings: homeData.siteSettings),
        ],
      ),
    );
  }

  Widget _buildEnrollTab({
    required List services,
    required dynamic homeData,
    required bool isMobile,
  }) {
    final enrollableServices =
        services
            .where(
              (s) => s.isActive && _enrollableServiceNames.contains(s.name),
            )
            .toList()
          ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

    // Ensure 'Become Team Member' option is available even if not defined in backend
    final hasTeamMember = enrollableServices.any(
      (s) => s.name == 'Become Team Member',
    );
    if (!hasTeamMember) {
      enrollableServices.add(
        Service(
          id: -999,
          name: 'Become Team Member',
          category: 'training',
          categoryDisplay: 'Training',
          description:
              'Join our team and participate in events, mentorship, and community initiatives.',
          features: const [],
          image: null,
          price: 0.0,
          duration: '',
          isActive: true,
          isFeatured: false,
          displayOrder: 9999,
          createdAt: null,
        ),
      );
    }

    if (enrollableServices.isNotEmpty && _enrollmentServiceId.value == null) {
      _enrollmentServiceId.value = enrollableServices.first.id;
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildServicesIntro(isMobile),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 80,
              vertical: isMobile ? 24 : 40,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enroll in a service',
                  style: TextStyle(
                    color: const Color(0xFF0B131E),
                    fontSize: isMobile ? 24 : 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Pick the service you want to join and complete the enrollment form in one step.',
                  style: TextStyle(
                    color: Color(0xFF5A6270),
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                _buildEnrollCard(enrollableServices, isMobile),
              ],
            ),
          ),
          FooterWidget(settings: homeData.siteSettings),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _enrollmentServiceId.dispose();
    super.dispose();
  }

  void _loadData() {
    Future.microtask(() {
      context.read<ServiceProvider>().loadServices();
      context.read<HomeProvider>().loadHomeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final isTablet =
        MediaQuery.of(context).size.width >= 768 &&
        MediaQuery.of(context).size.width < 1024;

    return DefaultTabController(
      length: 2,
      initialIndex: widget.initialTab,
      child: Consumer2<ServiceProvider, HomeProvider>(
        builder: (context, serviceProvider, homeProvider, child) {
          if (serviceProvider.isLoading || homeProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5886BF)),
              ),
            );
          }

          final services = serviceProvider.services;
          final homeData = homeProvider.homeData;

          if (homeData == null) {
            return const Center(
              child: Text(
                'No data available',
                style: TextStyle(color: Color(0xFF707781), fontSize: 16),
              ),
            );
          }

          return Column(
            children: [
              _buildPageHeader(isMobile),
              _buildTabSwitcher(isMobile),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildServicesTab(
                      services: services,
                      homeData: homeData,
                      isMobile: isMobile,
                      isTablet: isTablet,
                    ),
                    _buildEnrollTab(
                      services: services,
                      homeData: homeData,
                      isMobile: isMobile,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPageHeader(bool isMobile) {
    final titleSize = isMobile ? 36.0 : 56.0;
    final subtitleSize = isMobile ? 12.0 : 14.0;
    final descriptionSize = isMobile ? 16.0 : 18.0;
    final padding = isMobile ? 20.0 : 40.0;

    return Container(
      height: isMobile ? 250 : 320,
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
          Positioned.fill(
            child: CustomPaint(painter: _ChessboardPatternPainter()),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.5),
                ],
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'WHAT WE OFFER',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: subtitleSize,
                      letterSpacing: isMobile ? 2.5 : 3.5,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: isMobile ? 10 : 15),
                  Text(
                    'Our Services',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: titleSize,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: isMobile ? 12 : 20),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Text(
                      'Professional chess training for every skill level',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.95),
                        fontSize: descriptionSize,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesIntro(bool isMobile) {
    final horizontalPadding = isMobile ? 20.0 : 80.0;
    final verticalPadding = isMobile ? 36.0 : 72.0;
    final fontSize = isMobile ? 16.0 : 20.0;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF0F4F9), Colors.white],
        ),
      ),
      child: Column(
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 960),
            child: Text(
              'We offer a range of services designed to cater to all your chess needs. Whether you are learning the basics or sharpening your tournament edge, you will find a pathway that fits.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF404957),
                fontSize: fontSize,
                height: 1.7,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesGrid(
    List<_ServiceViewModel> services,
    bool isMobile,
    bool isTablet,
  ) {
    final horizontalPadding = isMobile ? 20.0 : 80.0;
    final crossAxisCount = isMobile ? 1 : (isTablet ? 2 : 3);
    final childAspectRatio = isMobile ? 0.85 : (isTablet ? 0.9 : 0.95);

    if (services.isEmpty) {
      return Container(
        padding: EdgeInsets.symmetric(
          vertical: 80,
          horizontal: horizontalPadding,
        ),
        child: const Center(
          child: Column(
            children: [
              Icon(Icons.school_outlined, size: 64, color: Color(0xFFB0B8C1)),
              SizedBox(height: 20),
              Text(
                'No services available at the moment',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF707781),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Please check back soon',
                style: TextStyle(fontSize: 14, color: Color(0xFFB0B8C1)),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 36,
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: isMobile ? 0 : 24,
          mainAxisSpacing: 24,
          childAspectRatio: childAspectRatio,
        ),
        itemCount: services.length,
        itemBuilder: (context, index) =>
            _buildServiceCard(services[index], isMobile),
      ),
    );
  }

  Widget _buildServiceCard(_ServiceViewModel service, bool isMobile) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(color: const Color(0xFFE8EFF7)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    image: service.imageUrl != null
                        ? DecorationImage(
                            image: NetworkImage(service.imageUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                    gradient: service.imageUrl == null
                        ? LinearGradient(
                            colors: [
                              const Color(0xFF5886BF).withOpacity(0.14),
                              const Color(0xFF283D57).withOpacity(0.10),
                            ],
                          )
                        : null,
                  ),
                  child: service.imageUrl == null
                      ? const Center(
                          child: Icon(
                            Icons.sports_esports,
                            size: 72,
                            color: Color(0xFF5886BF),
                          ),
                        )
                      : null,
                ),
                if (service.badge != null && service.badge!.isNotEmpty)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5886BF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        service.badge!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.title,
                      style: const TextStyle(
                        color: Color(0xFF0B131E),
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Text(
                        service.description,
                        style: const TextStyle(
                          color: Color(0xFF5A6270),
                          fontSize: 14,
                          height: 1.6,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 14),
                    if (service.features.isNotEmpty)
                      ...service.features
                          .take(3)
                          .map(
                            (f) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF5886BF,
                                      ).withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      size: 14,
                                      color: Color(0xFF5886BF),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      f,
                                      style: const TextStyle(
                                        color: Color(0xFF404957),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            service.isEnrollable && service.service != null
                            ? () {
                                _enrollmentServiceId.value =
                                    service.service!.id;
                                DefaultTabController.of(context).animateTo(1);
                              }
                            : () {
                                Navigator.pushNamed(context, '/contact');
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5886BF),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          service.isEnrollable && service.service != null
                              ? 'Enroll'
                              : 'Talk to us',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/contact'),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF5B728F),
                      ),
                      child: const Text('Contact us'),
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

  Widget _buildWhyChooseUs(bool isMobile) {
    final horizontalPadding = isMobile ? 20.0 : 80.0;
    final verticalPadding = isMobile ? 40.0 : 60.0;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      color: Colors.white,
      child: Column(
        children: [
          Text(
            'WHY CHOOSE US',
            style: TextStyle(
              color: const Color(0xFF5886BF),
              fontSize: isMobile ? 12 : 14,
              letterSpacing: 3,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Excellence in Chess Education',
            style: TextStyle(
              color: const Color(0xFF0B131E),
              fontSize: isMobile ? 28 : 42,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isMobile ? 30 : 50),
          isMobile
              ? Column(
                  children: [
                    _buildFeatureCard(
                      Icons.emoji_events_outlined,
                      'Expert Coaches',
                      'Learn from FIDE-rated masters and experienced educators',
                      isMobile,
                    ),
                    const SizedBox(height: 20),
                    _buildFeatureCard(
                      Icons.person_outline,
                      'Personalized Training',
                      'Customized curriculum tailored to your skill level and goals',
                      isMobile,
                    ),
                    const SizedBox(height: 20),
                    _buildFeatureCard(
                      Icons.groups_outlined,
                      'Flexible Learning',
                      'Choose between private lessons or group sessions',
                      isMobile,
                    ),
                    const SizedBox(height: 20),
                    _buildFeatureCard(
                      Icons.analytics_outlined,
                      'Progress Tracking',
                      'Regular assessments and detailed performance analytics',
                      isMobile,
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: _buildFeatureCard(
                        Icons.emoji_events_outlined,
                        'Expert Coaches',
                        'Learn from FIDE-rated masters and experienced educators',
                        isMobile,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _buildFeatureCard(
                        Icons.person_outline,
                        'Personalized Training',
                        'Customized curriculum tailored to your skill level and goals',
                        isMobile,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _buildFeatureCard(
                        Icons.groups_outlined,
                        'Flexible Learning',
                        'Choose between private lessons or group sessions',
                        isMobile,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _buildFeatureCard(
                        Icons.analytics_outlined,
                        'Progress Tracking',
                        'Regular assessments and detailed performance analytics',
                        isMobile,
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    IconData icon,
    String title,
    String description,
    bool isMobile,
  ) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 24),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8EFF7)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF5886BF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 32, color: const Color(0xFF5886BF)),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF0B131E),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              color: Color(0xFF707781),
              fontSize: 14,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCTASection(
    bool isMobile, {
    required VoidCallback onBookSession,
  }) {
    final horizontalPadding = isMobile ? 20.0 : 80.0;
    final verticalPadding = isMobile ? 50.0 : 80.0;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF5886BF), Color(0xFF283D57)],
        ),
      ),
      child: Column(
        children: [
          Text(
            'Ready to Begin Your Chess Journey?',
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 28 : 42,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isMobile ? 16 : 20),
          Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Text(
              'Contact us today to book your first session or learn more about our services',
              style: TextStyle(
                color: Colors.white.withOpacity(0.95),
                fontSize: isMobile ? 16 : 18,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: isMobile ? 30 : 40),
          isMobile
              ? Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onBookSession,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF5886BF),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'BOOK A SESSION',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/contact');
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: Colors.white, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'CONTACT US',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: onBookSession,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF5886BF),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 20,
                        ),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'BOOK A SESSION NOW',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/contact');
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 20,
                        ),
                        side: const BorderSide(color: Colors.white, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'CONTACT US',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  List<_ServiceViewModel> _composeServices(List services) {
    final Map<String, Service> backendServicesMap = {};
    for (var s in services.where((s) => s.isActive)) {
      backendServicesMap[s.name] = s;
    }

    return _coreServices.map((core) {
      final title = core['title']!;
      final backendService = backendServicesMap[title];

      return _ServiceViewModel(
        title: title,
        description: core['description']!,
        features: backendService?.features ?? [],
        imageUrl: backendService?.image != null
            ? '${ApiConfig.baseUrl}${backendService!.image}'
            : null,
        badge: backendService?.duration,
        isEnrollable: _enrollableServiceNames.contains(title),
        service: backendService,
      );
    }).toList();
  }

  Widget _buildOfferingsSection(bool isMobile) {
    final horizontalPadding = isMobile ? 20.0 : 80.0;
    final verticalPadding = isMobile ? 36.0 : 56.0;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      color: Colors.white,
      child: Column(
        children: [
          Text(
            'Services Include',
            style: TextStyle(
              color: const Color(0xFF0B131E),
              fontSize: isMobile ? 28 : 40,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: isMobile ? 12 : 20),
          Text(
            'Explore our complete range of offerings',
            style: TextStyle(
              color: const Color(0xFF5A6270),
              fontSize: isMobile ? 14 : 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnrollCard(List services, bool isMobile) {
    if (services.isEmpty) {
      return Container(
        padding: EdgeInsets.all(isMobile ? 20 : 32),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5ECF4)),
        ),
        child: const Column(
          children: [
            Icon(Icons.school_outlined, size: 56, color: Color(0xFFB0B8C1)),
            SizedBox(height: 16),
            Text(
              'No enrollment services available at the moment',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF707781),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ValueListenableBuilder<int?>(
      valueListenable: _enrollmentServiceId,
      builder: (context, selectedServiceId, child) {
        Service selectedService;
        try {
          selectedService = services.firstWhere(
            (s) => s.id == selectedServiceId,
          );
        } catch (e) {
          selectedService = services.first;
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE1E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (services.length > 1)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: DropdownButtonFormField<int>(
                    value: selectedServiceId,
                    decoration: const InputDecoration(
                      labelText: 'Select a service',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    items: services
                        .map<DropdownMenuItem<int>>(
                          (s) => DropdownMenuItem<int>(
                            value: s.id,
                            child: Text(s.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        _enrollmentServiceId.value = value;
                      }
                    },
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: _SimpleEnrollmentForm(service: selectedService),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SimpleEnrollmentForm extends StatefulWidget {
  final Service service;
  const _SimpleEnrollmentForm({required this.service});

  @override
  State<_SimpleEnrollmentForm> createState() => _SimpleEnrollmentFormState();
}

class _SimpleEnrollmentFormState extends State<_SimpleEnrollmentForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _messageController;
  bool _subscribedToNewsletter = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final enrollment = Enrollment(
      serviceId: widget.service.id,
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      message: _messageController.text.trim(),
      subscribedToNewsletter: _subscribedToNewsletter,
    );

    final provider = context.read<EnrollmentProvider>();
    final success = await provider.submitEnrollment(enrollment);
    if (success) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Enrollment submitted. We\'ll contact you within 24 hours.',
          ),
        ),
      );
      _formKey.currentState!.reset();
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _messageController.clear();
      setState(() {
        _subscribedToNewsletter = true;
      });
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error ?? 'Failed to submit enrollment'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enroll in ${widget.service.name}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Full Name'),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Required';
              if (v.trim().length < 3) return 'Enter at least 3 characters';
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email Address'),
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Required';
              if (!v.contains('@')) return 'Enter a valid email';
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(labelText: 'Phone Number'),
            keyboardType: TextInputType.phone,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Required';
              if (v.trim().length < 10) return 'Enter a valid phone number';
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _messageController,
            decoration: const InputDecoration(
              labelText: 'Additional Message (Optional)',
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 12),
          CheckboxListTile(
            value: _subscribedToNewsletter,
            onChanged: (val) {
              setState(() {
                _subscribedToNewsletter = val ?? true;
              });
            },
            title: const Text('Subscribe to newsletter'),
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submit,
              child: const Text('Submit Enrollment'),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for chessboard pattern in header
class _ChessboardPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..style = PaintingStyle.fill;

    const squareSize = 60.0;
    final rows = (size.height / squareSize).ceil();
    final cols = (size.width / squareSize).ceil();

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        if ((row + col) % 2 == 0) {
          canvas.drawRect(
            Rect.fromLTWH(
              col * squareSize,
              row * squareSize,
              squareSize,
              squareSize,
            ),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// View model to combine static services with dynamic backend data
class _ServiceViewModel {
  final String title;
  final String description;
  final List<String> features;
  final String? imageUrl;
  final String? badge;
  final bool isEnrollable;
  final Service? service;

  _ServiceViewModel({
    required this.title,
    required this.description,
    this.features = const [],
    this.imageUrl,
    this.badge,
    this.isEnrollable = false,
    this.service,
  });
}
