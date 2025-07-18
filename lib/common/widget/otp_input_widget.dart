import 'package:ausa/constants/constants.dart';
import 'package:ausa/constants/design_scale.dart';
import 'package:ausa/constants/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinput/pinput.dart';

class OtpInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool obscureText;
  final PinTheme defaultPinTheme;
  final PinTheme focusedPinTheme;
  final PinTheme submittedPinTheme;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;
  final Widget? preFilledWidget;
  final VoidCallback? onTap;
  final VoidCallback? onToggleVisibility;
  final bool showVisibilityToggle;
  final Color? visibilityIconColor;
  final bool isObscured;
  final double? width;
  final double? height;
  final int length;
  final List<TextInputFormatter>? inputFormatters;

  const OtpInputWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.obscureText,
    required this.defaultPinTheme,
    required this.focusedPinTheme,
    required this.submittedPinTheme,
    this.onChanged,
    this.onCompleted,
    this.preFilledWidget,
    this.onTap,
    this.onToggleVisibility,
    this.showVisibilityToggle = false,
    this.visibilityIconColor,
    this.isObscured = false,
    this.width,
    this.height,
    this.length = 6,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    final pinTheme = defaultPinTheme.copyWith(
      width: width ?? defaultPinTheme.width,
      height: height ?? defaultPinTheme.height,
    );
    final focusedTheme = focusedPinTheme.copyWith(
      width: width ?? focusedPinTheme.width,
      height: height ?? focusedPinTheme.height,
    );
    final submittedTheme = submittedPinTheme.copyWith(
      width: width ?? submittedPinTheme.width,
      height: height ?? submittedPinTheme.height,
    );
    final pin = Pinput(
      preFilledWidget: preFilledWidget,
      onTap: onTap,
      controller: controller,
      focusNode: focusNode,
      length: length,
      obscureText: obscureText,
      inputFormatters:
          inputFormatters ?? [FilteringTextInputFormatter.digitsOnly],
      defaultPinTheme: pinTheme,
      focusedPinTheme: focusedTheme,
      submittedPinTheme: submittedTheme,
      onChanged: onChanged,
      onCompleted: onCompleted,
    );
    if (!showVisibilityToggle) {
      return pin;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: pin),
        Padding(
          padding: EdgeInsets.only(left: AppSpacing.xl2),

          child: InkWell(
            onTap: onToggleVisibility,
            borderRadius: BorderRadius.circular(32),
            child: Container(
              width: DesignScaleManager.scaleValue(88),
              height: DesignScaleManager.scaleValue(88),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: SvgPicture.asset(
                  isObscured ? AusaIcons.eyeOff : AusaIcons.eye,
                  width: DesignScaleManager.scaleValue(40),
                  height: DesignScaleManager.scaleValue(40),
                  colorFilter: ColorFilter.mode(
                    visibilityIconColor ?? Colors.blue,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
