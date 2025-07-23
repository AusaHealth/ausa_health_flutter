import 'package:ausa/constants/design_scale.dart';
import 'package:ausa/constants/radius.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/features/profile/controller/profile_controller.dart';
import 'package:ausa/features/profile/widget/horizontal_tab_bar.dart';
import 'package:ausa/features/profile/widget/reading_value_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConditionPage extends StatefulWidget {
  const ConditionPage({super.key});

  @override
  State<ConditionPage> createState() => _ConditionPageState();
}

class _ConditionPageState extends State<ConditionPage> {
  int selectedTab = 0;
  final List<String> tabItems = [
    'Blood Pressure',
    'Body temperature',
    'SpO2 & Heart Rate',
    'Blood glucose',
  ];

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.xl3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.xl4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Diagnosed with',
                    style: AppTypography.callout(
                      color: Colors.black,
                      weight: AppTypographyWeight.regular,
                    ),
                  ),
                  SizedBox(height: AppSpacing.mdLarge),
                  Text(
                    profileController.condition.diagonedWith,
                    style: AppTypography.body(
                      color: Colors.black,
                      weight: AppTypographyWeight.semibold,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xl4),
                  Text(
                    'Last readings',
                    style: AppTypography.callout(
                      color: Colors.black,
                      weight: AppTypographyWeight.regular,
                    ),
                  ),

                  SizedBox(height: AppSpacing.mdLarge),
                  SizedBox(
                    height: DesignScaleManager.scaleValue(96),
                    width: DesignScaleManager.scaleValue(1272),
                    child: HorizontalTabBar(
                      items: tabItems,
                      selectedIndex: selectedTab,
                      onSelected: (index) {
                        setState(() {
                          selectedTab = index;
                        });
                      },
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.all(AppSpacing.xl4),
                    child: _buildReadingCard(),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReadingCard() {
    final profileController = Get.find<ProfileController>();

    switch (selectedTab) {
      case 0:
        return Row(
          children: [
            ReadingValueWidget(
              label: 'BP Systolic',
              value: profileController.condition.bloodPressure.systolic,
              unit: 'mmHg',
            ),
            SizedBox(width: DesignScaleManager.scaleValue(200)),
            ReadingValueWidget(
              label: 'BP Diastolic',
              value: profileController.condition.bloodPressure.diastolic,
              unit: 'mmHg',
            ),
          ],
        );
      case 1:
        return Row(
          children: [
            ReadingValueWidget(
              label: 'Fahrenheit',
              value: profileController.condition.bodyTemperature.temperatureF,
              unit: '°F',
            ),
            SizedBox(width: DesignScaleManager.scaleValue(200)),
            ReadingValueWidget(
              label: 'Celsius',
              value: profileController.condition.bodyTemperature.temperatureC,
              unit: '°C',
            ),
          ],
        );
      case 2:
        return Row(
          children: [
            ReadingValueWidget(
              label: 'SpO',
              value: profileController.condition.heartRate.heartRate,
              unit: '%',
              isBloodSugar: true,
            ),
          ],
        );
      case 3:
        return Row(
          children: [
            ReadingValueWidget(
              label: 'Fasting',
              value: profileController.condition.bloodSugar.fasting,
              unit: 'mg/dL',
            ),
            SizedBox(width: DesignScaleManager.scaleValue(200)),
            ReadingValueWidget(
              label: 'Post Meal',
              value: profileController.condition.bloodSugar.postPrandial,
              unit: 'mg/dL',
            ),
          ],
        );
      default:
        return SizedBox.shrink();
    }
  }
}
