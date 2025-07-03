import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography class containing text styles for the application
/// Based on the defined text styles:
/// - Large Title (64px)
/// - Title 1 (56px)
/// - Title 2 (48px)
/// - Headline (40px)
/// - Body (32px)
/// - Callout (24px)

/// Font size ratio used to scale all typography
const double _fontSizeRatio = 0.5;

class AppTypography {
  /// Large Title - 64px
  static TextStyle largeTitle({
    Color? color,
    FontWeight fontWeight = FontWeight.w600,
    double? height = 1.2,
    TextDecoration? decoration,
  }) {
    return GoogleFonts.inter(
      fontSize: 64 * _fontSizeRatio,
      fontWeight: fontWeight,
      color: color ?? Colors.black,
      height: height,
      decoration: decoration,
    );
  }

  /// Title 1 - 56px
  static TextStyle title1({
    Color? color,
    FontWeight fontWeight = FontWeight.w600,
    double? height = 1.2,
    TextDecoration? decoration,
  }) {
    return GoogleFonts.inter(
      fontSize: 56 * _fontSizeRatio,
      fontWeight: fontWeight,
      color: color ?? Colors.black,
      height: height,
      decoration: decoration,
    );
  }

  /// Title 2 - 48px
  static TextStyle title2({
    Color? color,
    FontWeight fontWeight = FontWeight.w600,
    double? height = 1.2,
    TextDecoration? decoration,
  }) {
    return GoogleFonts.inter(
      fontSize: 48 * _fontSizeRatio,
      fontWeight: fontWeight,
      color: color ?? Colors.black,
      height: height,
      decoration: decoration,
    );
  }

  /// Headline - 40px
  static TextStyle headline({
    Color? color,
    FontWeight fontWeight = FontWeight.w600,
    double? height = 1.2,
    TextDecoration? decoration,
  }) {
    return GoogleFonts.inter(
      fontSize: 40 * _fontSizeRatio,
      fontWeight: fontWeight,
      color: color ?? Colors.black,
      height: height,
      decoration: decoration,
    );
  }

  /// Body - 32px
  static TextStyle body({
    Color? color,
    FontWeight fontWeight = FontWeight.w400,
    double? height = 1.3,
    TextDecoration? decoration,
  }) {
    return GoogleFonts.inter(
      fontSize: 32 * _fontSizeRatio,
      fontWeight: fontWeight,
      color: color ?? Colors.black,
      height: height,
      decoration: decoration,
    );
  }

  /// Callout - 24px
  static TextStyle callout({
    Color? color,
    FontWeight fontWeight = FontWeight.w400,
    double? height = 1.3,
    TextDecoration? decoration,
  }) {
    return GoogleFonts.inter(
      fontSize: 24 * _fontSizeRatio,
      fontWeight: fontWeight,
      color: color ?? Colors.black,
      height: height,
      decoration: decoration,
    );
  }
}
