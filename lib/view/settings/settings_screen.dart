import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:yaaram/controller/utils/settings/app_settings.dart';
import 'package:yaaram/controller/utils/settings/settings_controller.dart';
import '../../controller/utils/theme/app_theme.dart';
import '../../utils/navigation_helper.dart';
import '../widgets/color_circle_widget.dart';
import '../widgets/admin_tile_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsController _settingsController = Get.put(SettingsController());
  late TextEditingController _appTitleController;
  late TextEditingController _appSubtitleController;
  late TextEditingController _timelineTabController;
  late TextEditingController _galleryTabController;
  late TextEditingController _favoritesTabController;

  @override
  void initState() {
    super.initState();
    // Initialize with default values first
    final defaultSettings = _settingsController.settings.value;
    _appTitleController = TextEditingController(text: defaultSettings.appTitle);
    _appSubtitleController = TextEditingController(text: defaultSettings.appSubtitle);
    _timelineTabController = TextEditingController(text: defaultSettings.timelineTab);
    _galleryTabController = TextEditingController(text: defaultSettings.galleryTab);
    _favoritesTabController = TextEditingController(text: defaultSettings.favoritesTab);
    
    // Load and update if settings are loaded
    _settingsController.loadSettings().then((_) {
      final settings = _settingsController.settings.value;
      _appTitleController.text = settings.appTitle;
      _appSubtitleController.text = settings.appSubtitle;
      _timelineTabController.text = settings.timelineTab;
      _galleryTabController.text = settings.galleryTab;
      _favoritesTabController.text = settings.favoritesTab;
    });
  }

  @override
  void dispose() {
    _appTitleController.dispose();
    _appSubtitleController.dispose();
    _timelineTabController.dispose();
    _galleryTabController.dispose();
    _favoritesTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'App Settings',
          style: AppTheme.getHeadingStyle(
            fontSize: AppTheme.fontSizeXL.sp,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.secondaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
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
                _buildFontCombinationSection(settings.selectedFontCombination),
                SizedBox(height: 3.h),
                _buildTextCustomizationSection(),
                SizedBox(height: 3.h),
                _buildAdminSection(),
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
                          ColorCircleWidget(color: palette.primaryColor),
                          SizedBox(width: 1.w),
                          ColorCircleWidget(color: palette.secondaryColor),
                          SizedBox(width: 1.w),
                          ColorCircleWidget(color: palette.accentColor),
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


  Widget _buildFontCombinationSection(FontCombination currentCombination) {
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
            '✍️ Font Combination',
            style: AppTheme.getHeadingStyle(fontSize: AppTheme.fontSizeXL.sp),
          ),
          SizedBox(height: 2.h),
          Text(
            'Select a font combination (Heading + Body)',
            style: AppTheme.getBodyStyle(
              fontSize: AppTheme.fontSizeSmall.sp,
              color: AppTheme.textSecondary.withOpacity(0.7),
            ),
          ),
          SizedBox(height: 2.h),
          ListView.builder(
            shrinkWrap: true,
            itemCount: AppSettings.fontCombinations.length,
            itemBuilder: (context, index) {
              final combination = AppSettings.fontCombinations[index];
              final isSelected = combination.id == currentCombination.id;

              return ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      combination.name,
                      style: AppTheme.getBodyStyle(
                        fontSize: AppTheme.fontSizeMedium.sp,
                      ).copyWith(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                          ),
                          child: Text(
                            'H: ${combination.headingFont.name}',
                            style: AppTheme.getCaptionStyle(
                              fontSize: AppTheme.fontSizeSmall.sp,
                            ),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: AppTheme.accentColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                          ),
                          child: Text(
                            'B: ${combination.bodyFont.name}',
                            style: AppTheme.getCaptionStyle(
                              fontSize: AppTheme.fontSizeSmall.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: isSelected
                    ? Icon(Icons.check, color: AppTheme.secondaryColor)
                    : null,
                onTap: () {
                  _settingsController.updateFontCombination(combination);
                  Get.snackbar('Success', 'Font combination updated!',
                      snackPosition: SnackPosition.BOTTOM,
                      duration: Duration(milliseconds: 800));
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
          _buildTextField('App Title', _appTitleController),
          SizedBox(height: 2.h),
          _buildTextField('App Subtitle', _appSubtitleController),
          SizedBox(height: 2.h),
          _buildTextField('Timeline Tab', _timelineTabController),
          SizedBox(height: 2.h),
          _buildTextField('Gallery Tab', _galleryTabController),
          SizedBox(height: 2.h),
          _buildTextField('Favorites Tab', _favoritesTabController),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _settingsController.updateTextCustomization(
                  appTitle: _appTitleController.text,
                  appSubtitle: _appSubtitleController.text,
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

  Widget _buildTextField(String label, TextEditingController controller) {
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

  Widget _buildAdminSection() {
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
          Row(
            children: [
              Icon(Icons.admin_panel_settings, color: AppTheme.secondaryColor, size: 6.w),
              SizedBox(width: 2.w),
              Text(
                '⚙️ Admin',
                style: AppTheme.getHeadingStyle(fontSize: AppTheme.fontSizeXL.sp),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          AdminTileWidget(
            title: 'Database Admin',
            icon: Icons.storage,
            onTap: NavigationHelper.toDatabaseAdmin,
          ),
          AdminTileWidget(
            title: 'Memories Admin',
            icon: Icons.photo_library,
            onTap: NavigationHelper.toMemoriesAdmin,
          ),
          AdminTileWidget(
            title: 'Debug Panel',
            icon: Icons.bug_report,
            onTap: NavigationHelper.toDebugScreen,
          ),
        ],
      ),
    );
  }

}
