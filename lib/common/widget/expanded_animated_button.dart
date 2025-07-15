import 'package:ausa/common/widget/buttons.dart';
import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/design_scale.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ExpandedAnimatedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final String icon;
  final Color? textColor;
  const ExpandedAnimatedButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
    required this.icon,
    this.textColor = AppColors.accent,
  });

  @override
  State<ExpandedAnimatedButton> createState() => ExpandedAnimatedButtonState();
}

class ExpandedAnimatedButtonState extends State<ExpandedAnimatedButton> {
  bool showFull = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) setState(() => showFull = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder:
          (child, animation) => ScaleTransition(scale: animation, child: child),
      child:
          showFull
              ? AusaButton(
                key: const ValueKey('full'),
                backgroundColor: Colors.white,
                leadingIcon: SvgPicture.asset(
                  widget.icon,
                  width: DesignScaleManager.scaleValue(32),
                  height: DesignScaleManager.scaleValue(32),
                  colorFilter: ColorFilter.mode(
                    AppColors.accent,
                    BlendMode.srcIn,
                  ),
                ),
                text: widget.buttonText,
                onPressed: widget.onPressed,
                textColor: widget.textColor,
              )
              : Material(
                key: const ValueKey('mini'),
                color: Colors.white,
                shape: const CircleBorder(),
                elevation: 2,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: widget.onPressed,
                  child: Container(
                    margin: EdgeInsets.all(AppSpacing.smMedium),
                    // padding: EdgeInsets.all(AppSpacing.xl2),
                    width: DesignScaleManager.scaleValue(48),
                    height: DesignScaleManager.scaleValue(48),
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      widget.icon,
                      width: DesignScaleManager.scaleValue(32),
                      height: DesignScaleManager.scaleValue(32),
                      colorFilter: ColorFilter.mode(
                        AppColors.accent,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
    );
  }
}
