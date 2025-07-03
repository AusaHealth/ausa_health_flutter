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
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Diagnosed with',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Diabetes, heart condition, cholestrol',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Last readings',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              HorizontalTabBar(
                items: tabItems,
                selectedIndex: selectedTab,
                onSelected: (index) {
                  setState(() {
                    selectedTab = index;
                  });
                },
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 32,
                  horizontal: 24,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: const Color(0xFF1EA7FF), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Expanded(child: _buildReadingCard()),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReadingCard() {
    switch (selectedTab) {
      case 0: // Blood Pressure
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BP Systolic',
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  '128 mmHg',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BP Diastolic',
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  '95 mmHg',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        );
      case 1: // ECG
        return Center(
          child: Text(
            'ECG Reading',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        );
      case 2: // Body temperature
        return Center(
          child: Text(
            'Body Temperature: 36.6°C',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        );
      case 3: // SpO2 & Heart Rate
        return Center(
          child: Text(
            'SpO2: 98%  |  Heart Rate: 72 bpm',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        );
      case 4: // Blood glucose
        return Center(
          child: Text(
            'Blood Glucose: 110 mg/dL',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        );
      default:
        return SizedBox.shrink();
    }
  }
}
