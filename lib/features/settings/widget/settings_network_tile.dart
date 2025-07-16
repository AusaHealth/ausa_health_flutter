import 'package:ausa/constants/app_images.dart';
import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/design_scale.dart';
import 'package:ausa/constants/icons.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/constants/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SettingsNetworkTile extends StatelessWidget {
  final String networkName;
  final bool isSecure;
  final bool isConnected;
  final int signalStrength; // 0-4
  final bool selected;
  final VoidCallback? onTap;

  const SettingsNetworkTile({
    super.key,
    required this.networkName,
    this.isSecure = false,
    this.isConnected = false,
    this.signalStrength = 3,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color selectedBg = const Color(0xFFE5F0FF);
    final Color normalBg = Colors.white;
    final Color selectedText = const Color(0xFF00267E);
    final Color normalText = Colors.black;
    final Color iconColor = selected ? Colors.white : const Color(0xff091227);

    return Container(
      decoration: BoxDecoration(
        color: selected ? AppColors.primary500 : Colors.transparent,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  networkName,
                  style: AppTypography.body(
                    color: selected ? Colors.white : normalText,
                    weight: AppTypographyWeight.regular,
                  ),
                ),
              ),
              if (isConnected) ...[
                Text(
                  'Connected',
                  style: AppTypography.body(
                    color: AppColors.white,
                    weight: AppTypographyWeight.medium,
                  ),
                ),
                SizedBox(width: AppSpacing.xl),
              ],
              if (isSecure) ...[
                SvgPicture.asset(
                  AusaIcons.lock01,
                  height: DesignScaleManager.scaleValue(32),
                  colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                ),
                SizedBox(width: AppSpacing.xl),
              ],
              SvgPicture.asset(
                AusaIcons.wifi,
                height: DesignScaleManager.scaleValue(32),
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),
              SizedBox(width: AppSpacing.xl),
              SvgPicture.asset(
                AusaIcons.infoCircle,
                height: DesignScaleManager.scaleValue(32),
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
