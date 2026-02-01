import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../controller/utils/theme/app_theme.dart';

class AdminAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const AdminAppBarWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      title: Text(
        title,
        style: AppTheme.getHeadingStyle(
          fontSize: AppTheme.fontSizeXL.sp,
          color: Colors.white,
        ),
      ),
      backgroundColor: AppTheme.secondaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
