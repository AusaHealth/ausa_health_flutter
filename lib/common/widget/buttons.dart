import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/constants.dart';

enum ButtonVariant { primary, secondary, tertiary }

enum ButtonSize { xs, s, md, lg }

class AusaButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final bool isEnabled;
  final bool isLoading;
  final double? width;
  final double? height;

  const AusaButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.s,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.leadingIcon,
    this.trailingIcon,
    this.isEnabled = true,
    this.isLoading = false,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final style = _getButtonStyle();
    final paddingConfig = _getPaddingConfig();
    final isButtonEnabled = isEnabled && !isLoading;

    return SizedBox(
      width: width,
      height: height,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(9999),
        child: InkWell(
          onTap:
              isButtonEnabled
                  ? () {
                    HapticFeedback.lightImpact();
                    onPressed?.call();
                  }
                  : null,
          borderRadius: BorderRadius.circular(9999),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: EdgeInsets.symmetric(
              horizontal: paddingConfig.horizontal,
              vertical: paddingConfig.vertical,
            ),
            decoration: BoxDecoration(
              color: isButtonEnabled ? style.backgroundColor : Colors.grey[300],
              border:
                  style.borderColor != null
                      ? Border.all(
                        color:
                            isButtonEnabled
                                ? style.borderColor!
                                : Colors.grey[400]!,
                        width: 1,
                      )
                      : null,
              borderRadius: BorderRadius.circular(9999),
              boxShadow:
                  variant == ButtonVariant.primary && isButtonEnabled
                      ? [
                        BoxShadow(
                          color: (style.backgroundColor ?? Colors.grey)
                              .withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ]
                      : null,
            ),
            child: _buildButtonContent(style, isButtonEnabled),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonContent(_ButtonStyle style, bool isButtonEnabled) {
    if (isLoading) {
      return Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              isButtonEnabled ? style.textColor : Colors.grey[600]!,
            ),
          ),
        ),
      );
    }

    final textWidget = Text(
      text,
      style: _getTextStyle(
        color: isButtonEnabled ? style.textColor : Colors.grey[600],
      ),
      textAlign: TextAlign.center,
    );

    if (leadingIcon == null && trailingIcon == null) {
      return Center(child: textWidget);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leadingIcon != null) ...[leadingIcon!, const SizedBox(width: 8)],
        Flexible(child: textWidget),
        if (trailingIcon != null) ...[const SizedBox(width: 8), trailingIcon!],
      ],
    );
  }

  TextStyle _getTextStyle({Color? color}) {
    switch (size) {
      case ButtonSize.xs:
      case ButtonSize.s:
        return AppTypography.callout(
          color: color,
          weight: AppTypographyWeight.medium,
        );
      case ButtonSize.md:
      case ButtonSize.lg:
        return AppTypography.body(
          color: color,
          weight: AppTypographyWeight.medium,
        );
    }
  }

  _ButtonPadding _getPaddingConfig() {
    return switch (size) {
      ButtonSize.xs => _ButtonPadding(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      ButtonSize.s => _ButtonPadding(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.md,
      ),
      ButtonSize.md => _ButtonPadding(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.md,
      ),
      ButtonSize.lg => _ButtonPadding(
        horizontal: AppSpacing.xl4,
        vertical: AppSpacing.xl,
      ),
    };
  }

  _ButtonStyle _getButtonStyle() {
    return switch (variant) {
      ButtonVariant.primary => _ButtonStyle(
        backgroundColor: backgroundColor ?? AppColors.primary700,
        textColor: textColor ?? Colors.white,
        borderColor: null,
      ),
      ButtonVariant.secondary => _ButtonStyle(
        backgroundColor: backgroundColor ?? Colors.white,
        textColor: textColor ?? AppColors.primary700,
        borderColor: borderColor ?? AppColors.primary700,
      ),
      ButtonVariant.tertiary => _ButtonStyle(
        backgroundColor: Colors.transparent,
        textColor: textColor ?? AppColors.primary700,
        borderColor: null,
      ),
    };
  }
}

class _ButtonStyle {
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;

  const _ButtonStyle({
    required this.backgroundColor,
    required this.textColor,
    this.borderColor,
  });
}

class _ButtonPadding {
  final double horizontal;
  final double vertical;

  const _ButtonPadding({required this.horizontal, required this.vertical});
}
