import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InputBgContainer extends StatelessWidget {
  final Widget child;
  const InputBgContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Important for blur effect
      body: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: const Color(0xFF0E2457).withOpacity(0.8)),
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.close, color: Colors.white),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
