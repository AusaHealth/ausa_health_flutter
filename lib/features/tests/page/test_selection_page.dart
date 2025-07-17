import 'package:ausa/common/widget/app_back_header.dart';
import 'package:ausa/common/widget/app_main_container.dart';
import 'package:ausa/common/widget/base_scaffold.dart';
import 'package:ausa/common/widget/buttons.dart';
import 'package:ausa/constants/color.dart';
import 'package:ausa/features/tests/controller/test_controller.dart';
import 'package:ausa/features/tests/widget/group_selection_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TestSelectionPage extends StatelessWidget {
  TestSelectionPage({super.key});

  final TestController controller = Get.find<TestController>();

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: AppColors.gray50,
      body: Column(
        children: [
          AppBackHeader(
            title: 'Your Tests',
            onBackPressed: () {
              controller.resetSelections();
              Get.back();
            },
          ),
          AppMainContainer(
            child: Stack(
              children: [
                Obx(
                  () =>
                      controller.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          :  GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    childAspectRatio: 1.1,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                  ),
                              itemCount: controller.availableGroups.length,
                              itemBuilder: (context, index) {
                                final group = controller.availableGroups[index];
                                return Obx(() {
                                  final isSelected = controller.selectedGroups
                                      .any((g) => g.id == group.id);
                                  return GroupSelectionCard(
                                    group: group,
                                    isSelected: isSelected,
                                    onTap:
                                        () => controller.toggleGroupSelection(
                                          group,
                                        ),
                                  );
                                });
                              },
                            ),
                ),
                _buildActionButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return Obx(() {
      if (!controller.hasSelectedGroups) {
        return const SizedBox.shrink();
      }

      return Positioned(
        bottom: 26,
        right: 24,
        child: AusaButton(
          text: 'Start${controller.selectedGroupsCount == 1 ? '' : ' ${controller.selectedGroupsCount}'} Test${controller.selectedGroupsCount == 1 ? '' : 's'}',
          onPressed:
              controller.canStartSession
                  ? () => controller.startTestSession()
                  : null,
          isLoading: controller.isLoading,
          variant: ButtonVariant.primary,
          size: ButtonSize.lg,
        ),
      );
    });
  }
}
