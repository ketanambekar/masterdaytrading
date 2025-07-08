import 'package:flutter/material.dart';
import 'package:masterdaytrading/annimations/effects/shake_effect.dart';

class WhyJoinMasterclassCard extends StatelessWidget {
  const WhyJoinMasterclassCard({super.key});

  final String title = "Why Join This Masterclass?";
  final String imageUrl =
      'https://media.istockphoto.com/id/2160537640/photo/robot-investment-monitoring-market-volatility-in-financial-market.webp?a=1&b=1&s=612x612&w=0&k=20&c=bAd18tMa22mxl6D01AYtjJnWlevTWAkHSBUOBXT7ScA='; // replace with actual
  final List<String> points = const [
    "Proven Strategies: Backtested results from October 2024 where ₹1 lakh turned into ₹7.24 lakh.",
    "Big Target, Small Stop Loss: Learn strategies that target 100+ points daily in intraday trading.",
    "Time-Efficient: Take trades within 30 minutes without sitting in front of the screen all day.",
    "Emotion Control: Master controlling your emotions to maintain consistency.",
    "Live Interaction: Monthly live Zoom sessions to clear your doubts.",
    "Flexible Learning: Access recorded classes and learn at your own pace.",
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                title,
                style: TextStyle(
                  fontSize: isMobile ? 18 : 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),

              const SizedBox(height: 10),

              // Separator
              Container(
                width: 60,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const SizedBox(height: 20),

              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  height: isMobile ? 180 : 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 20),

              // Bullet Points
              ...points.map(
                    (text) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "✔ ",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          text,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Price & Timer
              Center(
                child: Column(
                  children: [
                    const Text(
                      'Join Now today for',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
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
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
              ),

              const SizedBox(height: 20),

              // CTA Button
              ShakeAnimationWidget(
                child: Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // handle CTA
                    },
                    icon: const Icon(Icons.lock_open),
                    label: const Text("Join Now"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
