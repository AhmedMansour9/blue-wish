import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/theme/app_colors.dart';

Color _primaryColor = AppColors.primary; // Teal
Color _secondaryColor = AppColors.accent; // Navy


ThemeData light({Color? primaryColor, Color? secondaryColor})=> ThemeData(
  fontFamily: 'IBMPlexSansArabic-Medium',
  primaryColor: _primaryColor,
  brightness: Brightness.light,
  highlightColor: Colors.white,
  hintColor: AppColors.border, //Border Color
  splashColor: Colors.transparent,
  cardColor: AppColors.white,

  scaffoldBackgroundColor: AppColors.background,

  textTheme: TextTheme(
    bodyLarge: const TextStyle(color: AppColors.textPrimary),  // Text color primary
    bodyMedium: const TextStyle(color: AppColors.textSecondary), // Text color Secondary
    bodySmall: const TextStyle(color: Color(0xFFA7A7A7)),  // Text color Light grey

    titleMedium: const TextStyle(color: Color(0xFF656566)),

  ),

  colorScheme:  ColorScheme.light(
    primary: _primaryColor,  // Primary Color
    secondary: _secondaryColor,  // Secondary Color
    tertiary: const Color(0xFFFFBB38), // Warning Color
    tertiaryContainer: const Color(0xFFFFE0B2), // Warm orange tile/sheet tint
    onTertiaryContainer: const Color(0xFF04BB7B), // Success Color
    onPrimary: AppColors.lightBlue, // Light Blue tint
    surface: AppColors.white,
    onSecondary: secondaryColor ?? AppColors.lightBlue, // Light accent tint
    error: const Color(0xFFFF4040), // Danger Color
    onSecondaryContainer: AppColors.background,
    outline: const Color(0xff5C8FFC), // Info Color
    onTertiary: AppColors.border, // Tile/border fill
    shadow: AppColors.blue,

    primaryContainer: AppColors.lightBlue,
    secondaryContainer: AppColors.border, // Neutral shimmer tone
  ),

  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.android: CupertinoPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),
);
