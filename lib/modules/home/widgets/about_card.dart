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
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 600;

      return Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
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
                    fontSize: isMobile ? 24 : 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 16,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 24),
                Divider(color: Colors.grey.shade300),
                const SizedBox(height: 12),

                // Sections
                isMobile
                    ? Column(
                  children: [
                    _infoSection(),
                    const SizedBox(height: 24),
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

                // CTA Button
                ShakeAnimationWidget(
                  child: ElevatedButton.icon(
                    onPressed: onBuy,
                    icon: const Icon(Icons.flash_on),
                    label: const Text("Buy Now"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 18,
                      ),
                      textStyle: const TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 8,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _infoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _infoRow(Icons.play_circle_fill_rounded, "Recorded Class", "Start Anytime"),
        _infoRow(Icons.live_tv_rounded, "Live Doubt Sessions", "Every Month"),
        _infoRow(Icons.language_rounded, "Language", "Hindi"),
        _infoRow(Icons.schedule_rounded, "Duration", "2+ hours"),
      ],
    );
  }

  Widget _priceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Unlock the Secret Strategies',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 20, fontFamily: 'Montserrat'),
            children: [
              TextSpan(
                text: '₹$pricingOld ',
                style: const TextStyle(
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              TextSpan(
                text: '₹$pricingNew',
                style: TextStyle(
                  color: Colors.green.shade700,
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
            color: Colors.red.shade600,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            'Offer Ends in: $countdown mins',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoRow(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: Colors.blueAccent),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: "$title: ",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 14,
                ),
                children: [
                  TextSpan(
                    text: subtitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black87,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
