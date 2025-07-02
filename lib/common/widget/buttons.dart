import 'package:flutter/material.dart';
import '../../constants/constants.dart';

class AusaButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final Color? textColor;
  final double? fontSize;
  final double? borderRadius;
  final double? padding;
  final double? margin;
  final double? width;
  final double? height;
  final FontWeight? fontWeight;
  final double? borderWidth;
  final Color? borderColor;

  const AusaButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = Colors.blueAccent,
    this.textColor = Colors.white,
    this.fontSize = 12,
    this.borderRadius = 32,
    this.padding = 8,
    this.margin = 0,
    this.width = 120,
    this.height = 48,
    this.fontWeight = FontWeight.normal,
    this.borderWidth = 0,
    this.borderColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        margin: EdgeInsets.all(margin ?? 0),
        padding: EdgeInsets.all(padding ?? 0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius ?? 0),
          border: Border.all(
            color: borderColor ?? Colors.transparent,
            width: borderWidth ?? 0,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
          ),
        ),
      ),
    );
  }
}

class SelectionButton extends StatefulWidget {
  final String text;
  final bool initialSelected;
  final ValueChanged<bool> onSelectionChanged;
  final double? width;
  final double? height;
  final double? padding;
  final double? margin;
  final bool isEnabled;

  const SelectionButton({
    super.key,
    required this.text,
    required this.onSelectionChanged,
    this.initialSelected = false,
    this.width,
    this.height,
    this.padding = 8,
    this.margin = 0,
    this.isEnabled = true,
  });

  @override
  State<SelectionButton> createState() => _SelectionButtonState();
}

