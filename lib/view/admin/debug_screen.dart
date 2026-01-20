import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'dart:convert';

import '../../controller/utils/database_admin.dart';
import '../../controller/utils/theme/app_theme.dart';

class DebugScreen extends StatefulWidget {
  const DebugScreen({Key? key}) : super(key: key);

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  Map<String, dynamic>? _dbInfo;
  List<Map<String, dynamic>>? _tableInfo;
  List<Map<String, dynamic>>? _memories;
  List<Map<String, dynamic>>? _deletedMemories;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadDatabaseInfo();
  }

  Future<void> _loadDatabaseInfo() async {
    setState(() => _isLoading = true);
    final info = await DatabaseAdmin.getDatabaseInfo();
    final tables = await DatabaseAdmin.getTableInfo();
    final allMemories = await DatabaseAdmin.getAllMemoriesRaw();
    final deletedMemories = await DatabaseAdmin.getDeletedMemoriesRaw();
    
    setState(() {
      _dbInfo = info;
      _tableInfo = tables;
      _memories = allMemories;
      _deletedMemories = deletedMemories;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Database Admin',
          style: AppTheme.getHeadingStyle(fontSize: AppTheme.fontSizeXL.sp),
        ),
        backgroundColor: AppTheme.secondaryColor,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: EdgeInsets.all(5.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDatabaseInfo(),
                    SizedBox(height: 3.h),
                    _buildTableInfo(),
                    SizedBox(height: 3.h),
                    _buildActions(),
                    SizedBox(height: 3.h),
                    _buildMemoriesPreview(),
                    SizedBox(height: 3.h),
                    _buildDeletedMemoriesPreview(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildDatabaseInfo() {
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📊 Database Information',
            style: AppTheme.getHeadingStyle(fontSize: AppTheme.fontSizeXL.sp),
          ),
          SizedBox(height: 2.h),
          if (_dbInfo != null) ...[
            _buildInfoRow('Path', _dbInfo!['path']?.toString() ?? 'N/A'),
            _buildInfoRow('Size', _dbInfo!['size'] != null
                ? '${((_dbInfo!['size'] as int) / 1024).toStringAsFixed(2)} KB'
                : 'N/A'),
            _buildInfoRow('Version', _dbInfo!['version']?.toString() ?? 'N/A'),
            _buildInfoRow('Status', _dbInfo!['isOpen'] == true ? 'Open' : 'Closed'),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
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

  Widget _buildTableInfo() {
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📋 Tables',
            style: AppTheme.getHeadingStyle(fontSize: AppTheme.fontSizeXL.sp),
          ),
          SizedBox(height: 2.h),
          if (_tableInfo != null)
            ..._tableInfo!.map((table) => Padding(
                  padding: EdgeInsets.only(bottom: 1.5.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${table['name']} (${table['count']} records)',
                        style: AppTheme.getBodyStyle(
                          fontSize: AppTheme.fontSizeMedium.sp,
                        ).copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                )),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🔧 Actions',
            style: AppTheme.getHeadingStyle(fontSize: AppTheme.fontSizeXL.sp),
          ),
          SizedBox(height: 2.h),
          _buildActionButton(
            'Print Database Stats',
            Icons.print,
            () async {
              await DatabaseAdmin.printDatabaseStats();
              Get.snackbar('Success', 'Stats printed to console');
            },
          ),
          SizedBox(height: 1.h),
          _buildActionButton(
            'Export Database',
            Icons.download,
            () async {
              final export = await DatabaseAdmin.exportDatabase();
              final jsonString = const JsonEncoder.withIndent('  ').convert(export);
              
              Get.dialog(
                AlertDialog(
                  title: const Text('Database Export'),
                  content: SingleChildScrollView(
                    child: SelectableText(jsonString),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: 1.h),
          _buildActionButton(
            'Show Database Path',
            Icons.folder,
            () => DatabaseAdmin.showDatabasePath(),
          ),
          SizedBox(height: 1.h),
          _buildActionButton(
            'Refresh',
            Icons.refresh,
            _loadDatabaseInfo,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      child: Container(
        padding: EdgeInsets.all(3.w),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.secondaryColor, size: 5.w),
            SizedBox(width: 3.w),
            Text(
              label,
              style: AppTheme.getBodyStyle(fontSize: AppTheme.fontSizeMedium.sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemoriesPreview() {
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '💕 Memories Preview (${_memories?.length ?? 0})',
            style: AppTheme.getHeadingStyle(fontSize: AppTheme.fontSizeXL.sp),
          ),
          SizedBox(height: 2.h),
          if (_memories != null && _memories!.isNotEmpty)
            ..._memories!.take(5).map((memory) => Padding(
                  padding: EdgeInsets.only(bottom: 1.h),
                  child: Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceColor,
                      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                    ),
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
                ))
          else
            Text(
              'No memories found',
              style: AppTheme.getBodyStyle(
                fontSize: AppTheme.fontSizeMedium.sp,
                color: AppTheme.textSecondary.withOpacity(0.5),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDeletedMemoriesPreview() {
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.1),
            blurRadius: 10,
          ),
        ],
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.delete_outline, color: Colors.red, size: 6.w),
              SizedBox(width: 2.w),
              Text(
                '🗑️ Deleted Memories (${_deletedMemories?.length ?? 0})',
                style: AppTheme.getHeadingStyle(
                  fontSize: AppTheme.fontSizeXL.sp,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          if (_deletedMemories != null && _deletedMemories!.isNotEmpty)
            ..._deletedMemories!.take(5).map((memory) => Padding(
                  padding: EdgeInsets.only(bottom: 1.h),
                  child: Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                      border: Border.all(color: Colors.red.withOpacity(0.2)),
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
                        IconButton(
                          icon: Icon(Icons.restore, color: AppTheme.secondaryColor, size: 5.w),
                          onPressed: () async {
                            // Restore functionality would go here
                            Get.snackbar('Info', 'Restore functionality available in admin');
                          },
                        ),
                      ],
                    ),
                  ),
                ))
          else
            Text(
              'No deleted memories',
              style: AppTheme.getBodyStyle(
                fontSize: AppTheme.fontSizeMedium.sp,
                color: AppTheme.textSecondary.withOpacity(0.5),
              ),
            ),
        ],
      ),
    );
  }
}
