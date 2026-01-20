import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:video_player/video_player.dart';
import 'package:photo_view/photo_view.dart';
import 'package:chewie/chewie.dart';
import 'package:yaaram/model/media_file_model/media_file_model.dart';

import '../../controller/utils/theme/app_theme.dart';

class MediaGalleryWidget extends StatelessWidget {
  final List<MediaFile> mediaFiles;
  final bool showDeleteButton;
  final Function(int)? onDelete;

  const MediaGalleryWidget({
    Key? key,
    required this.mediaFiles,
    this.showDeleteButton = false,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (mediaFiles.isEmpty) {
      return const SizedBox.shrink();
    }

    if (mediaFiles.length == 1) {
      return _buildSingleMedia(mediaFiles.first, 0);
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: mediaFiles.length <= 2 ? 2 : 3,
        crossAxisSpacing: 2.w,
        mainAxisSpacing: 2.w,
        childAspectRatio: 1,
      ),
      itemCount: mediaFiles.length,
      itemBuilder: (context, index) {
        return _buildMediaItem(mediaFiles[index], index);
      },
    );
  }

  Widget _buildSingleMedia(MediaFile media, int index) {
    return GestureDetector(
      onTap: () => _openMediaViewer(media, index),
      child: Container(
        height: 25.h,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.radiusXL),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.2),
              blurRadius: 10,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.radiusXL),
          child: media.isImage
              ? Image.file(
                  File(media.path),
                  fit: BoxFit.cover,
                )
              : _buildVideoThumbnail(media.path),
        ),
      ),
    );
  }

  Widget _buildMediaItem(MediaFile media, int index) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => _openMediaViewer(media, index),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              child: media.isImage
                  ? Image.file(
                      File(media.path),
                      fit: BoxFit.cover,
                    )
                  : _buildVideoThumbnail(media.path),
            ),
          ),
        ),
        if (media.isVideo)
          Positioned.fill(
            child: Center(
              child: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 6.w,
                ),
              ),
            ),
          ),
        if (showDeleteButton && onDelete != null)
          Positioned(
            top: 1.h,
            right: 2.w,
            child: GestureDetector(
              onTap: () => onDelete!(index),
              child: Container(
                padding: EdgeInsets.all(1.5.w),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 4.w,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildVideoThumbnail(String videoPath) {
    return Container(
      color: Colors.grey[300],
      child: Stack(
        fit: StackFit.expand,
        children: [
          FutureBuilder<VideoPlayerController>(
            future: _initializeVideoController(videoPath),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                try {
                  final controller = snapshot.data!;
                  if (controller.value.isInitialized) {
                    return VideoPlayer(controller);
                  }
                } catch (e) {
                  print('Video player error: $e');
                }
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
          ),
          Container(
            color: Colors.black.withOpacity(0.2),
          ),
        ],
      ),
    );
  }

  Future<VideoPlayerController> _initializeVideoController(String path) async {
    try {
      final controller = VideoPlayerController.file(File(path));
      await controller.initialize().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw TimeoutException('Video initialization timeout');
        },
      );
      if (controller.value.isInitialized) {
        await controller.setLooping(false);
        await controller.pause();
        await controller.setVolume(0.0); // Mute thumbnail
      }
      return controller;
    } catch (e) {
      print('Error initializing video: $e');
      // Return a dummy controller that won't be used
      final dummyController = VideoPlayerController.file(File(path));
      return dummyController;
    }
  }

  void _openMediaViewer(MediaFile media, int currentIndex) {
    Get.to(
      () => MediaViewerScreen(
        mediaFiles: mediaFiles,
        initialIndex: currentIndex,
      ),
      transition: Transition.fadeIn,
    );
  }
}

class MediaViewerScreen extends StatefulWidget {
  final List<MediaFile> mediaFiles;
  final int initialIndex;

