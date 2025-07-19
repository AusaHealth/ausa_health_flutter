import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/design_scale.dart';
import 'package:ausa/constants/radius.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/constants/typography.dart';
import 'package:flutter/material.dart';

class HeightInputController {
  void Function(String)? onKeyPress;
  void Function()? onBackspace;
}

class WeightInputController {
  void Function(String)? onKeyPress;
  void Function()? onBackspace;
}

class HeightInput extends StatefulWidget {
  final String label;
  final String value;
  final ValueChanged<String> onChanged;
  final bool isFocused;
  final GlobalKey<HeightInputState>? inputKey;
  final VoidCallback? onTap;

  const HeightInput({
    super.key,
    required this.value,
    required this.label,
    required this.onChanged,
    this.isFocused = false,
    this.inputKey,
    this.onTap,
  });

  @override
  State<HeightInput> createState() => HeightInputState();
}

class HeightInputState extends State<HeightInput> {
  bool isFeet = true;
  final TextEditingController feetController = TextEditingController();
  final TextEditingController inchesController = TextEditingController();
  final TextEditingController cmController = TextEditingController();
  TextEditingController? activeController;
  bool isFirstInput = true;

  @override
  void initState() {
    super.initState();
    feetController.text = '0';
    inchesController.text = '0';
    cmController.text = '0.0';
    activeController = feetController;
  }

