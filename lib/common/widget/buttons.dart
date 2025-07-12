import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/constants.dart';

enum ButtonVariant {
  primary,
  secondary,
  tertiary,
  selection,
  link,
  icon,
  custom,
}

enum ButtonSize { extraSmall, small, medium, large, custom }

class AusaButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final Color? shadowColor;
  final Gradient? gradient;
  final double? borderWidth;
  final double? borderRadius;
  final double? elevation;
  final List<BoxShadow>? boxShadows;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final TextStyle? textStyle;
  final IconData? icon;
  final Widget? customIcon;
  final double? iconSize;
  final Color? iconColor;
  final double? iconSpacing;
  final bool iconOnLeft;
  final bool isLoading;
  final bool isEnabled;
  final bool isSelected;
  final ValueChanged<bool>? onSelectionChanged;
  final Duration? animationDuration;
  final Curve? animationCurve;
  final bool enableFeedback;
  final bool enableSplash;
  final Color? splashColor;
  final Color? highlightColor;
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;
  final MainAxisSize? mainAxisSize;
  final Widget? child;

  const AusaButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.shadowColor,
    this.gradient,
    this.borderWidth,
    this.borderRadius,
    this.elevation,
    this.boxShadows,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.fontSize,
    this.fontWeight,
    this.fontFamily,
    this.textStyle,
    this.icon,
    this.customIcon,
    this.iconSize,
    this.iconColor,
    this.iconSpacing,
    this.iconOnLeft = true,
    this.isLoading = false,
    this.isEnabled = true,
    this.isSelected = false,
    this.onSelectionChanged,
    this.animationDuration,
    this.animationCurve,
    this.enableFeedback = true,
    this.enableSplash = true,
    this.splashColor,
    this.highlightColor,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    this.mainAxisSize,
    this.child,
  });

  @override
  State<AusaButton> createState() => _AusaButtonState();
}

