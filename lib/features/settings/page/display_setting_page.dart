import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/design_scale.dart';
import 'package:ausa/constants/icons.dart';
import 'package:ausa/constants/radius.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/features/settings/controller/setting_controller.dart';
import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_core/theme.dart';

import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:syncfusion_flutter_sliders/sliders.dart';

class DisplaySettingPage extends StatefulWidget {
  const DisplaySettingPage({super.key});

  @override
  State<DisplaySettingPage> createState() => _DisplaySettingPageState();
}

class _DisplaySettingPageState extends State<DisplaySettingPage> {
  double textSize = 1.0;

  @override
  Widget build(BuildContext context) {
    final settingController = Get.find<SettingController>();
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _DisplayCard(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () => Text(
                    '${(settingController.brightness.value * 100).round()} %',
                    style: AppTypography.title1(
                      color: AppColors.primary500,
                      weight: AppTypographyWeight.regular,
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.xl7),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Obx(
                    () => _CustomSlider(
                      minValue: 0.0,
                      maxValue: 1.0,
                      value: settingController.brightness.value,
                      onChanged: (v) => settingController.setBrightness(v),
                      image: AusaIcons.sun,
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.xl7),
                Text(
                  'Brightness',
                  style: AppTypography.body(weight: AppTypographyWeight.medium),
                ),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.lg),
          // Text Size Card
          _DisplayCard(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'A',
                      style: AppTypography.title1(
                        color: Color(0xffCFDDFD),
                        fontWeight: FontWeight.w400,
                      ).copyWith(fontSize: 24),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'A',
                      style: AppTypography.title1(
                        color: Color(0xff0F54C7),
                        fontWeight: FontWeight.w400,
                      ).copyWith(fontSize: 32),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'A',
                      style: AppTypography.title1(
                        color: Color(0xffCFDDFD),
                        fontWeight: FontWeight.w400,
                      ).copyWith(fontSize: 38),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.xl7),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _CustomSlider(
                    minValue: 0.0,
                    maxValue: 1.0,
                    image: AusaIcons.type01,
                    value: textSize,
                    onChanged: (v) => setState(() => textSize = v),
                  ),
                ),
                SizedBox(height: AppSpacing.xl7),
                Text(
                  'Text Size',
                  style: AppTypography.body(weight: AppTypographyWeight.medium),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DisplayCard extends StatelessWidget {
  final Widget child;
  const _DisplayCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.xl3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

class _CustomSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final String image;
  final double minValue;
  final double maxValue;

  const _CustomSlider({
    required this.value,
    required this.onChanged,
    required this.image,
    this.minValue = 0.0,
    this.maxValue = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomSlider(
          image: image,
          value: value,
          onChanged: onChanged,
          minValue: minValue,
          maxValue: maxValue,
          activeTrackColor: AppColors.primary500,
        ),
      ],
    );
  }
}

class CustomSlider extends StatelessWidget {
  const CustomSlider({
    required this.image,
    super.key,
    required this.value,
    required this.onChanged,
    this.minValue = 0.0,
    this.maxValue = 8.0,
    this.activeTrackColor,
  });

  final double value;
  final ValueChanged<double> onChanged;
  final double minValue;
  final double maxValue;
  final Color? activeTrackColor;
  final String image;

  @override
  Widget build(BuildContext context) {
    return SfSliderTheme(
      data: SfSliderThemeData(
        thumbColor: Colors.white,
        thumbRadius: DesignScaleManager.scaleValue(42),
        thumbStrokeColor: AppColors.primary500,
      ),
      child: SfSlider(
        thumbIcon: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SvgPicture.asset(
            image,
            width: DesignScaleManager.scaleValue(20),
            height: DesignScaleManager.scaleValue(20),
            colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn),
          ),
        ),
        inactiveColor: AppColors.gray200,
        activeColor: AppColors.primary500,
        thumbShape: SfThumbShape(),

        value: value,

        onChanged: (dynamic value) {
          onChanged(value);
        },
      ),
    );
  }
}
