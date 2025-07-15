import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/constants.dart';
import 'package:ausa/constants/design_scale.dart';
import 'package:ausa/constants/icons.dart';
import 'package:ausa/constants/radius.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum ToastType { error, warning, success }

class CustomToast extends StatelessWidget {
  final String message;
  final ToastType type;
  final VoidCallback? onClose;

  const CustomToast({
    Key? key,
    required this.message,
    required this.type,
    this.onClose,
  }) : super(key: key);

  Color get backgroundColor {
    switch (type) {
      case ToastType.error:
        return AppColors.toastErrorColor; // Red
      case ToastType.warning:
        return AppColors.toastWarningColor; // Orange
      case ToastType.success:
        return AppColors.toastSuccessColor; // Green
    }
  }

  Color get iconBgColor {
    switch (type) {
      case ToastType.error:
        return AppColors.toastErrorIconColor;
      case ToastType.warning:
        return AppColors.toastWarningIconColor;
      case ToastType.success:
        return AppColors.toastSuccessIconColor;
    }
  }

  String get iconAsset => AusaIcons.checkCircleBroken;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: DesignScaleManager.scaleValue(516),
        ),
        child: Container(
          height: DesignScaleManager.scaleValue(112),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(AppRadius.xl3),
              bottomRight: Radius.circular(AppRadius.xl3),
            ),
          ),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Container(
                  width: DesignScaleManager.scaleValue(72),
                  height: DesignScaleManager.scaleValue(72),
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      iconAsset,
                      width: DesignScaleManager.scaleValue(48),
                      height: DesignScaleManager.scaleValue(48),
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: Text(
                  message,
                  style: AppTypography.body(
                    color: Colors.white,
                    weight: AppTypographyWeight.medium,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: GestureDetector(
                  onTap: onClose ?? () => Get.closeCurrentSnackbar(),
                  child: Container(
                    width: DesignScaleManager.scaleValue(72),
                    height: DesignScaleManager.scaleValue(72),
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        AusaIcons.xClose,
                        width: DesignScaleManager.scaleValue(32),
                        height: DesignScaleManager.scaleValue(32),
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void show(
    String message, {
    ToastType type = ToastType.success,
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.closeAllSnackbars();
    Get.rawSnackbar(
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.transparent,
      borderRadius: 0,
      messageText: CustomToast(message: message, type: type),
      duration: duration,
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOut,
      reverseAnimationCurve: Curves.easeIn,
      snackStyle: SnackStyle.GROUNDED,
    );
  }
}
