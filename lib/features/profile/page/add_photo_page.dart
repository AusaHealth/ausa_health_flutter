import 'package:ausa/common/widget/input_bg_container.dart';
import 'package:ausa/constants/typography.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class AddPhotoPage extends StatelessWidget {
  const AddPhotoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return InputBgContainer(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 200,
            left: 16,
            right: 16,
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: 400,
                    padding: EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: Color(0xff0060FF),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Title
                        Text(
                          'Have your mobile app\ndownloaded',
                          textAlign: TextAlign.center,
                          style: AppTypography.headline(color: Colors.white),
                        ),

                        SizedBox(height: 24),

                        // Description
                        Text(
                          'A notification will be sent to you. Follow the steps on your mobile app to add a profile picture for Chris.',
                          textAlign: TextAlign.center,
                          style: AppTypography.body(color: Colors.white),
                        ),

                        SizedBox(height: 32),

                        // Send Notification Button
                        Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(
                                  255,
                                  150,
                                  33,
                                  1,
                                ), // Color(red: 1, green: 0.59, blue: 0.13)
                                blurRadius: 25.45,
                                offset: Offset(7, 11),
                              ),
                              BoxShadow(
                                color: Colors.white,
                                blurRadius: 10,
                                offset: Offset(-5, -4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Get.back();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Color(0xFF4285F4),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.notifications_outlined,
                                  size: 20,
                                  color: Color(0xFF4285F4),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Send Notification',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF4285F4),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_forward,
                                  size: 16,
                                  color: Color(0xFF4285F4),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
