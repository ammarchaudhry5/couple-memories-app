import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../controller/utils/theme/app_theme.dart';
import 'admin_section_card_widget.dart';
import 'memory_item_widget.dart';

class MemoriesPreviewWidget extends StatelessWidget {
  final List<Map<String, dynamic>>? memories;
  final int maxItems;
  final String title;

  const MemoriesPreviewWidget({
    Key? key,
    required this.memories,
    this.maxItems = 10,
    this.title = '💕 Memories',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdminSectionCardWidget(
      title: '$title (${memories?.length ?? 0})',
      child: memories != null && memories!.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: memories!.take(maxItems).map((memory) => MemoryItemWidget(
                    memory: memory,
                  )).toList(),
            )
          : Text(
              'No memories found',
              style: AppTheme.getBodyStyle(
                fontSize: AppTheme.fontSizeMedium.sp,
                color: AppTheme.textSecondary.withOpacity(0.5),
              ),
            ),
    );
  }
}
