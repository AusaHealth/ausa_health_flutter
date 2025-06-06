import 'package:ausa/common/enums/test_status.dart';
import 'package:ausa/common/widget/auto_hide_container.dart';
import 'package:ausa/common/widget/base_scaffold.dart';
import 'package:ausa/constants/color.dart';
import 'package:ausa/features/teleconsultation/controller/teleconsultation_controller.dart';
import 'package:ausa/features/teleconsultation/widget/action_bar.dart';
import 'package:ausa/features/teleconsultation/widget/test_in_progress.dart';
import 'package:ausa/features/teleconsultation/widget/test_instruction.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TestPage extends StatelessWidget {
  TestPage({super.key,required this.controller});
  final TeleconsultationController controller;
  
  final GlobalKey<AutoHideContainerState> _actionBarKey = GlobalKey<AutoHideContainerState>();

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: backgroundColor,
      appBar: appBar,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          _actionBarKey.currentState?.showBar();
        },
        child: Stack(
          children: [
            body,
            Positioned(
                left: 32,
                top: 48,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha:0.08),
                        blurRadius: 16,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IconButton(onPressed: (){
                    Get.back();
                  }, icon: Icon(Icons.arrow_back_ios_new_rounded,color: AppColors.primaryColor,),),
                ),
              ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ActionBar(autoHideContainerKey: _actionBarKey, controller: controller,showIncompleteTests: false),
            ),
          ],
        ),
      ),
      floatingActionButton: floatingActionButton,
    );
  }

  Widget get body {
    return Obx((){
      if(controller.currentTest==null){
      Get.back();
    }
    switch (controller.currentTestStatus) {
      case TestStatus.requested:
      case TestStatus.ready:
        return TestInstruction(controller: controller);
      case TestStatus.started:
        return TestInProgress(controller: controller);
      default:
        return SizedBox.shrink();
    }
    });
    
  }

  PreferredSizeWidget? get appBar => null;

  Color get backgroundColor => AppColors.scaffoldBackgroundColor;

  FloatingActionButton? get floatingActionButton => null;
}