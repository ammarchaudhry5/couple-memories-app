import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AppSettings {
  // Color Palettes
  static const List<ColorPalette> colorPalettes = [
    ColorPalette(
      name: 'Romantic Rose',
      id: 'romantic_rose',
      primaryColor: Color(0xFFFFB6C1),
      secondaryColor: Color(0xFFB76E79),
      surfaceColor: Color(0xFFFFF5EE),
      accentColor: Color(0xFFE6E6FA),
      textPrimary: Color(0xFF2C3E50),
      textSecondary: Color(0xFFB76E79),
    ),
    ColorPalette(
      name: 'Ocean Breeze',
      id: 'ocean_breeze',
      primaryColor: Color(0xFF87CEEB),
      secondaryColor: Color(0xFF4682B4),
      surfaceColor: Color(0xFFF0F8FF),
      accentColor: Color(0xFFE0F7FA),
      textPrimary: Color(0xFF1A237E),
      textSecondary: Color(0xFF4682B4),
    ),
    ColorPalette(
      name: 'Sunset Dream',
      id: 'sunset_dream',
      primaryColor: Color(0xFFFFA07A),
      secondaryColor: Color(0xFFFF6347),
      surfaceColor: Color(0xFFFFF8F0),
      accentColor: Color(0xFFFFE4E1),
      textPrimary: Color(0xFF5D4037),
      textSecondary: Color(0xFFFF6347),
    ),
    ColorPalette(
      name: 'Lavender Fields',
      id: 'lavender_fields',
      primaryColor: Color(0xFFE6E6FA),
      secondaryColor: Color(0xFF9370DB),
      surfaceColor: Color(0xFFFAF0FF),
      accentColor: Color(0xFFF0E6FF),
      textPrimary: Color(0xFF4A148C),
      textSecondary: Color(0xFF9370DB),
    ),
    ColorPalette(
      name: 'Forest Serenity',
      id: 'forest_serenity',
      primaryColor: Color(0xFF98D8C8),
      secondaryColor: Color(0xFF6B8E23),
      surfaceColor: Color(0xFFF5FFFA),
      accentColor: Color(0xFFE8F5E9),
      textPrimary: Color(0xFF1B5E20),
      textSecondary: Color(0xFF6B8E23),
    ),
    ColorPalette(
      name: 'Golden Hour',
      id: 'golden_hour',
      primaryColor: Color(0xFFFFD700),
      secondaryColor: Color(0xFFFF8C00),
      surfaceColor: Color(0xFFFFFEF0),
      accentColor: Color(0xFFFFF8DC),
      textPrimary: Color(0xFF8B4513),
      textSecondary: Color(0xFFFF8C00),
    ),
    ColorPalette(
      name: 'Midnight Blue',
      id: 'midnight_blue',
      primaryColor: Color(0xFF191970),
      secondaryColor: Color(0xFF4169E1),
      surfaceColor: Color(0xFFF0F4FF),
      accentColor: Color(0xFFE3F2FD),
      textPrimary: Color(0xFF0D47A1),
      textSecondary: Color(0xFF4169E1),
    ),
    ColorPalette(
      name: 'Cherry Blossom',
      id: 'cherry_blossom',
      primaryColor: Color(0xFFFFB3BA),
      secondaryColor: Color(0xFFFF6B9D),
      surfaceColor: Color(0xFFFFF0F5),
      accentColor: Color(0xFFFFE4E9),
      textPrimary: Color(0xFF880E4F),
      textSecondary: Color(0xFFFF6B9D),
    ),
  ];

  // Font Options
  static const List<FontOption> fontOptions = [
    FontOption(name: 'Playfair Display', id: 'playfair', package: 'google_fonts'),
    FontOption(name: 'Dancing Script', id: 'dancing', package: 'google_fonts'),
    FontOption(name: 'Cormorant Garamond', id: 'cormorant', package: 'google_fonts'),
    FontOption(name: 'Lora', id: 'lora', package: 'google_fonts'),
    FontOption(name: 'Merriweather', id: 'merriweather', package: 'google_fonts'),
    FontOption(name: 'Poppins', id: 'poppins', package: 'google_fonts'),
    FontOption(name: 'Roboto', id: 'roboto', package: 'google_fonts'),
    FontOption(name: 'Montserrat', id: 'montserrat', package: 'google_fonts'),
    FontOption(name: 'Raleway', id: 'raleway', package: 'google_fonts'),
    FontOption(name: 'Open Sans', id: 'opensans', package: 'google_fonts'),
  ];

  // Text Customization
  String appTitle = 'Our Love Story';
  String appSubtitle = 'Forever and Always';
  String daysCounterText = 'Days of loving you';
  String newMemoryButton = 'New Memory';
  String timelineTab = 'Timeline';
  String galleryTab = 'Gallery';
  String favoritesTab = 'Favorites';

  // Selected Settings
  ColorPalette selectedPalette;
  FontOption selectedFont;

  AppSettings({
    this.selectedPalette = const ColorPalette.romanticRose(),
    this.selectedFont = const FontOption.playfair(),
  }) {
    selectedPalette = colorPalettes.first;
    selectedFont = fontOptions.first;
  }

  // Load settings from SharedPreferences
  static Future<AppSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    final settings = AppSettings();

    // Load color palette
    final paletteId = prefs.getString('color_palette_id') ?? 'romantic_rose';
    settings.selectedPalette = colorPalettes.firstWhere(
      (p) => p.id == paletteId,
      orElse: () => colorPalettes.first,
    );

    // Load font
    final fontId = prefs.getString('font_id') ?? 'playfair';
    settings.selectedFont = fontOptions.firstWhere(
      (f) => f.id == fontId,
      orElse: () => fontOptions.first,
    );

    // Load text customizations
    settings.appTitle = prefs.getString('app_title') ?? 'Our Love Story';
    settings.appSubtitle = prefs.getString('app_subtitle') ?? 'Forever and Always';
    settings.daysCounterText = prefs.getString('days_counter_text') ?? 'Days of loving you';
    settings.newMemoryButton = prefs.getString('new_memory_button') ?? 'New Memory';
    settings.timelineTab = prefs.getString('timeline_tab') ?? 'Timeline';
    settings.galleryTab = prefs.getString('gallery_tab') ?? 'Gallery';
    settings.favoritesTab = prefs.getString('favorites_tab') ?? 'Favorites';

    return settings;
  }

  // Save settings to SharedPreferences
  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('color_palette_id', selectedPalette.id);
    await prefs.setString('font_id', selectedFont.id);
    await prefs.setString('app_title', appTitle);
    await prefs.setString('app_subtitle', appSubtitle);
    await prefs.setString('days_counter_text', daysCounterText);
    await prefs.setString('new_memory_button', newMemoryButton);
    await prefs.setString('timeline_tab', timelineTab);
    await prefs.setString('gallery_tab', galleryTab);
    await prefs.setString('favorites_tab', favoritesTab);
  }
}

class ColorPalette {
  final String name;
  final String id;
  final Color primaryColor;
  final Color secondaryColor;
  final Color surfaceColor;
  final Color accentColor;
  final Color textPrimary;
  final Color textSecondary;

  const ColorPalette({
    required this.name,
    required this.id,
    required this.primaryColor,
    required this.secondaryColor,
    required this.surfaceColor,
    required this.accentColor,
    required this.textPrimary,
    required this.textSecondary,
  });

  const ColorPalette.romanticRose()
      : name = 'Romantic Rose',
        id = 'romantic_rose',
        primaryColor = const Color(0xFFFFB6C1),
        secondaryColor = const Color(0xFFB76E79),
        surfaceColor = const Color(0xFFFFF5EE),
        accentColor = const Color(0xFFE6E6FA),
        textPrimary = const Color(0xFF2C3E50),
        textSecondary = const Color(0xFFB76E79);
}

class FontOption {
  final String name;
  final String id;
  final String package;

  const FontOption({
    required this.name,
    required this.id,
    required this.package,
  });

  const FontOption.playfair()
      : name = 'Playfair Display',
        id = 'playfair',
        package = 'google_fonts';
}
