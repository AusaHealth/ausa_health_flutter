import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'design_scale.dart';

/// Typography class containing text styles for the application
/// Based on the defined text styles:
/// - Large Title (64px)
/// - Title 1 (56px)
/// - Title 2 (48px)
/// - Headline (40px)
/// - Body (32px)
/// - Callout (24px)

class AppTypography {
  // Base font sizes
  static const double _baseLargeTitle = 64;
  static const double _baseTitle1 = 56;
  static const double _baseTitle2 = 48;
  static const double _baseHeadline = 40;
  static const double _baseBody = 32;
  static const double _baseCallout = 24;

  /// Large Title - 64px base
  static TextStyle largeTitle({
    Color? color,
    FontWeight fontWeight = FontWeight.w600,
    double? height = 1.2,
    TextDecoration? decoration,
  }) {
    return GoogleFonts.inter(
      fontSize: DesignScaleManager.scaleValue(_baseLargeTitle),
      fontWeight: fontWeight,
      color: color ?? Colors.black,
      height: height,
      decoration: decoration,
    );
  }

  /// Title 1 - 56px base
  static TextStyle title1({
    Color? color,
    FontWeight fontWeight = FontWeight.w600,
    double? height = 1.2,
    TextDecoration? decoration,
  }) {
    return GoogleFonts.inter(
      fontSize: DesignScaleManager.scaleValue(_baseTitle1),
      fontWeight: fontWeight,
      color: color ?? Colors.black,
      height: height,
      decoration: decoration,
    );
  }

  /// Title 2 - 48px base
  static TextStyle title2({
    Color? color,
    FontWeight fontWeight = FontWeight.w600,
    double? height = 1.2,
    TextDecoration? decoration,
  }) {
    return GoogleFonts.inter(
      fontSize: DesignScaleManager.scaleValue(_baseTitle2),
      fontWeight: fontWeight,
      color: color ?? Colors.black,
      height: height,
      decoration: decoration,
    );
  }

  /// Headline - 40px base
  static TextStyle headline({
    Color? color,
    FontWeight fontWeight = FontWeight.w600,
    double? height = 1.2,
    TextDecoration? decoration,
  }) {
    return GoogleFonts.inter(
      fontSize: DesignScaleManager.scaleValue(_baseHeadline),
      fontWeight: fontWeight,
      color: color ?? Colors.black,
      height: height,
      decoration: decoration,
    );
  }

  /// Body - 32px base
  static TextStyle body({
    Color? color,
    FontWeight fontWeight = FontWeight.w400,
    double? height = 1.3,
    TextDecoration? decoration,
  }) {
    return GoogleFonts.inter(
      fontSize: DesignScaleManager.scaleValue(_baseBody),
      fontWeight: fontWeight,
      color: color ?? Colors.black,
      height: height,
      decoration: decoration,
    );
  }

  /// Callout - 24px base
  static TextStyle callout({
    Color? color,
    FontWeight fontWeight = FontWeight.w400,
    double? height = 1.3,
    TextDecoration? decoration,
  }) {
    return GoogleFonts.inter(
      fontSize: DesignScaleManager.scaleValue(_baseCallout),
      fontWeight: fontWeight,
      color: color ?? Colors.black,
      height: height,
      decoration: decoration,
    );
  }
}
