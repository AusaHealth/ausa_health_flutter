import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/constants.dart';

enum ButtonVariant { primary, secondary, tertiary }

class AusaButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
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
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.md,
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
      style: AppTypography.body(
        color: isButtonEnabled ? style.textColor : Colors.grey[600],
        weight: AppTypographyWeight.semibold,
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
