import 'package:ausa/constants/design_scale.dart';
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

/// Typography weight enum for consistent font weights across the app
enum AppTypographyWeight { regular, medium, semibold, bold }

class AppTypography {
  // Base font sizes
  static const double _baseLargeTitle = 64;
  static const double _baseTitle1 = 56;
  static const double _baseTitle2 = 48;
  static const double _baseHeadline = 40;
  static const double _baseBody = 32;
  static const double _baseCallout = 24;

  /// Convert AppTypographyWeight enum to Flutter FontWeight
  static FontWeight _getFlutterFontWeight(AppTypographyWeight weight) {
    switch (weight) {
      case AppTypographyWeight.regular:
        return FontWeight.w400;
      case AppTypographyWeight.medium:
        return FontWeight.w500;
      case AppTypographyWeight.semibold:
        return FontWeight.w600;
      case AppTypographyWeight.bold:
        return FontWeight.w700;
    }
  }

  // ==================== LARGE TITLE METHODS ====================

  /// Large Title - 64px base (flexible method)
  static TextStyle largeTitle({
    Color? color,
    FontWeight? fontWeight,
    AppTypographyWeight? weight,
    double? height = 1.2,
    TextDecoration? decoration,
  }) {
    // Use AppTypographyWeight if provided, otherwise use FontWeight
    final effectiveWeight =
        weight != null
            ? _getFlutterFontWeight(weight)
            : (fontWeight ?? FontWeight.w600);

    return GoogleFonts.inter(
      fontSize: DesignScaleManager.scaleValue(_baseLargeTitle),
      fontWeight: effectiveWeight,
      color: color ?? Colors.black,
      height: height,
      decoration: decoration,
    );
  }

  // ==================== TITLE 1 METHODS ====================

  /// Title 1 - 56px base (flexible method)
  static TextStyle title1({
    Color? color,
    FontWeight? fontWeight,
    AppTypographyWeight? weight,
    double? height = 1.2,
    TextDecoration? decoration,
  }) {
    // Use AppTypographyWeight if provided, otherwise use FontWeight
    final effectiveWeight =
        weight != null
            ? _getFlutterFontWeight(weight)
            : (fontWeight ?? FontWeight.w600);

    return GoogleFonts.inter(
      fontSize: DesignScaleManager.scaleValue(_baseTitle1),
      fontWeight: effectiveWeight,
      color: color ?? Colors.black,
      height: height,
      decoration: decoration,
    );
  }

  // ==================== TITLE 2 METHODS ====================

  /// Title 2 - 48px base (flexible method)
  static TextStyle title2({
    Color? color,
    FontWeight? fontWeight,
    AppTypographyWeight? weight,
    double? height = 1.25,
    TextDecoration? decoration,
  }) {
    // Use AppTypographyWeight if provided, otherwise use FontWeight
    final effectiveWeight =
        weight != null
            ? _getFlutterFontWeight(weight)
            : (fontWeight ?? FontWeight.w600);

    return GoogleFonts.inter(
      fontSize: DesignScaleManager.scaleValue(_baseTitle2),
      fontWeight: effectiveWeight,
      color: color ?? Colors.black,
      height: height,
      decoration: decoration,
    );
  }

  // ==================== HEADLINE METHODS ====================

  /// Headline - 40px base (flexible method)
  static TextStyle headline({
    Color? color,
    FontWeight? fontWeight,
    AppTypographyWeight? weight,
    double? height = 1.2,
    TextDecoration? decoration,
  }) {
    // Use AppTypographyWeight if provided, otherwise use FontWeight
    final effectiveWeight =
        weight != null
            ? _getFlutterFontWeight(weight)
            : (fontWeight ?? FontWeight.w600);

    return GoogleFonts.inter(
      fontSize: DesignScaleManager.scaleValue(_baseHeadline),
      fontWeight: effectiveWeight,
      color: color ?? Colors.black,
      height: height,
      decoration: decoration,
    );
  }

  // ==================== BODY METHODS ====================

  /// Body - 32px base (flexible method)
  static TextStyle body({
    Color? color,
    FontWeight? fontWeight,
    AppTypographyWeight? weight,
    double? height = 1.5,
    TextDecoration? decoration,
  }) {
    // Use AppTypographyWeight if provided, otherwise use FontWeight
    final effectiveWeight =
        weight != null
            ? _getFlutterFontWeight(weight)
            : (fontWeight ?? FontWeight.w400);

    return GoogleFonts.inter(
      fontSize: DesignScaleManager.scaleValue(_baseBody),
      fontWeight: effectiveWeight,
      color: color ?? Colors.black,
      height: height,
      decoration: decoration,
    );
  }

  // ==================== CALLOUT METHODS ====================

  /// Callout - 24px base (flexible method)
  static TextStyle callout({
    Color? color,
    FontWeight? fontWeight,
    AppTypographyWeight? weight,
    double? height = 1.5,
    TextDecoration? decoration,
  }) {
    // Use AppTypographyWeight if provided, otherwise use FontWeight
    final effectiveWeight =
        weight != null
            ? _getFlutterFontWeight(weight)
            : (fontWeight ?? FontWeight.w400);

    return GoogleFonts.inter(
      fontSize: DesignScaleManager.scaleValue(_baseCallout),
      fontWeight: effectiveWeight,
      color: color ?? Colors.black,
      height: height,
      decoration: decoration,
    );
  }
}
