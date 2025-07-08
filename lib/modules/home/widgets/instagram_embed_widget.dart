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
    if (await canLaunchUrl(Uri.parse(postUrl))) {
      await launchUrl(Uri.parse(postUrl), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $postUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _launchInstagram,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        elevation: 5,
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Image.network(imageUrl, fit: BoxFit.cover, height: 250, width: 250),
            Container(
              color: Colors.black.withOpacity(0.5),
              padding: const EdgeInsets.all(12),
              child: const Text(
                'View on Instagram',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
