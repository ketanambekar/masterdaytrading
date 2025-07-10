import 'package:flutter/material.dart';
import 'dart:ui';

class FreeBonusesCard extends StatelessWidget {
  const FreeBonusesCard({super.key});

  final List<_Bonus> bonuses = const [
    _Bonus(
      imageUrl: 'https://www.shutterstock.com/shutterstock/photos/2453447349/display_1500/stock-photo-investors-analyze-the-data-stock-market-index-via-smartphone-screen-to-trade-the-stock-chart-for-2453447349.jpg',
      number: 'BONUS 01',
      title: 'Private WhatsApp Community',
      description: 'Access to a private group with educational content and live session links.',
    ),
    _Bonus(
      imageUrl: 'https://www.shutterstock.com/shutterstock/photos/2453447349/display_1500/stock-photo-investors-analyze-the-data-stock-market-index-via-smartphone-screen-to-trade-the-stock-chart-for-2453447349.jpg',
      number: 'BONUS 02',
      title: 'Live Sessions with Chetan Sir',
      description: 'Monthly live Zoom session to clarify doubts.',
    ),
    _Bonus(
      imageUrl: 'https://www.shutterstock.com/shutterstock/photos/2453447349/display_1500/stock-photo-investors-analyze-the-data-stock-market-index-via-smartphone-screen-to-trade-the-stock-chart-for-2453447349.jpg',
      number: 'BONUS 03',
      title: 'Discount on Upcoming Courses',
      description: 'Exclusive discounts for advanced courses.',
    ),
    _Bonus(
      imageUrl: 'https://www.shutterstock.com/shutterstock/photos/2453447349/display_1500/stock-photo-investors-analyze-the-data-stock-market-index-via-smartphone-screen-to-trade-the-stock-chart-for-2453447349.jpg',
      number: 'BONUS 04',
      title: 'Lifetime Access',
      description: 'Lifetime updates to course content and resources.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 850),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple.shade700.withOpacity(0.6), Colors.black.withOpacity(0.3)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 25,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🎁 Get FREE Bonuses',
                      style: TextStyle(
                        fontSize: isMobile ? 20 : 26,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Unlock premium perks valued beyond money.',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Bonus Cards
                    ...bonuses.map((bonus) => _BonusCard(bonus: bonus)),

                    const SizedBox(height: 32),

                    // CTA
                    Center(
                      child: Column(
                        children: [
                          const Text(
                            'Get Instant Access @',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          RichText(
                            text: const TextSpan(
                              style: TextStyle(fontSize: 22),
                              children: [
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
                                    color: Colors.greenAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Colors.redAccent, Colors.orange],
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Text(
                              '⏰ Offer Ends in: 00:00 mins',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Bonus {
  final String imageUrl;
  final String number;
  final String title;
  final String description;

  const _Bonus({
    required this.imageUrl,
    required this.number,
    required this.title,
    required this.description,
  });
}

class _BonusCard extends StatelessWidget {
  final _Bonus bonus;

  const _BonusCard({required this.bonus});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with gradient overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Stack(
                children: [
                  Image.network(
                    bonus.imageUrl,
                    width: isMobile ? 60 : 80,
                    height: isMobile ? 60 : 80,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    width: isMobile ? 60 : 80,
                    height: isMobile ? 60 : 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: LinearGradient(
                        colors: [Colors.black.withOpacity(0.25), Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bonus.number,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.amberAccent,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  bonus.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  bonus.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'Free',
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
