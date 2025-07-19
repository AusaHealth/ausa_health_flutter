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

  // static double calculateBMI({
  //   required double weightKg,
  //   required double heightCm,
  // }) {
  //   final heightM = heightCm / 100;
  //   if (heightM == 0) return double.nan;
  //   return weightKg / (heightM * heightM);
  // }

  static double calculateBMI({
    required String heightFeetInches, // e.g. "5'11"
    required double weightLbs,
  }) {
    try {
      // Extract feet and inches from the string
      final parts = heightFeetInches.split("'");
      if (parts.length != 2) return double.nan;

      final feet = int.tryParse(parts[0].trim());
      final inches = int.tryParse(
        parts[1].replaceAll(RegExp(r'[^0-9]'), '').trim(),
      );

      if (feet == null || inches == null) return double.nan;

      // Convert height to meters
      final totalInches = (feet * 12) + inches;
      final heightM = totalInches * 0.0254;

      // Convert weight to kg
      final weightKg = weightLbs * 0.453592;

      if (heightM == 0) return double.nan;

      // Calculate BMI
      return weightKg / (heightM * heightM);
    } catch (e) {
      return double.nan;
    }
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
