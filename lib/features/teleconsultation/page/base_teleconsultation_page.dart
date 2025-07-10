import 'package:ausa/common/widget/base_scaffold.dart';
import 'package:ausa/constants/color.dart';
import 'package:ausa/features/teleconsultation/controller/teleconsultation_controller.dart';
import 'package:ausa/features/teleconsultation/widget/action_bar.dart';
import 'package:ausa/features/teleconsultation/widget/doctor_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BaseTeleconsultationPage extends StatelessWidget {
  BaseTeleconsultationPage({super.key});

  final TeleconsultationController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: backgroundColor,
      appBar: appBar,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          controller.showActionBar();
        },
        child: Stack(
          children: [
            body,
            if (controller.showDoctorInfo)
              Positioned(
                left: 32,
                top: 48,
                child: DoctorInfo(doctor: controller.doctor!),
              ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ActionBar(
                autoHideContainerKey: controller.actionBarKey,
                controller: controller,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: floatingActionButton,
    );
  }

  Widget get body {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(children: [Text('Base Teleconsultation Page')]),
    );
  }

  PreferredSizeWidget? get appBar => null;

  Color get backgroundColor => AppColors.gray50;

  FloatingActionButton? get floatingActionButton => null;
}
