import 'dart:ui';

import 'package:ausa/common/widget/close_button_widget.dart';
import 'package:ausa/constants/radius.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Utils {
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
                child: CloseButtonWidget(),
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
