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
    if (oldWidget.isSelected != widget.isSelected) {
      _currentSelection = widget.isSelected;
    }
  }
 
  void _handleTap() {
    if (!_isButtonEnabled) return;
 
    if (widget.enableFeedback) {
      HapticFeedback.lightImpact();
    }
 
    if (widget.onSelectionChanged != null) {
      setState(() => _currentSelection = !_currentSelection);
      widget.onSelectionChanged!(_currentSelection);
    }
 
    widget.onPressed?.call();
  }
 
  bool get _isButtonEnabled => widget.isEnabled && !widget.isLoading;
 
  @override
  Widget build(BuildContext context) {
    final style = _getButtonStyle();
    final size = _getButtonSize();
 
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder:
          (context, child) => Transform.scale(
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
                  onTap: _handleTap,
                  onTapDown:
                      (_) =>
                          _isButtonEnabled
                              ? _animationController.forward()
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
          ),
    );
  }
 
  Widget _buildButtonContent() {
    if (widget.child != null) return widget.child!;
 
    if (widget.isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            _getButtonStyle().textColor,
          ),
        ),
      );
    }
 
    final iconWidget =
        widget.customIcon ??
        (widget.icon != null
            ? Icon(
              widget.icon,
              size: widget.iconSize ?? _getButtonFontSize() + 4,
              color:
                  widget.isEnabled
                      ? widget.iconColor ?? _getButtonStyle().textColor
                      : Colors.grey[600]!,
            )
            : null);
 
    final textWidget =
        widget.text.isNotEmpty
            ? Text(
              widget.text,
              style:
                  widget.textStyle ??
                  TextStyle(
                    color:
                        widget.isEnabled
                            ? _getButtonStyle().textColor
                            : Colors.grey[600]!,
                    fontSize: _getButtonFontSize(),
                    fontWeight: widget.fontWeight ?? FontWeight.w600,
                    fontFamily: widget.fontFamily,
                  ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            )
            : null;
 
    if (iconWidget == null && textWidget == null)
      return const SizedBox.shrink();
    if (iconWidget == null) return textWidget!;
    if (textWidget == null) return iconWidget;
 
    return Row(
      mainAxisSize: widget.mainAxisSize ?? MainAxisSize.min,
      mainAxisAlignment: widget.mainAxisAlignment ?? MainAxisAlignment.center,
      crossAxisAlignment:
          widget.crossAxisAlignment ?? CrossAxisAlignment.center,
      children:
          widget.iconOnLeft
              ? [
                iconWidget,
                SizedBox(width: widget.iconSpacing ?? 8),
                Flexible(child: textWidget!),
              ]
              : [
                Flexible(child: textWidget!),
                SizedBox(width: widget.iconSpacing ?? 8),
                iconWidget,
              ],
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
      final sizeMap = {
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
 
    final paddingMap = {
      ButtonSize.extraSmall: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 6,
      ),
      ButtonSize.small: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ButtonSize.medium: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      ButtonSize.large: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ),
      ButtonSize.custom: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
    };
 
    return paddingMap[widget.size]!;
  }
 
  double _getButtonFontSize() {
    if (widget.fontSize != null) return widget.fontSize!;
 
    final fontSizeMap = {
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