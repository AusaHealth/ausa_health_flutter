import 'package:ausa/common/enums/test_status.dart';
import 'package:ausa/common/widget/buttons.dart';
import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/gradients.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/features/teleconsultation/widget/instruction_card_scrollable.dart';
import 'package:flutter/material.dart';
import 'package:ausa/features/teleconsultation/controller/teleconsultation_controller.dart';
import 'package:get/get.dart';

class TestInstruction extends StatefulWidget {
  final TeleconsultationController controller;
  const TestInstruction({super.key, required this.controller});

  @override
  State<TestInstruction> createState() => _TestInstructionState();
}

class _TestInstructionState extends State<TestInstruction> {
  bool isDetailed = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 10), () {
      widget.controller.setCurrentTestStatus(TestStatus.ready);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (widget.controller.currentTestStatus == TestStatus.ready) {
        isDetailed = false;
      }
      if (!isDetailed) {
        return Stack(
          children: [
            MainInstructionContainer(controller: widget.controller),
            Positioned(
              bottom: 0,
              left: 0,
              child:
                  widget.controller.currentTestStatus == TestStatus.ready
                      ? ReadyInstructionContainer()
                      : SecondaryInstructionContainer(
                        controller: widget.controller,
                        onShowMore: (bool isShowMore) {
                          setState(() {
                            isDetailed = isShowMore;
                          });
                        },
                      ),
            ),
          ],
        );
      } else {
        return Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(flex: 1, child: SizedBox()),
                  Expanded(
                    flex: 5,
                    child: Container(
                      margin: const EdgeInsets.only(left: 16, bottom: 16),
                      child: InstructionCardScrollable(
                        test: widget.controller.currentTest!,
                        onShowLess: (bool isShowLess) {
                          setState(() {
                            isDetailed = !isShowLess;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: MainInstructionContainer(controller: widget.controller),
            ),
          ],
        );
      }
    });
  }
}

class ReadyInstructionContainer extends StatelessWidget {
  const ReadyInstructionContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(40),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/ready_gradient.png"),
          fit: BoxFit.fitWidth,
        ),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          Text(
            'Your are all set',
            style: AppTypography.body(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          RichText(
            text: TextSpan(
              style: AppTypography.body(color: Colors.white),
              children: [
                TextSpan(text: 'Test starting automatically in 3'),
                TextSpan(text: '\nseconds.'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SecondaryInstructionContainer extends StatelessWidget {
  const SecondaryInstructionContainer({
    super.key,
    required this.controller,
    required this.onShowMore,
  });

  final TeleconsultationController controller;
  final Function(bool) onShowMore;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackgroundColor,
        gradient: Gradients.gradient2,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Color.fromARGB(150, 165, 199, 255)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          Text(
            'Instruction',
            style: AppTypography.body(fontWeight: FontWeight.w600),
          ),
          Text(
            controller.currentTest!.instruction!,
            style: AppTypography.body(),
          ),
          TextButton(
            onPressed: () {
              onShowMore(true);
            },
            child: Text(
              'Show more',
              style: AppTypography.callout(color: Color(0xFF2978FB)),
            ),
          ),
        ],
      ),
    );
  }
}

class MainInstructionContainer extends StatelessWidget {
  const MainInstructionContainer({super.key, required this.controller});

  final TeleconsultationController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackgroundColor,
        image: DecorationImage(
          image: AssetImage(controller.currentTest!.image),
          fit: BoxFit.fitWidth,
        ),
      ),
      child: Align(
        alignment: Alignment.bottomRight,
        child: Obx(() {
          if (controller.currentTestStatus == TestStatus.ready) {
            return AusaButton(
              text: 'Start Test',
              onPressed: () {
                controller.startTest();
              },
              color: Colors.white,
              textColor: Colors.orange,
            );
          }
          return SizedBox();
        }),
      ),
    );
  }
}
