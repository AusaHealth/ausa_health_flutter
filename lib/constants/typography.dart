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

  /// Base method for creating text styles
  static TextStyle _createTextStyle({
    required double baseFontSize,
    required AppTypographyWeight weight,
    Color? color,
    double? height,
    TextDecoration? decoration,
  }) {
    return GoogleFonts.inter(
      fontSize: DesignScaleManager.scaleValue(baseFontSize),
      fontWeight: _getFlutterFontWeight(weight),
      color: color ?? Colors.black,
      height: height,
      decoration: decoration,
    );
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

  /// Large Title Regular - 64px base, regular weight
  static TextStyle largeTitleRegular({
    Color? color,
    double? height = 1.2,
    TextDecoration? decoration,
  }) => _createTextStyle(
    baseFontSize: _baseLargeTitle,
    weight: AppTypographyWeight.regular,
    color: color,
    height: height,
    decoration: decoration,
  );

  /// Large Title Medium - 64px base, medium weight
  static TextStyle largeTitleMedium({
    Color? color,
    double? height = 1.2,
    TextDecoration? decoration,
  }) => _createTextStyle(
    baseFontSize: _baseLargeTitle,
    weight: AppTypographyWeight.medium,
    color: color,
    height: height,
    decoration: decoration,
  );

  /// Large Title Semibold - 64px base, semibold weight
  static TextStyle largeTitleSemibold({
    Color? color,
    double? height = 1.2,
    TextDecoration? decoration,
  }) => _createTextStyle(
    baseFontSize: _baseLargeTitle,
    weight: AppTypographyWeight.semibold,
    color: color,
    height: height,
    decoration: decoration,
  );

  /// Large Title Bold - 64px base, bold weight
  static TextStyle largeTitleBold({
    Color? color,
    double? height = 1.2,
    TextDecoration? decoration,
  }) => _createTextStyle(
    baseFontSize: _baseLargeTitle,
    weight: AppTypographyWeight.bold,
    color: color,
    height: height,
    decoration: decoration,
  );

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

  /// Title 1 Regular - 56px base, regular weight
  static TextStyle title1Regular({
    Color? color,
    double? height = 1.2,
    TextDecoration? decoration,
  }) => _createTextStyle(
    baseFontSize: _baseTitle1,
    weight: AppTypographyWeight.regular,
    color: color,
    height: height,
    decoration: decoration,
  );

  /// Title 1 Medium - 56px base, medium weight
  static TextStyle title1Medium({
    Color? color,
    double? height = 1.2,
    TextDecoration? decoration,
  }) => _createTextStyle(
    baseFontSize: _baseTitle1,
    weight: AppTypographyWeight.medium,
    color: color,
    height: height,
    decoration: decoration,
  );

  /// Title 1 Semibold - 56px base, semibold weight
  static TextStyle title1Semibold({
    Color? color,
    double? height = 1.2,
    TextDecoration? decoration,
  }) => _createTextStyle(
    baseFontSize: _baseTitle1,
    weight: AppTypographyWeight.semibold,
    color: color,
    height: height,
    decoration: decoration,
  );

  /// Title 1 Bold - 56px base, bold weight
  static TextStyle title1Bold({
    Color? color,
    double? height = 1.2,
    TextDecoration? decoration,
  }) => _createTextStyle(
    baseFontSize: _baseTitle1,
    weight: AppTypographyWeight.bold,
    color: color,
    height: height,
    decoration: decoration,
  );

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

  /// Title 2 Regular - 48px base, regular weight
  static TextStyle title2Regular({
    Color? color,
    double? height = 1.25,
    TextDecoration? decoration,
  }) => _createTextStyle(
    baseFontSize: _baseTitle2,
    weight: AppTypographyWeight.regular,
    color: color,
    height: height,
    decoration: decoration,
  );

  /// Title 2 Medium - 48px base, medium weight
  static TextStyle title2Medium({
    Color? color,
    double? height = 1.25,
    TextDecoration? decoration,
  }) => _createTextStyle(
    baseFontSize: _baseTitle2,
    weight: AppTypographyWeight.medium,
    color: color,
    height: height,
    decoration: decoration,
  );

  /// Title 2 Semibold - 48px base, semibold weight
  static TextStyle title2Semibold({
    Color? color,
    double? height = 1.25,
    TextDecoration? decoration,
  }) => _createTextStyle(
    baseFontSize: _baseTitle2,
    weight: AppTypographyWeight.semibold,
    color: color,
    height: height,
    decoration: decoration,
  );

  /// Title 2 Bold - 48px base, bold weight
  static TextStyle title2Bold({
    Color? color,
    double? height = 1.25,
    TextDecoration? decoration,
  }) => _createTextStyle(
    baseFontSize: _baseTitle2,
    weight: AppTypographyWeight.bold,
    color: color,
    height: height,
    decoration: decoration,
  );

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

  /// Headline Regular - 40px base, regular weight
  static TextStyle headlineRegular({
    Color? color,
    double? height = 1.2,
    TextDecoration? decoration,
  }) => _createTextStyle(
    baseFontSize: _baseHeadline,
    weight: AppTypographyWeight.regular,
    color: color,
    height: height,
    decoration: decoration,
  );

  /// Headline Medium - 40px base, medium weight
  static TextStyle headlineMedium({
    Color? color,
    double? height = 1.2,
    TextDecoration? decoration,
  }) => _createTextStyle(
    baseFontSize: _baseHeadline,
    weight: AppTypographyWeight.medium,
    color: color,
    height: height,
    decoration: decoration,
  );

  /// Headline Semibold - 40px base, semibold weight
  static TextStyle headlineSemibold({
    Color? color,
    double? height = 1.2,
    TextDecoration? decoration,
  }) => _createTextStyle(
    baseFontSize: _baseHeadline,
    weight: AppTypographyWeight.semibold,
    color: color,
    height: height,
    decoration: decoration,
  );

  /// Headline Bold - 40px base, bold weight
  static TextStyle headlineBold({
    Color? color,
    double? height = 1.2,
    TextDecoration? decoration,
  }) => _createTextStyle(
    baseFontSize: _baseHeadline,
    weight: AppTypographyWeight.bold,
    color: color,
    height: height,
    decoration: decoration,
  );

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

  /// Body Regular - 32px base, regular weight
  static TextStyle bodyRegular({
    Color? color,
    double? height = 1.5,
    TextDecoration? decoration,
  }) => _createTextStyle(
    baseFontSize: _baseBody,
    weight: AppTypographyWeight.regular,
    color: color,
    height: height,
    decoration: decoration,
  );

  /// Body Medium - 32px base, medium weight
  static TextStyle bodyMedium({
    Color? color,
    double? height = 1.5,
    TextDecoration? decoration,
  }) => _createTextStyle(
    baseFontSize: _baseBody,
    weight: AppTypographyWeight.medium,
    color: color,
    height: height,
    decoration: decoration,
  );

  /// Body Semibold - 32px base, semibold weight
  static TextStyle bodySemibold({
    Color? color,
    double? height = 1.5,
    TextDecoration? decoration,
  }) => _createTextStyle(
    baseFontSize: _baseBody,
    weight: AppTypographyWeight.semibold,
    color: color,
    height: height,
    decoration: decoration,
  );

  /// Body Bold - 32px base, bold weight
  static TextStyle bodyBold({
    Color? color,
    double? height = 1.5,
    TextDecoration? decoration,
  }) => _createTextStyle(
    baseFontSize: _baseBody,
    weight: AppTypographyWeight.bold,
    color: color,
    height: height,
    decoration: decoration,
  );

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

  /// Callout Regular - 24px base, regular weight
  static TextStyle calloutRegular({
    Color? color,
    double? height = 1.5,
    TextDecoration? decoration,
  }) => _createTextStyle(
    baseFontSize: _baseCallout,
    weight: AppTypographyWeight.regular,
    color: color,
    height: height,
    decoration: decoration,
  );

  /// Callout Medium - 24px base, medium weight
  static TextStyle calloutMedium({
    Color? color,
    double? height = 1.5,
    TextDecoration? decoration,
  }) => _createTextStyle(
    baseFontSize: _baseCallout,
    weight: AppTypographyWeight.medium,
    color: color,
    height: height,
    decoration: decoration,
  );

  /// Callout Semibold - 24px base, semibold weight
  static TextStyle calloutSemibold({
    Color? color,
    double? height = 1.5,
    TextDecoration? decoration,
  }) => _createTextStyle(
    baseFontSize: _baseCallout,
    weight: AppTypographyWeight.semibold,
    color: color,
    height: height,
    decoration: decoration,
  );

  /// Callout Bold - 24px base, bold weight
  static TextStyle calloutBold({
    Color? color,
    double? height = 1.5,
    TextDecoration? decoration,
  }) => _createTextStyle(
    baseFontSize: _baseCallout,
    weight: AppTypographyWeight.bold,
    color: color,
    height: height,
    decoration: decoration,
  );

  /// Example usage:
  /// ```
  /// // Using weight-specific methods (recommended)
  /// Text(
  ///   'Hello World',
  ///   style: AppTypography.largeTitleBold(
  ///     color: AppColors.primaryColor,
  ///   ),
  /// )
  ///
  /// // Using flexible methods with AppTypographyWeight
  /// Text(
  ///   'Hello World',
  ///   style: AppTypography.callout(
  ///     color: AppColors.primaryColor,
  ///     weight: AppTypographyWeight.medium,
  ///   ),
  /// )
  ///
  /// // Using flexible methods with FontWeight (backward compatibility)
  /// Text(
  ///   'Hello World',
  ///   style: AppTypography.largeTitle(
  ///     color: AppColors.primaryColor,
  ///     fontWeight: FontWeight.w700,
  ///   ),
  /// )
  ///
  /// // All available weight-specific methods:
  /// AppTypography.largeTitleRegular()
  /// AppTypography.largeTitleMedium()
  /// AppTypography.largeTitleSemibold()
  /// AppTypography.largeTitleBold()
  ///
  /// AppTypography.title1Regular()
  /// AppTypography.title1Medium()
  /// AppTypography.title1Semibold()
  /// AppTypography.title1Bold()
  ///
  /// AppTypography.title2Regular()
  /// AppTypography.title2Medium()
  /// AppTypography.title2Semibold()
  /// AppTypography.title2Bold()
  ///
  /// AppTypography.headlineRegular()
  /// AppTypography.headlineMedium()
  /// AppTypography.headlineSemibold()
  /// AppTypography.headlineBold()
  ///
  /// AppTypography.bodyRegular()
  /// AppTypography.bodyMedium()
  /// AppTypography.bodySemibold()
  /// AppTypography.bodyBold()
  ///
  /// AppTypography.calloutRegular()
  /// AppTypography.calloutMedium()
  /// AppTypography.calloutSemibold()
  /// AppTypography.calloutBold()
  /// ```
}
