import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/theme/app_colors.dart';

Color _primaryColor = AppColors.primary; // Copper gold
Color _secondaryColor = AppColors.goldLight; // Soft gold (brand black is the background here)

ThemeData dark = ThemeData(
  fontFamily: 'IBMPlexSansArabic-Medium',
  primaryColor: _primaryColor,
  brightness: Brightness.dark,
  highlightColor: AppColors.card,
  hintColor: AppColors.textSecondary,
  cardColor: AppColors.card,
  scaffoldBackgroundColor: AppColors.background,
  splashColor: Colors.transparent,


  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppColors.textPrimary),  // Text color primary
    bodyMedium: TextStyle(color: AppColors.textSecondary), // Text color Secondary
    bodySmall: TextStyle(color: AppColors.textMuted),  // Text color Light grey
  ),

  colorScheme : ColorScheme.dark(
    primary: _primaryColor,  // Primary Color
    secondary: _secondaryColor,  // Secondary Color
    tertiary: const Color(0xFFFFBB38), // Warning Color
    tertiaryContainer: const Color(0xFF4A3B2A), // Warm orange-neutral tile/sheet tint
    surface: AppColors.surface,
    onPrimary: AppColors.goldLight, // Light accent tint
    onTertiaryContainer: const Color(0xFF04BB7B), // Success Color
    primaryContainer: AppColors.goldTintDark,
    onSecondaryContainer: const Color(0x912A2A2A),
    outline: const Color(0xff5C8FFC), // Info Color
    onTertiary: AppColors.border,
    secondaryContainer: const Color(0xFFEFEAE2), // Warm neutral shimmer tone
    surfaceContainer: const Color(0xFFFB6C4C),
    error: const Color(0xFFFF4040), // Danger Color
    shadow: const Color(0xFFF4F7FC),
  ),

  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),
);
