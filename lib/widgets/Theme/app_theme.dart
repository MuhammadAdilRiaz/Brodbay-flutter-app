import 'package:brodbay/models/theme_model.dart';
import 'package:flutter/material.dart';


const AppThemeModel defaultTheme = AppThemeModel(
  primary: Color(0xFFFF6304),
  secondary: Color(0xFFFF7D26),
  homeGradient: [],
  overlayColor: Color(0xCCFFFFFF),
  bannerBackground: Color(0xFFFF7D26),
  bannerText: Colors.white,
  bannerAccent: Color(0xFFFFD180),
);

const AppThemeModel pinkSaleTheme = AppThemeModel(
  primary: Colors.pink,
  secondary: Colors.pinkAccent,
  homeGradient: [
    Color(0xFFE91E63),
    Color(0xFFF06292),
    Color(0xFFF8BBD0),
    Color(0xFFFFFFFF),
  ],
  overlayColor: Color(0xCCFFFFFF),
  bannerBackground: Colors.pinkAccent,
  bannerText: Colors.white,
  bannerAccent: Color(0xFFF8BBD0),
);

const AppThemeModel greenSaleTheme = AppThemeModel(
  primary: Colors.green,
  secondary: Colors.lightGreen,
  homeGradient: [
    Color(0xFF2E7D32),
    Color(0xFF66BB6A),
    Color(0xFFC8E6C9),
    Color(0xFFFFFFFF),
  ],
  overlayColor: Color(0xCCFFFFFF),
  bannerBackground: Colors.lightGreen,
  bannerText: Colors.white,
  bannerAccent: Color(0xFFC8E6C9),
);
