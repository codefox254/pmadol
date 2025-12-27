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
    final isMobile = MediaQuery.of(context).size.width < 768;
    
    return Container(
      color: const Color(0xFF1A2634),
      child: Column(
        children: [
          // Main footer content
          Container(
            padding: EdgeInsets.symmetric(
              vertical: isMobile ? 40 : 80,
              horizontal: isMobile ? 20 : 80,
            ),
            child: isMobile
                ? _buildMobileFooterContent()
                : _buildDesktopFooterContent(),
          ),
          
          // Divider
          Container(
            height: 1,
            margin: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 80),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF5886BF).withOpacity(0.0),
                  const Color(0xFF5886BF).withOpacity(0.5),
                  const Color(0xFF5886BF).withOpacity(0.0),
                ],
              ),
            ),
          ),
          
          // Footer bottom
          Container(
            padding: EdgeInsets.symmetric(
              vertical: isMobile ? 20 : 30,
              horizontal: isMobile ? 20 : 80,
            ),
            child: isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '© 2024 ${settings.siteName}. All rights reserved.',
                        style: const TextStyle(
                          color: Color(0xFFB0B8C1),
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildFooterLink('Privacy Policy'),
                          const Text(' · ', style: TextStyle(color: Color(0xFF5886BF))),
                          _buildFooterLink('Terms of Service'),
                        ],
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '© 2024 ${settings.siteName}. All rights reserved.',
                        style: const TextStyle(
                          color: Color(0xFFB0B8C1),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Row(
                        children: [
                          _buildFooterLink('Privacy Policy'),
                          const Text(' · ', style: TextStyle(color: Color(0xFF5886BF))),
                          _buildFooterLink('Terms of Service'),
                        ],
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopFooterContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Column 1: About
        Expanded(
          flex: 10,
          child: _buildFooterColumn(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: Text(
                  settings.siteName.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ),
              Container(
                width: 50,
                height: 3,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF5886BF), Color(0xFF4A6FA8)],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                settings.tagline,
                style: const TextStyle(
                  color: Color(0xFFE8EFF7),
                  fontSize: 15,
                  height: 1.8,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildSocialIcon(Icons.facebook, settings.facebookUrl),
                  _buildSocialIcon(Icons.camera_alt, settings.instagramUrl),
                  _buildSocialIcon(Icons.share, settings.twitterUrl),
                  _buildSocialIcon(Icons.play_circle, settings.youtubeUrl),
                  _buildSocialIcon(Icons.business, settings.linkedinUrl),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 60),
        
        // Column 2: Quick Links
        Expanded(
          flex: 7,
          child: _buildFooterColumn(
            children: [
              _buildColumnTitle('Quick Links'),
              const SizedBox(height: 24),
              ..._buildLinks(['Home', 'About', 'Services', 'Blog', 'Gallery', 'Shop']),
            ],
          ),
        ),
        const SizedBox(width: 60),
        
        // Column 3: Contact Info
        Expanded(
          flex: 8,
          child: _buildFooterColumn(
            children: [
              _buildColumnTitle('Contact Info'),
              const SizedBox(height: 24),
              _buildContactItem(Icons.phone, settings.phone),
              const SizedBox(height: 18),
              _buildContactItem(Icons.email, settings.email),
              const SizedBox(height: 18),
              _buildLocationItem(
                title: 'Kasarani Sportsview\nNairobi, Kenya',
                url: settings.mapUrl ?? 'https://www.google.com/maps/search/?api=1&query=Kasarani%20Sportsview%2C%20Nairobi',
              ),
            ],
          ),
        ),
        const SizedBox(width: 60),
        
        // Column 4: Open Hours
        Expanded(
          flex: 8,
          child: _buildFooterColumn(
            children: [
              _buildColumnTitle('Business Hours'),
              const SizedBox(height: 24),
              _buildHoursItem('Monday - Friday', '9:00 AM - 6:00 PM'),
              const SizedBox(height: 14),
              _buildHoursItem('Saturday', '10:00 AM - 4:00 PM'),
              const SizedBox(height: 14),
              _buildHoursItem('Sunday', 'Closed'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileFooterContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // About Section
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              settings.siteName.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 3,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF5886BF), Color(0xFF4A6FA8)],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              settings.tagline,
              style: const TextStyle(
                color: Color(0xFFE8EFF7),
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        
        // Quick Links
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildColumnTitle('Quick Links'),
            const SizedBox(height: 16),
            ..._buildLinks(['Home', 'About', 'Services', 'Blog', 'Gallery', 'Shop']),
          ],
        ),
        const SizedBox(height: 32),
        
        // Contact Info
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildColumnTitle('Contact Info'),
            const SizedBox(height: 16),
            _buildContactItem(Icons.phone, settings.phone),
            const SizedBox(height: 14),
            _buildContactItem(Icons.email, settings.email),
            const SizedBox(height: 14),
            _buildLocationItem(
              title: 'Kasarani Sportsview, Nairobi',
              url: settings.mapUrl ?? 'https://www.google.com/maps/search/?api=1&query=Kasarani%20Sportsview%2C%20Nairobi',
            ),
          ],
        ),
        const SizedBox(height: 32),
        
        // Social Media
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildColumnTitle('Follow Us'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildSocialIcon(Icons.facebook, settings.facebookUrl),
                _buildSocialIcon(Icons.camera_alt, settings.instagramUrl),
                _buildSocialIcon(Icons.share, settings.twitterUrl),
                _buildSocialIcon(Icons.play_circle, settings.youtubeUrl),
                _buildSocialIcon(Icons.business, settings.linkedinUrl),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooterColumn({required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Widget _buildColumnTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      ),
    );
  }

  List<Widget> _buildLinks(List<String> links) {
    return links.map((link) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Semantics(
            button: true,
            child: GestureDetector(
              onTap: () {
                // TODO: Implement navigation
              },
              child: Text(
                link,
                style: const TextStyle(
                  color: Color(0xFFB0B8C1),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  height: 1.6,
                ),
              ),
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
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: const Color(0xFF5886BF).withOpacity(0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, color: const Color(0xFF5886BF), size: 14),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFFE8EFF7),
              fontSize: 15,
              fontWeight: FontWeight.w400,
              height: 1.5,
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
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: const Color(0xFF5886BF).withOpacity(0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(Icons.location_on, color: Color(0xFF5886BF), size: 14),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => _launchUrl(url),
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF5886BF),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                  decorationColor: Color(0xFF5886BF),
                  height: 1.5,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHoursItem(String day, String hours) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          day,
          style: const TextStyle(
            color: Color(0xFFB0B8C1),
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          hours,
          style: const TextStyle(
            color: Color(0xFF5886BF),
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon, String? url) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: url != null ? () => _launchUrl(url) : null,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF5886BF),
                Color(0xFF4A6FA8),
              ],
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF5886BF).withOpacity(0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }

  Widget _buildFooterLink(String text) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFB0B8C1),
          fontSize: 14,
          fontWeight: FontWeight.w400,
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
