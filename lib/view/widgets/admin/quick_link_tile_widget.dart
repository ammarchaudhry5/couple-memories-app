import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../controller/utils/theme/app_theme.dart';

class QuickLinkTileWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const QuickLinkTileWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        ),
        child: Icon(icon, color: AppTheme.secondaryColor, size: 5.w),
      ),
      title: Text(
        title,
        style: AppTheme.getBodyStyle(
          fontSize: AppTheme.fontSizeMedium.sp,
        ).copyWith(fontWeight: FontWeight.w600),
      ),
      trailing: Icon(Icons.chevron_right, color: AppTheme.textSecondary),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      ),
      tileColor: AppTheme.surfaceColor.withOpacity(0.5),
    );
  }
}
