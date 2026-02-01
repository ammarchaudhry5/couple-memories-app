import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../utils/navigation_helper.dart';
import 'quick_link_tile_widget.dart';
import 'admin_section_card_widget.dart';

class QuickLinksSectionWidget extends StatelessWidget {
  const QuickLinksSectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdminSectionCardWidget(
      title: '🔗 Quick Links',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          QuickLinkTileWidget(
            title: 'Database Admin',
            icon: Icons.storage,
            onTap: NavigationHelper.toDatabaseAdmin,
          ),
          SizedBox(height: 1.h),
          QuickLinkTileWidget(
            title: 'Memories Admin',
            icon: Icons.photo_library,
            onTap: NavigationHelper.toMemoriesAdmin,
          ),
        ],
      ),
    );
  }
}
