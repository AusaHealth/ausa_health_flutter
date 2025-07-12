import 'package:ausa/constants/radius.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/features/profile/widget/horizontal_tab_bar.dart';
import 'package:flutter/material.dart';

class ConditionPage extends StatefulWidget {
  const ConditionPage({super.key});

  @override
  State<ConditionPage> createState() => _ConditionPageState();
}

class _ConditionPageState extends State<ConditionPage> {
  int selectedTab = 0;
  final List<String> tabItems = [
    'Blood Pressure',
    'ECG',
    'Body temperature',
    'SpO2 & Heart Rate',
    'Blood glucose',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Diagnosed with',
                  style: AppTypography.calloutRegular(color: Colors.black),
                ),
                SizedBox(height: AppSpacing.sm),
                Text(
                  'Diabetes, heart condition, cholestrol',
                  style: AppTypography.bodyMedium(color: Colors.black),
                ),
                SizedBox(height: AppSpacing.xl),
                Text(
                  'Last readings',
                  style: AppTypography.body(color: Colors.black),
                ),

                HorizontalTabBar(
                  items: tabItems,
                  selectedIndex: selectedTab,
                  onSelected: (index) {
                    setState(() {
                      selectedTab = index;
                    });
                  },
                ),
                SizedBox(height: AppSpacing.xl),
                Container(
                  height: 285,
                  padding: EdgeInsets.symmetric(
                    vertical: AppSpacing.lg,
                    horizontal: AppSpacing.lg,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.xl3),
                    border: Border.all(
                      color: const Color(0xFF1EA7FF),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: _buildReadingCard(),
                ),
                SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReadingCard() {
    switch (selectedTab) {
      case 0: // Blood Pressure
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BP Systolic',
                      style: AppTypography.body(color: Colors.black),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '128 mmHg',
                      style: AppTypography.title2(color: Colors.black),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BP Diastolic',
                      style: AppTypography.body(color: Colors.black),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '95 mmHg',
                      style: AppTypography.title2(color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      case 1: // ECG
        return Center(
          child: Text(
            'ECG Reading',
            style: AppTypography.title2(color: Colors.black),
          ),
        );
      case 2: // Body temperature
        return Center(
          child: Text(
            'Body Temperature: 36.6°C',
            style: AppTypography.title2(color: Colors.black),
          ),
        );
      case 3: // SpO2 & Heart Rate
        return Center(
          child: Text(
            'SpO2: 98%  |  Heart Rate: 72 bpm',
            style: AppTypography.title2(color: Colors.black),
          ),
        );
      case 4: // Blood glucose
        return Center(
          child: Text(
            'Blood Glucose: 110 mg/dL',
            style: AppTypography.title2(color: Colors.black),
          ),
        );
      default:
        return SizedBox.shrink();
    }
  }
}
