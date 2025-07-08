import 'package:flutter/material.dart';

class WhatWillBeCoveredCard extends StatelessWidget {
  const WhatWillBeCoveredCard({super.key});

  final List<_CoveredItem> items = const [
    _CoveredItem(
      imageUrl: 'https://media.istockphoto.com/id/2160537640/photo/robot-investment-monitoring-market-volatility-in-financial-market.webp?a=1&b=1&s=612x612&w=0&k=20&c=bAd18tMa22mxl6D01AYtjJnWlevTWAkHSBUOBXT7ScA=',
      title: 'Version 0.009 Strategy',
      bullets: [
        'My unique trading Strategy',
        '100 Points Target in Intraday',
        'Entry within 30 Min of Market opening',
      ],
    ),
    _CoveredItem(
      imageUrl: 'https://media.istockphoto.com/id/2192471037/photo/business-professional-interacting-with-ai-powered-analytics-through-a-digital-interface.jpg?s=1024x1024&w=is&k=20&c=2OSRW3rSN_rJfsBRFCirqCcXRO11L0b3DFjYoHDwSmg=',
      title: 'Heneiken Beer Strategy',
      bullets: [
        'For high intraday gains (500 points targets)',
        'Trend Entry/Exit: Enter before trends, exit as they end',
      ],
    ),
    _CoveredItem(
      imageUrl: 'https://media.istockphoto.com/id/2160537640/photo/robot-investment-monitoring-market-volatility-in-financial-market.webp?a=1&b=1&s=612x612&w=0&k=20&c=bAd18tMa22mxl6D01AYtjJnWlevTWAkHSBUOBXT7ScA=',
      title: 'Emotion Control',
      bullets: [
        'How to control your emotions in market hours',
        'How to Stop Over Trading and End your day with Profit',
      ],
    ),
    _CoveredItem(
      imageUrl: 'https://media.istockphoto.com/id/878460096/photo/using-a-smartphone-and-pc-to-look-at-financial-data.jpg?s=1024x1024&w=is&k=20&c=Rs7WdnL1yf2SYH3uDvw-Zp4cy36BeVF9CeIl6ig1xV4=',
      title: 'Risk Management',
      bullets: [
        'Learn to protect your capital',
      ],
    ),
    _CoveredItem(
      imageUrl: 'https://media.istockphoto.com/id/2160537640/photo/robot-investment-monitoring-market-volatility-in-financial-market.webp?a=1&b=1&s=612x612&w=0&k=20&c=bAd18tMa22mxl6D01AYtjJnWlevTWAkHSBUOBXT7ScA=',
      title: 'Backtesting',
      bullets: [
        'Results for the entire October 2024 month',
      ],
    ),
    _CoveredItem(
      imageUrl: 'https://media.istockphoto.com/id/2160537640/photo/robot-investment-monitoring-market-volatility-in-financial-market.webp?a=1&b=1&s=612x612&w=0&k=20&c=bAd18tMa22mxl6D01AYtjJnWlevTWAkHSBUOBXT7ScA=',
      title: 'Live Doubt-Clearing Sessions',
      bullets: [
        'Monthly Zoom meetings to address your queries',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What Will Be Covered?',
                style: TextStyle(
                  fontSize: isMobile ? 18 : 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 4,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),

              // Grid/List of Topics
              ...items.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: _CoveredBlock(item: e),
              )),

              const SizedBox(height: 20),

              // CTA
              Center(
                child: Column(
                  children: [
                    const Text(
                      'Start Learning today @',
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
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(20),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _CoveredItem {
  final String imageUrl;
  final String title;
  final List<String> bullets;

  const _CoveredItem({
    required this.imageUrl,
    required this.title,
    required this.bullets,
  });
}

class _CoveredBlock extends StatelessWidget {
  final _CoveredItem item;

  const _CoveredBlock({required this.item});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            item.imageUrl,
            width: isMobile ? 60 : 80,
            height: isMobile ? 60 : 80,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 14),

        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              ...item.bullets.map(
                    (b) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "• ",
                        style: TextStyle(fontSize: 14),
                      ),
                      Expanded(
                        child: Text(
                          b,
                          style: const TextStyle(fontSize: 14, height: 1.3),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
