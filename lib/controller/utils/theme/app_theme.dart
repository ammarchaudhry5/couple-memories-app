import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFFFFB6C1);
  static const Color secondaryColor = Color(0xFFB76E79);
  static const Color surfaceColor = Color(0xFFFFF5EE);
  static const Color accentColor = Color(0xFFE6E6FA);
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFFB76E79);

  // Font Sizes (Base sizes - will be scaled with responsive_sizer)
  static const double fontSizeSmall = 12.0;
  static const double fontSizeBody = 14.0;
  static const double fontSizeMedium = 16.0;
  static const double fontSizeLarge = 18.0;
  static const double fontSizeXL = 20.0;
  static const double fontSizeXXL = 24.0;
  static const double fontSizeHeading = 28.0;
  static const double fontSizeTitle = 32.0;
  static const double fontSizeDisplay = 42.0;

  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 12.0;
  static const double spacingLarge = 16.0;
  static const double spacingXL = 20.0;
  static const double spacingXXL = 24.0;
  static const double spacingXXXL = 32.0;

  // Border Radius
  static const double radiusSmall = 12.0;
  static const double radiusMedium = 16.0;
  static const double radiusLarge = 20.0;
  static const double radiusXL = 24.0;
  static const double radiusXXXL = 30.0;

  // Text Styles
  static TextStyle getHeadingStyle({Color? color, double? fontSize}) {
    return GoogleFonts.playfairDisplay(
      fontSize: fontSize ?? fontSizeHeading,
      fontWeight: FontWeight.bold,
      color: color ?? textSecondary,
      letterSpacing: 0.5,
    );
  }

  static TextStyle getTitleStyle({Color? color, double? fontSize}) {
    return GoogleFonts.playfairDisplay(
      fontSize: fontSize ?? fontSizeTitle,
      fontWeight: FontWeight.bold,
      color: color ?? textSecondary,
      letterSpacing: 1.0,
    );
  }

  static TextStyle getBodyStyle({Color? color, double? fontSize}) {
    return GoogleFonts.poppins(
      fontSize: fontSize ?? fontSizeBody,
      color: color ?? textPrimary,
      height: 1.6,
    );
  }

  static TextStyle getCaptionStyle({Color? color, double? fontSize}) {
    return GoogleFonts.poppins(
      fontSize: fontSize ?? fontSizeSmall,
      color: color ?? textSecondary.withOpacity(0.6),
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle getScriptStyle({Color? color, double? fontSize}) {
    return GoogleFonts.dancingScript(
      fontSize: fontSize ?? fontSizeLarge,
      color: color ?? textSecondary,
      fontWeight: FontWeight.w500,
    );
  }

  // Gradients
  static LinearGradient get primaryGradient => LinearGradient(
        colors: [primaryColor, secondaryColor],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get backgroundGradient => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          surfaceColor,
          primaryColor.withOpacity(0.1),
        ],
      );

  static LinearGradient get cardGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          primaryColor.withOpacity(0.3),
          accentColor.withOpacity(0.3),
        ],
      );

  // Theme Data
  static ThemeData get themeData => ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: surfaceColor,
        colorScheme: const ColorScheme.light(
          primary: primaryColor,
          secondary: secondaryColor,
          surface: surfaceColor,
        ),
        textTheme: TextTheme(
          displayLarge: getTitleStyle(),
          displayMedium: getHeadingStyle(),
          bodyLarge: getBodyStyle(),
          bodyMedium: getBodyStyle(fontSize: fontSizeMedium),
          bodySmall: getCaptionStyle(),
        ),
      );
}