class _SelectionButtonState extends State<SelectionButton> {
  late bool isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = widget.initialSelected;
  }

  void _toggleSelection() {
    if (!widget.isEnabled) return;

    setState(() {
      isSelected = !isSelected;
    });
    widget.onSelectionChanged(isSelected);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isEnabled ? _toggleSelection : null,
      child: Container(
        width: widget.width,
        height: widget.height,
        margin: EdgeInsets.all(widget.margin ?? 0),
        padding: EdgeInsets.all(widget.padding ?? 16),
        decoration: BoxDecoration(
          color:
              !widget.isEnabled
                  ? Colors.grey[100]
                  : isSelected
                  ? AppColors.selectionButtonActive
                  : AppColors.selectionButtonBackground,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color:
                !widget.isEnabled
                    ? Colors.grey[300]!
                    : isSelected
                    ? AppColors.selectionButtonActive
                    : AppColors.selectionButtonBackground,
            width: !widget.isEnabled ? 1.5 : 2,
          ),
        ),
        child: Center(
          child: Text(
            widget.text,
            style: AppTypography.body(
              color:
                  !widget.isEnabled
                      ? Colors.grey[400]
                      : isSelected
                      ? AppColors.selectionButtonActiveText
                      : AppColors.selectionButtonText,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class TertiaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color? color;
  final Color? textColor;
  final Color? iconColor;
  final double? fontSize;
  final double? borderRadius;
  final double? padding;
  final double? margin;
  final double? width;
  final double? height;
  final FontWeight? fontWeight;
  final double? borderWidth;
  final Color? borderColor;
  final double? iconSize;
  final double? spacing;
  final bool iconOnLeft;

  const TertiaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.color = Colors.transparent,
    this.textColor = Colors.grey,
    this.iconColor,
    this.fontSize = 12,
    this.borderRadius = 32,
    this.padding = 12,
    this.margin = 0,
    this.width,
    this.height = 48,
    this.fontWeight = FontWeight.w500,
    this.borderWidth = 1,
    this.borderColor = Colors.grey,
    this.iconSize = 16,
    this.spacing = 8,
    this.iconOnLeft = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        margin: EdgeInsets.all(margin ?? 0),
        padding: EdgeInsets.all(padding ?? 12),
        child: Center(
          child:
              icon != null
                  ? Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (iconOnLeft) ...[
                        Icon(
                          icon,
                          size: iconSize,
                          color: iconColor ?? textColor,
                        ),
                        SizedBox(width: spacing),
                      ],
                      Flexible(
                        child: Text(
                          text,
                          style: AppTypography.body(color: textColor),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!iconOnLeft) ...[
                        SizedBox(width: spacing),
                        Icon(
                          icon,
                          size: iconSize,
                          color: iconColor ?? textColor,
                        ),
                      ],
                    ],
                  )
                  : Text(text, style: AppTypography.headline(color: textColor)),
        ),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? borderRadius;
  final double? padding;
  final double? margin;
  final FontWeight? fontWeight;
  final bool isLoading;
  final bool isEnabled;
  final IconData? icon;
  final double? iconSize;
  final double? spacing;
  final bool iconOnLeft;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = 56,
    this.borderRadius = 16,
    this.padding = 16,
    this.margin = 0,
    this.fontWeight = FontWeight.w600,
    this.isLoading = false,
    this.isEnabled = true,
    this.icon,
    this.iconSize = 20,
    this.spacing = 8,
    this.iconOnLeft = true,
  });

  @override
  Widget build(BuildContext context) {
    final bool isButtonEnabled = isEnabled && onPressed != null && !isLoading;
    final Color effectiveBackgroundColor =
        !isButtonEnabled
            ? Colors.grey[300]!
            : backgroundColor ?? AppColors.primaryColor;
    final Color effectiveTextColor =
        !isButtonEnabled ? Colors.grey[500]! : textColor ?? Colors.white;

    return GestureDetector(
      onTap: isButtonEnabled ? onPressed : null,
      child: Container(
        width: width,
        height: height,
        margin: EdgeInsets.all(margin ?? 0),
        padding: EdgeInsets.all(padding ?? 16),
        decoration: BoxDecoration(
          color: effectiveBackgroundColor,
          borderRadius: BorderRadius.circular(borderRadius ?? 16),
          boxShadow:
              isButtonEnabled
                  ? [
                    BoxShadow(
                      color: (backgroundColor ?? AppColors.primaryColor)
                          .withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : null,
        ),
        child: Center(
          child:
              isLoading
                  ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        effectiveTextColor,
                      ),
                    ),
                  )
                  : icon != null
                  ? Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (iconOnLeft) ...[
                        Icon(icon, size: iconSize, color: effectiveTextColor),
                        SizedBox(width: spacing),
                      ],
                      Flexible(
                        child: Text(
                          text,
                          style: AppTypography.body(
                            color: effectiveTextColor,
                            fontWeight: fontWeight ?? FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!iconOnLeft) ...[
                        SizedBox(width: spacing),
                        Icon(icon, size: iconSize, color: effectiveTextColor),
                      ],
                    ],
                  )
                  : Text(
                    text,
                    style: AppTypography.body(
                      color: effectiveTextColor,
                      fontWeight: fontWeight ?? FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
        ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? borderColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? borderRadius;
  final double? padding;
  final double? margin;
  final FontWeight? fontWeight;
  final bool isLoading;
  final bool isEnabled;
  final IconData? icon;
  final double? iconSize;
  final double? spacing;
  final bool iconOnLeft;
  final double? borderWidth;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.borderColor,
    this.textColor,
    this.width,
    this.height = 56,
    this.borderRadius = 32,
    this.padding = 20,
    this.margin = 0,
    this.fontWeight = FontWeight.w600,
    this.isLoading = false,
    this.isEnabled = true,
    this.icon,
    this.iconSize = 20,
    this.spacing = 10,
    this.iconOnLeft = true,
    this.borderWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    final bool isButtonEnabled = isEnabled && onPressed != null && !isLoading;
    final Color effectiveTextColor =
        !isButtonEnabled
            ? Colors.grey[400]!
            : textColor ?? AppColors.primaryColor;

    return GestureDetector(
      onTap: isButtonEnabled ? onPressed : null,
      child: Container(
        margin: EdgeInsets.all(margin ?? 0),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius ?? 32),
        ),
        child: Center(
          child:
              isLoading
                  ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        effectiveTextColor,
                      ),
                    ),
                  )
                  : icon != null
                  ? Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (iconOnLeft) ...[
                        Icon(icon, size: iconSize, color: effectiveTextColor),
                        SizedBox(width: spacing),
                      ],
                      Flexible(
                        child: Text(
                          text,
                          style: AppTypography.body(
                            color: effectiveTextColor,
                            fontWeight: fontWeight ?? FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!iconOnLeft) ...[
                        SizedBox(width: spacing),
                        Icon(icon, size: iconSize, color: effectiveTextColor),
                      ],
                    ],
                  )
                  : Text(
                    text,
                    style: AppTypography.body(
                      color: effectiveTextColor,
                      fontWeight: fontWeight ?? FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
        ),
      ),
    );
  }
}
