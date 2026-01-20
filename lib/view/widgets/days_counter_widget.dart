import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:yaaram/controller/memory_controller.dart';
import '../../controller/utils/theme/app_theme.dart';

class DaysCounterWidget extends StatefulWidget {
  final ScrollController? scrollController;
  final double hideThreshold;

  const DaysCounterWidget({
    Key? key,
    this.scrollController,
    this.hideThreshold = 50.0,
  }) : super(key: key);

  @override
  State<DaysCounterWidget> createState() => _DaysCounterWidgetState();
}

class _DaysCounterWidgetState extends State<DaysCounterWidget> {
  final RxBool showDaysCounter = true.obs;

  @override
  void initState() {
    super.initState();
    if (widget.scrollController != null) {
      widget.scrollController!.addListener(_updateVisibility);
    }
  }

  @override
  void dispose() {
    if (widget.scrollController != null) {
      widget.scrollController!.removeListener(_updateVisibility);
    }
    super.dispose();
  }

  void _updateVisibility() {
    if (widget.scrollController != null) {
      if (widget.scrollController!.offset > widget.hideThreshold) {
        showDaysCounter.value = false;
      } else {
        showDaysCounter.value = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: showDaysCounter.value
          ? _buildDaysCounter()
          : const SizedBox.shrink(),
    ));
  }

  Widget _buildDaysCounter() {
    final MemoryController memoryController = Get.find<MemoryController>();
    
    return Obx(() {
      final daysTogether = memoryController.daysTogether;
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
}
