import 'package:ausa/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CustomStatusBar extends StatelessWidget {
  const CustomStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32, // Typical status bar height
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.transparent, // Transparent
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(CupertinoIcons.wifi, color: Theme.of(context).iconTheme.color),
          const SizedBox(width: 8),
          // Add more icons if needed
        ],
      ),
    );
  }
}

class BaseScaffold extends StatelessWidget {
  final Widget? body;
  final Color backgroundColor;
  final PreferredSizeWidget? appBar;
  final FloatingActionButton? floatingActionButton;
  const BaseScaffold({super.key, this.body, this.backgroundColor = AppColors.scaffoldBackgroundColor, this.appBar, this.floatingActionButton});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      body: Stack(
        children: [
          if (body != null) body!,
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: const CustomStatusBar(),
          ),
        ],
      ),
    );
  }
}
