import 'package:ausa/constants/design_scale.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/constants/icons.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomHeader extends StatelessWidget {
  const CustomHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: DesignScaleManager.scaleValue(88),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ).copyWith(right: AppSpacing.xl3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SvgPicture.asset(
              AusaIcons.bluetoothOn,
              height: DesignScaleManager.scaleValue(40),
              colorFilter: ColorFilter.mode(Color(0xff59739E), BlendMode.srcIn),
            ),
            SizedBox(width: AppSpacing.xl2),
            SvgPicture.asset(
              AusaIcons.rss01,
              height: DesignScaleManager.scaleValue(40),
              colorFilter: ColorFilter.mode(Color(0xff59739E), BlendMode.srcIn),
            ),
            SizedBox(width: AppSpacing.xl2),
            SvgPicture.asset(
              AusaIcons.batteryFull,
              height: DesignScaleManager.scaleValue(40),
              colorFilter: ColorFilter.mode(Color(0xff59739E), BlendMode.srcIn),
            ),
          ],
        ),
      ),
    );
  }
}
