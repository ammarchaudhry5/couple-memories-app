import 'package:flutter/material.dart';
import 'admin_section_card_widget.dart';
import 'info_row_widget.dart';

class DatabaseInfoWidget extends StatelessWidget {
  final Map<String, dynamic>? dbInfo;

  const DatabaseInfoWidget({
    Key? key,
    required this.dbInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdminSectionCardWidget(
      title: '📊 Database Information',
      child: dbInfo != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfoRowWidget(
                  label: 'Path',
                  value: dbInfo!['path']?.toString() ?? 'N/A',
                ),
                InfoRowWidget(
                  label: 'Size',
                  value: dbInfo!['size'] != null
                      ? '${((dbInfo!['size'] as int) / 1024).toStringAsFixed(2)} KB'
                      : 'N/A',
                ),
                InfoRowWidget(
                  label: 'Version',
                  value: dbInfo!['version']?.toString() ?? 'N/A',
                ),
                InfoRowWidget(
                  label: 'Status',
                  value: dbInfo!['isOpen'] == true ? 'Open' : 'Closed',
                ),
              ],
            )
          : const SizedBox.shrink(),
    );
  }
}
