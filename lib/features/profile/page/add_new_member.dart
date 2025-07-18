import 'package:ausa/common/widget/custom_text_field.dart';
import 'package:ausa/common/widget/app_back_header.dart';
import 'package:ausa/common/widget/app_main_container.dart';
import 'package:ausa/common/widget/base_scaffold.dart';
import 'package:ausa/common/widget/buttons.dart';
import 'package:ausa/constants/icons.dart';
import 'package:ausa/constants/utils.dart';
import 'package:ausa/features/profile/controller/profile_controller.dart';
import 'package:ausa/features/profile/widget/add_photo_popup_widget.dart';
import 'package:ausa/features/profile/widget/member_summary_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:ausa/constants/constants.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AddNewMember extends StatefulWidget {
  const AddNewMember({super.key});

  @override
  State<AddNewMember> createState() => _AddNewMemberState();
}

class _AddNewMemberState extends State<AddNewMember> {
  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.find<ProfileController>();
    return BaseScaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [AppBackHeader2(title: 'Add new member')],
            ),
          ),
          SizedBox(height: AppSpacing.xl),
          AppMainContainer(
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.all(AppSpacing.smMedium),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(AppRadius.xl3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          offset: Offset(0, 10),
                          blurRadius: 20,
                        ),
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Utils.showBlurredDialog(
                                context,
                                AddPhotoPopupWidget(),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(AppSpacing.smMedium),
                              decoration: BoxDecoration(
                                color: Color(0xffC2EFFF).withOpacity(0.5),
                                borderRadius: BorderRadius.circular(
                                  AppRadius.xl3,
                                ),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  AusaIcons.userPlus01,
                                  height: DesignScaleManager.scaleValue(170),
                                  width: DesignScaleManager.scaleValue(170),
                                  colorFilter: ColorFilter.mode(
                                    AppColors.primary100,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: AppSpacing.lg),

                        // Add profile photo button
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.xl,
                          ),
                          child: Center(
                            child: AusaButton(
                              size: ButtonSize.md,
                              backgroundColor: Colors.white,
                              leadingIcon: SvgPicture.asset(
                                AusaIcons.imageUser,
                                height: DesignScaleManager.scaleValue(32),
                                width: DesignScaleManager.scaleValue(32),
                                colorFilter: ColorFilter.mode(
                                  AppColors.primary500,
                                  BlendMode.srcIn,
                                ),
                              ),
                              variant: ButtonVariant.secondary,
                              text: 'Add a profile photo',
                              onPressed: () {},
                            ),
                          ),
                        ),
                        SizedBox(height: AppSpacing.xl3),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: AppSpacing.lg),
                Expanded(
                  flex: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.xl3),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 16,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.xl4,
                        vertical: AppSpacing.xl6,
                      ),
                      child: Obx(
                        () =>
                            controller.showSummary.value
                                ? MemberSummaryCardWidget(
                                  member: controller.member,
                                )
                                : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ProfileCustomTextField(
                                            focusFieldName: 'shortName',
                                            label: 'Short Name',
                                            placeholder: 'Enter',
                                          ),
                                        ),
                                        SizedBox(width: AppSpacing.xl4),
                                        Expanded(
                                          child: ProfileCustomTextField(
                                            focusFieldName: 'shortName',
                                            label: 'Full name',
                                            placeholder: 'Enter',
                                          ),
                                        ),
                                        SizedBox(width: AppSpacing.xl4),
                                        Expanded(
                                          child: ProfileCustomTextField(
                                            focusFieldName: 'relationship',
                                            label: 'Relation',
                                            placeholder: 'Enter',
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: AppSpacing.xl),

                                    Row(
                                      children: [
                                        Expanded(
                                          child: ProfileCustomTextField(
                                            focusFieldName: 'phone',
                                            label: 'Phone Number',
                                            placeholder: '+1 (000) 000-0000',
                                          ),
                                        ),
                                        SizedBox(width: AppSpacing.xl4),
                                        Expanded(
                                          child: ProfileCustomTextField(
                                            focusFieldName: 'email',
                                            label: 'Email',
                                            placeholder: 'Enter',
                                          ),
                                        ),
                                        Spacer(),
                                      ],
                                    ),
                                    SizedBox(height: AppSpacing.xl),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ProfileCustomTextField(
                                            focusFieldName: 'address',
                                            label: 'Address',
                                            placeholder: 'Enter',
                                          ),
                                        ),

                                        Spacer(),
                                        Spacer(),
                                      ],
                                    ),
                                  ],
                                ),
                      ),
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
