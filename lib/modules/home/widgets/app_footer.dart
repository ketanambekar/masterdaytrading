import 'package:flutter/material.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      color: Colors.grey.shade100,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Logo or Title
          Text(
            "Master Day Trading",
            style: TextStyle(
              fontSize: isMobile ? 18 : 22,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),

          const SizedBox(height: 16),

          // Disclaimer Text
          Text(
            'Disclaimer: The information provided is for educational purposes only and should not be construed as investment advice. '
                'We make no warranties or representations, express or implied, on products and services offered through the platform. '
                'Past performance is not indicative of future returns. Please consider your specific investment requirements, risk tolerance, '
                'goal, investment time frame, risk and reward as well as the cost associated with the investment before investing, or designing a portfolio '
                'that suits your needs. Performance and returns of any investment portfolio can neither be predicted nor guaranteed. '
                'Investments in securities markets are subject to market risks. Read all related documents carefully before investing.',
            style: TextStyle(
              fontSize: isMobile ? 12 : 14,
              color: Colors.black87,
              height: 1.4,
            ),
            textAlign: TextAlign.justify,
          ),

          const SizedBox(height: 24),

          // Contact and Rights
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '📧 course@masterdaytrading.com',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Text(
                '© 2025 Master Day Trading Private Limited',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              InkWell(
                onTap: () {
                  // handle privacy tap
                },
                child: const Text(
                  'Privacy Policy',
                  style: TextStyle(
                    color: Colors.blueAccent,
                    decoration: TextDecoration.underline,
                    fontSize: 13,
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
