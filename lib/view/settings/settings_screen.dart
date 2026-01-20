import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:yaaram/controller/utils/settings/app_settings.dart';
import 'package:yaaram/controller/utils/settings/settings_controller.dart';
import '../../controller/utils/theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsController _settingsController = Get.put(SettingsController());
  late TextEditingController _appTitleController;
  late TextEditingController _appSubtitleController;
  late TextEditingController _daysCounterController;
  late TextEditingController _timelineTabController;
  late TextEditingController _galleryTabController;
  late TextEditingController _favoritesTabController;

  @override
  void initState() {
    super.initState();
    _settingsController.loadSettings().then((_) {
      final settings = _settingsController.settings.value;
      _appTitleController = TextEditingController(text: settings.appTitle);
      _appSubtitleController = TextEditingController(text: settings.appSubtitle);
      _daysCounterController = TextEditingController(text: settings.daysCounterText);
      _timelineTabController = TextEditingController(text: settings.timelineTab);
      _galleryTabController = TextEditingController(text: settings.galleryTab);
      _favoritesTabController = TextEditingController(text: settings.favoritesTab);
    });
  }

  @override
  void dispose() {
    _appTitleController.dispose();
    _appSubtitleController.dispose();
    _daysCounterController.dispose();
    _timelineTabController.dispose();
    _galleryTabController.dispose();
    _favoritesTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'App Settings',
          style: AppTheme.getHeadingStyle(fontSize: AppTheme.fontSizeXL.sp),
        ),
        backgroundColor: AppTheme.secondaryColor,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: Obx(() {
          if (_settingsController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final settings = _settingsController.settings.value;
          return SingleChildScrollView(
            padding: EdgeInsets.all(5.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildColorPaletteSection(settings.selectedPalette),
                SizedBox(height: 3.h),
                _buildFontSection(settings.selectedFont),
                SizedBox(height: 3.h),
                _buildTextCustomizationSection(),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildColorPaletteSection(ColorPalette currentPalette) {
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🎨 Color Palette',
            style: AppTheme.getHeadingStyle(fontSize: AppTheme.fontSizeXL.sp),
          ),
          SizedBox(height: 2.h),
          Text(
            'Choose your favorite color scheme',
            style: AppTheme.getBodyStyle(
              fontSize: AppTheme.fontSizeSmall.sp,
              color: AppTheme.textSecondary.withOpacity(0.7),
            ),
          ),
          SizedBox(height: 2.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 3.w,
              childAspectRatio: 1.5,
            ),
            itemCount: AppSettings.colorPalettes.length,
            itemBuilder: (context, index) {
              final palette = AppSettings.colorPalettes[index];
              final isSelected = palette.id == currentPalette.id;

              return GestureDetector(
                onTap: () {
                  _settingsController.updateColorPalette(palette);
                  Get.snackbar('Success', 'Color palette updated!',
                      snackPosition: SnackPosition.BOTTOM);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.secondaryColor
                          : Colors.grey.shade300,
                      width: isSelected ? 3 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppTheme.secondaryColor.withOpacity(0.3),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildColorCircle(palette.primaryColor),
                          SizedBox(width: 1.w),
                          _buildColorCircle(palette.secondaryColor),
                          SizedBox(width: 1.w),
                          _buildColorCircle(palette.accentColor),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        palette.name,
                        style: AppTheme.getBodyStyle(
                          fontSize: AppTheme.fontSizeSmall.sp,
                        ).copyWith(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (isSelected)
                        Padding(
                          padding: EdgeInsets.only(top: 0.5.h),
                          child: Icon(
                            Icons.check_circle,
                            color: AppTheme.secondaryColor,
                            size: 5.w,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildColorCircle(Color color) {
    return Container(
      width: 8.w,
      height: 8.w,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildFontSection(FontOption currentFont) {
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '✍️ Font Style',
            style: AppTheme.getHeadingStyle(fontSize: AppTheme.fontSizeXL.sp),
          ),
          SizedBox(height: 2.h),
          Text(
            'Select your preferred font family',
            style: AppTheme.getBodyStyle(
              fontSize: AppTheme.fontSizeSmall.sp,
              color: AppTheme.textSecondary.withOpacity(0.7),
            ),
          ),
          SizedBox(height: 2.h),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: AppSettings.fontOptions.length,
            itemBuilder: (context, index) {
              final font = AppSettings.fontOptions[index];
              final isSelected = font.id == currentFont.id;

              return ListTile(
                title: Text(
                  font.name,
                  style: AppTheme.getBodyStyle(
                    fontSize: AppTheme.fontSizeMedium.sp,
                  ).copyWith(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                trailing: isSelected
                    ? Icon(Icons.check, color: AppTheme.secondaryColor)
                    : null,
                onTap: () {
                  _settingsController.updateFont(font);
                  Get.snackbar('Success', 'Font updated!',
                      snackPosition: SnackPosition.BOTTOM);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                tileColor: isSelected
                    ? AppTheme.secondaryColor.withOpacity(0.1)
                    : null,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextCustomizationSection() {
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📝 Customize Texts',
            style: AppTheme.getHeadingStyle(fontSize: AppTheme.fontSizeXL.sp),
          ),
          SizedBox(height: 2.h),
          Text(
            'Personalize app text labels',
            style: AppTheme.getBodyStyle(
              fontSize: AppTheme.fontSizeSmall.sp,
              color: AppTheme.textSecondary.withOpacity(0.7),
            ),
          ),
          SizedBox(height: 2.h),
          _buildTextField('App Title', _appTitleController, 'appTitle'),
          SizedBox(height: 2.h),
          _buildTextField('App Subtitle', _appSubtitleController, 'appSubtitle'),
          SizedBox(height: 2.h),
          _buildTextField('Days Counter Text', _daysCounterController, 'daysCounter'),
          SizedBox(height: 2.h),
          _buildTextField('Timeline Tab', _timelineTabController, 'timelineTab'),
          SizedBox(height: 2.h),
          _buildTextField('Gallery Tab', _galleryTabController, 'galleryTab'),
          SizedBox(height: 2.h),
          _buildTextField('Favorites Tab', _favoritesTabController, 'favoritesTab'),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _settingsController.updateTextCustomization(
                  appTitle: _appTitleController.text,
                  appSubtitle: _appSubtitleController.text,
                  daysCounterText: _daysCounterController.text,
                  timelineTab: _timelineTabController.text,
                  galleryTab: _galleryTabController.text,
                  favoritesTab: _favoritesTabController.text,
                );
                Get.snackbar('Success', 'Texts updated!',
                    snackPosition: SnackPosition.BOTTOM);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.secondaryColor,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                ),
              ),
              child: Text(
                'Save Text Changes',
                style: AppTheme.getBodyStyle(
                  fontSize: AppTheme.fontSizeMedium.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String field) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          borderSide: BorderSide(color: AppTheme.secondaryColor, width: 2),
        ),
      ),
    );
  }
}
