import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../utils/navigation_helper.dart';
import '../../../controller/utils/theme/app_theme.dart';
import 'admin_section_card_widget.dart';

class SettingsSectionWidget extends StatelessWidget {
  const SettingsSectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdminSectionCardWidget(
      title: '🎨 App Settings',
      titleIcon: Icons.settings,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customize app appearance, colors, fonts, and text',
            style: AppTheme.getBodyStyle(
              fontSize: AppTheme.fontSizeSmall.sp,
              color: AppTheme.textSecondary.withOpacity(0.7),
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: NavigationHelper.toSettings,
              icon: Icon(Icons.palette, size: 5.w),
              label: Text(
                'Open Settings',
                style: AppTheme.getBodyStyle(
                  fontSize: AppTheme.fontSizeMedium.sp,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.secondaryColor,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
