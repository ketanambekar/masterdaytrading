import 'package:flutter/material.dart';

class MasterclassTopicsCard extends StatelessWidget {
  const MasterclassTopicsCard({super.key});

  final String title = "What’s Covered in Recorded Index Options Masterclass";
  final List<String> topics = const [
    "How to achieve Big targets in intraday trading, specifically for index options",
    "Master 2 Unique strategies – Version 0.09 and Heneiken Beer Strategy",
    "How to Control your Emotions to achieve consistent profits",
    "How ₹1,00,000 capital turned into ₹7,24,500 in October 2024 backtesting",
    "Learn how to take Entries within 30 minutes of market opening",
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
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SVG Icon + Title Row
              Row(
                children: [
                Icon(Icons.live_tv),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Bullet Points
              ...topics.map((point) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("• ",
                        style: TextStyle(
                            fontSize: 18, color: Colors.blueAccent)),
                    Expanded(
                      child: Text(
                        point,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.4,
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