  void updateFromFeetInches() {
    int f = int.tryParse(feetController.text) ?? 0;
    int i = int.tryParse(inchesController.text) ?? 0;
    double c = f * 30.48 + i * 2.54;
    cmController.text = c.toStringAsFixed(1);
    widget.onChanged('$f\' $i\"');
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
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            widget.onTap?.call();
            setState(() {
              isFirstInput = true;
            });
          },
          child: AnimatedContainer(
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
                      color:
                          widget.isFocused
                              ? Color(0xFFFF9900)
                              : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child:
                      isFeet
                          ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  widget.onTap?.call();
                                  setState(() {
                                    activeController = feetController;
                                    isFirstInput = true;
                                  });
                                },
                                child: SizedBox(
                                  width: 40,
                                  child: TextField(
                                    enabled: false,
                                    scrollPadding: EdgeInsets.zero,
                                    controller: feetController,
                                    textAlign: TextAlign.center,
                                    style: AppTypography.body(
                                      color: AppColors.black,
                                      weight: AppTypographyWeight.regular,
                                    ),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                'ft',
                                style: AppTypography.body(
                                  color: AppColors.bodyTextColor,
                                  weight: AppTypographyWeight.regular,
                                ),
                              ),
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  widget.onTap?.call();
                                  setState(() {
                                    activeController = inchesController;
                                    isFirstInput = true;
                                  });
                                },
                                child: SizedBox(
                                  width: 40,
                                  child: TextField(
                                    enabled: false,
                                    scrollPadding: EdgeInsets.zero,
                                    controller: inchesController,
                                    textAlign: TextAlign.center,
                                    style: AppTypography.body(
                                      color: AppColors.black,
                                      weight: AppTypographyWeight.regular,
                                    ),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                'in',
                                style: AppTypography.body(
                                  color: AppColors.bodyTextColor,
                                  weight: AppTypographyWeight.regular,
                                ),
                              ),
                            ],
                          )
                          : Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  widget.onTap?.call();
                                  setState(() {
                                    activeController = cmController;
                                    isFirstInput = true;
                                  });
                                },
                                child: SizedBox(
                                  width: 50,
                                  child: TextField(
                                    enabled: false,
                                    controller: cmController,
                                    textAlign: TextAlign.center,
                                    style: AppTypography.body(
                                      color: AppColors.black,
                                      weight: AppTypographyWeight.regular,
                                    ),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
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
                  onLeftTap:
                      () => setState(() {
                        isFeet = true;
                        activeController = feetController;
                        isFirstInput = true;
                      }),
                  onRightTap:
                      () => setState(() {
                        isFeet = false;
                        activeController = cmController;
                        isFirstInput = true;
                      }),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void handleKeyPress(String value) {
    if (!widget.isFocused) return;

    if (isFeet) {
      if (activeController == feetController) {
        if (isFirstInput) {
          feetController.text = value;
          isFirstInput = false;
        } else {
          String newText = feetController.text + value;
          if (int.tryParse(newText) != null) {
            feetController.text = newText;
          }
        }
        updateFromFeetInches();
      } else {
        if (isFirstInput) {
          inchesController.text = value;
          isFirstInput = false;
        } else {
          String newText = inchesController.text + value;
          if (int.tryParse(newText) != null && int.parse(newText) < 12) {
            inchesController.text = newText;
          }
        }
        updateFromFeetInches();
      }
    } else {
      if (isFirstInput) {
        cmController.text = value;
        isFirstInput = false;
      } else {
        String newText = cmController.text + value;
        if (double.tryParse(newText) != null) {
          cmController.text = newText;
        }
      }
      updateFromCm();
    }
  }

  void handleBackspace() {
    if (!widget.isFocused) return;

    if (isFeet) {
      if (activeController == feetController) {
        if (feetController.text.isNotEmpty) {
          if (feetController.text.length == 1) {
            feetController.text = '0';
            isFirstInput = true;
          } else {
            feetController.text = feetController.text.substring(
              0,
              feetController.text.length - 1,
            );
          }
          updateFromFeetInches();
        }
      } else {
        if (inchesController.text.isNotEmpty) {
          if (inchesController.text.length == 1) {
            inchesController.text = '0';
            isFirstInput = true;
          } else {
            inchesController.text = inchesController.text.substring(
              0,
              inchesController.text.length - 1,
            );
          }
          updateFromFeetInches();
        }
      }
    } else {
      if (cmController.text.isNotEmpty) {
        if (cmController.text.length == 1) {
          cmController.text = '0';
          isFirstInput = true;
        } else {
          cmController.text = cmController.text.substring(
            0,
            cmController.text.length - 1,
          );
        }
        updateFromCm();
      }
    }
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
  final ValueChanged<String> onChanged;
  final bool isFocused;
  final GlobalKey<WeightInputState>? inputKey;
  final VoidCallback? onTap;

  const WeightInput({
    super.key,
    required this.value,
    required this.label,
    required this.onChanged,
    this.isFocused = false,
    this.inputKey,
    this.onTap,
  });

  @override
  State<WeightInput> createState() => WeightInputState();
}

class WeightInputState extends State<WeightInput> {
  bool isLbs = true;
  final TextEditingController lbsController = TextEditingController();
  final TextEditingController kgController = TextEditingController();
  TextEditingController? activeController;
  bool isFirstInput = true;

  @override
  void initState() {
    super.initState();
    lbsController.text = '0';
    kgController.text = '0.0';
    activeController = lbsController;
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
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            widget.onTap?.call();
            setState(() {
              isFirstInput = true;
            });
          },
          child: AnimatedContainer(
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
                      color:
                          widget.isFocused
                              ? Color(0xFFFF9900)
                              : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child:
                      isLbs
                          ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  widget.onTap?.call();
                                  setState(() {
                                    activeController = lbsController;
                                    isFirstInput = true;
                                  });
                                },
                                child: SizedBox(
                                  width: 60,
                                  child: TextField(
                                    enabled: false,
                                    scrollPadding: EdgeInsets.zero,
                                    controller: lbsController,
                                    textAlign: TextAlign.center,
                                    style: AppTypography.body(
                                      color: AppColors.black,
                                      weight: AppTypographyWeight.regular,
                                    ),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                'lbs',
                                style: AppTypography.body(
                                  color: AppColors.bodyTextColor,
                                  weight: AppTypographyWeight.regular,
                                ),
                              ),
                            ],
                          )
                          : Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  widget.onTap?.call();
                                  setState(() {
                                    activeController = kgController;
                                    isFirstInput = true;
                                  });
                                },
                                child: SizedBox(
                                  width: 60,
                                  child: TextField(
                                    enabled: false,
                                    controller: kgController,
                                    textAlign: TextAlign.center,
                                    style: AppTypography.body(
                                      color: AppColors.black,
                                      weight: AppTypographyWeight.regular,
                                    ),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
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
                  onLeftTap:
                      () => setState(() {
                        isLbs = true;
                        activeController = lbsController;
                        isFirstInput = true;
                      }),
                  onRightTap:
                      () => setState(() {
                        isLbs = false;
                        activeController = kgController;
                        isFirstInput = true;
                      }),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void handleKeyPress(String value) {
    if (!widget.isFocused) return;

    if (isLbs) {
      if (isFirstInput) {
        lbsController.text = value;
        isFirstInput = false;
      } else {
        String newText = lbsController.text + value;
        if (double.tryParse(newText) != null) {
          lbsController.text = newText;
        }
      }
      updateFromLbs();
    } else {
      if (isFirstInput) {
        kgController.text = value;
        isFirstInput = false;
      } else {
        String newText = kgController.text + value;
        if (double.tryParse(newText) != null) {
          kgController.text = newText;
        }
      }
      updateFromKg();
    }
  }

  void handleBackspace() {
    if (!widget.isFocused) return;

    if (isLbs) {
      if (lbsController.text.isNotEmpty) {
        if (lbsController.text.length == 1) {
          lbsController.text = '0';
          isFirstInput = true;
        } else {
          lbsController.text = lbsController.text.substring(
            0,
            lbsController.text.length - 1,
          );
        }
        updateFromLbs();
      }
    } else {
      if (kgController.text.isNotEmpty) {
        if (kgController.text.length == 1) {
          kgController.text = '0';
          isFirstInput = true;
        } else {
          kgController.text = kgController.text.substring(
            0,
            kgController.text.length - 1,
          );
        }
        updateFromKg();
      }
    }
  }
}
