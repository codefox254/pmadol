import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/service_provider.dart';
import 'providers/home_provider.dart';
import 'providers/enrollment_provider.dart';
import 'widgets/footer_widget.dart';
import 'config/api_config.dart';
import 'screens/enrollment_screen.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({Key? key}) : super(key: key);

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  String selectedLevel = 'All Levels';
  
  @override
  void initState() {
    super.initState();
    _loadData();
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
    final isTablet = MediaQuery.of(context).size.width >= 768 && 
                     MediaQuery.of(context).size.width < 1024;

    return Consumer2<ServiceProvider, HomeProvider>(
      builder: (context, serviceProvider, homeProvider, child) {
        if (serviceProvider.isLoading || homeProvider.isLoading) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5886BF)),
            ),
          );
        }

        final services = serviceProvider.services;
        final homeData = homeProvider.homeData;
        
        if (homeData == null) {
          return Center(
            child: Text(
              'No data available',
              style: TextStyle(color: Color(0xFF707781), fontSize: 16),
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              _buildPageHeader(isMobile),
              _buildServicesIntro(isMobile),
              _buildLevelFilter(isMobile),
              _buildServicesGrid(services, isMobile, isTablet),
              _buildWhyChooseUs(isMobile),
              _buildPricingSection(isMobile, isTablet),
              _buildCTASection(isMobile),
              FooterWidget(settings: homeData.siteSettings),
            ],
          ),
        );
      },
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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF5886BF), Color(0xFF283D57)],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _ChessboardPatternPainter(),
            ),
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
                    constraints: BoxConstraints(maxWidth: 600),
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
    final verticalPadding = isMobile ? 40.0 : 80.0;
    final fontSize = isMobile ? 16.0 : 20.0;
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF0F4F9),
            Colors.white,
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: 900),
            child: Text(
              'We offer a comprehensive range of chess services designed to cater to players of all skill levels. From beginner basics to advanced tournament preparation, our expert coaches provide personalized instruction that helps you achieve your chess goals.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF404957),
                fontSize: fontSize,
                height: 1.8,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(height: isMobile ? 30 : 40),
          _buildStatsRow(isMobile),
        ],
      ),
    );
  }

  Widget _buildStatsRow(bool isMobile) {
    if (isMobile) {
      return Column(
        children: [
          _buildStatItem('500+', 'Students Trained'),
          SizedBox(height: 20),
          _buildStatItem('15+', 'Expert Coaches'),
          SizedBox(height: 20),
          _buildStatItem('95%', 'Success Rate'),
        ],
      );
    }
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem('500+', 'Students Trained'),
        Container(width: 1, height: 60, color: Color(0xFFE8EFF7)),
        _buildStatItem('15+', 'Expert Coaches'),
        Container(width: 1, height: 60, color: Color(0xFFE8EFF7)),
        _buildStatItem('95%', 'Success Rate'),
      ],
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: Color(0xFF5886BF),
            fontSize: 36,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Color(0xFF707781),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildLevelFilter(bool isMobile) {
    final levels = ['All Levels', 'Beginner', 'Intermediate', 'Advanced', 'Tournament'];
    final horizontalPadding = isMobile ? 20.0 : 80.0;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 20),
      child: isMobile
          ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: levels.map((level) => _buildLevelChip(level, isMobile)).toList(),
              ),
            )
          : Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: levels.map((level) => _buildLevelChip(level, isMobile)).toList(),
            ),
    );
  }

  Widget _buildLevelChip(String level, bool isMobile) {
    final isSelected = selectedLevel == level;
    
    return Padding(
      padding: EdgeInsets.only(right: isMobile ? 8 : 0),
      child: FilterChip(
        label: Text(level),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            selectedLevel = level;
          });
        },
        backgroundColor: Colors.white,
        selectedColor: Color(0xFF5886BF),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Color(0xFF707781),
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          fontSize: 14,
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: isSelected ? 4 : 0,
        side: BorderSide(
          color: isSelected ? Color(0xFF5886BF) : Color(0xFFE8EFF7),
          width: 1,
        ),
      ),
    );
  }

  Widget _buildServicesGrid(List services, bool isMobile, bool isTablet) {
    final horizontalPadding = isMobile ? 20.0 : 80.0;
    final crossAxisCount = isMobile ? 1 : (isTablet ? 2 : 3);
    final childAspectRatio = isMobile ? 0.75 : (isTablet ? 0.80 : 0.85);
    
    if (services.isEmpty) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 80, horizontal: horizontalPadding),
        child: Center(
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
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 40),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: isMobile ? 0 : 30,
          mainAxisSpacing: 30,
          childAspectRatio: childAspectRatio,
        ),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return _buildServiceCard(service, isMobile);
        },
      ),
    );
  }

  Widget _buildServiceCard(dynamic service, bool isMobile) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (service.image != null)
              Stack(
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                      image: DecorationImage(
                        image: NetworkImage('${ApiConfig.baseUrl}${service.image}'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Color(0xFF5886BF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        service.duration ?? 'Flexible',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            else
              Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF5886BF).withOpacity(0.15),
                      Color(0xFF5886BF).withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Center(
                  child: Icon(Icons.school_outlined, size: 80, color: Color(0xFF5886BF)),
                ),
              ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.name,
                      style: TextStyle(
                        color: Color(0xFF0B131E),
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 12),
                    Expanded(
                      child: Text(
                        service.description,
                        style: TextStyle(
                          color: Color(0xFF707781),
                          fontSize: 14,
                          height: 1.6,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 16),
                    if (service.price != null)
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'KES ',
                              style: TextStyle(
                                color: Color(0xFF707781),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              service.price.toStringAsFixed(0),
                              style: TextStyle(
                                color: Color(0xFF5886BF),
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              '/month',
                              style: TextStyle(
                                color: Color(0xFF707781),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChangeNotifierProvider(
                                create: (_) => EnrollmentProvider(),
                                child: EnrollmentScreen(service: service),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF5886BF),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Enroll Now',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, size: 18),
                          ],
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
              color: Color(0xFF5886BF),
              fontSize: isMobile ? 12 : 14,
              letterSpacing: 3,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Excellence in Chess Education',
            style: TextStyle(
              color: Color(0xFF0B131E),
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
                    SizedBox(height: 20),
                    _buildFeatureCard(
                      Icons.person_outline,
                      'Personalized Training',
                      'Customized curriculum tailored to your skill level and goals',
                      isMobile,
                    ),
                    SizedBox(height: 20),
                    _buildFeatureCard(
                      Icons.groups_outlined,
                      'Flexible Learning',
                      'Choose between private lessons or group sessions',
                      isMobile,
                    ),
                    SizedBox(height: 20),
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
                    SizedBox(width: 24),
                    Expanded(
                      child: _buildFeatureCard(
                        Icons.person_outline,
                        'Personalized Training',
                        'Customized curriculum tailored to your skill level and goals',
                        isMobile,
                      ),
                    ),
                    SizedBox(width: 24),
                    Expanded(
                      child: _buildFeatureCard(
                        Icons.groups_outlined,
                        'Flexible Learning',
                        'Choose between private lessons or group sessions',
                        isMobile,
                      ),
                    ),
                    SizedBox(width: 24),
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

  Widget _buildFeatureCard(IconData icon, String title, String description, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 24),
      decoration: BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE8EFF7)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF5886BF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 32, color: Color(0xFF5886BF)),
          ),
          SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              color: Color(0xFF0B131E),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
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

  Widget _buildPricingSection(bool isMobile, bool isTablet) {
    final horizontalPadding = isMobile ? 20.0 : 80.0;
    final verticalPadding = isMobile ? 40.0 : 80.0;
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF5F9FF), Color(0xFFFFFFFF)],
        ),
      ),
      child: Column(
        children: [
          Text(
            'PRICING PLANS',
            style: TextStyle(
              color: Color(0xFF5886BF),
              fontSize: isMobile ? 12 : 14,
              letterSpacing: 3,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Choose Your Package',
            style: TextStyle(
              color: Color(0xFF0B131E),
              fontSize: isMobile ? 32 : 48,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isMobile ? 8 : 16),
          Text(
            'Flexible options to match your learning journey',
            style: TextStyle(
              color: Color(0xFF707781),
              fontSize: isMobile ? 14 : 18,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isMobile ? 30 : 60),
          if (isMobile)
            Column(
              children: [
                _buildPricingCard(
                  'Beginner',
                  '5,000',
                  'per month',
                  ['4 group sessions', '1 hour each', 'Basic materials', 'Certificate'],
                  isMobile,
                ),
                SizedBox(height: 20),
                _buildPricingCard(
                  'Intermediate',
                  '8,000',
                  'per month',
                  ['4 private lessons', '1.5 hours each', 'Game analysis', 'Tournament entry', 'Advanced materials'],
                  isMobile,
                  isPopular: true,
                ),
                SizedBox(height: 20),
                _buildPricingCard(
                  'Advanced',
                  '12,000',
                  'per month',
                  ['8 private lessons', '2 hours each', 'Personalized training', 'Tournament coaching', 'All materials', 'Mentorship'],
                  isMobile,
                ),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildPricingCard(
                    'Beginner',
                    '5,000',
                    'per month',
                    ['4 group sessions', '1 hour each', 'Basic materials', 'Certificate'],
                    isMobile,
                  ),
                ),
                SizedBox(width: 30),
                Expanded(
                  child: _buildPricingCard(
                    'Intermediate',
                    '8,000',
                    'per month',
                    ['4 private lessons', '1.5 hours each', 'Game analysis', 'Tournament entry', 'Advanced materials'],
                    isMobile,
                    isPopular: true,
                  ),
                ),
                SizedBox(width: 30),
                Expanded(
                  child: _buildPricingCard(
                    'Advanced',
                    '12,000',
                    'per month',
                    ['8 private lessons', '2 hours each', 'Personalized training', 'Tournament coaching', 'All materials', 'Mentorship'],
                    isMobile,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildPricingCard(
    String name,
    String price,
    String period,
    List<String> features,
    bool isMobile,
    {bool isPopular = false}
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isPopular
            ? Border.all(color: Color(0xFF5886BF), width: 2)
            : Border.all(color: Color(0xFFE8EFF7)),
        boxShadow: [
          BoxShadow(
            color: isPopular
                ? Color(0xFF5886BF).withOpacity(0.15)
                : Colors.black.withOpacity(0.05),
            blurRadius: isPopular ? 20 : 10,
            offset: Offset(0, isPopular ? 8 : 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 24 : 32),
        child: Column(
          children: [
            if (isPopular)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF5886BF), Color(0xFF4A6FA8)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'MOST POPULAR',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ),
            SizedBox(height: isPopular ? 20 : 12),
            Text(
              name,
              style: TextStyle(
                color: Color(0xFF0B131E),
                fontSize: isMobile ? 24 : 28,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'KES ',
                  style: TextStyle(
                    color: Color(0xFF5886BF),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  price,
                  style: TextStyle(
                    color: Color(0xFF5886BF),
                    fontSize: isMobile ? 40 : 48,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              period,
              style: TextStyle(
                color: Color(0xFF707781),
                fontSize: 14,
              ),
            ),
            SizedBox(height: 30),
            Container(
              height: 1,
              color: Color(0xFFE8EFF7),
            ),
            SizedBox(height: 30),
            ...features.map((feature) => Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Color(0xFF5886BF).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.check,
                      color: Color(0xFF5886BF),
                      size: 16,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      feature,
                      style: TextStyle(
                        color: Color(0xFF404957),
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            )),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Navigate to enrollment with selected plan
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isPopular ? Color(0xFF5886BF) : Color(0xFF5B728F),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCTASection(bool isMobile) {
    final horizontalPadding = isMobile ? 20.0 : 80.0;
    final verticalPadding = isMobile ? 50.0 : 80.0;
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
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
            constraints: BoxConstraints(maxWidth: 600),
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
                        onPressed: () {
                          // TODO: Navigate to enrollment
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Color(0xFF5886BF),
                          padding: EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'BOOK A SESSION',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          // TODO: Navigate to contact
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: Colors.white, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
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
                      onPressed: () {
                        // TODO: Navigate to enrollment
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Color(0xFF5886BF),
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'BOOK A SESSION NOW',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    OutlinedButton(
                      onPressed: () {
                        // TODO: Navigate to contact
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                        side: BorderSide(color: Colors.white, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
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
