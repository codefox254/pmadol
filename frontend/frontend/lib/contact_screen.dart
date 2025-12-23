// ============================================
// lib/contact_screen.dart - Modern Dynamic
// ============================================
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'providers/home_provider.dart';
import 'widgets/footer_widget.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSubmitting = false;

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
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        if (homeProvider.isLoading) {
          return Center(
            child: CircularProgressIndicator(color: Color(0xFF5886BF)),
          );
        }

        final homeData = homeProvider.homeData;
        if (homeData == null) {
          return Center(child: Text('No data available'));
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              _buildPageHeader(),
              _buildContactForm(),
              _buildContactInfo(homeData.siteSettings),
              _buildMapSection(),
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
          colors: [
            Color(0xFF5886BF),
            Color(0xFF3D5A8F),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'GET IN TOUCH',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                letterSpacing: 3.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 15),
            Text(
              'Contact Us Today',
              style: TextStyle(
                color: Colors.white,
                fontSize: 56,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 15),
            Text(
              'We\'re here to help and answer any question you might have',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactForm() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 80, horizontal: 80),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFFFFF),
            Color(0xFFF8FAFC),
          ],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Send us a message',
                  style: TextStyle(
                    color: Color(0xFF0B131E),
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'Let us know how we can help you achieve your chess goals',
                  style: TextStyle(
                    color: Color(0xFF707781),
                    fontSize: 16,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 80),
          Expanded(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildFormField('Full Name', _nameController, false),
                  SizedBox(height: 20),
                  _buildFormField('Email Address', _emailController, false),
                  SizedBox(height: 20),
                  _buildFormField('Phone Number', _phoneController, false),
                  SizedBox(height: 20),
                  _buildFormField('Message', _messageController, true),
                  SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF5886BF),
                        disabledBackgroundColor: Colors.grey,
                      ),
                      child: _isSubmitting
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              'Send Message',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
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

  Widget _buildFormField(String label, TextEditingController controller, bool isMultiline) {
    return TextFormField(
      controller: controller,
      maxLines: isMultiline ? 5 : 1,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color(0xFF5886BF), width: 2),
        ),
        labelStyle: TextStyle(color: Color(0xFF707781)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        if (label == 'Email Address' && !value.contains('@')) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      // Simulate API call
      await Future.delayed(Duration(seconds: 1));

      setState(() => _isSubmitting = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Message sent successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );

      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _messageController.clear();
    }
  }

  Widget _buildContactInfo(dynamic settings) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 80, horizontal: 80),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF0F4F9),
            Color(0xFFE8EFF7),
          ],
        ),
      ),
      child: Column(
        children: [
          Text(
            'OUR CONTACT INFORMATION',
            style: TextStyle(
              color: Color(0xFF5886BF),
              fontSize: 14,
              letterSpacing: 3.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildContactCard(
                Icons.phone,
                'Phone',
                settings.phone,
                () => _launchUrl('tel:${settings.phone}'),
              ),
              _buildContactCard(
                Icons.email,
                'Email',
                settings.email,
                () => _launchUrl('mailto:${settings.email}'),
              ),
              _buildContactCard(
                Icons.location_on,
                'Address',
                settings.address,
                () {},
              ),
              _buildContactCard(
                Icons.schedule,
                'Working Hours',
                'Mon-Sat: 8AM-10PM\nSun: 10AM-8PM',
                () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(
    IconData icon,
    String title,
    String value,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220,
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Color(0xFF5886BF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(icon, color: Color(0xFF5886BF), size: 30),
            ),
            SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                color: Color(0xFF0B131E),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 15),
            Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF707781),
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapSection() {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFF5886BF),
            Color(0xFF3D5A8F),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.map, size: 80, color: Colors.white),
            SizedBox(height: 20),
            Text(
              'Map View Coming Soon',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Visit us at our location in Nairobi',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    try {
      final Uri url = Uri.parse(urlString);
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }

}
