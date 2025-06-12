import 'package:ausa/common/controller/snackbar_controller.dart';
import 'package:ausa/common/widget/auto_hide_container.dart';
import 'package:ausa/common/widget/buttons.dart';
import 'package:ausa/common/widget/trapezium_clippers.dart';
import 'package:ausa/constants/gradients.dart';
import 'package:ausa/constants/tests.dart';
import 'package:ausa/common/model/test.dart';
import 'package:ausa/common/widget/app_icons.dart';
import 'package:ausa/constants/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../controller/teleconsultation_controller.dart';

class ActionBar extends StatelessWidget {
  final TeleconsultationController controller;
  final GlobalKey<AutoHideContainerState> autoHideContainerKey;
  final bool showIncompleteTests;
  const ActionBar({
    super.key,
    required this.autoHideContainerKey,
    required this.controller,
    this.showIncompleteTests = true,
  });

  @override
  Widget build(BuildContext context) {
    return ActionBarPillAndIncompleteTests(
      controller: controller,
      autoHideContainerKey: autoHideContainerKey,
      showIncompleteTests: showIncompleteTests,
    );
  }
}

class ActionBarPillAndIncompleteTests extends StatelessWidget {
  final TeleconsultationController controller;
  final GlobalKey<AutoHideContainerState> autoHideContainerKey;
  final bool showIncompleteTests;
  const ActionBarPillAndIncompleteTests({
    super.key,
    required this.controller,
    required this.autoHideContainerKey,
    this.showIncompleteTests = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showIncompleteTests)
          Obx(() {
            if (controller.hasIncompleteTests) {
              return IncompleteTests(controller: controller);
            }
            return SizedBox.shrink();
          }),
        ActionBarPill(
          controller: controller,
          autoHideContainerKey: autoHideContainerKey,
        ),
      ],
    );
  }
}

class IncompleteTests extends StatelessWidget {
  final TeleconsultationController controller;
  const IncompleteTests({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TrapeziumBackground(
          curveHeight: 8,
          topInset: 4,
          horizontalPadding: 24,
          verticalPadding: 8,
          child: Text(
            'Tests Requested',
            style: AppTypography.body(),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: const BoxDecoration(
            gradient: Gradients.gradient1,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Column(
            children: [
              Row(
                spacing: 8,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (var test in controller.tests) TestItem(test: test),
                ],
              ),

              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AusaButton(
                    text: 'Decline',
                    onPressed: () {
                      controller.declineTests();
                    },
                    color: Colors.white,
                    textColor: Colors.orange,
                  ),
                  const SizedBox(width: 16),
                  AusaButton(
                    text: 'Take Tests',
                    onPressed: () {
                      controller.startTests();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        ClipPath(
          clipper: BottomNipClipper(),
          child: Container(
            width: double.infinity,
            height: 10,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: const BoxDecoration(
              gradient: Gradients.gradient1,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
          ),
        ),
      ],
    );
  }
}

class TestItem extends StatelessWidget {
  final Test test;
  const TestItem({super.key, required this.test});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Image.asset(test.image, width: 120, height: 80),
              const SizedBox(height: 8),
              Text(
                test.name,
                style: AppTypography.callout(),
              ),
            ],
          ),
        ),
        if (test.isDone)
          Positioned(
            top: 0,
            right: 0,
            child: Icon(Icons.check, color: Colors.green),
          ),
      ],
    );
  }
}

class ActionBarPill extends StatelessWidget {
  ActionBarPill({
    super.key,
    required this.controller,
    required this.autoHideContainerKey,
  });

  final TeleconsultationController controller;
  final GlobalKey<AutoHideContainerState> autoHideContainerKey;
  final CustomSnackbarController snackbarController =
      CustomSnackbarController();

  @override
  Widget build(BuildContext context) {
    const double iconPadding = 12.0;

    return AutoHideContainer(
      key: autoHideContainerKey,
      child: TrapeziumBackground(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Obx(
            () => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ActionIcon(
                  iconWidget: AppIcons.videoIcon(size: IconSize.medium),
                  selected: controller.isVideoOn,
                  onTap: () => controller.setIsVideoOn(!controller.isVideoOn),
                  padding: iconPadding,
                ),
                const SizedBox(width: 16),
                _ActionIcon(
                  iconWidget: AppIcons.mikeIcon(size: IconSize.medium),
                  selected: controller.isMicOn,
                  onTap: () => controller.setIsMicOn(!controller.isMicOn),
                  padding: iconPadding,
                ),
                const SizedBox(width: 16),
                _ActionIcon(
                  iconWidget: AppIcons.testIcon(size: IconSize.medium),
                  selected: false,
                  onTap: () {
                    if (controller.tests.isEmpty) {
                      controller.setTests([
                        tests[TestType.bloodPressure]!,
                        tests[TestType.heartSignal]!,
                      ]);
                      snackbarController.show(
                        context: context,
                        leading: Icon(Icons.error, color: Colors.white),
                        body: Text(
                          'No tests available',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    } else {
                      // TODO: Implement test action
                    }
                  },
                  padding: iconPadding,
                ),
                const SizedBox(width: 16),
                _ActionIcon(
                  iconWidget: AppIcons.phoneIcon(size: IconSize.medium),
                  selected: true,
                  selectedColor: Colors.orange,
                  onTap: () {
                    // TODO: Implement end call action
                  },
                  padding: iconPadding,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final Widget iconWidget;
  final bool selected;
  final VoidCallback onTap;
  final Color? selectedColor;
  final double padding;

  const _ActionIcon({
    required this.iconWidget,
    required this.selected,
    required this.onTap,
    this.selectedColor,
    this.padding = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    final Color bg =
        selected
            ? (selectedColor ?? Colors.black.withValues(alpha: 0.08))
            : Colors.white;
    return Container(
      width: 48,
      height: 48,
      child: Material(
        color: bg,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Padding(padding: EdgeInsets.all(padding), child: iconWidget),
        ),
      ),
    );
  }
}
