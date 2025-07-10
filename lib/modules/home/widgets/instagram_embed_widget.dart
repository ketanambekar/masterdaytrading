import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InstagramPostWidget extends StatelessWidget {
  final String imageUrl;
  final String postUrl;

  const InstagramPostWidget({
    super.key,
    required this.imageUrl,
    required this.postUrl,
  });

  void _launchInstagram() async {
    final uri = Uri.parse(postUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $postUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _launchInstagram,
      child: AspectRatio(
        aspectRatio: 1,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          clipBehavior: Clip.antiAlias,
          elevation: 5,
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Positioned.fill(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Center(child: Icon(Icons.broken_image)),
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
              Container(
                width: double.infinity,
                color: Colors.black.withOpacity(0.5),
                padding: const EdgeInsets.all(12),
                child: const Text(
                  'View on Instagram',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
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

class InstagramEmbedWidget extends StatelessWidget {
  const InstagramEmbedWidget({super.key});

  final List<Map<String, String>> posts = const [
    {
      "imageUrl": "https://www.shutterstock.com/shutterstock/photos/2453447349/display_1500/stock-photo-investors-analyze-the-data-stock-market-index-via-smartphone-screen-to-trade-the-stock-chart-for-2453447349.jpg",
      "postUrl": "https://www.instagram.com/p/abc123/"
    },
    {
      "imageUrl": "https://www.shutterstock.com/shutterstock/photos/2453447349/display_1500/stock-photo-investors-analyze-the-data-stock-market-index-via-smartphone-screen-to-trade-the-stock-chart-for-2453447349.jpg",
      "postUrl": "https://www.instagram.com/p/def456/"
    },
    {
      "imageUrl": "https://www.shutterstock.com/shutterstock/photos/2453447349/display_1500/stock-photo-investors-analyze-the-data-stock-market-index-via-smartphone-screen-to-trade-the-stock-chart-for-2453447349.jpg",
      "postUrl": "https://www.instagram.com/p/ghi789/"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      int columns = 1;
      if (constraints.maxWidth > 1000) {
        columns = 4;
      } else if (constraints.maxWidth > 700) {
        columns = 3;
      } else if (constraints.maxWidth > 500) {
        columns = 2;
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: posts.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final post = posts[index];
            return InstagramPostWidget(
              imageUrl: post['imageUrl']!,
              postUrl: post['postUrl']!,
            );
          },
        ),
      );
    });
  }
}
