import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../controller/utils/theme/app_theme.dart';

class MediaPickerWidget extends StatelessWidget {
  final VoidCallback onTap;

  const MediaPickerWidget({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 15.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.radiusXL),
          gradient: AppTheme.cardGradient,
          border: Border.all(
            color: AppTheme.primaryColor.withOpacity(0.5),
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
              child: Icon(
                Icons.add_photo_alternate,
                size: 8.w,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 3.w),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Media',
                  style: AppTheme.getHeadingStyle(
                    fontSize: AppTheme.fontSizeXL.sp,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Photos & Videos',
                  style: AppTheme.getCaptionStyle(
                    fontSize: AppTheme.fontSizeSmall.sp,
                    color: AppTheme.textSecondary.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
