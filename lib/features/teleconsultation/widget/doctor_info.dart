import 'package:ausa/common/model/user.dart';
import 'package:ausa/common/widget/app_icons.dart';
import 'package:ausa/common/widget/containers.dart';
import 'package:ausa/constants/typography.dart';
import 'package:flutter/material.dart';

class DoctorInfo extends StatelessWidget {
  final User doctor;
  const DoctorInfo({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return BlurContainer(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIcons.doctorIcon(size: IconSize.large),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                doctor.name,
                style: AppTypography.headline(color: Color(0xFF5A749E)),
              ),
              Text(
                doctor.specialization,
                style: AppTypography.callout(color: Color(0xFF5A749E)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
