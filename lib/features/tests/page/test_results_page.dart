import 'package:ausa/common/widget/app_main_container.dart';
import 'package:ausa/common/widget/buttons.dart';
import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/features/tests/controller/test_controller.dart';
import 'package:ausa/features/tests/model/test_result.dart';
import 'package:ausa/common/model/test.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TestResultsPage extends StatelessWidget {
  TestResultsPage({super.key});

  final TestController controller = Get.find<TestController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Obx(
              () =>
                  controller.sessionResults.isEmpty
                      ? _buildEmptyState()
                      : _buildResultsContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Back button
            GestureDetector(
              onTap: () {
                controller.resetSelections();
                Get.back();
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black87,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_turned_in_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Results Available',
            style: AppTypography.headline(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Complete some tests to see results here',
            style: AppTypography.body(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsContent() {
    return AppMainContainer(
      backgroundColor: Colors.white,
      opacity: 1.0,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(0),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
        bottomLeft: Radius.circular(24),
        bottomRight: Radius.circular(24),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Results heading (fixed at top)
          Container(
            padding: const EdgeInsets.only(
              top: 20,
              bottom: 0,
              left: 20,
              right: 20,
            ),
            child: Text(
              'Results',
              style: AppTypography.body(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Scrollable results section
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children:
                    controller.sessionResults
                        .map((result) => _buildResultRow(result))
                        .toList(),
              ),
            ),
          ),

          // Action buttons fixed at bottom of container
          const SizedBox(height: 32),
          _buildActionButtonsContent(),
        ],
      ),
    );
  }

  Widget _buildResultRow(TestResult result) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Test name and category
          Row(
            children: [
              Expanded(
                child: Text(
                  result.testName,
                  style: AppTypography.callout(fontWeight: FontWeight.w400),
                ),
              ),
              if (result.category != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary700.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primary700.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    _getCategoryDisplayName(result),
                    style: AppTypography.callout(
                      color: AppColors.primary700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              // Abnormal values warning
              if (result.hasAbnormalValues) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xffFFCECB),
                    borderRadius: BorderRadius.circular(38),
                  ),
                  child: Text(
                    'Abnormal reading',
                    style: AppTypography.callout(
                      color: Color(0xffD92D20),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),

          // Parameters grid
          _buildParametersGrid(result.parameters),
        ],
      ),
    );
  }

  Widget _buildParametersGrid(List<TestResultParameter> parameters) {
    return Wrap(
      spacing: 40,
      runSpacing: 16,
      children:
          parameters
              .map((parameter) => _buildParameterCard(parameter))
              .toList(),
    );
  }

  Widget _buildParameterCard(TestResultParameter parameter) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          parameter.name,
          style: AppTypography.callout(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              parameter.value,
              style: AppTypography.title1(
                color: parameter.isAbnormal ? Colors.red : Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
            if (parameter.unit.isNotEmpty) ...[
              const SizedBox(width: 4),
              Text(
                parameter.unit,
                style: AppTypography.callout(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtonsContent() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Would you like to:',
            style: AppTypography.body(color: Colors.grey[700]),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: AusaButton(
                  text: 'Schedule Appointment',
                  onPressed: () {
                    // TODO: Navigate to appointment scheduling
                  },
                  variant: ButtonVariant.secondary,
                  borderColor: AppColors.primary700,
                  textColor: AppColors.primary700,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AusaButton(
                  text: 'Check Again',
                  onPressed: () => controller.retakeAllTests(),
                  variant: ButtonVariant.secondary,
                  borderColor: AppColors.primary700,
                  textColor: AppColors.primary700,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AusaButton(
                  text: 'Take another Test',
                  onPressed: () => controller.navigateToTestSelection(),
                  variant: ButtonVariant.secondary,
                  borderColor: AppColors.primary700,
                  textColor: AppColors.primary700,
                ),
              ),
              const SizedBox(width: 60),
              Expanded(
                child: AusaButton(
                  text: 'Finish',
                  borderRadius: 40,
                  height: 50,
                  onPressed: () {
                    controller.resetSelections();
                    Get.back();
                  },
                  variant: ButtonVariant.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper method to get display name for category
  String _getCategoryDisplayName(TestResult result) {
    if (result.category == null) return '';

    switch (result.testType) {
      case TestType.ecg:
        switch (result.category) {
          case '6_lead':
            return '6-Lead';
          case '12_lead':
            return '12-Lead';
          default:
            return result.category!;
        }
      case TestType.bodySound:
        switch (result.category) {
          case 'heart':
            return 'Heart';
          case 'lungs':
            return 'Lungs';
          case 'stomach':
            return 'Stomach';
          case 'bowel':
            return 'Bowel';
          default:
            return result.category!;
        }
      case TestType.ent:
        switch (result.category) {
          case 'ear':
            return 'Ear';
          case 'nose':
            return 'Nose';
          case 'throat':
            return 'Throat';
          default:
            return result.category!;
        }
      case TestType.bloodGlucose:
        switch (result.category) {
          case 'fasting':
            return 'Fasting';
          case 'post_meal':
            return 'Post Meal';
          default:
            return result.category!;
        }
      default:
        // For other test types, return the category as is
        return result.category!;
    }
  }
}
