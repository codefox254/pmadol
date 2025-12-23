import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/service_provider.dart';
import 'providers/home_provider.dart';
import 'widgets/footer_widget.dart';
import 'config/api_config.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({Key? key}) : super(key: key);

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
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
    return Consumer2<ServiceProvider, HomeProvider>(
      builder: (context, serviceProvider, homeProvider, child) {
        if (serviceProvider.isLoading || homeProvider.isLoading) {
          return Center(
            child: CircularProgressIndicator(color: Color(0xFF5886BF)),
          );
        }

        final services = serviceProvider.services;
        final homeData = homeProvider.homeData;
        
        if (homeData == null) {
          return Center(child: Text('No data available'));
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              _buildPageHeader(),
              _buildServicesIntro(),
              _buildServicesGrid(services),
              _buildPricingSection(),
              _buildCTASection(),
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
        image: DecorationImage(
          image: AssetImage('assets/images/services_header.jpg'),
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
                Text('WHAT WE OFFER',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    letterSpacing: 3.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 15),
                Text('Our Services',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 56,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesIntro() {
    return Container(
      padding: EdgeInsets.all(80),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF0F4F9),
            Color(0xFFFFFFFF),
          ],
        ),
      ),
      child: Column(
        children: [
          Text(
            'We offer a comprehensive range of chess services designed to cater to players of all skill levels. From beginner basics to advanced tournament preparation, our expert coaches provide personalized instruction that helps you achieve your chess goals.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF404957),
              fontSize: 20,
              height: 1.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesGrid(List services) {
    if (services.isEmpty) {
      return Container(
        padding: EdgeInsets.all(80),
        child: Center(
          child: Text(
            'No services available at the moment',
            style: TextStyle(fontSize: 18, color: Color(0xFF707781)),
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 80, vertical: 40),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 30,
          mainAxisSpacing: 30,
          childAspectRatio: 0.85,
        ),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return _buildServiceCard(service);
        },
      ),
    );
  }

  Widget _buildServiceCard(dynamic service) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (service.image != null)
            Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                image: DecorationImage(
                  image: NetworkImage('${ApiConfig.baseUrl}${service.image}'),
                  fit: BoxFit.cover,
                ),
              ),
            )
          else
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: Color(0xFF5886BF).withOpacity(0.1),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Center(
                child: Icon(Icons.school, size: 60, color: Color(0xFF5886BF)),
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
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
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
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (service.duration != null && service.duration.isNotEmpty)
                        Text(
                          service.duration,
                          style: TextStyle(
                            color: Color(0xFF5886BF),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      if (service.price != null)
                        Text(
                          'KES ${service.price.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: Color(0xFF0B131E),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
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
    );
  }

  Widget _buildDetailedServiceCard(IconData icon, String title, String subtitle, String description, List<String> features) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              gradient: LinearGradient(
                colors: [Color(0xFF5886BF), Color(0xFF4F78AB)],
              ),
            ),
            child: Center(
              child: Icon(icon, size: 80, color: Colors.white),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                    style: TextStyle(
                      color: Color(0xFF0B131E),
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(subtitle,
                    style: TextStyle(
                      color: Color(0xFF5886BF),
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(description,
                    style: TextStyle(
                      color: Color(0xFF404957),
                      fontSize: 14,
                      height: 1.5,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 15),
                  ...features.take(3).map((feature) => Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Color(0xFF5886BF), size: 16),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(feature,
                            style: TextStyle(
                              color: Color(0xFF404957),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
                  Spacer(),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    child: Text('Learn More →',
                      style: TextStyle(
                        color: Color(0xFF5886BF),
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
    );
  }

  Widget _buildPricingSection() {
    return Container(
      padding: EdgeInsets.all(80),
      color: Color(0xFFF5F9FF),
      child: Column(
        children: [
          Text('PRICING PLANS',
            style: TextStyle(
              color: Color(0xFF283D57),
              fontSize: 14,
              letterSpacing: 3.5,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 15),
          Text('Choose Your Package',
            style: TextStyle(
              color: Color(0xFF0B131E),
              fontSize: 48,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 60),
          Row(
            children: [
              Expanded(child: _buildPricingCard('Beginner', '5,000 KES', 'per month', ['4 group sessions', '1 hour each', 'Basic materials', 'Certificate'])),
              SizedBox(width: 30),
              Expanded(child: _buildPricingCard('Intermediate', '8,000 KES', 'per month', ['4 private lessons', '1.5 hours each', 'Game analysis', 'Tournament entry', 'Advanced materials'], isPopular: true)),
              SizedBox(width: 30),
              Expanded(child: _buildPricingCard('Advanced', '12,000 KES', 'per month', ['8 private lessons', '2 hours each', 'Personalized training', 'Tournament coaching', 'All materials', 'Mentorship'])),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPricingCard(String name, String price, String period, List<String> features, {bool isPopular = false}) {
    return Card(
      elevation: isPopular ? 8 : 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: isPopular ? BorderSide(color: Color(0xFF5886BF), width: 2) : BorderSide.none,
      ),
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          children: [
            if (isPopular)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                  color: Color(0xFF5886BF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('POPULAR',
                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            SizedBox(height: 20),
            Text(name,
              style: TextStyle(
                color: Color(0xFF0B131E),
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 20),
            Text(price,
              style: TextStyle(
                color: Color(0xFF5886BF),
                fontSize: 48,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(period,
              style: TextStyle(
                color: Color(0xFF404957),
                fontSize: 16,
              ),
            ),
            SizedBox(height: 30),
            ...features.map((feature) => Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Color(0xFF5886BF), size: 20),
                  SizedBox(width: 10),
                  Text(feature,
                    style: TextStyle(color: Color(0xFF404957), fontSize: 16)),
                ],
              ),
            )),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: isPopular ? Color(0xFF5886BF) : Color(0xFF5B728F),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Get Started',
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
    );
  }

  Widget _buildCTASection() {
    return Container(
      padding: EdgeInsets.all(80),
      color: Color(0xFF5886BF),
      child: Column(
        children: [
          Text('Ready to Begin Your Chess Journey?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 42,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 20),
          Text('Contact us today to book your first session or learn more about our services',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('BOOK A SESSION NOW',
              style: TextStyle(
                color: Color(0xFF5886BF),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