  const MediaViewerScreen({
    Key? key,
    required this.mediaFiles,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  State<MediaViewerScreen> createState() => _MediaViewerScreenState();
}

class _MediaViewerScreenState extends State<MediaViewerScreen> {
  late PageController _pageController;
  late int _currentIndex;
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    _initializeMedia(widget.mediaFiles[_currentIndex]);
  }

  Future<void> _initializeMedia(MediaFile media) async {
    // Dispose previous controllers first
    await _disposeControllers();

    if (media.isVideo) {
      try {
        final file = File(media.path);
        if (!await file.exists()) {
          if (mounted) {
            setState(() {});
          }
          return;
        }

        _videoController = VideoPlayerController.file(file);
        
        await _videoController!.initialize().timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            _videoController?.dispose();
            _videoController = null;
            throw TimeoutException('Video initialization timeout');
          },
        );

        if (!mounted) {
          await _videoController?.dispose();
          _videoController = null;
          return;
        }

        if (_videoController != null && _videoController!.value.isInitialized) {
          try {
            _chewieController = ChewieController(
              videoPlayerController: _videoController!,
              autoPlay: false, // Don't autoplay to avoid codec issues
              looping: false,
              aspectRatio: _videoController!.value.aspectRatio,
              showControls: true,
              showControlsOnInitialize: true,
              allowFullScreen: true,
              allowMuting: true,
              allowPlaybackSpeedChanging: false,
              materialProgressColors: ChewieProgressColors(
                playedColor: AppTheme.secondaryColor,
                handleColor: AppTheme.secondaryColor,
                backgroundColor: Colors.grey,
                bufferedColor: Colors.grey.shade300,
              ),
              errorBuilder: (context, errorMessage) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(5.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.videocam_off, color: Colors.white70, size: 10.w),
                        SizedBox(height: 2.h),
                        Text(
                          'Unable to play this video',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: AppTheme.fontSizeLarge.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'This video format may not be supported on this device.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: AppTheme.fontSizeMedium.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 2.h),
                        TextButton.icon(
                          onPressed: () {
                            _disposeControllers();
                            _initializeMedia(media);
                          },
                          icon: Icon(Icons.refresh, color: Colors.white),
                          label: Text(
                            'Try Again',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.2),
                            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
            
            if (mounted) {
              setState(() {});
            }
          } catch (e) {
            print('Error creating Chewie controller: $e');
            await _videoController?.dispose();
            _videoController = null;
            if (mounted) {
              setState(() {});
            }
          }
        }
      } catch (e) {
        print('Error initializing video: $e');
        await _videoController?.dispose();
        _videoController = null;
        if (mounted) {
          setState(() {});
        }
      }
    } else {
      // For images, just update state
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _disposeControllers() async {
    try {
      if (_chewieController != null) {
        _chewieController!.dispose();
        _chewieController = null;
      }
      if (_videoController != null) {
        await _videoController!.pause();
        await _videoController!.dispose();
        _videoController = null;
      }
    } catch (e) {
      print('Error disposing controllers: $e');
      _chewieController = null;
      _videoController = null;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          '${_currentIndex + 1} / ${widget.mediaFiles.length}',
          style: AppTheme.getBodyStyle(color: Colors.white),
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.mediaFiles.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
          _initializeMedia(widget.mediaFiles[index]);
        },
        itemBuilder: (context, index) {
          final media = widget.mediaFiles[index];
          if (media.isImage) {
            return PhotoView(
              imageProvider: FileImage(File(media.path)),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2,
            );
          } else {
            if (_chewieController != null &&
                _chewieController!.videoPlayerController.value.isInitialized) {
              return Center(
                child: Chewie(controller: _chewieController!),
              );
            } else if (_videoController == null) {
              // Video failed to initialize
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(5.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.videocam_off, color: Colors.white70, size: 10.w),
                      SizedBox(height: 2.h),
                      Text(
                        'Unable to play this video',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppTheme.fontSizeLarge.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'This video format may not be supported.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: AppTheme.fontSizeMedium.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }
          }
        },
      ),
    );
  }
}
