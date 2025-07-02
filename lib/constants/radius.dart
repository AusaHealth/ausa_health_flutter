import 'package:flutter/material.dart';
import 'design_scale.dart';

/// Radius constants for the application
/// All values are scalable based on the current design scale
/// Base radius values in logical pixels

class AppRadius {
  // Base radius values
  static const double _radiusMinimal = 2;
  static const double _radiusSmall = 4;
  static const double _radiusRounded = 8;
  static const double _radiusMedium = 12;
  static const double _radiusLarge = 16;
  static const double _radiusFull = 9999; // Very large number for full rounding

  // Additional radius values from the design system
  static const double _radius24 = 24;
  static const double _radius56 = 56;
  static const double _radius80 = 80;

  /// Minimal radius (2px base)
  static double get minimal => DesignScaleManager.scaleValue(_radiusMinimal);

  /// Small radius (4px base)
  static double get sm => DesignScaleManager.scaleValue(_radiusSmall);

  /// Rounded radius (8px base)
  static double get rounded => DesignScaleManager.scaleValue(_radiusRounded);

  /// Medium radius (12px base)
  static double get md => DesignScaleManager.scaleValue(_radiusMedium);

  /// Large radius (16px base)
  static double get lg => DesignScaleManager.scaleValue(_radiusLarge);

  /// Full radius for circular/pill shapes
  static double get full =>
      _radiusFull; // Don't scale this as it's meant to be circular

  /// Extra large radius (24px base)
  static double get xl => DesignScaleManager.scaleValue(_radius24);

  /// 2x extra large radius (56px base)
  static double get xl2 => DesignScaleManager.scaleValue(_radius56);

  /// 3x extra large radius (80px base)
  static double get xl3 => DesignScaleManager.scaleValue(_radius80);

  // Alternative naming for consistency
  /// Radius 2 (2px base)
  static double get radius2 => minimal;

  /// Radius 4 (4px base)
  static double get radius4 => sm;

  /// Radius 8 (8px base)
  static double get radius8 => rounded;

  /// Radius 12 (12px base)
  static double get radius12 => md;

  /// Radius 16 (16px base)
  static double get radius16 => lg;

  /// Radius 24 (24px base)
  static double get radius24 => xl;

  /// Radius 56 (56px base)
  static double get radius56 => xl2;

  /// Radius 80 (80px base)
  static double get radius80 => xl3;

  /// Helper method to create BorderRadius with all corners
  static BorderRadius circular(double radius) {
    return BorderRadius.circular(radius);
  }

  /// Helper method to create BorderRadius with only top corners
  static BorderRadius topOnly(double radius) {
    return BorderRadius.only(
      topLeft: Radius.circular(radius),
      topRight: Radius.circular(radius),
    );
  }

  /// Helper method to create BorderRadius with only bottom corners
  static BorderRadius bottomOnly(double radius) {
    return BorderRadius.only(
      bottomLeft: Radius.circular(radius),
      bottomRight: Radius.circular(radius),
    );
  }

  /// Example usage:
  /// ```
  /// Container(
  ///   decoration: BoxDecoration(
  ///     borderRadius: AppRadius.circular(AppRadius.lg),
  ///   ),
  /// )
  /// ```
}
