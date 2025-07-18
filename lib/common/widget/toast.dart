import 'package:ausa/constants/constants.dart';
import 'package:ausa/constants/icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'package:ausa/main.dart';

enum ToastType { error, warning, success }

class CustomToast extends StatelessWidget {
  final String message;
  final ToastType type;
  final VoidCallback? onClose;

  const CustomToast({
    super.key,
    required this.message,
    required this.type,
    this.onClose,
  });

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
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(AppRadius.xl2),
            bottomRight: Radius.circular(AppRadius.xl2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
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

            Flexible(
              child: Text(
                message,
                style: AppTypography.body(
                  color: Colors.white,
                  weight: AppTypographyWeight.medium,
                ),

                overflow: TextOverflow.visible,
                softWrap: false,
              ),
            ),
            SizedBox(width: AppSpacing.xl4),
            Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: InkWell(
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
    );
  }

  static void show({
    String message = 'Connecting...',
    ToastType type = ToastType.success,
    Duration duration = const Duration(seconds: 8),
  }) {
    Color color;
    String icon;
    switch (type) {
      case ToastType.error:
        color = AppColors.toastErrorColor;
        icon = AusaIcons.checkCircleBroken;
        break;
      case ToastType.warning:
        color = AppColors.toastWarningColor;
        icon = AusaIcons.checkCircleBroken;
        break;
      case ToastType.success:
        color = AppColors.toastSuccessColor;
        icon = AusaIcons.checkCircleBroken;
        break;
    }
    showSnackbar(message: message, color: color, icon: icon, type: type);
  }
}

class AnimatedCustomToast extends StatefulWidget {
  final String message;
  final ToastType type;
  final VoidCallback? onClose;

  const AnimatedCustomToast({
    super.key,
    required this.message,
    required this.type,
    this.onClose,
  });

  @override
  State<AnimatedCustomToast> createState() => _AnimatedCustomToastState();
}

class _AnimatedCustomToastState extends State<AnimatedCustomToast>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: CustomToast(
          message: widget.message,
          type: widget.type,
          onClose: widget.onClose,
        ),
      ),
    );
  }
}

AnimationController? _currentTopSnackbar;
bool _isToastClosing = false;

void showSnackbar({
  required String message,
  required Color color,
  String icon = '',
  ToastType type = ToastType.success,
  Function()? onPressed,
}) {
  final context = Get.context ?? navigatorKey.currentContext;

  if (context == null) {
    return;
  }

  // Close any existing top snackbar
  if (_currentTopSnackbar != null &&
      !_isToastClosing &&
      _currentTopSnackbar!.isAnimating) {
    _isToastClosing = true;
    _currentTopSnackbar?.reverse();
  }
  _currentTopSnackbar = null;
  _isToastClosing = false;

  // Ensure we have a valid overlay
  final overlay = Navigator.of(context, rootNavigator: true).overlay;
  if (overlay == null) return;

  showTopSnackBar(
    overlay,
    Material(
      color: Colors.transparent,
      child: AnimatedCustomToast(
        message: message,
        type: type,
        onClose: () {
          if (_currentTopSnackbar != null &&
              !_isToastClosing &&
              _currentTopSnackbar!.isAnimating) {
            _isToastClosing = true;
            _currentTopSnackbar?.reverse();
          }
        },
      ),
    ),
    displayDuration: const Duration(seconds: 8),
    snackBarPosition: SnackBarPosition.top,
    padding: EdgeInsets.symmetric(horizontal: 16),
    onAnimationControllerInit: (controller) {
      _currentTopSnackbar = controller;
      _isToastClosing = false;
    },
    onDismissed: () {
      _currentTopSnackbar = null;
      _isToastClosing = false;
    },
  );
}
