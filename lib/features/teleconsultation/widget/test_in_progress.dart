import 'package:ausa/common/widget/buttons.dart';
import 'package:ausa/constants/color.dart';
import 'package:ausa/features/teleconsultation/controller/teleconsultation_controller.dart';
import 'package:ausa/features/teleconsultation/widget/animated_test_timer.dart';
import 'package:flutter/material.dart';

class TestInProgress extends StatefulWidget {
  final TeleconsultationController controller;
  const TestInProgress({super.key, required this.controller});

  @override
  State<TestInProgress> createState() => _TestInProgressState();
}

class _TestInProgressState extends State<TestInProgress> {

  bool isCompleted = false;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.scaffoldBackgroundColor,
      child: Column(
        children: [
          Expanded(child: SizedBox()),
          Expanded(
            child: AnimatedTestTimerWidget(duration: 10, centerWidget: Image.asset(widget.controller.currentTest!.image,), completedWidget: Icon(Icons.check,color: Colors.green,), onCompleted: () {
              setState(() {
                isCompleted = true;
              });
              Future.delayed(Duration(seconds: 1), () {
                widget.controller.completeTest();
              });
            },),
          ),
          Expanded(child: isCompleted ? SizedBox() : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AusaButton(text: "Stop Test", onPressed: () {
                  widget.controller.cancelTest();
                }),
              ],
            ),
          )),
        ],
      ),
    );
  }
}