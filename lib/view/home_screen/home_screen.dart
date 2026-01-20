import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:video_player/video_player.dart';
import 'package:yaaram/controller/memory_controller.dart';
import 'package:yaaram/model/memory_model/memory_model.dart';
import '../../controller/utils/admin_auth.dart';
import '../../controller/utils/theme/app_theme.dart';
import '../add_memory_screen/add_memory_screen.dart';
import '../memory_detail_screen/memory_detail_screen.dart';
import '../admin/debug_screen.dart';
import '../../model/memory_model/memory_model.dart';
import '../widgets/memory_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  final RxInt _selectedIndex = 0.obs;
  late AnimationController _fabController;
  final MemoryController _memoryController = Get.find<MemoryController>();
  final ScrollController _scrollController = ScrollController();
  final ScrollController _gridScrollController = ScrollController();
  final ScrollController _favoritesScrollController = ScrollController();
  final RxBool _showScrollTopButton = false.obs;
  final RxBool _showDaysCounter = true.obs;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabController.forward();
    
    _scrollController.addListener(_updateScrollState);
    _gridScrollController.addListener(_updateGridScrollState);
    _favoritesScrollController.addListener(_updateFavoritesScrollState);
  }

  void _updateScrollState() {
    // Only update if timeline is active
    if (_selectedIndex.value == 0 && _scrollController.hasClients) {
      if (_scrollController.offset > 200) {
        _showScrollTopButton.value = true;
        _showDaysCounter.value = false;
      } else {
        _showScrollTopButton.value = false;
        _showDaysCounter.value = true;
      }
    }
  }

  void _updateGridScrollState() {
    // Only update if gallery is active
    if (_selectedIndex.value == 1 && _gridScrollController.hasClients) {
      if (_gridScrollController.offset > 50) {
        _showDaysCounter.value = false;
      } else {
        _showDaysCounter.value = true;
      }
    }
  }

  void _updateFavoritesScrollState() {
    // Only update if favorites is active
    if (_selectedIndex.value == 2 && _favoritesScrollController.hasClients) {
      if (_favoritesScrollController.offset > 200) {
        _showScrollTopButton.value = true;
        _showDaysCounter.value = false;
      } else {
        _showScrollTopButton.value = false;
        _showDaysCounter.value = true;
      }
    }
  }

  @override
  void dispose() {
    _fabController.dispose();
    _scrollController.dispose();
    _gridScrollController.dispose();
    _favoritesScrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    ScrollController? controller;
    if (_selectedIndex.value == 0) {
      controller = _scrollController;
    } else if (_selectedIndex.value == 2) {
      controller = _favoritesScrollController;
    }
    
    controller?.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Obx(() => AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: _showDaysCounter.value
                    ? _buildDaysCounter()
                    : const SizedBox.shrink(),
              )),
              Expanded(
                child: Stack(
                  children: [
                    Obx(() => _selectedIndex.value == 0
                        ? _buildTimelineView()
                        : _selectedIndex.value == 1
                        ? _buildGridView()
                        : _buildFavoritesView()),
                    Obx(() => _showScrollTopButton.value
                        ? Positioned(
                            bottom: 2.h,
                            right: 5.w,
                            child: FloatingActionButton(
                              heroTag: "scrollToTop",
                              onPressed: _scrollToTop,
                              backgroundColor: AppTheme.secondaryColor,
                              child: Icon(Icons.keyboard_arrow_up, color: Colors.white),
                              mini: true,
                            ),
                          )
                        : const SizedBox.shrink()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: ScaleTransition(
        scale: Tween<double>(begin: 0.8, end: 1.0).animate(
          CurvedAnimation(
            parent: _fabController,
            curve: Curves.easeInOut,
          ),
        ),
        child: FloatingActionButton(
          heroTag: "newMemoryFAB",
          onPressed: () {
            Get.to(() => const AddMemoryScreen());
          },
          backgroundColor: AppTheme.secondaryColor,
          child: const Icon(Icons.add, color: Colors.white),
          elevation: 8,
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Our Love Story',
                style: AppTheme.getHeadingStyle(fontSize: AppTheme.fontSizeHeading.sp),
              ),
              Text(
                'Forever and Always',
                style: AppTheme.getScriptStyle(
                  fontSize: AppTheme.fontSizeMedium.sp,
                  color: AppTheme.textSecondary.withOpacity(0.6),
                ),
              ),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onLongPress: () => _showAdminLoginDialog(),
                child: Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/ChatGPT Image Jan 20, 2026, 05_09_06 PM.png',
                      width: 12.w,
                      height: 12.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDaysCounter() {
    return Obx(() {
      final daysTogether = _memoryController.daysTogether;
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        padding: EdgeInsets.all(5.w),
        decoration: BoxDecoration(
          gradient: AppTheme.cardGradient,
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          border: Border.all(
            color: AppTheme.primaryColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite,
              color: AppTheme.textSecondary,
              size: 7.w,
            ),
            SizedBox(width: 3.w),
            Column(
              children: [
                Text(
                  '$daysTogether Days',
                  style: AppTheme.getTitleStyle(
                    fontSize: AppTheme.fontSizeTitle.sp,
                    color: AppTheme.textSecondary,
                  ),
                ),
                Text(
                  'of loving you',
                  style: AppTheme.getScriptStyle(
                    fontSize: AppTheme.fontSizeLarge.sp,
                    color: AppTheme.textSecondary.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTimelineView() {
    return Obx(() {
      final memories = _memoryController.memories;
      if (_memoryController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
        itemCount: memories.length,
        itemBuilder: (context, index) {
          return TweenAnimationBuilder(
            duration: Duration(milliseconds: 400 + (index * 100)),
            tween: Tween<double>(begin: 0, end: 1),
            builder: (context, double value, child) {
              return Transform.translate(
                offset: Offset(0, 50 * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: child,
                ),
              );
            },
            child: MemoryCardWidget(
              memory: memories[index],
              onEdit: (memory) {
                // TODO: Implement edit functionality
                Get.snackbar('Info', 'Edit functionality coming soon');
              },
              onDelete: (memory) {
                Get.dialog(
                  AlertDialog(
                    title: Text('Delete Memory'),
                    content: Text('Are you sure you want to delete "${memory.title}"?'),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          _memoryController.deleteMemory(memory.id);
                          Get.back();
                          Get.snackbar('Success', 'Memory deleted');
                        },
                        child: Text('Delete', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      );
    });
  }


  Widget _buildGridView() {
    return Obx(() {
      final memories = _memoryController.memories;
      if (_memoryController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return GridView.builder(
        controller: _gridScrollController,
        padding: EdgeInsets.all(5.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4.w,
          mainAxisSpacing: 4.w,
          childAspectRatio: 0.75,
        ),
        itemCount: memories.length,
        itemBuilder: (context, index) {
          final memory = memories[index];
          final firstMedia = memory.mediaFiles.isNotEmpty ? memory.mediaFiles.first : null;
          
          return TweenAnimationBuilder(
            duration: Duration(milliseconds: 400 + (index * 100)),
            tween: Tween<double>(begin: 0, end: 1),
            builder: (context, double value, child) {
              return Transform.scale(
                scale: value,
                child: Opacity(opacity: value, child: child),
              );
            },
            child: GestureDetector(
              onTap: () {
                Get.to(() => MemoryDetailScreen(memory: memory),
                    transition: Transition.rightToLeft);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                  gradient: AppTheme.cardGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Thumbnail or gradient background
                    if (firstMedia != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                        child: firstMedia.isImage
                            ? Image.file(
                                File(firstMedia.path),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      gradient: AppTheme.cardGradient,
                                    ),
                                  );
                                },
                              )
                            : _buildVideoThumbnailForGallery(firstMedia.path),
                      )
                    else
                      Container(
                        decoration: BoxDecoration(
                          gradient: AppTheme.cardGradient,
                        ),
                      ),
                    // Gradient overlay for text readability
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                    // Title and media count
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: EdgeInsets.all(4.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (memory.mediaFiles.length > 1)
                              Row(
                                children: [
                                  Icon(
                                    Icons.collections,
                                    size: 4.w,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    '${memory.mediaFiles.length}',
                                    style: AppTheme.getCaptionStyle(
                                      fontSize: AppTheme.fontSizeSmall.sp,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                ],
                              ),
                            SizedBox(height: 0.5.h),
                            Text(
                              memory.title,
                              style: AppTheme.getHeadingStyle(
                                fontSize: AppTheme.fontSizeMedium.sp,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.left,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Play icon for videos
                    if (firstMedia != null && firstMedia.isVideo)
                      Positioned.fill(
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.all(3.w),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 8.w,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildFavoritesView() {
    return Obx(() {
      final favoriteMemories = _memoryController.favoriteMemories;

      return favoriteMemories.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 20.w,
                    color: AppTheme.textSecondary.withOpacity(0.3),
                  ),
                  SizedBox(height: 2.5.h),
                  Text(
                    'No favorites yet',
                    style: AppTheme.getHeadingStyle(
                      fontSize: AppTheme.fontSizeXXL.sp,
                      color: AppTheme.textSecondary.withOpacity(0.5),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Text(
                      'Tap the heart on memories to save them here',
                      style: AppTheme.getBodyStyle(
                        fontSize: AppTheme.fontSizeBody.sp,
                        color: AppTheme.textSecondary.withOpacity(0.4),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              controller: _favoritesScrollController,
              padding: EdgeInsets.all(5.w),
              itemCount: favoriteMemories.length,
              itemBuilder: (context, index) {
                return TweenAnimationBuilder(
                  duration: Duration(milliseconds: 400 + (index * 100)),
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, double value, child) {
                    return Transform.translate(
                      offset: Offset(0, 50 * (1 - value)),
                      child: Opacity(
                        opacity: value,
                        child: child,
                      ),
                    );
                  },
                  child: MemoryCardWidget(
                    memory: favoriteMemories[index],
                    onEdit: (memory) {
                      Get.snackbar('Info', 'Edit functionality coming soon');
                    },
                    onDelete: (memory) {
                      Get.dialog(
                        AlertDialog(
                          title: Text('Delete Memory'),
                          content: Text('Are you sure you want to delete "${memory.title}"?'),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                _memoryController.deleteMemory(memory.id);
                                Get.back();
                                Get.snackbar('Success', 'Memory deleted');
                              },
                              child: Text('Delete', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            );
    });
  }

  Widget _buildBottomNav() {
    return Obx(() => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex.value,
            onTap: (index) {
              _selectedIndex.value = index;
            },
            selectedItemColor: AppTheme.textSecondary,
            unselectedItemColor: AppTheme.textSecondary.withOpacity(0.4),
            selectedLabelStyle: AppTheme.getBodyStyle(
              fontSize: AppTheme.fontSizeSmall.sp,
            ).copyWith(fontWeight: FontWeight.w600),
            unselectedLabelStyle:
                AppTheme.getBodyStyle(fontSize: AppTheme.fontSizeSmall.sp),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.timeline),
                label: 'Timeline',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.grid_view),
                label: 'Gallery',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Favorites',
              ),
            ],
          ),
        ));
  }

  Widget _buildVideoThumbnailForGallery(String videoPath) {
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
      // Return a dummy controller on error - will show gradient background
      final dummyController = VideoPlayerController.file(File(path));
      return dummyController;
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  void _showAdminLoginDialog() {
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    final RxBool isObscured = true.obs;

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        title: Row(
          children: [
            Icon(Icons.admin_panel_settings, color: AppTheme.secondaryColor),
            SizedBox(width: 2.w),
            Text(
              'Admin Access',
              style: AppTheme.getHeadingStyle(fontSize: AppTheme.fontSizeXL.sp),
            ),
          ],
        ),
        content: SizedBox(
          width: 80.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person, color: AppTheme.textSecondary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                    borderSide: BorderSide(color: AppTheme.secondaryColor, width: 2),
                  ),
                ),
                style: AppTheme.getBodyStyle(fontSize: AppTheme.fontSizeMedium.sp),
              ),
              SizedBox(height: 2.h),
              Obx(() => TextField(
                    controller: passwordController,
                    obscureText: isObscured.value,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock, color: AppTheme.textSecondary),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isObscured.value ? Icons.visibility : Icons.visibility_off,
                          color: AppTheme.textSecondary,
                        ),
                        onPressed: () => isObscured.value = !isObscured.value,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                        borderSide: BorderSide(color: AppTheme.secondaryColor, width: 2),
                      ),
                    ),
                    style: AppTheme.getBodyStyle(fontSize: AppTheme.fontSizeMedium.sp),
                  )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: AppTheme.getBodyStyle(
                fontSize: AppTheme.fontSizeMedium.sp,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final username = usernameController.text.trim();
              final password = passwordController.text.trim();

              if (username.isEmpty || password.isEmpty) {
                Get.snackbar(
                  'Error',
                  'Please enter both username and password',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
                return;
              }

              final isValid = await AdminAuth.validateCredentials(username, password);
              
              if (isValid) {
                Get.back(); // Close login dialog
                Get.to(() => const DebugScreen(), transition: Transition.fadeIn);
              } else {
                Get.snackbar(
                  'Access Denied',
                  'Invalid username or password',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 2),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.secondaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
            ),
            child: Text(
              'Login',
              style: AppTheme.getBodyStyle(
                fontSize: AppTheme.fontSizeMedium.sp,
                color: Colors.white,
              ).copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void _showMemoryOptionsMenu(Memory memory) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(5.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusXL)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 15.w,
              height: 0.5.h,
              margin: EdgeInsets.only(bottom: 2.h),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: Icon(Icons.edit, color: AppTheme.textSecondary),
              title: Text(
                'Edit Memory',
                style: AppTheme.getBodyStyle(fontSize: AppTheme.fontSizeMedium.sp),
              ),
              onTap: () {
                Get.back();
                // TODO: Navigate to edit screen
                Get.snackbar('Coming Soon', 'Edit functionality will be added soon');
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text(
                'Delete Memory',
                style: AppTheme.getBodyStyle(
                  fontSize: AppTheme.fontSizeMedium.sp,
                  color: Colors.red,
                ),
              ),
              onTap: () {
                Get.back();
                _confirmDeleteMemory(memory);
              },
            ),
            SizedBox(height: 1.h),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  void _confirmDeleteMemory(Memory memory) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        title: Text(
          'Delete Memory?',
          style: AppTheme.getHeadingStyle(fontSize: AppTheme.fontSizeXL.sp),
        ),
        content: Text(
          'This memory will be moved to trash. You can restore it from the admin panel.',
          style: AppTheme.getBodyStyle(fontSize: AppTheme.fontSizeMedium.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: AppTheme.getBodyStyle(
                fontSize: AppTheme.fontSizeMedium.sp,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              await _memoryController.deleteMemory(memory.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
            ),
            child: Text(
              'Delete',
              style: AppTheme.getBodyStyle(
                fontSize: AppTheme.fontSizeMedium.sp,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}