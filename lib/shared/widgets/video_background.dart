import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'net_image.dart';

/// Muted, looping, cover-fit background video with an image poster that
/// remains if the stream cannot initialise (slow networks, blocked CDNs).
class VideoBackground extends StatefulWidget {
  const VideoBackground({
    super.key,
    required this.videoUrl,
    required this.posterUrl,
  });

  final String videoUrl;
  final String posterUrl;

  @override
  State<VideoBackground> createState() => _VideoBackgroundState();
}

class _VideoBackgroundState extends State<VideoBackground> {
  VideoPlayerController? _controller;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    if (widget.videoUrl.isEmpty) return;
    final controller =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    _controller = controller;
    try {
      await controller.initialize();
      await controller.setVolume(0);
      await controller.setLooping(true);
      await controller.play();
      if (mounted) setState(() => _ready = true);
    } catch (_) {
      // Poster image carries the scene instead.
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    return Stack(
      fit: StackFit.expand,
      children: [
        NetImage(widget.posterUrl),
        if (_ready && controller != null)
          AnimatedOpacity(
            opacity: 1,
            duration: const Duration(milliseconds: 900),
            child: FittedBox(
              fit: BoxFit.cover,
              clipBehavior: Clip.hardEdge,
              child: SizedBox(
                width: controller.value.size.width,
                height: controller.value.size.height,
                child: VideoPlayer(controller),
              ),
            ),
          ),
      ],
    );
  }
}
