import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:yaaram/controller/memory_controller.dart';
import '../../controller/utils/theme/app_theme.dart';
import '../add_memory_screen/add_memory_screen.dart';
import '../widgets/memory_card_widget.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/bottom_nav_widget.dart';
import '../widgets/gallery_item_widget.dart';
import '../widgets/empty_favorites_widget.dart';
import '../widgets/delete_memory_dialog.dart';

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

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabController.forward();
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
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
              AppBarWidget(),
              Expanded(
                child: Obx(() => IndexedStack(
                  index: _selectedIndex.value,
                  children: [
                    _buildTimelineView(),
                    _buildGridView(),
                    _buildFavoritesView(),
                  ],
                )),
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
          shape: CircleBorder(),
          child: const Icon(Icons.add, color: Colors.white),
          elevation: 8,
        ),
      ),
      bottomNavigationBar: BottomNavWidget(
        currentIndex: _selectedIndex.value,
        onTap: (index) => _selectedIndex.value = index,
      ),
    );
  }

  Widget _buildTimelineView() {
    return Obx(() {
      final memories = _memoryController.memories;
      if (_memoryController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
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
                        Get.snackbar('Info', 'Edit functionality coming soon');
                      },
                      onDelete: (memory) {
                        DeleteMemoryDialog.show(
                          memory: memory,
                          onConfirm: () {
                            _memoryController.deleteMemory(memory.id);
                            Get.snackbar('Success', 'Memory deleted');
                          },
                        );
                      },
                    ),
                  );
                },
                childCount: memories.length,
              ),
            ),
          ),
        ],
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
        padding: EdgeInsets.all(5.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4.w,
          mainAxisSpacing: 4.w,
          childAspectRatio: 0.75,
        ),
        itemCount: memories.length,
        itemBuilder: (context, index) {
          return GalleryItemWidget(
            memory: memories[index],
            index: index,
          );
        },
      );
    });
  }

  Widget _buildFavoritesView() {
    return Obx(() {
      final favoriteMemories = _memoryController.favoriteMemories;

      return favoriteMemories.isEmpty
          ? const EmptyFavoritesWidget()
          : ListView.builder(
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
                      DeleteMemoryDialog.show(
                        memory: memory,
                        onConfirm: () {
                          _memoryController.deleteMemory(memory.id);
                          Get.snackbar('Success', 'Memory deleted');
                        },
                      );
                    },
                  ),
                );
              },
            );
    });
  }

}