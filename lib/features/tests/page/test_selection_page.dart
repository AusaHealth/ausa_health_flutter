import 'package:ausa/common/widget/app_back_header.dart';
import 'package:ausa/common/widget/app_main_container.dart';
import 'package:ausa/common/widget/buttons.dart';
import 'package:ausa/constants/color.dart';
import 'package:ausa/features/tests/controller/test_controller.dart';
import 'package:ausa/features/tests/widget/test_selection_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TestSelectionPage extends StatelessWidget {
  TestSelectionPage({super.key});

  final TestController controller = Get.find<TestController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      body: Column(
        children: [
          const AppBackHeader(title: 'Your Tests'),
          Expanded(
            child: Stack(
              children: [
                Obx(
                  () =>
                      controller.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _buildTestGrid(),
                ),
                _buildActionButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestGrid() {
    return AppMainContainer(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 0.95,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: controller.availableTests.length,
        itemBuilder: (context, index) {
          final test = controller.availableTests[index];
          return TestSelectionCard(
            test: test,
            onTap: () => controller.toggleTestSelection(test),
            onCategoryTap:
                test.hasCategories
                    ? () => controller.showCategorySelectionDialog(test)
                    : null,
          );
        },
      ),
    );
  }

  Widget _buildActionButton() {
    return Obx(() {
      if (!controller.hasSelectedTests) {
        return const SizedBox.shrink();
      }

      return Positioned(
        bottom: 26,
        right: 24,
        child: AusaButton(
          text: 'Start Test${controller.selectedTestsCount == 1 ? '' : 's'}',
          onPressed:
              controller.canStartSession
                  ? () => controller.startTestSession()
                  : null,
          isLoading: controller.isLoading,
          variant: ButtonVariant.primary,
        ),
      );
    });
  }
}
