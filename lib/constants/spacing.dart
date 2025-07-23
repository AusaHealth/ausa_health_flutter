import 'package:ausa/constants/design_scale.dart';

/// Spacing constants for the application
/// All values are scalable based on the current design scale
/// Base spacing values in logical pixels

class AppSpacing {
  /// No spacing (0px)
  static double get none => DesignScaleManager.scaleValue(0);

  /// Extra small spacing (4px base)
  static double get xs => DesignScaleManager.scaleValue(4);

  /// Small spacing (8px base)
  static double get sm => DesignScaleManager.scaleValue(8);

  /// Small-medium spacing (12px base)
  static double get smMedium => DesignScaleManager.scaleValue(12);

  /// Medium spacing (16px base)
  static double get md => DesignScaleManager.scaleValue(16);

  /// Medium-large spacing (20px base)
  static double get mdLarge => DesignScaleManager.scaleValue(20);

  /// Large spacing (24px base)
  static double get lg => DesignScaleManager.scaleValue(24);

  /// Extra large spacing (32px base)
  static double get xl => DesignScaleManager.scaleValue(32);

  /// 2x extra large spacing (40px base)
  static double get xl2 => DesignScaleManager.scaleValue(40);

  /// 3x extra large spacing (48px base)
  static double get xl3 => DesignScaleManager.scaleValue(48);

  /// 4x extra large spacing (56px base)
  static double get xl4 => DesignScaleManager.scaleValue(56);

  /// 5x extra large spacing (64px base)
  static double get xl5 => DesignScaleManager.scaleValue(64);

  /// 6x extra large spacing (80px base)
  static double get xl6 => DesignScaleManager.scaleValue(80);

  /// 7x extra large spacing (96px base)
  static double get xl7 => DesignScaleManager.scaleValue(96);

  static double get xl8 => DesignScaleManager.scaleValue(112);

  /// 8x extra large spacing (128px base)
  static double get xl9 => DesignScaleManager.scaleValue(128);

  static double get xl10 => DesignScaleManager.scaleValue(144);

  static double get xl11 => DesignScaleManager.scaleValue(160);

  /// Example usage:
  /// ```
  /// Container(
  ///   padding: EdgeInsets.all(AppSpacing.md),
  ///   margin: EdgeInsets.symmetric(vertical: AppSpacing.lg),
  /// )
  /// ```
}
