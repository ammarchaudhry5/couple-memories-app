import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../controller/utils/theme/app_theme.dart';

class ActionButtonWidget extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isFavorite;

  const ActionButtonWidget({
    Key? key,
    required this.icon,
    required this.onTap,
    this.isFavorite = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
          icon,
          color: isFavorite ? AppTheme.secondaryColor : AppTheme.textSecondary,
          size: 5.w,
        ),
      ),
    );
  }
}
