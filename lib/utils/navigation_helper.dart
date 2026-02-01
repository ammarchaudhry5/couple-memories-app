import 'package:get/get.dart';
import '../view/admin/database_admin_screen.dart';
import '../view/admin/memories_admin_screen.dart';
import '../view/admin/debug_screen.dart';
import '../view/settings/settings_screen.dart';

/// Centralized navigation helper to avoid duplicate navigation patterns
class NavigationHelper {
  static void toDatabaseAdmin() {
    Get.to(() => const DatabaseAdminScreen(), transition: Transition.rightToLeft);
  }

  static void toMemoriesAdmin() {
    Get.to(() => const MemoriesAdminScreen(), transition: Transition.rightToLeft);
  }

  static void toDebugScreen() {
    Get.to(() => const DebugScreen(), transition: Transition.rightToLeft);
  }

  static void toSettings() {
    Get.to(() => const SettingsScreen(), transition: Transition.rightToLeft);
  }
}
