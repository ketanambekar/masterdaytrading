import 'package:flutter/material.dart';
import 'package:masterdaytrading/annimations/effects/shake_effect.dart';

class AboutCard extends StatelessWidget {
  final String name;
  final String title;
  final String imageUrl;
  final String pricingOld;
  final String pricingNew;
  final String countdown;
  final VoidCallback onBuy;

  const AboutCard({
    super.key,
    required this.name,
    required this.title,
    required this.imageUrl,
    required this.pricingOld,
    required this.pricingNew,
    required this.countdown,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Image
                  CircleAvatar(
                    radius: isMobile ? 50 : 70,
                    backgroundImage: NetworkImage(imageUrl),
                  ),
                  const SizedBox(height: 16),

                  // Name and Title
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: isMobile ? 22 : 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isMobile ? 14 : 16,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Divider(color: Colors.grey.shade300),
                  const SizedBox(height: 12),

                  isMobile
                      ? Column(
                    children: [
                      _infoSection(),
                      const SizedBox(height: 20),
                      _priceSection(),
                    ],
                  )
                      : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _infoSection()),
                      const SizedBox(width: 40),
                      Expanded(child: _priceSection()),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Shake Buy Button
                  ShakeAnimationWidget(
                    child: ElevatedButton.icon(
                      onPressed: onBuy,
                      icon: const Icon(Icons.shopping_cart),
                      label: const Text("Buy Now"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 18,
                        ),
                        textStyle: const TextStyle(fontSize: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _infoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _infoRow(Icons.play_circle_fill, "Recorded", "Start Anytime"),
        _infoRow(Icons.live_tv, "Live Doubt Session", "Every Month"),
        _infoRow(Icons.language, "Language", "Hindi"),
        _infoRow(Icons.schedule, "Duration", "2+ hrs"),
      ],
    );
  }

  Widget _priceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Unlock the Secret Strategies',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 6),
        RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 20),
            children: [
              TextSpan(
                text: '$pricingOld ',
                style: const TextStyle(
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              TextSpan(
                text: ' ₹$pricingNew',
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Offer Ends in: $countdown mins',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoRow(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blueGrey),
          const SizedBox(width: 10),
          Text(
            '$title: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(subtitle),
        ],
      ),
    );
  }
}
