import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../controller/utils/theme/app_theme.dart';

class MediaSourceDialog {
  static void show({
    required VoidCallback onTakePhoto,
    required VoidCallback onRecordVideo,
    required VoidCallback onChoosePhotos,
    required VoidCallback onChooseVideo,
  }) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        title: Text(
          'Add Media',
          style: AppTheme.getHeadingStyle(fontSize: AppTheme.fontSizeXL.sp),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt, color: AppTheme.textSecondary),
              title: Text(
                'Take Photo',
                style: AppTheme.getBodyStyle(fontSize: AppTheme.fontSizeMedium.sp),
              ),
              onTap: () {
                Get.back();
                onTakePhoto();
              },
            ),
            ListTile(
              leading: Icon(Icons.videocam, color: AppTheme.textSecondary),
              title: Text(
                'Record Video',
                style: AppTheme.getBodyStyle(fontSize: AppTheme.fontSizeMedium.sp),
              ),
              onTap: () {
                Get.back();
                onRecordVideo();
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: AppTheme.textSecondary),
              title: Text(
                'Choose Photos',
                style: AppTheme.getBodyStyle(fontSize: AppTheme.fontSizeMedium.sp),
              ),
              onTap: () {
                Get.back();
                onChoosePhotos();
              },
            ),
            ListTile(
              leading: Icon(Icons.video_library, color: AppTheme.textSecondary),
              title: Text(
                'Choose Video',
                style: AppTheme.getBodyStyle(fontSize: AppTheme.fontSizeMedium.sp),
              ),
              onTap: () {
                Get.back();
                onChooseVideo();
              },
            ),
          ],
        ),
      ),
    );
  }
}