class _AusaButtonState extends State<AusaButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late bool _currentSelection;

  @override
  void initState() {
    super.initState();
    _currentSelection = widget.isSelected;
    _initializeAnimation();
  }

  void _initializeAnimation() {
    _animationController = AnimationController(
      duration: widget.animationDuration ?? const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.animationCurve ?? Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AusaButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update selection state if changed
    if (oldWidget.isSelected != widget.isSelected) {
      setState(() {
        _currentSelection = widget.isSelected;
      });
    }

    // Recreate animation controller if duration or curve changed
    if (oldWidget.animationDuration != widget.animationDuration ||
        oldWidget.animationCurve != widget.animationCurve) {
      _animationController.dispose();
      _initializeAnimation();
    }
  }

  void _handleTap() {
    if (!_isButtonEnabled) return;

    if (widget.enableFeedback) {
      HapticFeedback.lightImpact();
    }

    if (widget.onSelectionChanged != null) {
      final newSelection = !_currentSelection;
      setState(() {
        _currentSelection = newSelection;
      });
      widget.onSelectionChanged!(newSelection);
    }

    widget.onPressed?.call();
  }

  bool get _isButtonEnabled => widget.isEnabled && !widget.isLoading;

  _ButtonStyle get _buttonStyle {
    switch (widget.variant) {
      case ButtonVariant.primary:
        return _getPrimaryStyle();
      case ButtonVariant.secondary:
        return _getSecondaryStyle();
      case ButtonVariant.tertiary:
        return _getTertiaryStyle();
      case ButtonVariant.selection:
        return _getSelectionStyle();
      case ButtonVariant.link:
        return _getLinkStyle();
      case ButtonVariant.icon:
        return _getIconStyle();
      case ButtonVariant.custom:
      default:
        return _getCustomStyle();
    }
  }

  _ButtonStyle _getPrimaryStyle() {
    return _ButtonStyle(
      backgroundColor: widget.backgroundColor ?? AppColors.primary700,
      textColor: widget.textColor ?? Colors.white,
      borderColor: widget.borderColor ?? AppColors.primary700,
      borderWidth: widget.borderWidth ?? 0,
      borderRadius: widget.borderRadius ?? 16,
      elevation: widget.elevation ?? 2,
    );
  }

  _ButtonStyle _getSecondaryStyle() {
    return _ButtonStyle(
      backgroundColor: widget.backgroundColor ?? Colors.transparent,
      textColor: widget.textColor ?? AppColors.primary700,
      borderColor: widget.borderColor ?? AppColors.primary700,
      borderWidth: widget.borderWidth ?? 1,
      borderRadius: widget.borderRadius ?? 32,
      elevation: widget.elevation ?? 0,
    );
  }

  _ButtonStyle _getTertiaryStyle() {
    return _ButtonStyle(
      backgroundColor: widget.backgroundColor ?? Colors.transparent,
      textColor: widget.textColor ?? Colors.grey[600] ?? Colors.grey,
      borderColor: widget.borderColor ?? Colors.grey[300] ?? Colors.grey,
      borderWidth: widget.borderWidth ?? 1,
      borderRadius: widget.borderRadius ?? 32,
      elevation: widget.elevation ?? 0,
    );
  }

  _ButtonStyle _getSelectionStyle() {
    final bool isSelected = _currentSelection;
    return _ButtonStyle(
      backgroundColor:
          widget.backgroundColor ??
          (isSelected ? AppColors.primary700 : AppColors.primary25),
      textColor:
          widget.textColor ??
          (isSelected ? AppColors.primary25 : AppColors.primary700),
      borderColor:
          widget.borderColor ??
          (isSelected ? AppColors.primary700 : AppColors.primary25),
      borderWidth: widget.borderWidth ?? 2,
      borderRadius: widget.borderRadius ?? 32,
      elevation: widget.elevation ?? 0,
    );
  }

  _ButtonStyle _getLinkStyle() {
    return _ButtonStyle(
      backgroundColor: widget.backgroundColor ?? Colors.transparent,
      textColor: widget.textColor ?? AppColors.primary700,
      borderColor: widget.borderColor ?? Colors.transparent,
      borderWidth: widget.borderWidth ?? 0,
      borderRadius: widget.borderRadius ?? 0,
      elevation: widget.elevation ?? 0,
    );
  }

  _ButtonStyle _getIconStyle() {
    return _ButtonStyle(
      backgroundColor: widget.backgroundColor ?? Colors.grey[100]!,
      textColor: widget.textColor ?? AppColors.primary700,
      borderColor: widget.borderColor ?? Colors.transparent,
      borderWidth: widget.borderWidth ?? 0,
      borderRadius: widget.borderRadius ?? 24,
      elevation: widget.elevation ?? 0,
    );
  }

  _ButtonStyle _getCustomStyle() {
    return _ButtonStyle(
      backgroundColor: widget.backgroundColor ?? AppColors.primary700,
      textColor: widget.textColor ?? Colors.white,
      borderColor: widget.borderColor ?? Colors.transparent,
      borderWidth: widget.borderWidth ?? 0,
      borderRadius: widget.borderRadius ?? 16,
      elevation: widget.elevation ?? 0,
    );
  }

  Size get _buttonSize {
    // For link variant, let it size naturally unless explicitly set
    if (widget.variant == ButtonVariant.link) {
      return Size(widget.width ?? 0, widget.height ?? 0);
    }

    // For icon variant, make it square by default
    if (widget.variant == ButtonVariant.icon) {
      switch (widget.size) {
        case ButtonSize.extraSmall:
          final size = widget.width ?? widget.height ?? 28;
          return Size(size, size);
        case ButtonSize.small:
          final size = widget.width ?? widget.height ?? 36;
          return Size(size, size);
        case ButtonSize.medium:
          final size = widget.width ?? widget.height ?? 48;
          return Size(size, size);
        case ButtonSize.large:
          final size = widget.width ?? widget.height ?? 56;
          return Size(size, size);
        case ButtonSize.custom:
        default:
          final size = widget.width ?? widget.height ?? 48;
          return Size(size, size);
      }
    }

    switch (widget.size) {
      case ButtonSize.extraSmall:
        return Size(widget.width ?? 80, widget.height ?? 32);
      case ButtonSize.small:
        return Size(widget.width ?? 100, widget.height ?? 40);
      case ButtonSize.medium:
        return Size(widget.width ?? 150, widget.height ?? 48);
      case ButtonSize.large:
        return Size(widget.width ?? 200, widget.height ?? 56);
      case ButtonSize.custom:
      default:
        return Size(widget.width ?? 150, widget.height ?? 48);
    }
  }

  EdgeInsets get _buttonPadding {
    // For link variant, use no padding unless explicitly set
    if (widget.variant == ButtonVariant.link) {
      return widget.padding ?? EdgeInsets.zero;
    }

    // For icon variant, use minimal padding to center the icon
    if (widget.variant == ButtonVariant.icon) {
      return widget.padding ?? const EdgeInsets.all(8);
    }

    switch (widget.size) {
      case ButtonSize.extraSmall:
        return widget.padding ??
            const EdgeInsets.symmetric(horizontal: 8, vertical: 6);
      case ButtonSize.small:
        return widget.padding ??
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case ButtonSize.medium:
        return widget.padding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
      case ButtonSize.large:
        return widget.padding ??
            const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
      case ButtonSize.custom:
      default:
        return widget.padding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
    }
  }

  double get _buttonFontSize {
    switch (widget.size) {
      case ButtonSize.extraSmall:
        return widget.fontSize ?? 10;
      case ButtonSize.small:
        return widget.fontSize ?? 12;
      case ButtonSize.medium:
        return widget.fontSize ?? 14;
      case ButtonSize.large:
        return widget.fontSize ?? 16;
      case ButtonSize.custom:
      default:
        return widget.fontSize ?? 14;
    }
  }

  Widget _buildButtonContent() {
    if (widget.child != null) {
      return widget.child!;
    }

    if (widget.isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(_buttonStyle.textColor),
        ),
      );
    }

    final List<Widget> children = [];
    final iconWidget =
        widget.customIcon ??
        (widget.icon != null
            ? Icon(
              widget.icon,
              size: widget.iconSize ?? _buttonFontSize + 4,
              color:
                  widget.isEnabled
                      ? widget.iconColor ?? _buttonStyle.textColor
                      : Colors.grey[600]!,
            )
            : null);

    if (iconWidget != null && widget.iconOnLeft) {
      children.add(iconWidget);
      if (widget.text.isNotEmpty) {
        children.add(SizedBox(width: widget.iconSpacing ?? 8));
      }
    }

    if (widget.text.isNotEmpty) {
      children.add(
        Flexible(
          child: Text(
            widget.text,
            style:
                widget.textStyle ??
                TextStyle(
                  color:
                      widget.isEnabled
                          ? _buttonStyle.textColor
                          : Colors.grey[600]!,
                  fontSize: _buttonFontSize,
                  fontWeight: widget.fontWeight ?? FontWeight.w600,
                  fontFamily: widget.fontFamily,
                ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (iconWidget != null && !widget.iconOnLeft) {
      if (widget.text.isNotEmpty) {
        children.add(SizedBox(width: widget.iconSpacing ?? 8));
      }
      children.add(iconWidget);
    }

    if (children.isEmpty) {
      return const SizedBox.shrink();
    }

    if (children.length == 1) {
      return children.first;
    }

    return Row(
      mainAxisSize: widget.mainAxisSize ?? MainAxisSize.min,
      mainAxisAlignment: widget.mainAxisAlignment ?? MainAxisAlignment.center,
      crossAxisAlignment:
          widget.crossAxisAlignment ?? CrossAxisAlignment.center,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    final style = _getButtonStyle();
    final size = _getButtonSize();

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width:
                widget.variant == ButtonVariant.link && widget.width == null
                    ? null
                    : size.width,
            height:
                widget.variant == ButtonVariant.link && widget.height == null
                    ? null
                    : size.height,
            margin:
                widget.variant == ButtonVariant.link
                    ? EdgeInsets.zero
                    : widget.margin,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _isButtonEnabled ? _handleTap : null,
                onTapDown:
                    _isButtonEnabled
                        ? (_) => _animationController.forward()
                        : null,
                onTapUp: (_) => _animationController.reverse(),
                onTapCancel: () => _animationController.reverse(),
                borderRadius: BorderRadius.circular(style.borderRadius),
                splashColor:
                    widget.enableSplash
                        ? widget.splashColor
                        : Colors.transparent,
                highlightColor:
                    widget.enableSplash
                        ? widget.highlightColor
                        : Colors.transparent,
                child: AnimatedContainer(
                  duration:
                      widget.animationDuration ??
                      const Duration(milliseconds: 150),
                  curve: widget.animationCurve ?? Curves.easeInOut,
                  padding: _getButtonPadding(),
                  decoration: BoxDecoration(
                    color:
                        _isButtonEnabled
                            ? style.backgroundColor
                            : Colors.grey[300],
                    gradient: _isButtonEnabled ? widget.gradient : null,
                    borderRadius: BorderRadius.circular(style.borderRadius),
                    border:
                        style.borderWidth > 0
                            ? Border.all(
                              color:
                                  _isButtonEnabled
                                      ? style.borderColor
                                      : Colors.grey[300]!,
                              width: style.borderWidth,
                            )
                            : null,
                    boxShadow:
                        widget.boxShadows ??
                        (_isButtonEnabled && style.elevation > 0
                            ? [
                              BoxShadow(
                                color: (widget.shadowColor ??
                                        style.backgroundColor)
                                    .withOpacity(0.3),
                                blurRadius: style.elevation * 2,
                                offset: Offset(0, style.elevation),
                              ),
                            ]
                            : null),
                  ),
                  child: Center(child: _buildButtonContent()),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _ButtonStyle _getButtonStyle() {
    final isSelected =
        widget.variant == ButtonVariant.selection ? _currentSelection : false;

    return switch (widget.variant) {
      ButtonVariant.primary => _ButtonStyle(
        backgroundColor: widget.backgroundColor ?? AppColors.primary700,
        textColor: widget.textColor ?? Colors.white,
        borderColor: widget.borderColor ?? AppColors.primary700,
        borderWidth: widget.borderWidth ?? 0,
        borderRadius: widget.borderRadius ?? 16,
        elevation: widget.elevation ?? 2,
      ),
      ButtonVariant.secondary => _ButtonStyle(
        backgroundColor: widget.backgroundColor ?? Colors.transparent,
        textColor: widget.textColor ?? AppColors.primary700,
        borderColor: widget.borderColor ?? AppColors.primary700,
        borderWidth: widget.borderWidth ?? 1,
        borderRadius: widget.borderRadius ?? 32,
        elevation: widget.elevation ?? 0,
      ),
      ButtonVariant.tertiary => _ButtonStyle(
        backgroundColor: widget.backgroundColor ?? Colors.transparent,
        textColor: widget.textColor ?? Colors.grey[600]!,
        borderColor: widget.borderColor ?? Colors.grey[300]!,
        borderWidth: widget.borderWidth ?? 1,
        borderRadius: widget.borderRadius ?? 32,
        elevation: widget.elevation ?? 0,
      ),
      ButtonVariant.selection => _ButtonStyle(
        backgroundColor:
            widget.backgroundColor ??
            (isSelected ? AppColors.primary700 : AppColors.primary25),
        textColor:
            widget.textColor ??
            (isSelected ? AppColors.primary25 : AppColors.primary700),
        borderColor:
            widget.borderColor ??
            (isSelected ? AppColors.primary700 : AppColors.primary25),
        borderWidth: widget.borderWidth ?? 2,
        borderRadius: widget.borderRadius ?? 32,
        elevation: widget.elevation ?? 0,
      ),
      ButtonVariant.link => _ButtonStyle(
        backgroundColor: widget.backgroundColor ?? Colors.transparent,
        textColor: widget.textColor ?? AppColors.primary700,
        borderColor: widget.borderColor ?? Colors.transparent,
        borderWidth: widget.borderWidth ?? 0,
        borderRadius: widget.borderRadius ?? 0,
        elevation: widget.elevation ?? 0,
      ),
      ButtonVariant.icon => _ButtonStyle(
        backgroundColor: widget.backgroundColor ?? Colors.grey[100]!,
        textColor: widget.textColor ?? AppColors.primary700,
        borderColor: widget.borderColor ?? Colors.transparent,
        borderWidth: widget.borderWidth ?? 0,
        borderRadius: widget.borderRadius ?? 24,
        elevation: widget.elevation ?? 0,
      ),
      ButtonVariant.custom => _ButtonStyle(
        backgroundColor: widget.backgroundColor ?? AppColors.primary700,
        textColor: widget.textColor ?? Colors.white,
        borderColor: widget.borderColor ?? Colors.transparent,
        borderWidth: widget.borderWidth ?? 0,
        borderRadius: widget.borderRadius ?? 16,
        elevation: widget.elevation ?? 0,
      ),
    };
  }

  Size _getButtonSize() {
    if (widget.variant == ButtonVariant.link) {
      return Size(widget.width ?? 0, widget.height ?? 0);
    }

    if (widget.variant == ButtonVariant.icon) {
      const sizeMap = {
        ButtonSize.extraSmall: 28.0,
        ButtonSize.small: 36.0,
        ButtonSize.medium: 48.0,
        ButtonSize.large: 56.0,
        ButtonSize.custom: 48.0,
      };
      final size = widget.width ?? widget.height ?? sizeMap[widget.size]!;
      return Size(size, size);
    }

    final sizeMap = {
      ButtonSize.extraSmall: Size(widget.width ?? 80, widget.height ?? 32),
      ButtonSize.small: Size(widget.width ?? 100, widget.height ?? 40),
      ButtonSize.medium: Size(widget.width ?? 150, widget.height ?? 48),
      ButtonSize.large: Size(widget.width ?? 200, widget.height ?? 56),
      ButtonSize.custom: Size(widget.width ?? 150, widget.height ?? 48),
    };

    return sizeMap[widget.size]!;
  }

  EdgeInsets _getButtonPadding() {
    if (widget.padding != null) return widget.padding!;
    if (widget.variant == ButtonVariant.link) return EdgeInsets.zero;
    if (widget.variant == ButtonVariant.icon) return const EdgeInsets.all(8);

    const paddingMap = {
      ButtonSize.extraSmall: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      ButtonSize.small: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ButtonSize.medium: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ButtonSize.large: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ButtonSize.custom: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    };

    return paddingMap[widget.size]!;
  }

  double _getButtonFontSize() {
    if (widget.fontSize != null) return widget.fontSize!;

    const fontSizeMap = {
      ButtonSize.extraSmall: 10.0,
      ButtonSize.small: 12.0,
      ButtonSize.medium: 14.0,
      ButtonSize.large: 16.0,
      ButtonSize.custom: 14.0,
    };

    return fontSizeMap[widget.size]!;
  }
}

class _ButtonStyle {
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final double elevation;

  const _ButtonStyle({
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
    required this.borderWidth,
    required this.borderRadius,
    required this.elevation,
  });
}

// Convenience constructors
extension AusaButtonExtensions on AusaButton {
  static AusaButton primary({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    Color? backgroundColor,
    Color? textColor,
    double? width,
    double? height,
    ButtonSize size = ButtonSize.medium,
    IconData? icon,
    bool iconOnLeft = true,
    bool isLoading = false,
    bool isEnabled = true,
  }) => AusaButton(
    key: key,
    text: text,
    onPressed: onPressed,
    variant: ButtonVariant.primary,
    size: size,
    backgroundColor: backgroundColor,
    textColor: textColor,
    width: width,
    height: height,
    icon: icon,
    iconOnLeft: iconOnLeft,
    isLoading: isLoading,
    isEnabled: isEnabled,
  );

  static AusaButton secondary({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    Color? borderColor,
    Color? textColor,
    double? width,
    double? height,
    ButtonSize size = ButtonSize.medium,
    IconData? icon,
    bool iconOnLeft = true,
    bool isLoading = false,
    bool isEnabled = true,
  }) => AusaButton(
    key: key,
    text: text,
    onPressed: onPressed,
    variant: ButtonVariant.secondary,
    size: size,
    borderColor: borderColor,
    textColor: textColor,
    width: width,
    height: height,
    icon: icon,
    iconOnLeft: iconOnLeft,
    isLoading: isLoading,
    isEnabled: isEnabled,
  );

  static AusaButton selection({
    Key? key,
    required String text,
    required ValueChanged<bool> onSelectionChanged,
    bool isSelected = false,
    Color? activeColor,
    Color? inactiveColor,
    double? width,
    double? height,
    ButtonSize size = ButtonSize.medium,
    bool isEnabled = true,
  }) => AusaButton(
    key: key,
    text: text,
    onPressed: () {},
    variant: ButtonVariant.selection,
    size: size,
    backgroundColor: isSelected ? activeColor : inactiveColor,
    width: width,
    height: height,
    isSelected: isSelected,
    onSelectionChanged: onSelectionChanged,
    isEnabled: isEnabled,
  );

  static AusaButton link({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    Color? textColor,
    double? fontSize,
    FontWeight? fontWeight,
    IconData? icon,
    bool iconOnLeft = true,
    bool isEnabled = true,
  }) => AusaButton(
    key: key,
    text: text,
    onPressed: onPressed,
    variant: ButtonVariant.link,
    textColor: textColor,
    fontSize: fontSize,
    fontWeight: fontWeight,
    icon: icon,
    iconOnLeft: iconOnLeft,
    isEnabled: isEnabled,
  );

  static AusaButton icon({
    Key? key,
    IconData? icon,
    Widget? customIcon,
    VoidCallback? onPressed,
    Color? backgroundColor,
    Color? iconColor,
    Color? borderColor,
    double? iconSize,
    double? borderWidth,
    double? borderRadius,
    double? width,
    double? height,
    EdgeInsets? padding,
    ButtonSize size = ButtonSize.medium,
    bool isEnabled = true,
    bool enableFeedback = true,
    Duration? animationDuration,
  }) {
    assert(
      icon != null || customIcon != null,
      'Either icon or customIcon must be provided',
    );

    return AusaButton(
      key: key,
      text: '',
      onPressed: onPressed,
      variant: ButtonVariant.icon,
      size: size,
      icon: icon,
      customIcon: customIcon,
      backgroundColor: backgroundColor,
      iconColor: iconColor,
      borderColor: borderColor,
      iconSize: iconSize,
      borderWidth: borderWidth,
      borderRadius: borderRadius,
      width: width,
      height: height,
      padding: padding,
      isEnabled: isEnabled,
      enableFeedback: enableFeedback,
      animationDuration: animationDuration,
    );
  }
}
