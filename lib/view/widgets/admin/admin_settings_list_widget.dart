import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../controller/utils/theme/app_theme.dart';
import '../../../controller/utils/settings/settings_controller.dart';
import '../../../controller/utils/settings/app_settings.dart';
import '../../../controller/utils/database_admin.dart';
import 'admin_section_card_widget.dart';
import 'database_info_widget.dart';

class AdminSettingsListWidget extends StatefulWidget {
  const AdminSettingsListWidget({Key? key}) : super(key: key);

  @override
  State<AdminSettingsListWidget> createState() => _AdminSettingsListWidgetState();
}

class _AdminSettingsListWidgetState extends State<AdminSettingsListWidget> {
  final SettingsController _settingsController = Get.find<SettingsController>();
  bool _isAppSettingsExpanded = false;
  Map<String, dynamic>? _dbInfo;

  @override
  void initState() {
    super.initState();
    _loadDatabaseInfo();
  }

  Future<void> _loadDatabaseInfo() async {
    final info = await DatabaseAdmin.getDatabaseInfo();
    setState(() {
      _dbInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.backgroundGradient,
      ),
      child: ListView(
        padding: EdgeInsets.all(5.w),
        children: [
          _buildAppSettingsSection(),
          SizedBox(height: 2.h),
          _buildDatabaseInfoSection(),
        ],
      ),
    );
  }

  Widget _buildAppSettingsSection() {
    return Container(
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
        children: [
          ListTile(
            leading: Icon(Icons.settings, color: AppTheme.secondaryColor, size: 5.w),
            title: Text(
              'App Settings',
              style: AppTheme.getHeadingStyle(fontSize: AppTheme.fontSizeXL.sp),
            ),
            trailing: Icon(
              _isAppSettingsExpanded ? Icons.expand_less : Icons.expand_more,
              color: AppTheme.secondaryColor,
            ),
            onTap: () {
              setState(() {
                _isAppSettingsExpanded = !_isAppSettingsExpanded;
              });
            },
          ),
          if (_isAppSettingsExpanded) ...[
            Divider(height: 1, color: AppTheme.secondaryColor,),
            _buildSubItem(
              'Color Palette',
              Icons.palette,
              () => _navigateToColorPalette(),
            ),
            Divider(height: 1, color: AppTheme.secondaryColor,),
            _buildSubItem(
              'Font Combination',
              Icons.font_download,
              () => _navigateToFontCombination(),
            ),
            Divider(height: 1, color: AppTheme.secondaryColor,),
            _buildSubItem(
              'Customized Text',
              Icons.text_fields,
              () => _navigateToCustomizedText(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSubItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.secondaryColor, size: 5.w),
      title: Text(
        title,
        style: AppTheme.getBodyStyle(fontSize: AppTheme.fontSizeMedium.sp),
      ),
      trailing: Icon(Icons.chevron_right, color: AppTheme.textSecondary),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
    );
  }

  Widget _buildDatabaseInfoSection() {
    return Container(
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
      child: ListTile(
        leading: Icon(Icons.storage, color: AppTheme.secondaryColor, size: 6.w),
        title: Text(
          'Database Info',
          style: AppTheme.getHeadingStyle(fontSize: AppTheme.fontSizeXL.sp),
        ),
        trailing: Icon(Icons.chevron_right, color: AppTheme.textSecondary),
        onTap: () => _showDatabaseInfoDialog(),
      ),
    );
  }

  void _navigateToColorPalette() {
    Get.to(
      () => _ColorPaletteScreen(),
      transition: Transition.rightToLeft,
    );
  }

  void _navigateToFontCombination() {
    Get.to(
      () => _FontCombinationScreen(),
      transition: Transition.rightToLeft,
    );
  }

  void _navigateToCustomizedText() {
    Get.to(
      () => _CustomizedTextScreen(),
      transition: Transition.rightToLeft,
    );
  }

  void _showDatabaseInfoDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        child: Flexible(
          child: SingleChildScrollView(
            child: DatabaseInfoWidget(dbInfo: _dbInfo),
          ),
        ),
      ),
    );
  }
}

// Color Palette Screen
class _ColorPaletteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SettingsController settingsController = Get.find<SettingsController>();
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Color Palette',
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
        height: MediaQuery.sizeOf(context).height,
        decoration: BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: Obx(() {
          final settings = settingsController.settings.value;
          return SingleChildScrollView(
            padding: EdgeInsets.all(5.w),
            child: _buildColorPaletteSection(settings.selectedPalette, settingsController),
          );
        }),
      ),
    );
  }

  Widget _buildColorPaletteSection(ColorPalette currentPalette, SettingsController controller) {
    return AdminSectionCardWidget(
      title: '🎨 Color Palette',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  controller.updateColorPalette(palette);
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
                          Container(
                            width: 5.w,
                            height: 5.w,
                            decoration: BoxDecoration(
                              color: palette.primaryColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                          ),
                          SizedBox(width: 1.w),
                          Container(
                            width: 5.w,
                            height: 5.w,
                            decoration: BoxDecoration(
                              color: palette.secondaryColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                          ),
                          SizedBox(width: 1.w),
                          Container(
                            width: 5.w,
                            height: 5.w,
                            decoration: BoxDecoration(
                              color: palette.accentColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                          ),
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
}

// Font Combination Screen
class _FontCombinationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SettingsController settingsController = Get.find<SettingsController>();
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Font Combination',
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
        height: MediaQuery.sizeOf(context).height,
        decoration: BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: Obx(() {
          final settings = settingsController.settings.value;
          return SingleChildScrollView(
            padding: EdgeInsets.all(5.w),
            child: _buildFontCombinationSection(settings.selectedFontCombination, settingsController),
          );
        }),
      ),
    );
  }

  Widget _buildFontCombinationSection(FontCombination currentCombination, SettingsController controller) {
    return AdminSectionCardWidget(
      title: '✍️ Font Combination',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            physics: const NeverScrollableScrollPhysics(),
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
                  controller.updateFontCombination(combination);
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
}

// Customized Text Screen
class _CustomizedTextScreen extends StatefulWidget {
  @override
  State<_CustomizedTextScreen> createState() => _CustomizedTextScreenState();
}

class _CustomizedTextScreenState extends State<_CustomizedTextScreen> {
  final SettingsController _settingsController = Get.find<SettingsController>();
  late TextEditingController _appTitleController;
  late TextEditingController _appSubtitleController;
  late TextEditingController _timelineTabController;
  late TextEditingController _galleryTabController;
  late TextEditingController _favoritesTabController;

  @override
  void initState() {
    super.initState();
    final defaultSettings = _settingsController.settings.value;
    _appTitleController = TextEditingController(text: defaultSettings.appTitle);
    _appSubtitleController = TextEditingController(text: defaultSettings.appSubtitle);
    _timelineTabController = TextEditingController(text: defaultSettings.timelineTab);
    _galleryTabController = TextEditingController(text: defaultSettings.galleryTab);
    _favoritesTabController = TextEditingController(text: defaultSettings.favoritesTab);
    
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
          'Customized Text',
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
        height: MediaQuery.sizeOf(context).height,
        decoration: BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(5.w),
          child: AdminSectionCardWidget(
            title: '📝 Customize Texts',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall,),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          borderSide: BorderSide(color: AppTheme.secondaryColor, width: 2),
        ),
      ),
    );
  }
}
