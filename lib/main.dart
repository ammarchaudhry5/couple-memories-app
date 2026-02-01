import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:yaaram/controller/memory_controller.dart';
import 'package:yaaram/controller/utils/settings/settings_controller.dart';
import 'package:yaaram/view/splash_screen/splash_screen.dart';

import 'controller/utils/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize GetX controllers
  Get.put(MemoryController());
  final settingsController = Get.put(SettingsController());
  
  // Load settings before app starts
  await settingsController.loadSettings();
  
  runApp(const OurLoveStoryApp());
}

class OurLoveStoryApp extends StatelessWidget {
  const OurLoveStoryApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return Obx(() {
          // Access settings to make this reactive
          final _ = Get.find<SettingsController>().settings.value;
          return GetMaterialApp(
            title: 'Our Love Story',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.themeData,
            home: const SplashScreen(),
            defaultTransition: Transition.fadeIn,
          );
        });
      },
    );
  }
}