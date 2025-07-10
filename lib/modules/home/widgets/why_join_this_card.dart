import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:masterdaytrading/annimations/effects/shake_effect.dart';
import 'package:masterdaytrading/services/buy_now/check_out_pop_up.dart';

class WhyJoinMasterclassCard extends StatelessWidget {
  const WhyJoinMasterclassCard({super.key});

  final String title = "Why Join This Masterclass?";
  final String imageUrl =
      'https://media.istockphoto.com/id/2160537640/photo/robot-investment-monitoring-market-volatility-in-financial-market.webp?a=1&b=1&s=612x612&w=0&k=20&c=bAd18tMa22mxl6D01AYtjJnWlevTWAkHSBUOBXT7ScA=';

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

    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      padding: const EdgeInsets.all(16),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(28),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              colors: [Colors.white, Colors.deepPurple.shade50],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withOpacity(0.1),
                blurRadius: 30,
                offset: const Offset(0, 20),
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: isMobile ? 22 : 26,
                        fontWeight: FontWeight.w800,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Container(
                      width: 70,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        imageUrl,
                        height: isMobile ? 180 : 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Bullet Points with fade/slide animation
                    ...points.map((point) {
                      return AnimatedSlide(
                        duration: const Duration(milliseconds: 500),
                        offset: const Offset(0, 0.1),
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 500),
                          opacity: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.check_circle_outline_rounded,
                                    color: Colors.green.shade600, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    point,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      height: 1.6,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),

                    const SizedBox(height: 26),

                    // Price & Timer
                    Center(
                      child: Column(
                        children: [
                          const Text(
                            'Join Today for',
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
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

                    const SizedBox(height: 28),

                    // CTA Button
                    ShakeAnimationWidget(
                      child: Center(
                        child: ElevatedButton.icon(
                          onPressed: showCheckoutSheet,
                          icon: const Icon(Icons.lock_open_rounded, color: Colors.white),
                          label: const Text("Join Now", style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                            elevation: 10,
                          ),
                        ),
                      ),
                    )
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
