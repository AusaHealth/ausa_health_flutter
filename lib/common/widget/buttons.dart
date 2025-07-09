import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/constants.dart';


// Button size configurations following Untitled UI standards
enum ButtonSize { sm, md, lg, xl, xxl }

// Button variants
enum ButtonVariant {
  primary,
  secondary,
  tertiary,
  link,
}

// Button style configuration
class _ButtonStyleConfig {
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final Color hoverBackgroundColor;
  final Color pressedBackgroundColor;
  final Color disabledBackgroundColor;
  final Color disabledTextColor;
  final Color disabledBorderColor;
  final double borderWidth;
  final List<BoxShadow>? boxShadow;

  const _ButtonStyleConfig({
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
    required this.hoverBackgroundColor,
    required this.pressedBackgroundColor,
    required this.disabledBackgroundColor,
    required this.disabledTextColor,
    required this.disabledBorderColor,
    this.borderWidth = 0,
    this.boxShadow,
  });
}

// AusaButton Component
class AusaButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool isDestructive;
  final bool isLoading;
  final bool isDisabled;
  final bool isFullWidth;
  
  // Icons
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final Widget? customLeadingIcon;
  final Widget? customTrailingIcon;
  
  // Badge/Dot
  final bool showDot;
  final String? badge;
  final Color? badgeColor;
  final Color? badgeTextColor;
  
  // Custom styling
  final double? borderRadius;
  final EdgeInsets? customPadding;
  final TextStyle? customTextStyle;
  
  // Animation
  final Duration animationDuration;
  final bool enableHapticFeedback;

  const AusaButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.md,
    this.isDestructive = false,
    this.isLoading = false,
    this.isDisabled = false,
    this.isFullWidth = false,
    this.leadingIcon,
    this.trailingIcon,
    this.customLeadingIcon,
    this.customTrailingIcon,
    this.showDot = false,
    this.badge,
    this.badgeColor,
    this.badgeTextColor,
    this.borderRadius,
    this.customPadding,
    this.customTextStyle,
    this.animationDuration = const Duration(milliseconds: 200),
    this.enableHapticFeedback = true,
  });

  // Factory constructors for common button types
  factory AusaButton.primary({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    ButtonSize size = ButtonSize.md,
    bool isDestructive = false,
    bool isLoading = false,
    bool isDisabled = false,
    bool isFullWidth = false,
    IconData? leadingIcon,
    IconData? trailingIcon,
    Widget? customLeadingIcon,
    Widget? customTrailingIcon,
    bool showDot = false,
    String? badge,
  }) {
    return AusaButton(
      key: key,
      text: text,
      onPressed: onPressed,
      variant: ButtonVariant.primary,
      size: size,
      isDestructive: isDestructive,
      isLoading: isLoading,
      isDisabled: isDisabled,
      isFullWidth: isFullWidth,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      customLeadingIcon: customLeadingIcon,
      customTrailingIcon: customTrailingIcon,
      showDot: showDot,
      badge: badge,
    );
  }

  factory AusaButton.secondary({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    ButtonSize size = ButtonSize.md,
    bool isDestructive = false,
    bool isLoading = false,
    bool isDisabled = false,
    bool isFullWidth = false,
    IconData? leadingIcon,
    IconData? trailingIcon,
    Widget? customLeadingIcon,
    Widget? customTrailingIcon,
    bool showDot = false,
    String? badge,
  }) {
    return AusaButton(
      key: key,
      text: text,
      onPressed: onPressed,
      variant: ButtonVariant.secondary,
      size: size,
      isDestructive: isDestructive,
      isLoading: isLoading,
      isDisabled: isDisabled,
      isFullWidth: isFullWidth,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      customLeadingIcon: customLeadingIcon,
      customTrailingIcon: customTrailingIcon,
      showDot: showDot,
      badge: badge,
    );
  }

  factory AusaButton.tertiary({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    ButtonSize size = ButtonSize.md,
    bool isDestructive = false,
    bool isLoading = false,
    bool isDisabled = false,
    bool isFullWidth = false,
    IconData? leadingIcon,
    IconData? trailingIcon,
    Widget? customLeadingIcon,
    Widget? customTrailingIcon,
    bool showDot = false,
    String? badge,
  }) {
    return AusaButton(
      key: key,
      text: text,
      onPressed: onPressed,
      variant: ButtonVariant.tertiary,
      size: size,
      isDestructive: isDestructive,
      isLoading: isLoading,
      isDisabled: isDisabled,
      isFullWidth: isFullWidth,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      customLeadingIcon: customLeadingIcon,
      customTrailingIcon: customTrailingIcon,
      showDot: showDot,
      badge: badge,
    );
  }

  factory AusaButton.link({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    ButtonSize size = ButtonSize.md,
    bool isDestructive = false,
    bool isDisabled = false,
    IconData? leadingIcon,
    IconData? trailingIcon,
    Widget? customLeadingIcon,
    Widget? customTrailingIcon,
  }) {
    return AusaButton(
      key: key,
      text: text,
      onPressed: onPressed,
      variant: ButtonVariant.link,
      size: size,
      isDestructive: isDestructive,
      isDisabled: isDisabled,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      customLeadingIcon: customLeadingIcon,
      customTrailingIcon: customTrailingIcon,
    );
  }

  @override
  State<AusaButton> createState() => _AusaButtonState();
}

