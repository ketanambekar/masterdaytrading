import 'package:flutter/material.dart';

class MeetYourMentorCard extends StatelessWidget {
  const MeetYourMentorCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 6,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Meet Your Mentor',
                style: TextStyle(
                  fontSize: isMobile ? 20 : 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Umesh Bhandari',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 8),

              // Separator
              Container(
                height: 4,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 24),

              // Mentor Image
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  'https://media.licdn.com/dms/image/v2/D4D03AQFinXts4Hsh_Q/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1696345973511?e=2147483647&v=beta&t=wt520Utcpd8R284pRFTHKJZC4GWh-FM02D4YDACtwWk', // Replace with actual image URL
                  width: isMobile ? 120 : 150,
                  height: isMobile ? 120 : 150,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'Umesh Bhandari',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),

              // Tags/icons
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  _iconTag('https://media.istockphoto.com/id/2160537640/photo/robot-investment-monitoring-market-volatility-in-financial-market.webp?a=1&b=1&s=612x612&w=0&k=20&c=bAd18tMa22mxl6D01AYtjJnWlevTWAkHSBUOBXT7ScA='),
                  _iconTag('https://media.istockphoto.com/id/2192471037/photo/business-professional-interacting-with-ai-powered-analytics-through-a-digital-interface.jpg?s=1024x1024&w=is&k=20&c=2OSRW3rSN_rJfsBRFCirqCcXRO11L0b3DFjYoHDwSmg='),
                  _iconTag('https://media.istockphoto.com/id/2160537640/photo/robot-investment-monitoring-market-volatility-in-financial-market.webp?a=1&b=1&s=612x612&w=0&k=20&c=bAd18tMa22mxl6D01AYtjJnWlevTWAkHSBUOBXT7ScA='),
                ],
              ),
              const SizedBox(height: 20),

              // Bio
              const Text(
                'Umesh Bhandari, a SEBI-registered Investment Advisor and Research Analyst, has been in the stock market since 2020. '
                    'After losing crores in the market, he developed these unique strategies through hard-earned experience.\n\n'
                    'Despite people being willing to pay lakhs for his strategies, he never revealed them until now. Upon popular demand, '
                    'he decided to make this knowledge accessible to everyone at an affordable price.\n\n'
                    'Now, you have the chance to learn these proven strategies built on years of mistakes and hard work.',
                style: TextStyle(fontSize: 15, color: Colors.black87, height: 1.5),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconTag(String imageUrl) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.deepPurple.shade100),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Image.network(
        imageUrl,
        height: 32,
        width: 32,
        fit: BoxFit.contain,
      ),
    );
  }
}
