import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../controller/utils/theme/app_theme.dart';
import '../../controller/utils/settings/settings_controller.dart';
import '../../controller/utils/admin_auth.dart';
import '../../utils/navigation_helper.dart';
import 'app_logo_widget.dart';

class AppBarWidget extends StatelessWidget {
  final VoidCallback? onLongPress;

  const AppBarWidget({
    Key? key,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final settingsController = Get.find<SettingsController>();
      final settings = settingsController.settings.value;
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      settings.appTitle,
                      style: AppTheme.getHeadingStyle(fontSize: AppTheme.fontSizeHeading.sp),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      settings.appSubtitle,
                      style: AppTheme.getScriptStyle(
                        fontSize: AppTheme.fontSizeMedium.sp,
                        color: AppTheme.textSecondary.withOpacity(0.6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 2.w),
            GestureDetector(
              onLongPress: onLongPress ?? () => _showAdminLoginDialog(),
              child: const AppLogoWidget(
                size: 12.0,
                showShadow: true,
              ),
            ),
          ],
        ),
      );
    });
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
                Get.back();
                NavigationHelper.toDebugScreen();
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
}