class _AusaButtonState extends State<AusaButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool get _isEnabled => !widget.isDisabled && !widget.isLoading && widget.onPressed != null;

  _ButtonStyleConfig get _styleConfig {
    final configs = <ButtonVariant, _ButtonStyleConfig>{
      ButtonVariant.primary: _ButtonStyleConfig(
        backgroundColor: widget.isDestructive ? AppColors.error600 : AppColors.primary600,
        textColor: AppColors.white,
        borderColor: widget.isDestructive ? AppColors.error600 : AppColors.primary600,
        hoverBackgroundColor: widget.isDestructive ? AppColors.error700 : AppColors.primary700,
        pressedBackgroundColor: widget.isDestructive ? AppColors.error800 : AppColors.primary800,
        disabledBackgroundColor: AppColors.gray200,
        disabledTextColor: AppColors.gray400,
        disabledBorderColor: AppColors.gray200,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 1),
            blurRadius: 2,
            color: AppColors.gray900.withOpacity(0.05),
          ),
        ],
      ),
      ButtonVariant.secondary: _ButtonStyleConfig(
        backgroundColor: AppColors.white,
        textColor: widget.isDestructive ? AppColors.error700 : AppColors.gray700,
        borderColor: AppColors.gray300,
        hoverBackgroundColor: AppColors.gray50,
        pressedBackgroundColor: AppColors.gray100,
        disabledBackgroundColor: AppColors.white,
        disabledTextColor: AppColors.gray300,
        disabledBorderColor: AppColors.gray200,
        borderWidth: 1,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 1),
            blurRadius: 2,
            color: AppColors.gray900.withOpacity(0.05),
          ),
        ],
      ),
      ButtonVariant.tertiary: _ButtonStyleConfig(
        backgroundColor: Colors.transparent,
        textColor: widget.isDestructive ? AppColors.error700 : AppColors.gray600,
        borderColor: Colors.transparent,
        hoverBackgroundColor: AppColors.gray50,
        pressedBackgroundColor: AppColors.gray100,
        disabledBackgroundColor: Colors.transparent,
        disabledTextColor: AppColors.gray300,
        disabledBorderColor: Colors.transparent,
      ),
      ButtonVariant.link: _ButtonStyleConfig(
        backgroundColor: Colors.transparent,
        textColor: widget.isDestructive ? AppColors.error700 : AppColors.primary700,
        borderColor: Colors.transparent,
        hoverBackgroundColor: Colors.transparent,
        pressedBackgroundColor: Colors.transparent,
        disabledBackgroundColor: Colors.transparent,
        disabledTextColor: AppColors.gray300,
        disabledBorderColor: Colors.transparent,
      ),
    };

    return configs[widget.variant]!;
  }

  Size get _buttonSize {
    final sizes = <ButtonSize, Size>{
      ButtonSize.sm: const Size(0, 36),
      ButtonSize.md: const Size(0, 40),
      ButtonSize.lg: const Size(0, 44),
      ButtonSize.xl: const Size(0, 48),
      ButtonSize.xxl: const Size(0, 56),
    };
    return sizes[widget.size]!;
  }

  EdgeInsets get _padding {
    if (widget.customPadding != null) return widget.customPadding!;
    
    final isLink = widget.variant == ButtonVariant.link;
    final paddings = <ButtonSize, EdgeInsets>{
      ButtonSize.sm: EdgeInsets.symmetric(horizontal: isLink ? 0 : 12, vertical: 8),
      ButtonSize.md: EdgeInsets.symmetric(horizontal: isLink ? 0 : 14, vertical: 10),
      ButtonSize.lg: EdgeInsets.symmetric(horizontal: isLink ? 0 : 16, vertical: 10),
      ButtonSize.xl: EdgeInsets.symmetric(horizontal: isLink ? 0 : 18, vertical: 12),
      ButtonSize.xxl: EdgeInsets.symmetric(horizontal: isLink ? 0 : 22, vertical: 16),
    };
    return paddings[widget.size]!;
  }

  TextStyle get _textStyle {
    if (widget.customTextStyle != null) return widget.customTextStyle!;
    
    final textStyles = <ButtonSize, TextStyle>{
      ButtonSize.sm: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 20/14),
      ButtonSize.md: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 20/14),
      ButtonSize.lg: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 24/16),
      ButtonSize.xl: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 24/16),
      ButtonSize.xxl: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, height: 28/18),
    };
    return textStyles[widget.size]!;
  }

  double get _iconSize {
    final sizes = <ButtonSize, double>{
      ButtonSize.sm: 16,
      ButtonSize.md: 16,
      ButtonSize.lg: 20,
      ButtonSize.xl: 20,
      ButtonSize.xxl: 24,
    };
    return sizes[widget.size]!;
  }

  double get _iconSpacing {
    return widget.size == ButtonSize.xxl ? 12 : 8;
  }

  double get _borderRadius => widget.borderRadius ?? 8;

  void _handleTapDown(TapDownDetails details) {
    if (!_isEnabled) return;
    setState(() => _isPressed = true);
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    if (!_isEnabled) return;
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _handleTap() {
    if (!_isEnabled) return;
    if (widget.enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }
    widget.onPressed?.call();
  }

  Widget _buildIcon(IconData? icon, Widget? customIcon) {
    if (icon == null && customIcon == null) return const SizedBox.shrink();
    
    final iconWidget = customIcon ?? Icon(
      icon,
      size: _iconSize,
      color: _isEnabled ? _styleConfig.textColor : _styleConfig.disabledTextColor,
    );

    return iconWidget;
  }

  Widget _buildDot() {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _isEnabled ? _styleConfig.textColor : _styleConfig.disabledTextColor,
      ),
    );
  }

  Widget _buildBadge() {
    if (widget.badge == null) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: widget.badgeColor ?? (_isEnabled ? _styleConfig.textColor : _styleConfig.disabledTextColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        widget.badge!,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: widget.badgeTextColor ?? AppColors.white,
          height: 16/12,
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (widget.isLoading) {
      return SizedBox(
        width: _iconSize,
        height: _iconSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            _isEnabled ? _styleConfig.textColor : _styleConfig.disabledTextColor,
          ),
        ),
      );
    }

    final List<Widget> children = [];

    // Dot indicator
    if (widget.showDot) {
      children.add(_buildDot());
      children.add(SizedBox(width: _iconSpacing));
    }

    // Leading icon
    final leadingIcon = _buildIcon(widget.leadingIcon, widget.customLeadingIcon);
    if (widget.leadingIcon != null || widget.customLeadingIcon != null) {
      children.add(leadingIcon);
      children.add(SizedBox(width: _iconSpacing));
    }

    // Text
    children.add(
      Text(
        widget.text,
        style: _textStyle.copyWith(
          color: _isEnabled ? _styleConfig.textColor : _styleConfig.disabledTextColor,
          decoration: widget.variant == ButtonVariant.link ? TextDecoration.underline : null,
        ),
      ),
    );

    // Badge
    if (widget.badge != null) {
      children.add(SizedBox(width: _iconSpacing));
      children.add(_buildBadge());
    }

    // Trailing icon
    final trailingIcon = _buildIcon(widget.trailingIcon, widget.customTrailingIcon);
    if (widget.trailingIcon != null || widget.customTrailingIcon != null) {
      children.add(SizedBox(width: _iconSpacing));
      children.add(trailingIcon);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  Color get _currentBackgroundColor {
    if (!_isEnabled) return _styleConfig.disabledBackgroundColor;
    if (_isPressed) return _styleConfig.pressedBackgroundColor;
    if (_isHovered) return _styleConfig.hoverBackgroundColor;
    return _styleConfig.backgroundColor;
  }

  Color get _currentBorderColor {
    if (!_isEnabled) return _styleConfig.disabledBorderColor;
    return _styleConfig.borderColor;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: MouseRegion(
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            cursor: _isEnabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
            child: GestureDetector(
              onTapDown: _handleTapDown,
              onTapUp: _handleTapUp,
              onTapCancel: _handleTapCancel,
              onTap: _handleTap,
              child: AnimatedContainer(
                duration: widget.animationDuration,
                curve: Curves.easeInOut,
                height: _buttonSize.height,
                constraints: BoxConstraints(
                  minWidth: widget.isFullWidth ? double.infinity : 0,
                ),
                padding: _padding,
                decoration: BoxDecoration(
                  color: _currentBackgroundColor,
                  borderRadius: BorderRadius.circular(_borderRadius),
                  border: _styleConfig.borderWidth > 0
                      ? Border.all(
                          color: _currentBorderColor,
                          width: _styleConfig.borderWidth,
                        )
                      : null,
                  boxShadow: _styleConfig.boxShadow,
                ),
                child: _buildContent(),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Example usage
class ButtonExamples extends StatelessWidget {
  const ButtonExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Primary buttons
            const Text('Primary Buttons', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                AusaButton.primary(
                  text: 'Button CTA',
                  onPressed: () {},
                  leadingIcon: Icons.add,
                ),
                AusaButton.primary(
                  text: 'Button CTA',
                  onPressed: () {},
                  trailingIcon: Icons.arrow_forward,
                ),
                AusaButton.primary(
                  text: 'Button CTA',
                  onPressed: () {},
                  showDot: true,
                ),
                AusaButton.primary(
                  text: 'Button CTA',
                  onPressed: () {},
                  badge: '12',
                ),
                AusaButton.primary(
                  text: 'Destructive',
                  onPressed: () {},
                  isDestructive: true,
                  leadingIcon: Icons.delete,
                ),
                AusaButton.primary(
                  text: 'Disabled',
                  onPressed: () {},
                  isDisabled: true,
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Secondary buttons
            const Text('Secondary Buttons', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                AusaButton.secondary(
                  text: 'Button CTA',
                  onPressed: () {},
                  leadingIcon: Icons.cloud_upload,
                ),
                AusaButton.secondary(
                  text: 'Button CTA',
                  onPressed: () {},
                  trailingIcon: Icons.download,
                ),
                AusaButton.secondary(
                  text: 'Destructive',
                  onPressed: () {},
                  isDestructive: true,
                  leadingIcon: Icons.close,
                ),
                AusaButton.secondary(
                  text: 'Disabled',
                  onPressed: () {},
                  isDisabled: true,
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Tertiary buttons
            const Text('Tertiary Buttons', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                AusaButton.tertiary(
                  text: 'Button CTA',
                  onPressed: () {},
                  leadingIcon: Icons.settings,
                ),
                AusaButton.tertiary(
                  text: 'Button CTA',
                  onPressed: () {},
                  trailingIcon: Icons.chevron_right,
                ),
                AusaButton.tertiary(
                  text: 'Destructive',
                  onPressed: () {},
                  isDestructive: true,
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Link buttons
            const Text('Link Buttons', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                AusaButton.link(
                  text: 'Button CTA',
                  onPressed: () {},
                  leadingIcon: Icons.arrow_back,
                ),
                AusaButton.link(
                  text: 'Button CTA',
                  onPressed: () {},
                  trailingIcon: Icons.arrow_forward,
                ),
                AusaButton.link(
                  text: 'Destructive',
                  onPressed: () {},
                  isDestructive: true,
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Different sizes
            const Text('Button Sizes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                AusaButton.primary(text: 'Small', onPressed: () {}, size: ButtonSize.sm),
                AusaButton.primary(text: 'Medium', onPressed: () {}, size: ButtonSize.md),
                AusaButton.primary(text: 'Large', onPressed: () {}, size: ButtonSize.lg),
                AusaButton.primary(text: 'Extra Large', onPressed: () {}, size: ButtonSize.xl),
                AusaButton.primary(text: '2X Large', onPressed: () {}, size: ButtonSize.xxl),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // States
            const Text('Button States', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AusaButton.primary(text: 'Loading', onPressed: () {}, isLoading: true),
                const SizedBox(height: 12),
                AusaButton(
                  text: 'Full Width Button',
                  onPressed: () {},
                  isFullWidth: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}