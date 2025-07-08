import 'package:flutter/material.dart';

class MasterclassBenefitsCard extends StatelessWidget {
  const MasterclassBenefitsCard({super.key});

  final String title = "This Masterclass is for You if...";
  final List<String> benefits = const [
    "You aim to achieve a minimum 100 points target daily in intraday.",
    "You want to enter trades before a trend begins and exit when the trend ends.",
    "You prefer quick entries within 30 minutes of market opening.",
    "You value calculated trading over high-risk gambling.",
    "You want to learn emotional control for consistent profits.",
    "You’re ready to start your trading journey with proven, unique strategies.",
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
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
                  color: Colors.indigo,
                ),
              ),

              const SizedBox(height: 12),

              // Decorative Separator
              Container(
                width: 60,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const SizedBox(height: 20),

              // Bullet List
              ...benefits.map((text) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("✓ ",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        )),
                    Expanded(
                      child: Text(
                        text,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
