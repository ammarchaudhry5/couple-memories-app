import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../controller/utils/database_admin.dart';
import '../../controller/utils/theme/app_theme.dart';
import '../widgets/admin/admin_app_bar_widget.dart';
import '../widgets/admin/admin_settings_list_widget.dart';
// Keep imports for future use (not removing widgets)
// import '../widgets/admin/database_info_widget.dart';
// import '../widgets/admin/table_info_widget.dart';
// import '../widgets/admin/admin_actions_section_widget.dart';
// import '../widgets/admin/memories_preview_widget.dart';
// import '../widgets/admin/deleted_memories_preview_widget.dart';
// import '../widgets/admin/settings_section_widget.dart';
// import '../widgets/admin/quick_links_section_widget.dart';

class DebugScreen extends StatefulWidget {
  const DebugScreen({Key? key}) : super(key: key);

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  // Keep state variables for future use (not removing them)
  // Map<String, dynamic>? _dbInfo;
  // List<Map<String, dynamic>>? _tableInfo;
  // List<Map<String, dynamic>>? _memories;
  // List<Map<String, dynamic>>? _deletedMemories;
  // bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // _loadDatabaseInfo(); // Commented for now, will be used in future
  }

  // Keep method for future use
  // Future<void> _loadDatabaseInfo() async {
  //   setState(() => _isLoading = true);
  //   final info = await DatabaseAdmin.getDatabaseInfo();
  //   final tables = await DatabaseAdmin.getTableInfo();
  //   final allMemories = await DatabaseAdmin.getAllMemoriesRaw();
  //   final deletedMemories = await DatabaseAdmin.getDeletedMemoriesRaw();
  //   
  //   setState(() {
  //     _dbInfo = info;
  //     _tableInfo = tables;
  //     _memories = allMemories;
  //     _deletedMemories = deletedMemories;
  //     _isLoading = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AdminAppBarWidget(title: 'Settings'),
      body: const AdminSettingsListWidget(),
      // Old implementation kept for reference (commented out)
      // body: Container(
      //   decoration: BoxDecoration(
      //     gradient: AppTheme.backgroundGradient,
      //   ),
      //   child: _isLoading
      //       ? const Center(child: CircularProgressIndicator())
      //       : SingleChildScrollView(
      //           padding: EdgeInsets.all(5.w),
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               const SettingsSectionWidget(),
      //               SizedBox(height: 3.h),
      //               const QuickLinksSectionWidget(),
      //               SizedBox(height: 3.h),
      //               DatabaseInfoWidget(dbInfo: _dbInfo),
      //               SizedBox(height: 3.h),
      //               TableInfoWidget(tableInfo: _tableInfo),
      //               SizedBox(height: 3.h),
      //               AdminActionsSectionWidget(onRefresh: _loadDatabaseInfo),
      //               SizedBox(height: 3.h),
      //               MemoriesPreviewWidget(memories: _memories, maxItems: 5, title: '💕 Memories Preview'),
      //               SizedBox(height: 3.h),
      //               DeletedMemoriesPreviewWidget(deletedMemories: _deletedMemories, maxItems: 5),
      //             ],
      //           ),
      //         ),
      // ),
    );
  }

}
