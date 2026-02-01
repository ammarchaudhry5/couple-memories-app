import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../controller/utils/settings/settings_controller.dart';
import '../../controller/utils/theme/app_theme.dart';

class AppLogoWidget extends StatelessWidget {
  final double size;
  final bool showShadow;

  const AppLogoWidget({
    Key? key,
    this.size = 25.0,
    this.showShadow = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final settingsController = Get.find<SettingsController>();
      final palette = settingsController.settings.value.selectedPalette;
      
      return Container(
        width: size.w,
        height: size.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: palette.surfaceColor,
          boxShadow: showShadow
              ? [
                  BoxShadow(
                    color: palette.primaryColor.withOpacity(0.3),
                    blurRadius: 30,
                    spreadRadius: 10,
                  ),
                ]
              : null,
        ),
        child: ClipOval(
          child: Padding(
            padding: EdgeInsets.all(size.w * 0.15),
            child: SvgPicture.asset(
              'assets/images/logo.svg',
              width: size.w * 0.7,
              height: size.w * 0.7,
              fit: BoxFit.contain,
              allowDrawingOutsideViewBox: true,
              semanticsLabel: 'App Logo',
            ),
          ),
        ),
      );
    });
  }
}
