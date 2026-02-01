import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../controller/utils/theme/app_theme.dart';

class EmptyFavoritesWidget extends StatelessWidget {
  const EmptyFavoritesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 20.w,
            color: AppTheme.textSecondary.withOpacity(0.3),
          ),
          SizedBox(height: 2.5.h),
          Text(
            'No favorites yet',
            style: AppTheme.getHeadingStyle(
              fontSize: AppTheme.fontSizeXXL.sp,
              color: AppTheme.textSecondary.withOpacity(0.5),
            ),
          ),
          SizedBox(height: 1.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Text(
              'Tap the heart on memories to save them here',
              style: AppTheme.getBodyStyle(
                fontSize: AppTheme.fontSizeBody.sp,
                color: AppTheme.textSecondary.withOpacity(0.4),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
