import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../controller/utils/theme/app_theme.dart';
import 'admin_section_card_widget.dart';

class TableInfoWidget extends StatelessWidget {
  final List<Map<String, dynamic>>? tableInfo;

  const TableInfoWidget({
    Key? key,
    required this.tableInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdminSectionCardWidget(
      title: '📋 Tables',
      child: tableInfo != null && tableInfo!.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: tableInfo!.map((table) => Padding(
                    padding: EdgeInsets.only(bottom: 1.5.h),
                    child: Text(
                      '${table['name']} (${table['count']} records)',
                      style: AppTheme.getBodyStyle(
                        fontSize: AppTheme.fontSizeMedium.sp,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                  )).toList(),
            )
          : const SizedBox.shrink(),
    );
  }
}
