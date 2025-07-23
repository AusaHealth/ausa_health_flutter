import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/design_scale.dart';
import 'package:ausa/constants/icons.dart';
import 'package:ausa/constants/radius.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/features/settings/controller/setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class DisplaySettingPage extends StatefulWidget {
  const DisplaySettingPage({super.key});

  @override
  State<DisplaySettingPage> createState() => _DisplaySettingPageState();
}

class _DisplaySettingPageState extends State<DisplaySettingPage> {
  double textSize = 1.0;

  // Get the font size multiplier based on the selected step
  double getFontSizeMultiplier() {
    if (textSize <= 0.33) return 0.8; // Small
    if (textSize <= 0.66) return 1.0; // Medium
    return 1.2; // Large
  }

  // Get the preview text sizes based on the current step
  List<double> getPreviewSizes() {
    final multiplier = getFontSizeMultiplier();
    return [
      24 * multiplier, // Small A
      32 * multiplier, // Medium A
      38 * multiplier, // Large A
    ];
  }

  @override
  Widget build(BuildContext context) {
    final settingController = Get.find<SettingController>();
    final previewSizes = getPreviewSizes();

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
                    () => CustomSliderBrightness(
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
                        color:
                            textSize <= 0.33
                                ? AppColors.primary500
                                : Color(0xffCFDDFD),
                        fontWeight: FontWeight.w400,
                      ).copyWith(fontSize: previewSizes[0]),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'A',
                      style: AppTypography.title1(
                        color:
                            textSize > 0.33 && textSize <= 0.66
                                ? AppColors.primary500
                                : Color(0xffCFDDFD),
                        fontWeight: FontWeight.w400,
                      ).copyWith(fontSize: previewSizes[1]),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'A',
                      style: AppTypography.title1(
                        color:
                            textSize > 0.66
                                ? AppColors.primary500
                                : Color(0xffCFDDFD),
                        fontWeight: FontWeight.w400,
                      ).copyWith(fontSize: previewSizes[2]),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.xl7),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: CustomSlider(
                    minValue: 0.0,
                    maxValue: 1.0,
                    image: AusaIcons.type01,
                    value: textSize,
                    onChanged: (v) {
                      // Snap to nearest third
                      double snappedValue;
                      if (v <= 0.33) {
                        snappedValue = 0.0;
                      } else if (v <= 0.66)
                        snappedValue = 0.5;
                      else
                        snappedValue = 1.0;
                      setState(() => textSize = snappedValue);
                    },
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
        activeTrackHeight: 4,
        inactiveTrackHeight: 4,
        overlayRadius: 0,
        tickSize: Size(3, 12),
        tickOffset: Offset(0, 8),
        activeTickColor: AppColors.primary500,
        inactiveTickColor: AppColors.gray200,
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
        onChanged: (dynamic value) => onChanged(value as double),
        interval: 0.5,
        showTicks: true,
        minorTicksPerInterval: 0,
        stepSize: 0.5,
      ),
    );
  }
}

class CustomSliderBrightness extends StatelessWidget {
  const CustomSliderBrightness({
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
