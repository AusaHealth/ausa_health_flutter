import 'package:ausa/common/widget/expanded_animated_button.dart';
import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/icons.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/features/profile/model/family_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ausa/features/profile/controller/profile_controller.dart';

class MemberSummaryCardWidget extends StatelessWidget {
  final bool isFamily;
  final FamilyModel member;
  const MemberSummaryCardWidget({
    super.key,
    required this.member,
    this.isFamily = false,
  });

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.find<ProfileController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelValueRow(
          items: [
            LabelValueColumn(label: "Short name", value: member.shortName),
            LabelValueColumn(label: "Full name", value: member.fullName),
            const SizedBox.shrink(),
          ],
          spacing: AppSpacing.xl,
        ),
        SizedBox(height: AppSpacing.xl2),
        LabelValueRow(
          items: [
            LabelValueColumn(label: "Phone", value: member.phone),
            LabelValueColumn(label: "Email", value: member.email),
            LabelValueColumn(label: "Relation", value: member.relationship),
          ],
          spacing: AppSpacing.xl,
        ),
        SizedBox(height: AppSpacing.xl2),
        LabelValueColumn(
          label: "Address",
          value: member.address,
          isAddress: true,
        ),

        if (isFamily) ...[
          SizedBox(height: AppSpacing.xl4),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ExpandedAnimatedButton(
                buttonText: 'Delete Member',
                icon: AusaIcons.trash01,
                onPressed: () {
                  // Call your delete logic here
                  // For example: controller.deleteMember(member);
                },
              ),
            ],
          ),
          SizedBox(height: AppSpacing.xl),
        ],
      ],
    );
  }
}

class LabelValueRow extends StatelessWidget {
  final List<Widget> items;
  final double spacing;
  const LabelValueRow({super.key, required this.items, this.spacing = 0});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _addSpacing(items, spacing),
    );
  }

  List<Widget> _addSpacing(List<Widget> children, double spacing) {
    final spaced = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      spaced.add(Expanded(child: children[i]));
      if (i != children.length - 1) {
        spaced.add(SizedBox(width: spacing));
      }
    }
    return spaced;
  }
}

class LabelValueColumn extends StatelessWidget {
  final String label;
  final String value;
  final bool isAddress;
  const LabelValueColumn({
    super.key,
    required this.label,
    required this.value,
    this.isAddress = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.callout()),
        SizedBox(height: AppSpacing.md),
        SizedBox(
          width: 250,
          child: Text(
            value,
            maxLines: isAddress ? 3 : 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.body(
              color: AppColors.textColor,
              weight: AppTypographyWeight.semibold,
            ),
          ),
        ),
      ],
    );
  }
}
