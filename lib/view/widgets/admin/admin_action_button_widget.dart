import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../controller/utils/theme/app_theme.dart';

class AdminActionButtonWidget extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const AdminActionButtonWidget({
    Key? key,
    required this.label,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      child: Container(
        padding: EdgeInsets.all(3.w),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.secondaryColor, size: 5.w),
            SizedBox(width: 3.w),
            Text(
              label,
              style: AppTheme.getBodyStyle(fontSize: AppTheme.fontSizeMedium.sp),
            ),
          ],
        ),
      ),
    );
  }
}
