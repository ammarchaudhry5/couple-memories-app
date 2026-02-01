import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../controller/utils/theme/app_theme.dart';

class AdminSectionCardWidget extends StatelessWidget {
  final String title;
  final Widget child;
  final Color? borderColor;
  final IconData? titleIcon;

  const AdminSectionCardWidget({
    Key? key,
    required this.title,
    required this.child,
    this.borderColor,
    this.titleIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: (borderColor ?? AppTheme.primaryColor).withOpacity(0.1),
            blurRadius: 10,
          ),
        ],
        border: borderColor != null
            ? Border.all(color: borderColor!.withOpacity(0.3))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleIcon != null
              ? Row(
                  children: [
                    Icon(titleIcon, color: borderColor ?? AppTheme.secondaryColor, size: 6.w),
                    SizedBox(width: 2.w),
                    Text(
                      title,
                      style: AppTheme.getHeadingStyle(fontSize: AppTheme.fontSizeXL.sp)
                          .copyWith(color: borderColor),
                    ),
                  ],
                )
              : Text(
                  title,
                  style: AppTheme.getHeadingStyle(fontSize: AppTheme.fontSizeXL.sp)
                      .copyWith(color: borderColor),
                ),
          SizedBox(height: 2.h),
          child,
        ],
      ),
    );
  }
}
