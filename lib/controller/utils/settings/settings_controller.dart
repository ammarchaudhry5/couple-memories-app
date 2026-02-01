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
    settings.refresh(); // Immediately update reactive value
    await settings.value.save();
    // Force UI update within a second
    Future.delayed(Duration(milliseconds: 100), () {
      Get.forceAppUpdate();
    });
  }

  Future<void> updateFontCombination(FontCombination fontCombination) async {
    settings.value.selectedFontCombination = fontCombination;
    settings.refresh(); // Immediately update reactive value
    await settings.value.save();
    // Force UI update within a second
    Future.delayed(Duration(milliseconds: 100), () {
      Get.forceAppUpdate();
    });
  }

  // Keep for backward compatibility
  @Deprecated('Use updateFontCombination instead')
  Future<void> updateFont(FontOption font) async {
    // Find or create a combination with this font
    final combination = AppSettings.fontCombinations.firstWhere(
      (fc) => fc.headingFont.id == font.id || fc.bodyFont.id == font.id,
      orElse: () => AppSettings.fontCombinations.first,
    );
    await updateFontCombination(combination);
  }

  Future<void> updateTextCustomization({
    String? appTitle,
    String? appSubtitle,
    String? newMemoryButton,
    String? timelineTab,
    String? galleryTab,
    String? favoritesTab,
  }) async {
    if (appTitle != null) settings.value.appTitle = appTitle;
    if (appSubtitle != null) settings.value.appSubtitle = appSubtitle;
    if (newMemoryButton != null) settings.value.newMemoryButton = newMemoryButton;
    if (timelineTab != null) settings.value.timelineTab = timelineTab;
    if (galleryTab != null) settings.value.galleryTab = galleryTab;
    if (favoritesTab != null) settings.value.favoritesTab = favoritesTab;

    settings.refresh(); // Immediately update reactive value
    await settings.value.save();
    // Force UI update within a second
    Future.delayed(Duration(milliseconds: 100), () {
      Get.forceAppUpdate();
    });
  }
}
