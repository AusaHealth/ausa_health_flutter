import 'package:flutter/material.dart';
import '../../../common/widget/app_back_header.dart';
import '../../../common/widget/app_tab_buttons.dart';
import '../../../common/widget/app_main_container.dart';

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  int selectedTabIndex = 0;
  int currentStep = 1;

  final List<AppTabData> demoTabs = [
    const AppTabData(text: 'Design', icon: Icons.palette),
    const AppTabData(text: 'Components', icon: Icons.widgets),
    const AppTabData(text: 'Settings', icon: Icons.settings),
  ];

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            const AppBackHeader(title: 'Demo Page'),

            // Tab buttons
            AppTabButtons(
              tabs: demoTabs,
              selectedIndex: selectedTabIndex,
              onTabSelected: (index) {
                setState(() {
                  selectedTabIndex = index;
                });
              },
            ),

            // Main content
            AppMainContainer(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Selected Tab: ${demoTabs[selectedTabIndex].text}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Icon(
                      demoTabs[selectedTabIndex].icon,
                      size: 48,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'This is the AppMainContainer widget!',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'The header above is a regular AppBackHeader.\nBelow is the same component with step indicators:',
                      style: TextStyle(fontSize: 14, color: Colors.white60),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    // Demo AppBackHeader with steps
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: AppBackHeader(
                        title: 'Step Demo',
                        currentStep: currentStep,
                        totalSteps: 3,
                        onBackPressed: () {},
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Step control buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed:
                              currentStep > 1
                                  ? () => setState(() => currentStep--)
                                  : null,
                          child: const Text('Previous'),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed:
                              currentStep < 3
                                  ? () => setState(() => currentStep++)
                                  : null,
                          child: const Text('Next'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
