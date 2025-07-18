import 'package:ausa/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomLoader {
  static bool _isLoading = false;

  static void show({String message = 'Loading...'}) {
    if (!_isLoading) {
      _isLoading = true;
      Get.dialog(
        WillPopScope(
          onWillPop: () async => false,
          child: Stack(
            children: [
              ModalBarrier(
                color: Colors.black.withOpacity(0.3),
                dismissible: false,
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.toastWarningColor,
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
                              color: AppColors.toastWarningIconColor,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: SizedBox(
                                width: DesignScaleManager.scaleValue(40),
                                height: DesignScaleManager.scaleValue(40),
                                child: CircularProgressIndicator.adaptive(
                                  backgroundColor: Colors.white,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                  strokeWidth: 4,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(right: AppSpacing.xl2),
                            child: Text(
                              message,
                              style: AppTypography.body(
                                color: Colors.white,
                                weight: AppTypographyWeight.medium,
                              ),
                              overflow: TextOverflow.visible,
                              softWrap: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        barrierDismissible: false,
        useSafeArea: false,
        barrierColor: Colors.transparent,
      );
    }
  }

  static void hide() {
    if (_isLoading) {
      _isLoading = false;
      Get.back();
    }
  }
}
