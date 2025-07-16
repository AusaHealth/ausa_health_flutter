import 'dart:ui';

import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/design_scale.dart';
import 'package:ausa/constants/icons.dart';
import 'package:ausa/constants/radius.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class Utils {
  static String? emptyToNull(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return value;
  }

  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$",
    );
    return emailRegex.hasMatch(email);
  }

  static void showBlurredDialog(BuildContext context, Widget child) {
    showDialog(
      context: context,
      builder: (context) {
        return Stack(
          children: [
            // TO Do : Add a blur effect to the background
            // Make this constant
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 31.2, sigmaY: 31.2),
                child: Container(
                  color: const Color.fromRGBO(14, 36, 87, 0.50),
                  height: Get.height,
                  width: Get.width,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(AppSpacing.xl),
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Get.back();
                  },
                  icon: SvgPicture.asset(
                    AusaIcons.xClose,
                    height: DesignScaleManager.scaleValue(40),
                    width: DesignScaleManager.scaleValue(40),
                    colorFilter: ColorFilter.mode(
                      AppColors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Material(
                borderRadius: BorderRadius.circular(AppRadius.xl3),
                color: Colors.transparent,
                child: child,
              ),
            ),
          ],
        );
      },
    );
  }

  static String formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  static double calculateBMI({
    required double weightKg,
    required double heightCm,
  }) {
    final heightM = heightCm / 100;
    if (heightM == 0) return double.nan;
    return weightKg / (heightM * heightM);
  }

  static double inchesToCm(double inches) {
    return (inches * 2.54).toDouble();
  }

  static double cmToInches(double cm) {
    return cm / 2.54;
  }

  static int calculateAge(DateTime birthday) {
    final today = DateTime.now();
    int age = today.year - birthday.year;
    if (today.month < birthday.month ||
        (today.month == birthday.month && today.day < birthday.day)) {
      age--;
    }
    return age;
  }
}
