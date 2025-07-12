import 'design_scale.dart';

/// Spacing constants for the application
/// All values are scalable based on the current design scale
/// Base spacing values in logical pixels

class AppSpacing {
  // Base spacing values
  static const double _spacing0 = 0;
  static const double _spacing0_5 = 4;
  static const double _spacing1 = 8;
  static const double _spacing1_5 = 12;
  static const double _spacing2 = 16;
  static const double _spacing2_5 = 20;
  static const double _spacing3 = 24;
  static const double _spacing4 = 32;
  static const double _spacing5 = 40;
  static const double _spacing6 = 48;
  static const double _spacing7 = 56;
  static const double _spacing8 = 64;
  static const double _spacing10 = 80;
  static const double _spacing12 = 96;

  /// No spacing (0px)
  static double get none => DesignScaleManager.scaleValue(_spacing0);

  /// Extra small spacing (4px base)
  static double get xs => DesignScaleManager.scaleValue(_spacing0_5);

  /// Small spacing (8px base)
  static double get sm => DesignScaleManager.scaleValue(_spacing1);

  /// Small-medium spacing (12px base)
  static double get smMedium => DesignScaleManager.scaleValue(_spacing1_5);

  /// Medium spacing (16px base)
  static double get md => DesignScaleManager.scaleValue(_spacing2);

  /// Medium-large spacing (20px base)
  static double get mdLarge => DesignScaleManager.scaleValue(_spacing2_5);

  /// Large spacing (24px base)
  static double get lg => DesignScaleManager.scaleValue(_spacing3);

  /// Extra large spacing (32px base)
  static double get xl => DesignScaleManager.scaleValue(_spacing4);

  /// 2x extra large spacing (40px base)
  static double get xl2 => DesignScaleManager.scaleValue(_spacing5);

  /// 3x extra large spacing (48px base)
  static double get xl3 => DesignScaleManager.scaleValue(_spacing6);

  /// 4x extra large spacing (56px base)
  static double get xl4 => DesignScaleManager.scaleValue(_spacing7);

  /// 5x extra large spacing (64px base)
  static double get xl5 => DesignScaleManager.scaleValue(_spacing8);

  /// 6x extra large spacing (80px base)
  static double get xl6 => DesignScaleManager.scaleValue(_spacing10);

  /// 7x extra large spacing (96px base)
  static double get xl7 => DesignScaleManager.scaleValue(_spacing12);

  // Alternative numeric access methods
  /// Spacing 0 (0px)
  static double get spacing0 => none;

  /// Spacing 0.5 (4px base)
  static double get spacing0_5 => xs;

  /// Spacing 1 (8px base)
  static double get spacing1 => sm;

  /// Spacing 1.5 (12px base)
  static double get spacing1_5 => smMedium;

  /// Spacing 2 (16px base)
  static double get spacing2 => md;

  /// Spacing 2.5 (20px base)
  static double get spacing2_5 => mdLarge;

  /// Spacing 3 (24px base)
  static double get spacing3 => lg;

  /// Spacing 4 (32px base)
  static double get spacing4 => xl;

  /// Spacing 5 (40px base)
  static double get spacing5 => xl2;

  /// Spacing 6 (48px base)
  static double get spacing6 => xl3;

  /// Spacing 7 (56px base)
  static double get spacing7 => xl4;

  /// Spacing 8 (64px base)
  static double get spacing8 => xl5;

  /// Spacing 10 (80px base)
  static double get spacing10 => xl6;

  /// Spacing 12 (96px base)
  static double get spacing12 => xl7;

  /// Example usage:
  /// ```
  /// Container(
  ///   padding: EdgeInsets.all(AppSpacing.md),
  ///   margin: EdgeInsets.symmetric(vertical: AppSpacing.lg),
  /// )
  /// ```
}
