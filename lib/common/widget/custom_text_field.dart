import 'dart:developer' show log;

import 'package:ausa/common/widget/toast.dart';
import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/helpers.dart';
import 'package:ausa/constants/radius.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/features/profile/controller/profile_controller.dart';
import 'package:ausa/features/profile/page/input_model.dart';
import 'package:ausa/features/profile/page/input_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileCustomTextField extends StatelessWidget {
  final String label;
  final String placeholder;
  final int maxLines;
  final String? focusFieldName; // Add this parameter

  const ProfileCustomTextField({
    super.key,
    required this.label,
    required this.placeholder,
    this.maxLines = 1,
    this.focusFieldName, // Add this parameter
  });

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.find<ProfileController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: AppSpacing.sm),
          child: Text(
            label,
            style: AppTypography.callout(
              color: AppColors.textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: AppSpacing.smMedium),
        Container(
          decoration: BoxDecoration(
            color: Color(0xff1570EF).withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(AppRadius.xl2),
          ),
          child: TextFormField(
            onTap: () async {
              final inputs = [
                InputModel(
                  name: 'shortName',
                  label: 'Short Name',
                  inputType: InputTypeEnum.text,
                  value: '',
                ),
                InputModel(
                  name: 'fullName',
                  label: 'Full Name',
                  inputType: InputTypeEnum.text,
                  value: '',
                ),
                InputModel(
                  name: 'relationship',
                  label: 'Relationship',
                  inputType: InputTypeEnum.selector,
                  value: '',
                  inputSource: Helpers.relationshipOptions,
                ),
                InputModel(
                  name: 'phone',
                  label: 'Phone Number',
                  inputType: InputTypeEnum.number,
                  value: '',
                ),
                InputModel(
                  name: 'email',
                  label: 'Email',
                  inputType: InputTypeEnum.text,
                  value: '',
                ),
                InputModel(
                  name: 'address',
                  label: 'Address',
                  inputType: InputTypeEnum.text,
                  value: '',
                ),
              ];

              final result = await Get.to(
                () => InputPage(
                  inputs: inputs,
                  initialFocusFieldName:
                      focusFieldName, // Pass the focus field name
                ),
              );

              log('result: $result');
              log('result is List<InputModel>: ${result is List<InputModel>}');
              log('result is not null: ${result != null}');

              if (result != null &&
                  result is List<InputModel> &&
                  result.isNotEmpty) {
                final normalizedResult =
                    result
                        .map(
                          (input) => input.copyWith(
                            value: Helpers.emptyToNull(input.value),
                          ),
                        )
                        .toList();
                for (final input in normalizedResult) {
                  print(
                    'Normalized Input: ${input.name}, Value: ${input.value}',
                  );
                }
                final hasAnyValue = normalizedResult.any(
                  (input) =>
                      input.value != null &&
                      input.value.toString().trim().isNotEmpty,
                );

                if (hasAnyValue) {
                  CustomToast.show(
                    message: 'Profile added',
                    type: ToastType.success,
                  );
                  controller.member.updateFromInputs(normalizedResult);
                  controller.showSummary.value = true;
                  controller.familyMembers.add(controller.member);
                } else {
                  CustomToast.show(
                    message: 'Please fill at least one field to add a profile.',
                    type: ToastType.warning,
                  );
                }
              }
            },
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: InputBorder.none,
            ),
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}
