import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/theme/app_colors.dart';

Color _primaryColor = AppColors.primary; // Copper gold
Color _secondaryColor = AppColors.secondary; // Brand black


ThemeData light({Color? primaryColor, Color? secondaryColor})=> ThemeData(
  fontFamily: 'IBMPlexSansArabic-Medium',
  primaryColor: _primaryColor,
  brightness: Brightness.light,
  highlightColor: Colors.white,
  hintColor: AppColors.lightBorder, //Border Color
  splashColor: Colors.transparent,
  cardColor: AppColors.white,

  scaffoldBackgroundColor: AppColors.lightBackground,

  textTheme: TextTheme(
    bodyLarge: const TextStyle(color: AppColors.lightTextPrimary),  // Text color primary
    bodyMedium: const TextStyle(color: AppColors.lightTextSecondary), // Text color Secondary
    bodySmall: const TextStyle(color: Color(0xFFA7A7A7)),  // Text color Light grey

    titleMedium: const TextStyle(color: Color(0xFF656566)),

  ),

  colorScheme:  ColorScheme.light(
    primary: _primaryColor,  // Primary Color
    secondary: _secondaryColor,  // Secondary Color
    tertiary: const Color(0xFFFFBB38), // Warning Color
    tertiaryContainer: const Color(0xFFFFE0B2), // Warm orange tile/sheet tint
    onTertiaryContainer: const Color(0xFF04BB7B), // Success Color
    onPrimary: AppColors.goldTintLight, // Light gold tint
    surface: AppColors.white,
    onSecondary: secondaryColor ?? AppColors.goldTintLight, // Light accent tint
    error: const Color(0xFFFF4040), // Danger Color
    onSecondaryContainer: AppColors.lightBackground,
    outline: const Color(0xff5C8FFC), // Info Color
    onTertiary: AppColors.lightBorder, // Tile/border fill
    shadow: AppColors.secondary,

    primaryContainer: AppColors.goldTintLight,
    secondaryContainer: AppColors.lightBorder, // Neutral shimmer tone
  ),

  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.android: CupertinoPageTransitionsBuilder(),
    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),
);
