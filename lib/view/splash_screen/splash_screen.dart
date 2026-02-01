import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../controller/utils/settings/settings_controller.dart';
import '../../controller/utils/theme/app_theme.dart';
import '../home_screen/home_screen.dart';
import '../widgets/app_logo_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _heartController;
  late AnimationController _textController;
  late Animation<double> _heartScale;
  late Animation<double> _textOpacity;

  @override
  void initState() {
    super.initState();

    _heartController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _heartScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _heartController, curve: Curves.elasticOut),
    );

    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );

    _heartController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      _textController.forward();
    });

    Future.delayed(const Duration(seconds: 3), () {
      Get.off(() => const HomeScreen(), transition: Transition.fadeIn);
    });
  }

  @override
  void dispose() {
    _heartController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsController = Get.find<SettingsController>();
    final settings = settingsController.settings.value;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryColor.withOpacity(0.3),
              AppTheme.accentColor.withOpacity(0.3),
              AppTheme.surfaceColor,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _heartScale,
                child: const AppLogoWidget(
                  size: 25.0,
                  showShadow: true,
                ),
              ),
              SizedBox(height: 5.h),
              FadeTransition(
                opacity: _textOpacity,
                child: Column(
                  children: [
                    Text(
                      settings.appTitle,
                      // 'Our Love Story',
                      style: AppTheme.getTitleStyle(
                        fontSize: AppTheme.fontSizeDisplay.sp,
                        color: AppTheme.textSecondary,
                      ).copyWith(letterSpacing: 1.5),
                    ),
                    SizedBox(height: 1.5.h),
                    Text(
                      settings.appSubtitle,
                      // 'Every moment with you is a treasure',
                      style: AppTheme.getScriptStyle(
                        fontSize: AppTheme.fontSizeXL.sp,
                        color: AppTheme.textSecondary.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}