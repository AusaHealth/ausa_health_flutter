import 'package:ausa/common/custom_text_field.dart';
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
                                            label: 'Short Name',
                                            placeholder: 'Enter',
                                          ),
                                        ),
                                        SizedBox(width: AppSpacing.xl4),
                                        Expanded(
                                          child: ProfileCustomTextField(
                                            label: 'Full name',
                                            placeholder: 'Enter',
                                          ),
                                        ),
                                        SizedBox(width: AppSpacing.xl4),
                                        Expanded(
                                          child: ProfileCustomTextField(
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
                                            label: 'Phone Number',
                                            placeholder: '+1 (000) 000-0000',
                                          ),
                                        ),
                                        SizedBox(width: AppSpacing.xl4),
                                        Expanded(
                                          child: ProfileCustomTextField(
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

// Widget _buildTextField({
//   required String name,
//   required String label,
//   required String placeholder,
//   int maxLines = 1,
// }) {
//   final ProfileController controller = Get.find<ProfileController>();
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Padding(
//         padding: EdgeInsets.only(left: AppSpacing.sm),
//         child: Text(
//           label,
//           style: AppTypography.callout(
//             color: AppColors.textColor,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
//       SizedBox(height: AppSpacing.smMedium),
//       Container(
//         decoration: BoxDecoration(
//           color: Color(0xff1570EF).withValues(alpha: 0.05),
//           borderRadius: BorderRadius.circular(AppRadius.xl2),
//           // border: Border.all(color: Colors.grey[300]!),
//         ),
//         child: TextFormField(
//           onTap: () async {
//             final inputs = [
//               InputModel(
//                 name: 'shortName',
//                 label: 'Short Name',
//                 inputType: InputTypeEnum.text,
//                 value: '',
//               ),
//               InputModel(
//                 name: 'fullName',
//                 label: 'Full Name',
//                 inputType: InputTypeEnum.text,
//                 value: '',
//               ),
//               InputModel(
//                 name: 'relationship',
//                 label: 'Relationship',
//                 inputType: InputTypeEnum.selector,
//                 value: '',
//                 inputSource: [
//                   'Spouse',
//                   'Child',
//                   'Grandchild',
//                   'Parent',
//                   'Friend',
//                   'Other',
//                 ],
//               ),
//               InputModel(
//                 name: 'phone',
//                 label: 'Phone Number',
//                 inputType: InputTypeEnum.text,
//                 value: '',
//               ),
//               InputModel(
//                 name: 'email',
//                 label: 'Email',
//                 inputType: InputTypeEnum.text,
//                 value: '',
//               ),
//               InputModel(
//                 name: 'address',
//                 label: 'Address',
//                 inputType: InputTypeEnum.text,
//                 value: '',
//               ),
//             ];
//             final result = await Get.to(() => InputPage(inputs: inputs));
//             log('result: $result');

//             for (final input in result) {
//               print('Input: ${input.name}, Value: "${input.value}"');
//             }

//             log('result is List<InputModel>: ${result is List<InputModel>}');
//             log('result is not null: ${result != null}');
//             log('result is not empty: ${result.isNotEmpty}');
//             if (result != null &&
//                 result is List<InputModel> &&
//                 result.isNotEmpty) {
//               final normalizedResult =
//                   result
//                       .map(
//                         (input) => input.copyWith(
//                           value: Utils.emptyToNull(input.value),
//                         ),
//                       )
//                       .toList();
//               for (final input in normalizedResult) {
//                 print('Normalized Input: ${input.name}, Value: ${input.value}');
//               }
//               final hasAnyValue = normalizedResult.any(
//                 (input) =>
//                     input.value != null &&
//                     input.value.toString().trim().isNotEmpty,
//               );

//               if (hasAnyValue) {
//                 CustomToast.show(
//                   message: 'Profile added',
//                   type: ToastType.success,
//                 );
//                 controller.member.updateFromInputs(normalizedResult);
//                 controller.showSummary.value = true;
//               } else {
//                 CustomToast.show(
//                   message: 'Please fill at least one field to add a profile.',
//                   type: ToastType.warning,
//                 );
//               }
//             }
//           },

//           maxLines: maxLines,

//           decoration: InputDecoration(
//             hintText: placeholder,
//             hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
//             contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             border: InputBorder.none,
//           ),
//           style: TextStyle(fontSize: 14, color: Colors.black87),
//         ),
//       ),
//     ],
//   );
// }
