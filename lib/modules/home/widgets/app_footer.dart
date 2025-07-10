import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      color: Colors.grey.shade100,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Brand Name
          Text(
            "📈 Master Day Trading",
            style: TextStyle(
              fontSize: isMobile ? 20 : 24,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),

          const SizedBox(height: 12),

          // Social Media Icons
          Wrap(
            spacing: 20,
            alignment: WrapAlignment.center,
            children: [
              IconButton(
                onPressed: () {},
                icon: const FaIcon(FontAwesomeIcons.instagram),
                tooltip: 'Instagram',
              ),
              IconButton(
                onPressed: () {},
                icon: const FaIcon(FontAwesomeIcons.twitter),
                tooltip: 'Twitter',
              ),
              IconButton(
                onPressed: () {},
                icon: const FaIcon(FontAwesomeIcons.youtube),
                tooltip: 'YouTube',
              ),
              IconButton(
                onPressed: () {},
                icon: const FaIcon(FontAwesomeIcons.linkedin),
                tooltip: 'LinkedIn',
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Disclaimer
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Text(
              'Disclaimer: The information provided is for educational purposes only and should not be construed as investment advice. '
              'We make no warranties or representations, express or implied, on products and services offered through the platform. '
              'Past performance is not indicative of future returns. Please consider your specific investment requirements, risk tolerance, '
              'goal, investment time frame, and the cost associated before investing. Investments are subject to market risks.',
              style: TextStyle(
                fontSize: isMobile ? 12 : 14,
                color: Colors.black87,
                height: 1.5,
              ),
              textAlign: TextAlign.justify,
            ),
          ),

          const SizedBox(height: 28),

          // Contact Info + Legal
          Column(
            children: [
              Text(
                '📧 course@masterdaytrading.com',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '© 2025 Master Day Trading Pvt. Ltd.',
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              InkWell(
                onTap: () {
                  // Add your privacy policy navigation
                },
                child: const Text(
                  'Privacy Policy',
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 13,
                    decoration: TextDecoration.underline,
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
