import 'package:flutter/material.dart';

class BrandColors {
  static bool isDarkMode = false;

  // Base colors
  static Color get background => isDarkMode 
      ? const Color(0xFF3E3E3E)  // dark base-100: oklch(24.353% 0 0)
      : const Color(0xFFF2F4F9); // light base-100: oklch(95.127% 0.007 260.731)
  
  static Color get surfaceLight => isDarkMode 
      ? const Color(0xFF393939)  // dark base-200: oklch(22.648% 0 0)
      : const Color(0xFFEDEFF4); // light base-200: oklch(93.299% 0.01 261.788)
  
  static Color get surfaceMedium => isDarkMode 
      ? const Color(0xFF353535)  // dark base-300: oklch(20.944% 0 0)
      : const Color(0xFFE4E7F0); // light base-300: oklch(89.925% 0.016 262.749)
  
  static Color get baseContent => isDarkMode 
      ? const Color(0xFFD8D8D8)  // dark base-content: oklch(84.87% 0 0)
      : const Color(0xFF525B70); // light base-content: oklch(32.437% 0.022 264.182)

  // Primary colors
  static Color get primary => isDarkMode 
      ? const Color(0xFF6A8FD4)  // dark primary: oklch(41.703% 0.099 251.473)
      : const Color(0xFF7B96CC); // light primary: oklch(59.435% 0.077 254.027)
  
  static Color get primaryContent => isDarkMode 
      ? const Color(0xFFE1E8F7)  // dark primary-content: oklch(88.34% 0.019 251.473)
      : const Color(0xFF1E2534); // light primary-content: oklch(11.887% 0.015 254.027)

  // Secondary colors
  static Color get secondary => isDarkMode 
      ? const Color(0xFFA3B8D9)  // dark secondary: oklch(64.092% 0.027 229.389)
      : const Color(0xFFB1BFE3); // light secondary: oklch(69.651% 0.059 248.687)
  
  static Color get secondaryContent => isDarkMode 
      ? const Color(0xFF202B3D)  // dark secondary-content: oklch(12.818% 0.005 229.389)
      : const Color(0xFF232B47); // light secondary-content: oklch(13.93% 0.011 248.687)

  // Accent colors
  static Color get accent => isDarkMode 
      ? const Color(0xFFAC8A5B)  // dark accent: oklch(67.271% 0.167 35.791)
      : const Color(0xFFC5DBE6); // light accent: oklch(77.464% 0.062 217.469)
  
  static Color get accentContent => isDarkMode 
      ? const Color(0xFF221B12)  // dark accent-content: oklch(13.454% 0.033 35.791)
      : const Color(0xFF272E36); // light accent-content: oklch(15.492% 0.012 217.469)

  // Neutral colors
  static const Color neutral = Color(0xFF2D2D3D);      // neutral
  static const Color neutralContent = Color(0xFFFAFAFB); // neutral-content

  // Status colors
  static Color get info => isDarkMode 
      ? const Color(0xFFA0B8E0)  // dark info: oklch(62.616% 0.143 240.033)
      : const Color(0xFFB1B4D1); // light info: oklch(69.207% 0.062 332.664)

  static Color get success => isDarkMode 
      ? const Color(0xFFB3D9B3)  // dark success: oklch(70.226% 0.094 156.596)
      : const Color(0xFFC3E6B4); // light success: oklch(76.827% 0.074 131.063)

  static Color get warning => isDarkMode 
      ? const Color(0xFFC5B178)  // dark warning: oklch(77.482% 0.115 81.519)
      : const Color(0xFFDBD6A7); // light warning: oklch(85.486% 0.089 84.093)

  static Color get error => isDarkMode 
      ? const Color(0xFF843D2E)  // dark error: oklch(51.61% 0.146 29.674)
      : const Color(0xFF9B4D3A); // light error: oklch(60.61% 0.12 15.341)

  // Text colors (aliases for better semantics)
  static Color get textPrimary => baseContent;
  static Color get textSecondary => baseContent.withOpacity(0.7);

  // Legacy colors (keeping for backward compatibility)
  static Color get white => primaryContent;
  static Color get cardBackground => surfaceLight;
}
