import 'package:ausa/common/widget/input_bg_container.dart';
import 'package:ausa/common/widget/on_screen_keyboard_widget.dart';
import 'package:ausa/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class EmailInvitePage extends StatelessWidget {
  const EmailInvitePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    return InputBgContainer(
      child: Stack(
        children: [
          Positioned(
            top: 80,
            left: 32,
            right: 32,
            child: Column(
              children: [
                const SizedBox(height: 24),

                // Content area
                Row(
                  children: [
                    // Left side - Description and illustration
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Known member will onboard themselves and see your health profile from their app.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              height: 1.5,
                            ),
                          ),

                          const SizedBox(height: 32),
                        ],
                      ),
                    ),

                    // Right side - Form
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Email',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Email input field
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.email_outlined,
                                  color: Colors.grey[400],
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextField(
                                    controller:
                                        controller.emailInviteController,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Enter',
                                      hintStyle: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 16,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Send button
                          Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // Handle send invitation
                                if (controller
                                    .emailInviteController
                                    .text
                                    .isNotEmpty) {
                                  // Add your send logic here
                                  print(
                                    'Sending invitation to: ${controller.emailInviteController.text}',
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.3),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Send Invitation',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: OnScreenKeyboardWidget(
              controller: controller.emailInviteController,
              type: VirtualKeyboardType.Alphanumeric,
              color: Color(0xffE3E6EE),
            ),
          ),
        ],
      ),
    );
  }
}

class CurvedArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.6)
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height * 0.8);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.2,
      size.width * 0.9,
      size.height * 0.4,
    );

    canvas.drawPath(path, paint);

    // Draw arrowhead
    final arrowPaint =
        Paint()
          ..color = Colors.white.withOpacity(0.6)
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    final arrowPath = Path();
    arrowPath.moveTo(size.width * 0.85, size.height * 0.3);
    arrowPath.lineTo(size.width * 0.9, size.height * 0.4);
    arrowPath.lineTo(size.width * 0.95, size.height * 0.35);

    canvas.drawPath(arrowPath, arrowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
