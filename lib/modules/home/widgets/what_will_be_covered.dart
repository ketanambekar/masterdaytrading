import 'dart:ui';
import 'package:flutter/material.dart';

class WhatWillBeCoveredCard extends StatelessWidget {
  const WhatWillBeCoveredCard({super.key});

  final List<_CoveredItem> items = const [
    _CoveredItem(
      title: 'Version 0.009 Strategy',
      icon: Icons.track_changes,
      gradient: LinearGradient(colors: [Color(0xFF9C27B0), Color(0xFFE91E63)]),
      bullets: [
        'Proprietary intraday setup',
        '100-point target per trade',
        'Entry within 30 mins of open',
      ],
    ),
    _CoveredItem(
      title: 'Heineken Beer Strategy',
      icon: Icons.local_bar,
      gradient: LinearGradient(colors: [Color(0xFF00BCD4), Color(0xFF3F51B5)]),
      bullets: [
        'Catch major intraday moves (500+ pts)',
        'Enter before trend starts, exit precisely',
      ],
    ),
    _CoveredItem(
      title: 'Emotional Mastery',
      icon: Icons.psychology,
      gradient: LinearGradient(colors: [Color(0xFFFF5722), Color(0xFFF44336)]),
      bullets: [
        'Stay calm in volatile markets',
        'Stop revenge trading, lock in gains',
      ],
    ),
    _CoveredItem(
      title: 'Risk Management',
      icon: Icons.security,
      gradient: LinearGradient(colors: [Color(0xFF4CAF50), Color(0xFF388E3C)]),
      bullets: [
        'Shield your capital from big losses',
      ],
    ),
    _CoveredItem(
      title: 'Backtesting Results',
      icon: Icons.query_stats,
      gradient: LinearGradient(colors: [Color(0xFF2196F3), Color(0xFF3F51B5)]),
      bullets: [
        'October 2024 results analyzed',
        'How to validate any strategy',
      ],
    ),
    _CoveredItem(
      title: 'Live Q&A Zooms',
      icon: Icons.live_help,
      gradient: LinearGradient(colors: [Color(0xFFFFC107), Color(0xFFFF9800)]),
      bullets: [
        'Monthly live doubt-clearing sessions',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header
          Text(
            '🚀 What You Will Learn',
            style: TextStyle(
              fontSize: isMobile ? 24 : 30,
              fontWeight: FontWeight.w800,
              color: Colors.deepPurple.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 60,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade400,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 36),

          // Items with animation wrappers (future-ready)
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _CoveredBlock(item: item, isMobile: isMobile),
          )),

          const SizedBox(height: 40),
          _CTASection(isMobile: isMobile),
        ],
      ),
    );
  }
}

class _CoveredItem {
  final String title;
  final IconData icon;
  final List<String> bullets;
  final Gradient gradient;

  const _CoveredItem({
    required this.title,
    required this.icon,
    required this.bullets,
    required this.gradient,
  });
}

class _CoveredBlock extends StatelessWidget {
  final _CoveredItem item;
  final bool isMobile;

  const _CoveredBlock({required this.item, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: item.gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(item.icon, size: isMobile ? 28 : 34, color: Colors.white),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...item.bullets.map((b) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle, size: 16, color: Colors.white),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          b,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _CTASection extends StatelessWidget {
  final bool isMobile;

  const _CTASection({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [Colors.deepPurple.shade50, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.deepPurple.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.1),
            blurRadius: 24,
            offset: const Offset(0, 12),
          )
        ],
      ),
      child: Column(
        children: [
          Text(
            '🔥 Limited-Time Offer',
            style: TextStyle(
              fontSize: isMobile ? 20 : 22,
              fontWeight: FontWeight.w700,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: isMobile ? 24 : 28),
              children: const [
                TextSpan(
                  text: '₹7500 ',
                  style: TextStyle(
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                TextSpan(
                  text: ' ₹999',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: const Text(
              'Offer Ends in: 00:00 mins',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
