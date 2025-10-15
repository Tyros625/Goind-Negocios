import 'dart:ui';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:video_player/video_player.dart';

class NetworkVideoPreviewWidget extends StatefulWidget {
  final String videoFile;
  const NetworkVideoPreviewWidget({super.key, required this.videoFile});

  @override
  State<NetworkVideoPreviewWidget> createState() => _NetworkVideoPreviewWidgetState();
}

class _NetworkVideoPreviewWidgetState extends State<NetworkVideoPreviewWidget> {
  late VideoPlayerController _controller;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoFile))
      ..initialize().then(
        (_) => setState(
          () => _chewieController = ChewieController(
            videoPlayerController: _controller,
            autoInitialize: true,
            aspectRatio: _controller.value.aspectRatio,
          ),
        ),
      );
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized ? SizedBox(
      height: 220,
      child: Stack(alignment: Alignment.center, children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            child: VideoPlayer(_controller),
          ),
        ),

        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
            child: Container(
              color: Colors.black.withValues(alpha: 0.85),
            ),
          ),
        ),

        ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          child: Chewie(controller: _chewieController),
        ),
      ]),
    ) : SizedBox(
      height: 220,
      child: Shimmer(
        duration: const Duration(seconds: 2),
        child: Container(
          width: Get.width,
          decoration: BoxDecoration(
            color: Get.isDarkMode ? Colors.grey.shade700 : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
          ),
        ),
      ),
    );
  }
}
