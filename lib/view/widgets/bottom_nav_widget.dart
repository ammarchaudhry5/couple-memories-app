import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../controller/utils/theme/app_theme.dart';
import '../../controller/utils/settings/settings_controller.dart';

class BottomNavWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavWidget({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final settingsController = Get.find<SettingsController>();
      final settings = settingsController.settings.value;
      return Container(
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
          currentIndex: currentIndex,
          onTap: onTap,
          selectedItemColor: AppTheme.textSecondary,
          unselectedItemColor: AppTheme.textSecondary.withOpacity(0.4),
          selectedLabelStyle: AppTheme.getBodyStyle(
            fontSize: AppTheme.fontSizeSmall.sp,
          ).copyWith(fontWeight: FontWeight.w600),
          unselectedLabelStyle:
              AppTheme.getBodyStyle(fontSize: AppTheme.fontSizeSmall.sp),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.timeline),
              label: settings.timelineTab,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view),
              label: settings.galleryTab,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: settings.favoritesTab,
            ),
          ],
        ),
      );
    });
  }
}
