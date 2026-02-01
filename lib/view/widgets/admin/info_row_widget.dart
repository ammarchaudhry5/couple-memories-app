import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../controller/utils/theme/app_theme.dart';

class InfoRowWidget extends StatelessWidget {
  final String label;
  final String value;

  const InfoRowWidget({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 20.w,
            child: Text(
              '$label:',
              style: AppTheme.getBodyStyle(
                fontSize: AppTheme.fontSizeSmall.sp,
                color: AppTheme.textSecondary,
              ).copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: AppTheme.getBodyStyle(fontSize: AppTheme.fontSizeSmall.sp),
            ),
          ),
        ],
      ),
    );
  }
}
