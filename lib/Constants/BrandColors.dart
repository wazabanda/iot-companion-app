import 'package:flutter/material.dart';

class BrandColors {
  static bool isDarkMode = false;

  // Base colors
  static Color get background => isDarkMode 
      ? const Color(0xFF2A2A2A)  // dark base-100: oklch(21% 0.006 56.043)
      : const Color(0xFFF2F4F9); // light base-100: oklch(95.127% 0.007 260.731)
  
  static Color get surfaceLight => isDarkMode 
      ? const Color(0xFF1C1C1C)  // dark base-200: oklch(14% 0.004 49.25)
      : const Color(0xFFEDEFF4); // light base-200: oklch(93.299% 0.01 261.788)
  
  static Color get surfaceMedium => isDarkMode 
      ? const Color(0xFF000000)  // dark base-300: oklch(0% 0 0)
      : const Color(0xFFE4E7F0); // light base-300: oklch(89.925% 0.016 262.749)
  
  static Color get baseContent => isDarkMode 
      ? const Color(0xFFD9D9D9)  // dark base-content: oklch(84.955% 0 0)
      : const Color(0xFF525B70); // light base-content: oklch(32.437% 0.022 264.182)

  // Primary colors
  static Color get primary => isDarkMode 
      ? const Color(0xFFFFA500)  // dark primary: oklch(77.48% 0.204 60.62)
      : const Color(0xFF7B96CC); // light primary: oklch(59.435% 0.077 254.027)
  
  static Color get primaryContent => isDarkMode 
      ? const Color(0xFF333333)  // dark primary-content: oklch(19.693% 0.004 196.779)
      : const Color(0xFF1E2534); // light primary-content: oklch(11.887% 0.015 254.027)

  // Secondary colors
  static Color get secondary => isDarkMode 
      ? const Color(0xFF8A2BE2)  // dark secondary: oklch(45.98% 0.248 305.03)
      : const Color(0xFFB1BFE3); // light secondary: oklch(69.651% 0.059 248.687)
  
  static Color get secondaryContent => isDarkMode 
      ? const Color(0xFFE3E3E3)  // dark secondary-content: oklch(89.196% 0.049 305.03)
      : const Color(0xFF232B47); // light secondary-content: oklch(13.93% 0.011 248.687)

  // Accent colors
  static Color get accent => isDarkMode 
      ? const Color(0xFF00FF00)  // dark accent: oklch(64.8% 0.223 136.073)
      : const Color(0xFFC5DBE6); // light accent: oklch(77.464% 0.062 217.469)
  
  static Color get accentContent => isDarkMode 
      ? const Color(0xFF000000)  // dark accent-content: oklch(0% 0 0)
      : const Color(0xFF272E36); // light accent-content: oklch(15.492% 0.012 217.469)

  // Neutral colors
  static Color get neutral => isDarkMode 
      ? const Color(0xFF3E3E3E)  // dark neutral: oklch(24.371% 0.046 65.681)
      : const Color(0xFF2D2D3D); // light neutral

  static Color get neutralContent => isDarkMode 
      ? const Color(0xFFD9D9D9)  // dark neutral-content: oklch(84.874% 0.009 65.681)
      : const Color(0xFFFAFAFB); // light neutral-content

  // Status colors
  static Color get info => isDarkMode 
      ? const Color(0xFF6495ED)  // dark info: oklch(54.615% 0.215 262.88)
      : const Color(0xFFB1B4D1); // light info: oklch(69.207% 0.062 332.664)

  static Color get success => isDarkMode 
      ? const Color(0xFF00FF7F)  // dark success: oklch(62.705% 0.169 149.213)
      : const Color(0xFFC3E6B4); // light success: oklch(76.827% 0.074 131.063)

  static Color get warning => isDarkMode 
      ? const Color(0xFFFFA500)  // dark warning: oklch(66.584% 0.157 58.318)
      : const Color(0xFFDBD6A7); // light warning: oklch(85.486% 0.089 84.093)

  static Color get error => isDarkMode 
      ? const Color(0xFFFF6347)  // dark error: oklch(65.72% 0.199 27.33)
      : const Color(0xFF9B4D3A); // light error: oklch(60.61% 0.12 15.341)

  // Text colors (aliases for better semantics)
  static Color get textPrimary => baseContent;
  static Color get textSecondary => baseContent.withOpacity(0.7);

  // Legacy colors (keeping for backward compatibility)
  static Color get white => primaryContent;
  static Color get cardBackground => surfaceLight;
}
