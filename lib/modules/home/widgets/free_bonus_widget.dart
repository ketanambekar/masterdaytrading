import 'package:flutter/material.dart';

class FreeBonusesCard extends StatelessWidget {
  const FreeBonusesCard({super.key});

  final List<_Bonus> bonuses = const [
    _Bonus(
      imageUrl: 'https://media.istockphoto.com/id/2160537640/photo/robot-investment-monitoring-market-volatility-in-financial-market.webp?a=1&b=1&s=612x612&w=0&k=20&c=bAd18tMa22mxl6D01AYtjJnWlevTWAkHSBUOBXT7ScA=',
      number: 'BONUS 01',
      title: 'Private WhatsApp Community',
      description: 'Access to a private group with educational content and live session links.',
    ),
    _Bonus(
      imageUrl: 'https://media.istockphoto.com/id/2192471037/photo/business-professional-interacting-with-ai-powered-analytics-through-a-digital-interface.jpg?s=1024x1024&w=is&k=20&c=2OSRW3rSN_rJfsBRFCirqCcXRO11L0b3DFjYoHDwSmg=',
      number: 'BONUS 02',
      title: 'Live Sessions with Chetan Sir',
      description: 'Monthly live Zoom session to clarify doubts',
    ),
    _Bonus(
      imageUrl: 'https://media.istockphoto.com/id/878460096/photo/using-a-smartphone-and-pc-to-look-at-financial-data.jpg?s=1024x1024&w=is&k=20&c=Rs7WdnL1yf2SYH3uDvw-Zp4cy36BeVF9CeIl6ig1xV4=',
      number: 'BONUS 03',
      title: 'Discount on Upcoming Courses',
      description: 'Exclusive discounts for advanced courses',
    ),
    _Bonus(
      imageUrl: 'https://media.istockphoto.com/id/2160537640/photo/robot-investment-monitoring-market-volatility-in-financial-market.webp?a=1&b=1&s=612x612&w=0&k=20&c=bAd18tMa22mxl6D01AYtjJnWlevTWAkHSBUOBXT7ScA=',
      number: 'BONUS 04',
      title: 'Lifetime Access',
      description: 'Lifetime updates to course content and resources',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Get FREE Bonuses',
                style: TextStyle(
                  fontSize: isMobile ? 18 : 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Which is Priceless',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 10),
              Container(
                height: 4,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),

              // Bonus cards
              ...bonuses.map((bonus) => _BonusCard(bonus: bonus)),

              const SizedBox(height: 24),

              // CTA
              Center(
                child: Column(
                  children: [
                    const Text(
                      'Get Instant Access @',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 6),
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(fontSize: 20),
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
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Offer Ends in: 00:00 mins',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bonus Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              bonus.imageUrl,
              width: isMobile ? 60 : 80,
              height: isMobile ? 60 : 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),

          // Bonus Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bonus.number,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  bonus.title,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  bonus.description,
                  style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.4),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Free',
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
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
