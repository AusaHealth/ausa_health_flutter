import 'package:ausa/constants/design_scale.dart';
import 'package:ausa/constants/radius.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/features/profile/widget/horizontal_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ConditionPage extends StatefulWidget {
  const ConditionPage({super.key});

  @override
  State<ConditionPage> createState() => _ConditionPageState();
}

class _ConditionPageState extends State<ConditionPage> {
  int selectedTab = 0;
  final List<String> tabItems = [
    'Blood Pressure',
    // 'ECG',
    'Body temperature',
    'SpO2 & Heart Rate',
    'Blood glucose',
  ];

  @override
  Widget build(BuildContext context) {
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
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.xl3,
              ).copyWith(top: AppSpacing.xl2),
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
                    'Diabetes, heart condition, cholestrol',
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

                  // SizedBox(height: AppSpacing.xl7),
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
    final valueColor = const Color(0xff415981);
    switch (selectedTab) {
      case 0:
        return Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BP Systolic',
                  style: AppTypography.callout(
                    color: valueColor,
                    weight: AppTypographyWeight.regular,
                  ),
                ),
                SizedBox(height: AppSpacing.smMedium),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '128 ',
                        style: AppTypography.body(
                          color: valueColor,
                          weight: AppTypographyWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: 'mmHg',
                        style: AppTypography.body(
                          color: valueColor,
                          weight: AppTypographyWeight.regular,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(width: DesignScaleManager.scaleValue(200)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BP Diastolic',
                  style: AppTypography.callout(
                    color: valueColor,
                    weight: AppTypographyWeight.regular,
                  ),
                ),
                SizedBox(height: AppSpacing.smMedium),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '95 ',
                        style: AppTypography.body(
                          color: valueColor,
                          weight: AppTypographyWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: 'mmHg',
                        style: AppTypography.body(
                          color: valueColor,
                          weight: AppTypographyWeight.regular,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      case 1: // ECG
        return Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fahrenheit',
                  style: AppTypography.callout(
                    color: valueColor,
                    weight: AppTypographyWeight.regular,
                  ),
                ),
                SizedBox(height: AppSpacing.smMedium),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '96 ',
                        style: AppTypography.body(
                          color: valueColor,
                          weight: AppTypographyWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: '°F',
                        style: AppTypography.body(
                          color: valueColor,
                          weight: AppTypographyWeight.regular,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(width: DesignScaleManager.scaleValue(200)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Celsius',
                  style: AppTypography.callout(
                    color: valueColor,
                    weight: AppTypographyWeight.regular,
                  ),
                ),
                SizedBox(height: AppSpacing.smMedium),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '37 ',
                        style: AppTypography.body(
                          color: valueColor,
                          weight: AppTypographyWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: '°C',
                        style: AppTypography.body(
                          color: valueColor,
                          weight: AppTypographyWeight.regular,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );

      case 2: // Body temperature
        return Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'SpO',
                        style: AppTypography.callout(
                          color: valueColor,
                          weight: AppTypographyWeight.regular,
                        ),
                      ),
                      TextSpan(
                        text: '2',
                        style: AppTypography.callout(
                          color: valueColor,
                          weight: AppTypographyWeight.regular,
                        ).copyWith(
                          fontSize: AppTypography.callout().fontSize! * 0.7,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.smMedium),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '98 ',
                        style: AppTypography.body(
                          color: valueColor,
                          weight: AppTypographyWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: '%',
                        style: AppTypography.body(
                          color: valueColor,
                          weight: AppTypographyWeight.regular,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );

      case 3: // SpO2 & Heart Rate
        return Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fasting',
                  style: AppTypography.callout(
                    color: valueColor,
                    weight: AppTypographyWeight.regular,
                  ),
                ),
                SizedBox(height: AppSpacing.smMedium),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '80 ',
                        style: AppTypography.body(
                          color: valueColor,
                          weight: AppTypographyWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: 'mg/dL',
                        style: AppTypography.body(
                          color: valueColor,
                          weight: AppTypographyWeight.regular,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(width: DesignScaleManager.scaleValue(200)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Post Meal',
                  style: AppTypography.callout(
                    color: valueColor,
                    weight: AppTypographyWeight.regular,
                  ),
                ),
                SizedBox(height: AppSpacing.smMedium),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '120 ',
                        style: AppTypography.body(
                          color: valueColor,
                          weight: AppTypographyWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: 'mg/dL',
                        style: AppTypography.body(
                          color: valueColor,
                          weight: AppTypographyWeight.regular,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      default:
        return SizedBox.shrink();
    }
  }
}
