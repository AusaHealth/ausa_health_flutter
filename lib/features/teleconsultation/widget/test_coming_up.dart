import 'package:ausa/common/widget/buttons.dart';
import 'package:flutter/material.dart';
import 'package:ausa/features/teleconsultation/controller/teleconsultation_controller.dart';
import 'package:ausa/constants/color.dart';
import 'package:get/get.dart';

class TestComingUpDialog extends StatelessWidget {
  final TeleconsultationController controller;
  const TestComingUpDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shadowColor: AppColors.dialogShadowColor,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: [
          Column(
            children: [
              Text('Test Coming Up'),
          Text(controller.currentTest!.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            ],
          ),
          Image.asset(controller.currentTest!.image),
          
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            AusaButton(text: 'Decline', onPressed: () {
              Get.back();
              controller.cancelTest();
            }, color: Colors.white, textColor: AppColors.primaryColor, borderColor: AppColors.primaryColor,),
            const SizedBox(width: 32),
            AusaButton(text: 'Start Test', onPressed: () {
              Get.back();
              controller.requestTest();
            },),
          ],
        ),

        ],
      ),
    );
  }
}