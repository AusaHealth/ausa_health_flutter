import 'package:ausa/common/widget/buttons.dart';
import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/design_scale.dart';
import 'package:ausa/constants/icons.dart';
import 'package:ausa/constants/radius.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/constants/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AddPhotoPopupWidget extends StatelessWidget {
  const AddPhotoPopupWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: AppSpacing.xl6,
        left: AppSpacing.xl6,
        right: AppSpacing.xl6,
      ),
      height: DesignScaleManager.scaleValue(560),
      width: DesignScaleManager.scaleValue(816),
      decoration: BoxDecoration(
        color: AppColors.primary500,
        borderRadius: BorderRadius.circular(AppRadius.xl3),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Have your mobile app\ndownloaded',
            textAlign: TextAlign.center,
            style: AppTypography.headline(color: Colors.white),
          ),

          SizedBox(height: AppSpacing.xl),

          Text(
            'A notification will be sent to you. Follow the steps on your mobile app to add a profile picture for Chris.',
            textAlign: TextAlign.center,
            style: AppTypography.body(color: Colors.white),
          ),

          SizedBox(height: AppSpacing.xl2),

          AusaButton(
            trailingIcon: SvgPicture.asset(
              AusaIcons.arrowRight,
              height: DesignScaleManager.scaleValue(40),
              width: DesignScaleManager.scaleValue(40),
              colorFilter: ColorFilter.mode(
                AppColors.primary500,
                BlendMode.srcIn,
              ),
            ),
            textColor: AppColors.primary500,
            backgroundColor: Colors.white,
            leadingIcon: SvgPicture.asset(
              AusaIcons.bankNote01,
              height: DesignScaleManager.scaleValue(40),
              width: DesignScaleManager.scaleValue(40),
              colorFilter: ColorFilter.mode(
                AppColors.primary500,
                BlendMode.srcIn,
              ),
            ),
            text: 'Send Notification',

            onPressed: () {
              Get.back();
            },
          ),

          // Container(
          //   width: double.infinity,
          //   height: 50,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(60),
          // boxShadow: [
          //   BoxShadow(
          //     color: Color.fromRGBO(
          //       255,
          //       150,
          //       33,
          //       1,
          //     ), // Color(red: 1, green: 0.59, blue: 0.13)
          //     blurRadius: 25.45,
          //     offset: Offset(7, 11),
          //   ),
          //       BoxShadow(
          //         color: Colors.white,
          //         blurRadius: 10,
          //         offset: Offset(-5, -4),
          //       ),
          //     ],
          //   ),
          //   child: ElevatedButton(
          //     onPressed: () {
          //       Get.back();
          //     },
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: Colors.white,
          //       foregroundColor: Color(0xFF4285F4),
          //       elevation: 0,
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(25),
          //       ),
          //     ),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Icon(
          //           Icons.notifications_outlined,
          //           size: 20,
          //           color: Color(0xFF4285F4),
          //         ),
          //         SizedBox(width: 8),
          //         Text(
          //           'Send Notification',
          //           style: TextStyle(
          //             fontSize: 16,
          //             fontWeight: FontWeight.w500,
          //             color: Color(0xFF4285F4),
          //           ),
          //         ),
          //         SizedBox(width: 8),
          //         Icon(
          //           Icons.arrow_forward,
          //           size: 16,
          //           color: Color(0xFF4285F4),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
