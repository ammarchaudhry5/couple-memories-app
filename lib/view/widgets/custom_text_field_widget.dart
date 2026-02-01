import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../controller/utils/theme/app_theme.dart';

class CustomTextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final int maxLines;

  const CustomTextFieldWidget({
    Key? key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 5.w,
              color: AppTheme.textSecondary,
            ),
            SizedBox(width: 2.w),
            Text(
              label,
              style: AppTheme.getBodyStyle(
                fontSize: AppTheme.fontSizeBody.sp,
                color: AppTheme.textSecondary,
              ).copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        SizedBox(height: 1.5.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            style: AppTheme.getBodyStyle(
              fontSize: AppTheme.fontSizeMedium.sp,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTheme.getBodyStyle(
                fontSize: AppTheme.fontSizeBody.sp,
                color: AppTheme.textSecondary.withOpacity(0.4),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.all(5.w),
            ),
          ),
        ),
      ],
    );
  }
}
