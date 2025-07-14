import 'package:flutter/material.dart';
import 'design_scale.dart';

/// Radius constants for the application
/// All values are scalable based on the current design scale
/// Base radius values in logical pixels

class AppRadius {

  /// Minimal radius (2px base)
  static double get minimal => DesignScaleManager.scaleValue(2);

  /// Small radius (4px base)
  static double get sm => DesignScaleManager.scaleValue(4);

  /// Rounded radius (8px base)
  static double get rounded => DesignScaleManager.scaleValue(8);

  /// Medium radius (12px base)
  static double get md => DesignScaleManager.scaleValue(12);

  /// Large radius (16px base)
  static double get lg => DesignScaleManager.scaleValue(16);

  /// Full radius for circular/pill shapes
  static double get full => 9999; // Don't scale this as it's meant to be circular

  /// Extra large radius (24px base)
  static double get xl => DesignScaleManager.scaleValue(24);

  /// 2x extra large radius (56px base)
  static double get xl2 => DesignScaleManager.scaleValue(56);

  /// 3x extra large radius (80px base)
  static double get xl3 => DesignScaleManager.scaleValue(80);


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
