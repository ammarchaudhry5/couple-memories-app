import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:yaaram/controller/memory_controller.dart';
import 'package:yaaram/model/memory_model/memory_model.dart';
import 'package:yaaram/model/media_file_model/media_file_model.dart';
import 'package:yaaram/view/memory_detail_screen/memory_detail_screen.dart';

import '../../controller/utils/theme/app_theme.dart';
import '../widgets/memory_card_media.dart';

class AddMemoryScreen extends StatefulWidget {
  const AddMemoryScreen({Key? key}) : super(key: key);

  @override
  State<AddMemoryScreen> createState() => _AddMemoryScreenState();
}

class _AddMemoryScreenState extends State<AddMemoryScreen>
    with TickerProviderStateMixin {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _memoryController = Get.find<MemoryController>();
  final ImagePicker _imagePicker = ImagePicker();
  
  DateTime _selectedDate = DateTime.now();
  List<MediaFile> _selectedMedia = [];
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));

    _slideController.forward();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _pickMedia(ImageSource source, bool isImage) async {
    try {
      if (isImage) {
        final pickedFiles = await _imagePicker.pickMultiImage();
        if (pickedFiles.isNotEmpty) {
          setState(() {
            _selectedMedia.addAll(
              pickedFiles.map((file) => MediaFile(
                    path: file.path,
                    type: MediaType.image,
                  )),
            );
          });
        }
      } else {
        // For single image from camera or single video
        final pickedFile = isImage
            ? await _imagePicker.pickImage(source: source)
            : await _imagePicker.pickVideo(source: source);
        
        if (pickedFile != null) {
          setState(() {
            _selectedMedia.add(MediaFile(
              path: pickedFile.path,
              type: isImage ? MediaType.image : MediaType.video,
            ));
          });
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick media: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _showMediaSourceDialog() {
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
                _pickMedia(ImageSource.camera, true);
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
                _pickMedia(ImageSource.camera, false);
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
                _pickMedia(ImageSource.gallery, true);
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
                _pickMedia(ImageSource.gallery, false);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _removeMedia(int index) {
    setState(() {
      _selectedMedia.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _slideController,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create a New Memory',
                            style: AppTheme.getTitleStyle(
                              fontSize: AppTheme.fontSizeTitle.sp,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Capture this beautiful moment forever',
                            style: AppTheme.getScriptStyle(
                              fontSize: AppTheme.fontSizeLarge.sp,
                              color: AppTheme.textSecondary.withOpacity(0.7),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          _buildMediaPicker(),
                          if (_selectedMedia.isNotEmpty) SizedBox(height: 2.h),
                          if (_selectedMedia.isNotEmpty)
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(AppTheme.radiusXL),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primaryColor.withOpacity(0.1),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(AppTheme.radiusXL),
                                child: MemoryCardMedia(
                                  mediaFiles: _selectedMedia,
                                  showDeleteButton: true,
                                  onDelete: _removeMedia,
                                ),
                              ),
                            ),
                          SizedBox(height: 3.h),
                          _buildTextField(
                            controller: _titleController,
                            label: 'Memory Title',
                            hint: 'Give this moment a beautiful name...',
                            icon: Icons.title,
                          ),
                          SizedBox(height: 2.5.h),
                          _buildTextField(
                            controller: _descriptionController,
                            label: 'Your Story',
                            hint: 'What made this moment special?',
                            icon: Icons.edit_note,
                            maxLines: 5,
                          ),
                          SizedBox(height: 2.5.h),
                          _buildTextField(
                            controller: _locationController,
                            label: 'Where?',
                            hint: 'The place where magic happened...',
                            icon: Icons.location_on,
                          ),
                          SizedBox(height: 2.5.h),
                          _buildDatePicker(),
                          SizedBox(height: 4.h),
                          _buildSaveButton(),
                          SizedBox(height: 2.5.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Icon(
                Icons.close,
                color: AppTheme.textSecondary,
                size: 5.w,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            'New Memory',
            style: AppTheme.getHeadingStyle(
              fontSize: AppTheme.fontSizeXXL.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaPicker() {
    return GestureDetector(
      onTap: _showMediaSourceDialog,
      child: Container(
        height: 15.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.radiusXL),
          gradient: AppTheme.cardGradient,
          border: Border.all(
            color: AppTheme.primaryColor.withOpacity(0.5),
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
              child: Icon(
                Icons.add_photo_alternate,
                size: 8.w,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 3.w),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Media',
                  style: AppTheme.getHeadingStyle(
                    fontSize: AppTheme.fontSizeXL.sp,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Photos & Videos',
                  style: AppTheme.getCaptionStyle(
                    fontSize: AppTheme.fontSizeSmall.sp,
                    color: AppTheme.textSecondary.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 5.w,
              color: AppTheme.textSecondary,
            ),
            SizedBox(width: 2.w),
            Text(
              label,
              style: AppTheme.getBodyStyle(
                fontSize: AppTheme.fontSizeBody.sp,
                color: AppTheme.textSecondary,
              ).copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        SizedBox(height: 1.5.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            style: AppTheme.getBodyStyle(
              fontSize: AppTheme.fontSizeMedium.sp,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTheme.getBodyStyle(
                fontSize: AppTheme.fontSizeBody.sp,
                color: AppTheme.textSecondary.withOpacity(0.4),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.all(5.w),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: AppTheme.secondaryColor,
                  onPrimary: Colors.white,
                  surface: Colors.white,
                  onSurface: AppTheme.textPrimary,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          setState(() {
            _selectedDate = picked;
          });
        }
      },
      child: Container(
        padding: EdgeInsets.all(5.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.5.w),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: Icon(
                Icons.calendar_today,
                color: Colors.white,
                size: 5.w,
              ),
            ),
            SizedBox(width: 4.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Date',
                  style: AppTheme.getCaptionStyle(
                    fontSize: AppTheme.fontSizeSmall.sp,
                    color: AppTheme.textSecondary.withOpacity(0.6),
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  '${_selectedDate.day} ${_getMonthName(_selectedDate.month)} ${_selectedDate.year}',
                  style: AppTheme.getBodyStyle(
                    fontSize: AppTheme.fontSizeMedium.sp,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      height: 7.h,
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            if (_titleController.text.trim().isEmpty) {
              Get.snackbar(
                'Error',
                'Please enter a title for your memory',
                snackPosition: SnackPosition.BOTTOM,
              );
              return;
            }

            final newMemory = Memory(
              id: DateTime.now().millisecondsSinceEpoch,
              date: _selectedDate,
              title: _titleController.text.trim(),
              description: _descriptionController.text.trim(),
              location: _locationController.text.trim(),
              isFavorite: false,
              isDeleted: false,
              mediaFiles: _selectedMedia,
            );

            final createdMemory = await _memoryController.addMemory(newMemory);
            
            // Navigate back to home
            Get.back();
            
            if (createdMemory != null) {
              // Show success message - memory will appear in home page
              Get.snackbar(
                'Success',
                'Memory created successfully!',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: AppTheme.secondaryColor,
                colorText: Colors.white,
                duration: const Duration(seconds: 2),
              );
            }
          },
          borderRadius: BorderRadius.circular(30),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.favorite,
                  color: Colors.white,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Save Memory',
                  style: AppTheme.getBodyStyle(
                    fontSize: AppTheme.fontSizeLarge.sp,
                    color: Colors.white,
                  ).copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}