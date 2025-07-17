import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/design_scale.dart';
import 'package:ausa/constants/icons.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CloseButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  const CloseButtonWidget({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.xl),
      child: GestureDetector(
        onTap: () => onPressed ?? Get.back(),
        child: SvgPicture.asset(
          AusaIcons.xClose,
          width: DesignScaleManager.scaleValue(40),
          height: DesignScaleManager.scaleValue(40),
          colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn),
        ),
      ),
    );
  }
}
