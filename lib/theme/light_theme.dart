import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Color _primaryColor = const Color(0xFF2E7D32); // Olive Green
Color _secondaryColor = const Color(0xFFF57C00); // Warm Orange


ThemeData light({Color? primaryColor, Color? secondaryColor})=> ThemeData(
  fontFamily: 'TitilliumWeb',
  primaryColor: _primaryColor,
  brightness: Brightness.light,
  highlightColor: Colors.white,
  hintColor: const Color(0xFFA7A7A7), //Border Color
  splashColor: Colors.transparent,
  cardColor: Colors.white,

  scaffoldBackgroundColor: const Color(0xFFFFFDF8), // Off White

  textTheme: TextTheme(
    bodyLarge: const TextStyle(color: Color(0xFF252525)),  // Text color primary
    bodyMedium: TextStyle(color: _primaryColor), // Text color Secondary
    bodySmall: const TextStyle(color: Color(0xFFA7A7A7)),  // Text color Light grey

    titleMedium: const TextStyle(color: Color(0xFF656566)),

  ),

  colorScheme:  ColorScheme.light(
    primary: _primaryColor,  // Primary Color
    secondary: _secondaryColor,  // Secondary Color
    tertiary: const Color(0xFFFFBB38), // Warning Color
    tertiaryContainer: const Color(0xFFFFE0B2), // Warm orange tile/sheet tint
    onTertiaryContainer: const Color(0xFF04BB7B), // Success Color
    onPrimary: const Color(0xFFA5D6A7), // Light Green tint
    surface: const Color(0xFFFFFFFF),
    onSecondary: secondaryColor ?? const Color(0xFFFFCC80), // Light orange tint
    error: const Color(0xFFFF4040), // Danger Color
    onSecondaryContainer: const Color(0xFFFFF8F0),
    outline: const Color(0xff5C8FFC), // Info Color
    onTertiary: const Color(0xFFFFF3E0), // Warm cream tile/border fill
    shadow: const Color(0xFF66717C),

    primaryContainer: const Color(0xFFE8F5E9), // Light Green
    secondaryContainer: const Color(0xFFEFEAE2), // Warm neutral shimmer tone
  ),

  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.android: CupertinoPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),
);
