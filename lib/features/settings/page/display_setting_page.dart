import 'dart:ui';

import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/design_scale.dart';
import 'package:ausa/constants/icons.dart';
import 'package:ausa/constants/radius.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/features/settings/controller/setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

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
                        color: Colors.blue,
                        fontWeight: FontWeight.w400,
                      ).copyWith(fontSize: 24),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'A',
                      style: AppTypography.title1(
                        color: Colors.blue,
                        fontWeight: FontWeight.w400,
                      ).copyWith(fontSize: 32),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'A',
                      style: AppTypography.title1(
                        color: Colors.blue,
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
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 6.0,
        activeTrackColor:
            activeTrackColor ?? Theme.of(context).colorScheme.secondary,
        inactiveTrackColor: AppColors.gray200,
        thumbColor: activeTrackColor ?? Theme.of(context).colorScheme.secondary,
        thumbShape: SvgThumbShape(
          assetPath: image,
          size: 48,
        ), // <-- Use your SVG asset
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 0.0),
      ),
      child: Slider(
        value: value,
        onChanged: onChanged,
        min: minValue,
        max: maxValue,
      ),
    );
  }
}

class SvgThumbShape extends SliderComponentShape {
  final String assetPath;
  final double size;

  SvgThumbShape({required this.assetPath, this.size = 48});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size(size, size);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;
    final picture = SvgPicture.asset(
      assetPath,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(
        sliderTheme.thumbColor ?? Colors.white,
        BlendMode.srcIn,
      ),
    );
    // Use a PictureRecorder to draw SVG synchronously
    final recorder = PictureRecorder();
    final tempCanvas = Canvas(recorder);
    // picture(tempCanvas, Offset(size / 2, size / 2));
    final pic = recorder.endRecording();
    canvas.drawPicture(pic);
    // Or, for a simpler approach, use a circle as a placeholder:
    // canvas.drawCircle(center, size / 2, Paint()..color = sliderTheme.thumbColor ?? Colors.white);
  }
}

class SvgCircleThumbShape extends SliderComponentShape {
  final String assetPath;
  final double size;
  final Color fillColor;

  SvgCircleThumbShape({
    required this.assetPath,
    this.size = 48,
    required this.fillColor,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size(size, size);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;

    // Draw the filled circle
    final paint = Paint()..color = fillColor;
    canvas.drawCircle(center, size / 2, paint);

    // Draw the SVG icon centered in the thumb
    // This is a workaround: use a PictureRecorder to render the SVG to an image, then draw it
    // (This is synchronous and works for small icons)
    final pictureRecorder = PictureRecorder();
    final tempCanvas = Canvas(pictureRecorder);
    final svgWidget = SvgPicture.asset(
      assetPath,
      width: size * 0.5,
      height: size * 0.5,
      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
    );
    // Render the widget to an image
    final RenderRepaintBoundary boundary = RenderRepaintBoundary();
    final BuildContext? buildContext = context as BuildContext?;
    if (buildContext != null) {
      // This is a hack, but for a real app, use a precached PNG or use flutter_svg's DrawableRoot
    }
    // Instead, recommend using a PNG for the icon, or use a custom painter for simple icons.
    // For now, you can draw a placeholder:
    // canvas.drawCircle(center, size * 0.2, Paint()..color = Colors.white);
    // For a real SVG, see the note below.
  }
}
