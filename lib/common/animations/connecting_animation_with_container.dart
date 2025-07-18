import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/design_scale.dart';
import 'package:ausa/constants/icons.dart';
import 'package:ausa/constants/radius.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/constants/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ConnectingAnimationWithContainer extends StatefulWidget {
  final VoidCallback? onConnected;
  final Duration animationDuration;
  final Color dotColor;
  final double dotSize;
  final TextStyle? textStyle;
  final Color containerColor;
  final bool isAnimation;
  final String? text;
  const ConnectingAnimationWithContainer({
    super.key,
    this.onConnected,
    this.animationDuration = const Duration(seconds: 5),
    this.dotColor = const Color(0xFF1673FF),
    this.dotSize = 8.0,
    this.textStyle,
    this.containerColor = AppColors.primary500,
    this.isAnimation = true,
    this.text,
  });

  @override
  State<ConnectingAnimationWithContainer> createState() =>
      _ConnectingAnimationState();
}

class _ConnectingAnimationState extends State<ConnectingAnimationWithContainer>
    with TickerProviderStateMixin {
  late AnimationController _dotsController;
  late AnimationController _fadeController;
  late List<Animation<double>> _dotAnimations;
  bool _showConnected = false;

  @override
  void initState() {
    super.initState();

    if (widget.isAnimation) {
      // Controller for dots animation
      _dotsController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1000),
      )..repeat();

      // Controller for fade transition
      _fadeController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      );

      // Create animations for each dot
      _dotAnimations = List.generate(
        3,
        (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _dotsController,
            curve: Interval(
              index * 0.2, // Stagger the animations
              0.6 + index * 0.2,
              curve: Curves.easeInOutCirc,
            ),
          ),
        ),
      );

      // Start the connection timer
      Future.delayed(widget.animationDuration, () {
        if (mounted) {
          setState(() => _showConnected = true);
          _fadeController.forward();
          _dotsController.stop();
          widget.onConnected?.call();
        }
      });
    }
  }

  @override
  void dispose() {
    if (widget.isAnimation) {
      _dotsController.dispose();
      _fadeController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: DesignScaleManager.scaleValue(70),
      decoration: BoxDecoration(
        color: widget.containerColor,
        borderRadius: BorderRadius.circular(AppRadius.xl3),
      ),

      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.isAnimation) ...[
              if (!_showConnected) ...[
                const SizedBox(width: 4),
                ...List.generate(3, (index) {
                  return AnimatedBuilder(
                    animation: _dotAnimations[index],
                    builder: (context, child) {
                      return Container(
                        width: widget.dotSize,
                        height: widget.dotSize,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.dotColor.withOpacity(
                            0.2 + (_dotAnimations[index].value * 0.8),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ],
              if (_showConnected)
                FadeTransition(
                  opacity: _fadeController,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(
                      Icons.check_circle,
                      color: widget.dotColor,
                      size: 20,
                    ),
                  ),
                ),
              SizedBox(width: AppSpacing.md),
              Text(
                _showConnected ? "Connected" : "Connecting",
                style:
                    widget.textStyle ??
                    AppTypography.callout(
                      color: Colors.white,
                      weight: AppTypographyWeight.medium,
                    ),
              ),
            ],

            if (!widget.isAnimation) ...[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    AusaIcons.alertCircle,
                    width: DesignScaleManager.scaleValue(32),
                    height: DesignScaleManager.scaleValue(32),
                    colorFilter: ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: AppSpacing.smMedium),
                  Text(
                    widget.text ?? "Connected",
                    style:
                        widget.textStyle ??
                        AppTypography.callout(
                          color: Colors.white,
                          weight: AppTypographyWeight.medium,
                        ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
