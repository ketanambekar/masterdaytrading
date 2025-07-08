import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FullScreenVideoBackground extends StatefulWidget {
  final String videoUrl;
  final Widget? overlayContent;

  const FullScreenVideoBackground({
    super.key,
    required this.videoUrl,
    this.overlayContent,
  });

  @override
  State<FullScreenVideoBackground> createState() => _FullScreenVideoBackgroundState();
}

class _FullScreenVideoBackgroundState extends State<FullScreenVideoBackground> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        _controller.setLooping(true);
        _controller.setVolume(0);
        _controller.play();
        setState(() => _isInitialized = true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isInitialized
        ? Stack(
      children: [
        SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _controller.value.size.width,
              height: _controller.value.size.height,
              child: VideoPlayer(_controller),
            ),
          ),
        ),
        if (widget.overlayContent != null)
          Positioned.fill(
            child: Container(
              alignment: Alignment.center,
              child: widget.overlayContent,
            ),
          ),
      ],
    )
        : const Center(child: CircularProgressIndicator());
  }
}
