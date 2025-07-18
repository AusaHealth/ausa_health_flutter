import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/design_scale.dart';
import 'package:ausa/constants/radius.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/constants/typography.dart';
import 'package:flutter/material.dart';

class HeightInput extends StatefulWidget {
  final String label;
  final String value;
  final ValueChanged<String> onChanged; // <-- add this

  const HeightInput({
    super.key,
    required this.value,
    required this.label,
    required this.onChanged,
  });

  @override
  State<HeightInput> createState() => _HeightInputState();
}

class _HeightInputState extends State<HeightInput> {
  bool isFeet = true;
  final TextEditingController feetController = TextEditingController();
  final TextEditingController inchesController = TextEditingController();
  final TextEditingController cmController = TextEditingController();

  @override
  void initState() {
    super.initState();
    feetController.text = '0';
    inchesController.text = '0';
    cmController.text = '0.0';
  }

  void updateFromFeetInches() {
    int f = int.tryParse(feetController.text) ?? 0;
    int i = int.tryParse(inchesController.text) ?? 0;
    double c = f * 30.48 + i * 2.54;
    cmController.text = c.toStringAsFixed(1);
    widget.onChanged('$f\' $i\"'); // or any format you want to store
  }

  void updateFromCm() {
    double c = double.tryParse(cmController.text) ?? 0.0;
    int totalInches = (c / 2.54).round();
    int f = totalInches ~/ 12;
    int i = totalInches % 12;
    feetController.text = f.toString();
    inchesController.text = i.toString();
    widget.onChanged('${c.toStringAsFixed(1)} cm');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          height: DesignScaleManager.scaleValue(256),
          duration: Duration(milliseconds: 200),
          width: DesignScaleManager.scaleValue(512),
          margin: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xl6,
            vertical: AppSpacing.xl,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(AppRadius.xl2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 12,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: DesignScaleManager.scaleValue(352),
                height: DesignScaleManager.scaleValue(96),
                // padding: EdgeInsets.symmetric(
                //   horizontal: AppSpacing.lg,
                //   vertical: AppSpacing.smMedium,
                // ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.xl2),
                  border: Border.all(
                    color: const Color(0xFFFF7F50), // Orange border
                    width: 2,
                  ),
                ),
                child:
                    isFeet
                        ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 40,
                              child: TextField(
                                scrollPadding: EdgeInsets.zero,
                                controller: feetController,
                                textAlign: TextAlign.center,
                                style: AppTypography.body(
                                  color: AppColors.black,
                                  weight: AppTypographyWeight.regular,
                                ),
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                onChanged:
                                    (_) => setState(updateFromFeetInches),
                              ),
                            ),
                            SizedBox(width: 4),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'ft',
                                style: AppTypography.body(
                                  color: AppColors.bodyTextColor,
                                  weight: AppTypographyWeight.regular,
                                ),
                              ),
                            ),

                            SizedBox(
                              width: 40,
                              child: TextField(
                                scrollPadding: EdgeInsets.zero,
                                controller: inchesController,
                                textAlign: TextAlign.center,
                                style: AppTypography.body(
                                  color: AppColors.black,
                                  weight: AppTypographyWeight.regular,
                                ),
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                onChanged:
                                    (_) => setState(updateFromFeetInches),
                              ),
                            ),
                            SizedBox(width: 4),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'in',
                                style: AppTypography.body(
                                  color: AppColors.bodyTextColor,
                                  weight: AppTypographyWeight.regular,
                                ),
                              ),
                            ),
                          ],
                        )
                        : Row(
                          mainAxisSize: MainAxisSize.min,

                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 50,
                              child: TextField(
                                controller: cmController,
                                textAlign: TextAlign.center,

                                style: AppTypography.body(
                                  color: AppColors.black,
                                  weight: AppTypographyWeight.regular,
                                ),
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                onChanged: (_) => setState(updateFromCm),
                              ),
                            ),
                            Text(
                              'cm',
                              style: AppTypography.body(
                                color: AppColors.bodyTextColor,
                                weight: AppTypographyWeight.regular,
                              ),
                            ),
                          ],
                        ),
              ),
              SizedBox(height: AppSpacing.smMedium),
              UnitSwitch(
                leftLabel: 'ft in',
                rightLabel: 'cm',
                isLeftSelected: isFeet,
                onLeftTap: () => setState(() => isFeet = true),
                onRightTap: () => setState(() => isFeet = false),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class UnitSwitch extends StatelessWidget {
  final String leftLabel;
  final String rightLabel;
  final bool isLeftSelected;
  final VoidCallback onLeftTap;
  final VoidCallback onRightTap;
  const UnitSwitch({
    super.key,
    required this.leftLabel,
    required this.rightLabel,
    required this.isLeftSelected,
    required this.onLeftTap,
    required this.onRightTap,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: DesignScaleManager.scaleValue(400),
      height: DesignScaleManager.scaleValue(84),
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.smMedium,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F9FF),
        borderRadius: BorderRadius.circular(AppRadius.xl2),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onLeftTap,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                height: 52,
                decoration: BoxDecoration(
                  color:
                      isLeftSelected
                          ? const Color(0xFF1A1A2E)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.xl2),
                  boxShadow:
                      isLeftSelected
                          ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ]
                          : [],
                ),
                child: Center(
                  child: Text(
                    leftLabel,
                    style: AppTypography.callout(
                      weight: AppTypographyWeight.medium,
                      color:
                          isLeftSelected ? Colors.white : AppColors.primary400,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: onRightTap,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                height: 52,
                decoration: BoxDecoration(
                  color:
                      !isLeftSelected
                          ? const Color(0xFF1A1A2E)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.xl2),
                  boxShadow:
                      !isLeftSelected
                          ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ]
                          : [],
                ),
                child: Center(
                  child: Text(
                    rightLabel,
                    style: AppTypography.callout(
                      weight: AppTypographyWeight.medium,
                      color:
                          !isLeftSelected ? Colors.white : AppColors.primary400,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WeightInput extends StatefulWidget {
  final String label;
  final String value;
  final ValueChanged<String> onChanged; // <-- add this

  const WeightInput({
    super.key,
    required this.value,
    required this.label,
    required this.onChanged,
  });

  @override
  State<WeightInput> createState() => _WeightInputState();
}

class _WeightInputState extends State<WeightInput> {
  bool isLbs = true;
  final TextEditingController lbsController = TextEditingController();
  final TextEditingController kgController = TextEditingController();

  @override
  void initState() {
    super.initState();
    lbsController.text = '0';
    kgController.text = '0.0';
  }

  void updateFromLbs() {
    double lbs = double.tryParse(lbsController.text) ?? 0.0;
    double kg = lbs * 0.45359237;
    kgController.text = kg.toStringAsFixed(1);
    widget.onChanged(kg.toStringAsFixed(1));
  }

  void updateFromKg() {
    double kg = double.tryParse(kgController.text) ?? 0.0;
    double lbs = kg / 0.45359237;
    lbsController.text = lbs.toStringAsFixed(1);
    widget.onChanged(lbs.toStringAsFixed(1));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          height: DesignScaleManager.scaleValue(256),
          duration: Duration(milliseconds: 200),
          width: DesignScaleManager.scaleValue(512),
          margin: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xl6,
            vertical: AppSpacing.xl,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(AppRadius.xl2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 12,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: DesignScaleManager.scaleValue(352),
                height: DesignScaleManager.scaleValue(96),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.xl2),
                  border: Border.all(
                    color: const Color(0xFFFF7F50), // Orange border
                    width: 2,
                  ),
                ),
                child:
                    isLbs
                        ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 60,
                              child: TextField(
                                scrollPadding: EdgeInsets.zero,
                                controller: lbsController,
                                textAlign: TextAlign.center,
                                style: AppTypography.body(
                                  color: AppColors.black,
                                  weight: AppTypographyWeight.regular,
                                ),
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                onChanged: (_) => setState(updateFromLbs),
                              ),
                            ),
                            SizedBox(width: 4),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'lbs',
                                style: AppTypography.body(
                                  color: AppColors.bodyTextColor,
                                  weight: AppTypographyWeight.regular,
                                ),
                              ),
                            ),
                          ],
                        )
                        : Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 60,
                              child: TextField(
                                controller: kgController,
                                textAlign: TextAlign.center,
                                style: AppTypography.body(
                                  color: AppColors.black,
                                  weight: AppTypographyWeight.regular,
                                ),
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                onChanged: (_) => setState(updateFromKg),
                              ),
                            ),
                            Text(
                              'kg',
                              style: AppTypography.body(
                                color: AppColors.bodyTextColor,
                                weight: AppTypographyWeight.regular,
                              ),
                            ),
                          ],
                        ),
              ),
              SizedBox(height: AppSpacing.smMedium),
              UnitSwitch(
                leftLabel: 'in lbs',
                rightLabel: 'kg',
                isLeftSelected: isLbs,
                onLeftTap: () => setState(() => isLbs = true),
                onRightTap: () => setState(() => isLbs = false),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
