import 'dart:ui';

class AppThemeModel {
  final Color primary;
  final Color secondary;

  // Home
  final List<Color> homeGradient;
  final Color overlayColor;

  // Banners
  final Color bannerBackground;
  final Color bannerText;
  final Color bannerAccent;

  const AppThemeModel({
    required this.primary,
    required this.secondary,
    required this.homeGradient,
    required this.overlayColor,
    required this.bannerBackground,
    required this.bannerText,
    required this.bannerAccent,
  });
}
