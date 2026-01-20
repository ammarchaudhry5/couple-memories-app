import 'package:get/get.dart';
import 'app_settings.dart';

class SettingsController extends GetxController {
  final Rx<AppSettings> settings = AppSettings().obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  Future<void> loadSettings() async {
    isLoading.value = true;
    try {
      settings.value = await AppSettings.load();
    } catch (e) {
      print('Error loading settings: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateColorPalette(ColorPalette palette) async {
    settings.value.selectedPalette = palette;
    await settings.value.save();
    update();
    // Notify AppTheme to reload
    Get.forceAppUpdate();
  }

  Future<void> updateFont(FontOption font) async {
    settings.value.selectedFont = font;
    await settings.value.save();
    update();
    Get.forceAppUpdate();
  }

  Future<void> updateTextCustomization({
    String? appTitle,
    String? appSubtitle,
    String? daysCounterText,
    String? newMemoryButton,
    String? timelineTab,
    String? galleryTab,
    String? favoritesTab,
  }) async {
    if (appTitle != null) settings.value.appTitle = appTitle;
    if (appSubtitle != null) settings.value.appSubtitle = appSubtitle;
    if (daysCounterText != null) settings.value.daysCounterText = daysCounterText;
    if (newMemoryButton != null) settings.value.newMemoryButton = newMemoryButton;
    if (timelineTab != null) settings.value.timelineTab = timelineTab;
    if (galleryTab != null) settings.value.galleryTab = galleryTab;
    if (favoritesTab != null) settings.value.favoritesTab = favoritesTab;

    await settings.value.save();
    update();
    Get.forceAppUpdate();
  }
}
