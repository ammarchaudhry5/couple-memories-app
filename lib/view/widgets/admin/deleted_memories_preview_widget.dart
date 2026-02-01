import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../controller/utils/theme/app_theme.dart';
import 'admin_section_card_widget.dart';
import 'memory_item_widget.dart';

class DeletedMemoriesPreviewWidget extends StatelessWidget {
  final List<Map<String, dynamic>>? deletedMemories;
  final int maxItems;

  const DeletedMemoriesPreviewWidget({
    Key? key,
    required this.deletedMemories,
    this.maxItems = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdminSectionCardWidget(
      title: '🗑️ Deleted Memories (${deletedMemories?.length ?? 0})',
      titleIcon: Icons.delete_outline,
      borderColor: Colors.red,
      child: deletedMemories != null && deletedMemories!.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: deletedMemories!.take(maxItems).map((memory) => MemoryItemWidget(
                    memory: memory,
                    isDeleted: true,
                    onRestore: () {
                      Get.snackbar('Info', 'Restore functionality available in admin');
                    },
                  )).toList(),
            )
          : Text(
              'No deleted memories',
              style: AppTheme.getBodyStyle(
                fontSize: AppTheme.fontSizeMedium.sp,
                color: AppTheme.textSecondary.withOpacity(0.5),
              ),
            ),
    );
  }
}
