import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/design_scale.dart';
import 'package:ausa/constants/icons.dart';
import 'package:ausa/constants/radius.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/constants/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

Future<String?> showBottomSheetModal(
  BuildContext context, {
  String? selected,
  required List<String> listItems,
}) {
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl3)),
    ),
    constraints: BoxConstraints(maxHeight: 350),
    isScrollControlled: false,
    builder: (context) {
      return Container(
        // padding: const EdgeInsets.fromLTRB(32, 32, 32, 32),
        width: Get.width,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xl6,
            vertical: AppSpacing.xl4,
          ),
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('Select', style: TextStyle(fontSize: 20)),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: SvgPicture.asset(
                      AusaIcons.xClose,
                      height: DesignScaleManager.scaleValue(40),
                      width: DesignScaleManager.scaleValue(40),
                      colorFilter: ColorFilter.mode(
                        Colors.black,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.xl),
              Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.md,
                children:
                    listItems.map((gender) {
                      final isSelected = selected == gender;
                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(gender),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.xl2,
                              vertical: AppSpacing.lg,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? Colors.black
                                      : Colors.blue.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(
                                AppRadius.xl3,
                              ),
                            ),
                            child: Text(
                              gender,
                              style: AppTypography.body(
                                color:
                                    isSelected
                                        ? Colors.white
                                        : AppColors.primary500,
                                weight: AppTypographyWeight.medium,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ],
          ),
        ),
      );
    },
  );
}
