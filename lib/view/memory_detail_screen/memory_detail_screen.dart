import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:yaaram/controller/memory_controller.dart';
import 'package:yaaram/model/memory_model/memory_model.dart';
import 'package:intl/intl.dart';

import '../../controller/utils/theme/app_theme.dart';
import '../widgets/media_gallery_widget.dart';

class MemoryDetailScreen extends StatefulWidget {
  final Memory memory;

  const MemoryDetailScreen({Key? key, required this.memory}) : super(key: key);

  @override
  State<MemoryDetailScreen> createState() => _MemoryDetailScreenState();
}

class _MemoryDetailScreenState extends State<MemoryDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  final MemoryController _memoryController = Get.find<MemoryController>();
  late Memory _currentMemory;

  @override
  void initState() {
    super.initState();
    _currentMemory = widget.memory;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: Obx(() {
          final memory = _memoryController.memories
              .firstWhereOrNull((m) => m.id == _currentMemory.id) ??
              _currentMemory;
          return CustomScrollView(
            slivers: [
              _buildSliverAppBar(memory),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (memory.mediaFiles.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.all(5.w),
                        child: MediaGalleryWidget(mediaFiles: memory.mediaFiles),
                      ),
                    _buildContentSection(),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildSliverAppBar(Memory memory) {
    return SliverAppBar(
      expandedHeight: 30.h,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: AppTheme.surfaceColor,
      leading: null,
      automaticallyImplyLeading: false,
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool isExpanded = constraints.maxHeight > 20.h;
          
          return FlexibleSpaceBar(
            titlePadding: EdgeInsets.zero,
            centerTitle: false,
            title: isExpanded
                ? const SizedBox.shrink() // Hide title when expanded
                : Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.arrow_back,
                              color: AppTheme.textSecondary,
                              size: 4.w,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Our Love Story',
                                style: AppTheme.getHeadingStyle(
                                  fontSize: AppTheme.fontSizeHeading.sp,
                                ),
                              ),
                              Text(
                                'Forever and Always',
                                style: AppTheme.getScriptStyle(
                                  fontSize: AppTheme.fontSizeSmall.sp,
                                  color: AppTheme.textSecondary.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 8.w,
                          height: 8.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryColor.withOpacity(0.3),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/ChatGPT Image Jan 20, 2026, 05_09_06 PM.png',
                              width: 8.w,
                              height: 8.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
            background: Container(
              decoration: BoxDecoration(
                gradient: AppTheme.backgroundGradient,
              ),
              child: isExpanded
                  ? SafeArea(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () => Get.back(),
                                  child: Container(
                                    padding: EdgeInsets.all(3.w),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.9),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 10,
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.arrow_back,
                                      color: AppTheme.textSecondary,
                                      size: 5.w,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    _buildActionButton(
                                      Icons.share,
                                      () => _shareMemory(memory),
                                    ),
                                    SizedBox(width: 3.w),
                                    Obx(() {
                                      final mem = _memoryController.memories
                                          .firstWhereOrNull((m) => m.id == _currentMemory.id) ??
                                          memory;
                                      return _buildActionButton(
                                        mem.isFavorite ? Icons.favorite : Icons.favorite_border,
                                        () => _toggleFavorite(mem),
                                        isFavorite: mem.isFavorite,
                                      );
                                    }),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 2.h),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    memory.title,
                                    style: AppTheme.getTitleStyle(
                                      fontSize: AppTheme.fontSizeTitle.sp,
                                    ),
                                  ),
                                  SizedBox(height: 1.h),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        size: 4.w,
                                        color: AppTheme.textSecondary.withOpacity(0.7),
                                      ),
                                      SizedBox(width: 1.w),
                                      Text(
                                        memory.location,
                                        style: AppTheme.getScriptStyle(
                                          fontSize: AppTheme.fontSizeMedium.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }


  Widget _buildActionButton(IconData icon, VoidCallback onTap,
      {bool isFavorite = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
            ),
          ],
        ),
        child: Icon(
          icon,
          color: isFavorite ? AppTheme.secondaryColor : AppTheme.textSecondary,
          size: 5.w,
        ),
      ),
    );
  }

  void _toggleFavorite(Memory memory) {
    _memoryController.toggleFavorite(memory.id);
    // Update local state
    setState(() {
      _currentMemory = memory.copyWith(isFavorite: !memory.isFavorite);
    });
    Get.snackbar(
      memory.isFavorite ? 'Removed from favorites' : 'Added to favorites',
      '',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }

  void _shareMemory(Memory memory) {
    final shareText =
        '💕 ${memory.title}\n\n${memory.description}\n\n📍 ${memory.location}\n📅 ${DateFormat('MMM dd, yyyy').format(memory.date)}';
    Clipboard.setData(ClipboardData(text: shareText));
    Get.snackbar(
      'Copied to clipboard',
      'Memory details ready to share',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  Widget _buildImageSection() {
    return Obx(() {
      final memory = _memoryController.memories
          .firstWhereOrNull((m) => m.id == _currentMemory.id) ??
          _currentMemory;
      return ScaleTransition(
        scale: _scaleAnimation,
        child: GestureDetector(
          onTap: () {
            if (memory.imagePath != null) {
              // Show full screen image view
              Get.dialog(
                Dialog(
                  backgroundColor: Colors.transparent,
                  child: Stack(
                    children: [
                      Center(
                        child: Image.file(
                          File(memory.imagePath!),
                          fit: BoxFit.contain,
                        ),
                      ),
                      Positioned(
                        top: 2.h,
                        right: 4.w,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Get.back(),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
          child: Container(
            margin: EdgeInsets.all(5.w),
            height: 50.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.radiusXXXL),
              gradient: memory.imagePath == null ? AppTheme.cardGradient : null,
              image: memory.imagePath != null
                  ? DecorationImage(
                      image: FileImage(File(memory.imagePath!)),
                      fit: BoxFit.cover,
                    )
                  : null,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.radiusXXXL),
              child: Stack(
                children: [
                  // Main image placeholder with animated shimmer effect
                  if (memory.imagePath == null)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppTheme.cardGradient,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.photo_camera,
                                size: 20.w,
                                color: Colors.white.withOpacity(0.6),
                              ),
                              SizedBox(height: 1.5.h),
                              Text(
                                'No image available',
                                style: AppTheme.getBodyStyle(
                                  fontSize: AppTheme.fontSizeSmall.sp,
                                  color: Colors.white.withOpacity(0.8),
                                ).copyWith(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  // Animated hearts floating effect (decorative)
                  if (memory.imagePath == null)
                    Positioned(
                      top: 4.h,
                      left: 4.w,
                      child: TweenAnimationBuilder(
                        duration: const Duration(seconds: 2),
                        tween: Tween<double>(begin: 0, end: 1),
                        builder: (context, double value, child) {
                          return Transform.translate(
                            offset: Offset(0, -10 * math.sin(value * math.pi * 2)),
                            child: Opacity(
                              opacity: 0.3 + (0.2 * math.sin(value * math.pi * 2)),
                              child: Icon(
                                Icons.favorite,
                                color: Colors.white,
                                size: 6.w,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                  if (memory.imagePath == null)
                    Positioned(
                      top: 7.h,
                      right: 6.w,
                      child: TweenAnimationBuilder(
                        duration: const Duration(milliseconds: 2500),
                        tween: Tween<double>(begin: 0, end: 1),
                        builder: (context, double value, child) {
                          return Transform.translate(
                            offset: Offset(0, -15 * math.sin(value * math.pi * 2)),
                            child: Opacity(
                              opacity: 0.2 + (0.3 * math.sin(value * math.pi * 2)),
                              child: Icon(
                                Icons.favorite,
                                color: Colors.white,
                                size: 4.5.w,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                  // Bottom gradient overlay with location info
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.4),
                            Colors.black.withOpacity(0.8),
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(2.w),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                                ),
                                child: Icon(
                                  Icons.location_on,
                                  size: 4.5.w,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Location',
                                      style: AppTheme.getCaptionStyle(
                                        fontSize: AppTheme.fontSizeSmall.sp,
                                        color: Colors.white.withOpacity(0.7),
                                      ),
                                    ),
                                    SizedBox(height: 0.5.h),
                                    Text(
                                      memory.location,
                                      style: AppTheme.getScriptStyle(
                                        fontSize: AppTheme.fontSizeLarge.sp,
                                        color: Colors.white,
                                      ).copyWith(fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.5.h),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 3.w,
                                  vertical: 1.h,
                                ),
                                decoration: BoxDecoration(
                                  gradient: AppTheme.primaryGradient,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 3.5.w,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 1.5.w),
                                    Text(
                                      _getTimeAgo(memory.date),
                                      style: AppTheme.getBodyStyle(
                                        fontSize: AppTheme.fontSizeSmall.sp,
                                        color: Colors.white,
                                      ).copyWith(fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Top corner decorative element
                  Positioned(
                    top: 2.5.h,
                    right: 5.w,
                    child: Obx(() {
                      final mem = _memoryController.memories
                          .firstWhereOrNull((m) => m.id == _currentMemory.id) ??
                          _currentMemory;
                      return Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          mem.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: AppTheme.textSecondary,
                          size: 6.w,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildContentSection() {
    return Obx(() {
      final memory = _memoryController.memories
          .firstWhereOrNull((m) => m.id == _currentMemory.id) ??
          _currentMemory;
      return FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: EdgeInsets.all(5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 5.w,
                    color: AppTheme.textSecondary.withOpacity(0.6),
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    DateFormat('MMMM dd, yyyy').format(memory.date),
                    style: AppTheme.getCaptionStyle(
                      fontSize: AppTheme.fontSizeSmall.sp,
                      color: AppTheme.textSecondary.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Text(
                memory.title,
                style: AppTheme.getTitleStyle(
                  fontSize: AppTheme.fontSizeTitle.sp,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                memory.description,
                style: AppTheme.getBodyStyle(
                  fontSize: AppTheme.fontSizeMedium.sp,
                ),
              ),
              SizedBox(height: 3.h),
            ],
          ),
        ),
      );
    });
  }

  String _getTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }
}