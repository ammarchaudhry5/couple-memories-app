import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../controller/utils/theme/app_theme.dart';

class MemoryItemWidget extends StatelessWidget {
  final Map<String, dynamic> memory;
  final bool isDeleted;
  final VoidCallback? onRestore;

  const MemoryItemWidget({
    Key? key,
    required this.memory,
    this.isDeleted = false,
    this.onRestore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final container = Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: isDeleted
            ? Colors.red.withOpacity(0.05)
            : AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        border: isDeleted
            ? Border.all(color: Colors.red.withOpacity(0.2))
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  memory['title'] ?? 'No Title',
                  style: AppTheme.getBodyStyle(
                    fontSize: AppTheme.fontSizeMedium.sp,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'ID: ${memory['id']} | Date: ${memory['date']}',
                  style: AppTheme.getCaptionStyle(
                    fontSize: AppTheme.fontSizeSmall.sp,
                  ),
                ),
              ],
            ),
          ),
          if (isDeleted && onRestore != null)
            IconButton(
              icon: Icon(Icons.restore, color: AppTheme.secondaryColor, size: 5.w),
              onPressed: onRestore,
            ),
        ],
      ),
    );

    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: container,
    );
  }
}
