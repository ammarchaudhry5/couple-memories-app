import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../controller/utils/theme/app_theme.dart';

class VideoThumbnailWidget extends StatelessWidget {
  final String videoPath;
  final BoxFit fit;

  const VideoThumbnailWidget({
    Key? key,
    required this.videoPath,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<VideoPlayerController>(
      future: _initializeVideoThumbnail(videoPath),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData &&
            snapshot.data!.value.isInitialized) {
          return VideoPlayer(snapshot.data!);
        }
        return Container(
          color: Colors.grey[300],
          child: Center(
            child: CircularProgressIndicator(
              color: AppTheme.primaryColor,
            ),
          ),
        );
      },
    );
  }

  Future<VideoPlayerController> _initializeVideoThumbnail(String path) async {
    try {
      final controller = VideoPlayerController.file(File(path));
      await controller.initialize().timeout(
        const Duration(seconds: 3),
        onTimeout: () {
          controller.dispose();
          throw TimeoutException('Video thumbnail timeout');
        },
      );
      if (controller.value.isInitialized) {
        await controller.setLooping(false);
        await controller.pause();
        await controller.setVolume(0.0);
      }
      return controller;
    } catch (e) {
      final dummyController = VideoPlayerController.file(File(path));
      return dummyController;
    }
  }
}
