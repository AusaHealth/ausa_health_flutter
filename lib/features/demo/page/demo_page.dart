import 'package:flutter/material.dart';
import '../../../common/widget/app_back_header.dart';

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});
  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            const AppBackHeader(title: 'Interactive Demo'),

            // Main content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Additional Animation (Example of how easy it is to add more)
                    Text('hello')
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
