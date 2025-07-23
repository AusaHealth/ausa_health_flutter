/// Design scale configuration for consistent scaling across typography, spacing, and radius
/// Provides different scale options: default, 1.25x, 1.50x, 1.75x
library;

/// Common ratio applied to all design tokens (typography, spacing, radius)
/// This scales down all Figma values by 50% by default
const double _baseDesignRatio = 0.5;

enum DesignScale {
  /// Default scale (1.0x)
  defaultScale(1.0, 'Default'),

  /// Medium scale (1.25x)
  mediumScale(1.25, 'Medium'),

  /// Large scale (1.50x)
  largeScale(1.50, 'Large'),

  /// Extra large scale (1.75x)
  extraLargeScale(1.75, 'Extra Large');

  const DesignScale(this.multiplier, this.displayName);

  final double multiplier;
  final String displayName;
}

/// Design scale manager to handle current scale across the application
class DesignScaleManager {
  static const keyboardHeight = 268;
  static DesignScale _currentScale = DesignScale.defaultScale;

  /// Get the current design scale
  static DesignScale get currentScale => _currentScale;

  /// Get the current scale multiplier
  static double get currentMultiplier => _currentScale.multiplier;

  /// Get the base design ratio (0.5)
  static double get baseRatio => _baseDesignRatio;

  /// Set the current design scale
  static void setScale(DesignScale scale) {
    _currentScale = scale;
  }

  /// Get all available scales
  static List<DesignScale> get availableScales => DesignScale.values;

  /// Apply the current scale to a base value with common ratio
  /// Formula: figmaValue * baseRatio * scaleMultiplier
  /// Example: 24px from Figma * 0.5 * 1.25 = 15px final
  static double scaleValue(double baseValue) {
    return baseValue * _baseDesignRatio * currentMultiplier;
  }

  /// Get the final ratio being applied (base ratio * scale multiplier)
  /// Useful for debugging or display purposes
  static double get finalRatio => _baseDesignRatio * currentMultiplier;
}
