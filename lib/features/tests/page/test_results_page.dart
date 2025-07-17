import 'package:ausa/common/widget/app_main_container.dart';
import 'package:ausa/common/widget/base_scaffold.dart';
import 'package:ausa/common/widget/buttons.dart';
import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/icons.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/features/tests/controller/test_controller.dart';
import 'package:ausa/features/tests/model/test_result.dart';
import 'package:ausa/common/model/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ausa/routes/app_routes.dart';

class TestResultsPage extends StatelessWidget {
  TestResultsPage({super.key});

  final TestController controller = Get.find<TestController>();

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: AppColors.gray50,
      body: Column(
        children: [
          // _buildHeader(),
          Container(
            padding: EdgeInsets.only(
              top: AppSpacing.xl,
              left: AppSpacing.xl,
              right: AppSpacing.xl,
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: const Color(0xff21C373),
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    AusaIcons.shieldTick,
                    width: 16,
                    height: 16,
                    colorFilter: ColorFilter.mode(
                      Color(0xff046535),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                SizedBox(width: AppSpacing.lg),
                Text(
                  'Success',
                  style: AppTypography.headline(
                    color: Colors.black,
                    weight: AppTypographyWeight.medium,
                  ),
                ),
              ],
            ),
          ),
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
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AusaButton(
                text: 'Home',
                variant: ButtonVariant.tertiary,
                onPressed: () {
                  Get.toNamed(AppRoutes.home);
                },
              ),
            ],
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
              style: AppTypography.headline(
                color: Colors.black87,
                weight: AppTypographyWeight.regular,
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
                  style: AppTypography.body(
                    weight: AppTypographyWeight.bold,
                    color: Color(0xff5A7497),
                  ),
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
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xffFFCECB),
                    borderRadius: BorderRadius.circular(38),
                  ),
                  child: Text(
                    'Abnormal reading',
                    style: AppTypography.body(
                      color: Color(0xffD92D20),
                      weight: AppTypographyWeight.medium,
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
          style: AppTypography.body(
            color: Color(0xff5A7497),
            weight: AppTypographyWeight.semibold,
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
                weight: AppTypographyWeight.semibold,
              ),
            ),
            if (parameter.unit.isNotEmpty) ...[
              const SizedBox(width: 4),
              Text(
                parameter.unit,
                style: AppTypography.body(
                  color: parameter.isAbnormal ? Colors.red : Colors.black,
                  weight: AppTypographyWeight.regular,
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
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 50),
      decoration: BoxDecoration(
        color: Color(0xffEBE9E6),
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
            style: AppTypography.headline(
              color: Color(0xff5A7497),
              weight: AppTypographyWeight.regular,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AusaButton(
                text: 'Schedule Appointment',
                onPressed: () {
                  Get.toNamed(AppRoutes.appointmentSchedule);
                },
                variant: ButtonVariant.secondary,
                borderColor: AppColors.white,
                textColor: AppColors.primary700,
                leadingIcon: SvgPicture.asset(
                  AusaIcons.calendarPlus02,
                  width: 16,
                  height: 16,
                  colorFilter: ColorFilter.mode(
                    AppColors.primary700,
                    BlendMode.srcIn,
                  ),
                ),
                size: ButtonSize.lg,
              ),
              const SizedBox(width: 5),
              AusaButton(
                text: 'Check Again',
                onPressed: () {
                  controller.retakeAllTests();
                },
                variant: ButtonVariant.secondary,
                borderColor: AppColors.white,
                textColor: AppColors.primary700,
                leadingIcon: SvgPicture.asset(
                  AusaIcons.repeat02,
                  width: 16,
                  height: 16,
                  colorFilter: ColorFilter.mode(
                    AppColors.primary700,
                    BlendMode.srcIn,
                  ),
                ),
                size: ButtonSize.lg,
              ),
              const SizedBox(width: 5),
              AusaButton(
                text: 'Take another Test',
                onPressed:
                    () => {
                      controller.resetFlow(),
                      controller.navigateToTestSelection(),
                    },
                variant: ButtonVariant.secondary,
                borderColor: AppColors.white,
                textColor: AppColors.primary700,
                leadingIcon: SvgPicture.asset(
                  AusaIcons.share05,
                  width: 16,
                  height: 16,
                  colorFilter: ColorFilter.mode(
                    AppColors.primary700,
                    BlendMode.srcIn,
                  ),
                ),
                size: ButtonSize.lg,
              ),
              const SizedBox(width: 10),
              AusaButton(
                text: 'Finish',
                onPressed: () {
                  controller.resetFlow();
                  controller.navigateToTestSelection();
                },
                width: 200,
                variant: ButtonVariant.primary,
                size: ButtonSize.lg,
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
