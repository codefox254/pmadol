// ============================================
// lib/widgets/footer_widget.dart
// ============================================
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/home_models.dart';
import '../config/api_config.dart';

class FooterWidget extends StatelessWidget {
  final SiteSettings settings;

  const FooterWidget({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF0B131E),
      padding: EdgeInsets.symmetric(vertical: 80, horizontal: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Footer content grid
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Column 1: About
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      settings.siteName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      settings.tagline,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              // Column 2: Quick Links
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Links',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    ..._buildLinks(['Home', 'About', 'Services', 'Blog', 'Gallery', 'Shop']),
                  ],
                ),
              ),
              // Column 3: Contact Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contact Us',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    _buildContactItem(Icons.phone, settings.phone),
                    SizedBox(height: 10),
                    _buildContactItem(Icons.email, settings.email),
                    SizedBox(height: 10),
                    _buildLocationItem(
                      title: 'Kasarani Sportsview, Nairobi',
                      url: settings.mapUrl ?? 'https://www.google.com/maps/search/?api=1&query=Kasarani%20Sportsview%2C%20Nairobi',
                    ),
                  ],
                ),
              ),
              // Column 4: Social Media
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Follow Us',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        if (settings.facebookUrl != null)
                          _buildSocialIcon(Icons.facebook, settings.facebookUrl!),
                        if (settings.instagramUrl != null)
                          _buildSocialIcon(Icons.camera_alt, settings.instagramUrl!),
                        if (settings.twitterUrl != null)
                          _buildSocialIcon(Icons.share, settings.twitterUrl!),
                        if (settings.youtubeUrl != null)
                          _buildSocialIcon(Icons.play_circle, settings.youtubeUrl!),
                        if (settings.linkedinUrl != null)
                          _buildSocialIcon(Icons.business, settings.linkedinUrl!),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 60),
          Divider(color: Colors.grey[700]),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '© 2024 ${settings.siteName}. All rights reserved.',
                style: TextStyle(color: Colors.grey[400], fontSize: 14),
              ),
              Row(
                children: [
                  _buildFooterLink('Privacy Policy'),
                  SizedBox(width: 30),
                  _buildFooterLink('Terms of Service'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildLinks(List<String> links) {
    return links.map((link) {
      return Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Text(
            link,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Color(0xFF5886BF), size: 16),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationItem({required String title, required String url}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.location_on, color: Color(0xFF5886BF), size: 16),
        SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: () => _launchUrl(url),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon, String url) {
    return Padding(
      padding: EdgeInsets.only(right: 15),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => _launchUrl(url),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Color(0xFF5886BF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildFooterLink(String text) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey[400],
          fontSize: 14,
        ),
      ),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    try {
      final Uri url = Uri.parse(urlString);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }
}
