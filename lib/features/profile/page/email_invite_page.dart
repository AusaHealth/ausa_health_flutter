import 'dart:ui';
import 'package:ausa/constants/app_images.dart';
import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/design_scale.dart';
import 'package:ausa/constants/icons.dart';
import 'package:ausa/constants/radius.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class EmailInvitePage extends StatelessWidget {
  const EmailInvitePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    final TextEditingController emailController = TextEditingController();

    return Stack(
      children: [
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 31.2, sigmaY: 31.2),
            child: Container(
              color: const Color.fromRGBO(14, 36, 87, 0.70),
              height: Get.height,
              width: Get.width,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: Align(
            alignment: Alignment.topRight,
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Get.back();
              },
              icon: SvgPicture.asset(
                AusaIcons.xClose,
                height: DesignScaleManager.scaleValue(40),
                width: DesignScaleManager.scaleValue(40),
                colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn),
              ),
            ),
          ),
        ),
        Positioned(
          top: 120,
          left: 0,
          right: 32,
          child: Container(
            width: DesignScaleManager.scaleValue(1824),
            height: DesignScaleManager.scaleValue(524),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.xl3),
              image: DecorationImage(
                image: AssetImage(AppImages.emailInviteBg),
                fit: BoxFit.cover,
              ),
            ),
            child: Material(
              borderRadius: BorderRadius.circular(AppRadius.xl3),
              color: Colors.transparent,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left side: Title and description
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Email invitation',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 32,
                          ),
                        ),
                        SizedBox(height: AppSpacing.xl2),
                        Text(
                          'Known member will onboard\nthemselves and see your health profile\nfrom their app.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Right side: Email label, field, error, and button
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: AppSpacing.xl3,
                        horizontal: AppSpacing.xl3,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Email',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          SizedBox(height: AppSpacing.mdLarge),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                AppRadius.xl2,
                              ),
                              border: Border.all(
                                color: Colors.redAccent,
                                width: 2,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.xl2,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.email_outlined,
                                  color: Colors.black54,
                                ),
                                SizedBox(width: AppSpacing.mdLarge),
                                Expanded(
                                  child: TextField(
                                    controller: emailController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'olivia@untitledui.com',
                                      hintStyle: TextStyle(
                                        color: Colors.black54,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: AppSpacing.mdLarge,
                                      ),
                                      isDense: true,
                                    ),
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: AppSpacing.smMedium),
                          Text(
                            'Invalid email',
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: AppSpacing.xl2),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF1563FF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.xl2,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppSpacing.xl2,
                                  vertical: AppSpacing.mdLarge,
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'Send Invitation',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
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
          ),
        ),
      ],
    );
  }
}
