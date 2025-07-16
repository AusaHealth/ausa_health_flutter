import 'dart:ui';
import 'package:ausa/common/widget/buttons.dart';
import 'package:ausa/constants/app_images.dart';
import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/design_scale.dart';
import 'package:ausa/constants/icons.dart';
import 'package:ausa/constants/radius.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/constants/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class EmailInvitePage extends StatefulWidget {
  const EmailInvitePage({super.key});

  @override
  State<EmailInvitePage> createState() => _EmailInvitePageState();
}

class _EmailInvitePageState extends State<EmailInvitePage> {
  final TextEditingController emailController = TextEditingController();
  bool isEmailValid = false;
  bool isEmailDirty = false; // To show error only after user types

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          top: AppSpacing.xl9,
          left: AppSpacing.xl3,
          right: AppSpacing.xl3,
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
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: AppSpacing.xl5,
                        horizontal: AppSpacing.xl9,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Email invitation',
                            style: AppTypography.headline(
                              weight: AppTypographyWeight.medium,
                              color: AppColors.white,
                            ),
                          ),
                          SizedBox(height: AppSpacing.xl2),
                          Text(
                            'Known member will onboard\nthemselves and see your health profile\nfrom their app.',
                            style: AppTypography.body(
                              weight: AppTypographyWeight.semibold,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Right side: Email label, field, error, and button
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: AppSpacing.xl3,
                        horizontal: AppSpacing.xl3,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: AppSpacing.xl3),
                            child: Text(
                              'Email',
                              style: AppTypography.body(
                                weight: AppTypographyWeight.regular,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: AppSpacing.mdLarge),
                          Container(
                            height: DesignScaleManager.scaleValue(160),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                AppRadius.xl2,
                              ),
                              border: Border.all(
                                color:
                                    !isEmailDirty
                                        ? Colors.white
                                        : isEmailValid
                                        ? AppColors.lightGreen
                                        : AppColors.lightRed,
                                width: 2,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.xl2,
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  AusaIcons.mail01,
                                  height: DesignScaleManager.scaleValue(40),
                                  width: DesignScaleManager.scaleValue(40),
                                  colorFilter: ColorFilter.mode(
                                    AppColors.bodyTextColor,
                                    BlendMode.srcIn,
                                  ),
                                ),

                                SizedBox(width: AppSpacing.mdLarge),
                                Expanded(
                                  child: TextField(
                                    onChanged: (value) {
                                      setState(() {
                                        isEmailDirty = true;
                                        isEmailValid = Utils.isValidEmail(
                                          value.trim(),
                                        );
                                      });
                                    },
                                    controller: emailController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Enter ',
                                      hintStyle: TextStyle(
                                        color: AppColors.bodyTextColor,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: AppSpacing.mdLarge,
                                      ),
                                      isDense: true,
                                    ),
                                    style: AppTypography.body(
                                      weight: AppTypographyWeight.regular,
                                      color: AppColors.bodyTextColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: AppSpacing.smMedium),
                          if (isEmailDirty)
                            Padding(
                              padding: EdgeInsets.only(left: AppSpacing.xl3),
                              child: Text(
                                isEmailValid
                                    ? 'Email verified'
                                    : 'Invalid email',
                                style: AppTypography.body(
                                  weight: AppTypographyWeight.medium,
                                  color:
                                      isEmailValid
                                          ? AppColors.lightGreen
                                          : AppColors.lightRed,
                                ),
                              ),
                            ),
                          SizedBox(height: AppSpacing.xl2),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                AusaButton(
                                  isEnabled: isEmailValid,
                                  onPressed: () {},

                                  text: 'Send Invitation',
                                  backgroundColor: AppColors.accent,
                                  textColor: AppColors.white,
                                ),
                              ],
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
