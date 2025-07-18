import 'package:ausa/common/animations/connecting_animation_with_container.dart';
import 'package:ausa/constants/app_images.dart';
import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/design_scale.dart';
import 'package:ausa/constants/radius.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/constants/typography.dart';
import 'package:flutter/material.dart';

class BluetoothPage extends StatelessWidget {
  const BluetoothPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.xl6,
            bottom: AppSpacing.xl2,
            top: AppSpacing.xl,
          ),
          child: Text(
            'Device status',
            style: AppTypography.body(weight: AppTypographyWeight.regular),
          ),
        ),

        Expanded(
          child: Row(
            children: [
              DeviceStatusCard(
                deviceName: 'Blood pressure',
                imagePath: AppImages.bloodPressure,
                statusImagePath: AppImages.connecting,
                isActive: true,
              ),
              SizedBox(width: AppSpacing.lg),
              DeviceStatusCard(
                deviceName: 'X',
                imagePath: AppImages.X,
                statusImagePath: AppImages.notFound,
                isActive: false,
              ),
              SizedBox(width: AppSpacing.lg),
              DeviceStatusCard(
                deviceName: 'ECG',
                imagePath: AppImages.ecg,
                statusImagePath: AppImages.notFound,
                isActive: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DeviceStatusCard extends StatelessWidget {
  final String deviceName;
  final String imagePath;

  final String statusImagePath;
  final bool isActive;

  const DeviceStatusCard({
    super.key,
    required this.deviceName,
    required this.imagePath,
    required this.statusImagePath,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.xl3),
          border: Border.all(
            color: isActive ? Color(0xFF1673FF) : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.lg,
              ),
              child: Align(
                alignment: Alignment.topRight,
                child:
                    isActive
                        ? ConnectingAnimationWithContainer(
                          containerColor: AppColors.primary500,
                          dotColor: Colors.white,
                          textStyle: AppTypography.callout(
                            weight: AppTypographyWeight.medium,
                            color: Colors.white,
                          ),
                          onConnected: () {
                            // Handle connected state if needed
                          },
                        )
                        : ConnectingAnimationWithContainer(
                          isAnimation: false,
                          text: "Not found.",
                          containerColor: Color(0xff7A879C),
                          dotColor: Colors.white,
                          textStyle: AppTypography.callout(
                            weight: AppTypographyWeight.medium,
                            color: Colors.white,
                          ),
                        ),
              ),
            ),
            // Device image and label
            Expanded(
              child: Center(
                child: Image.asset(
                  imagePath,
                  // height: DesignScaleManager.scaleValue(328),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(height: AppSpacing.sm),

            Center(
              child: Text(
                deviceName,
                style: AppTypography.body(weight: AppTypographyWeight.medium),
              ),
            ),
            SizedBox(height: AppSpacing.xl6),
          ],
        ),
      ),
    );
  }
}

class ConnectingAnimation extends StatefulWidget {
  final VoidCallback? onConnected;
  final Duration animationDuration;
  final Color dotColor;
  final double dotSize;
  final TextStyle? textStyle;

  const ConnectingAnimation({
    super.key,
    this.onConnected,
    this.animationDuration = const Duration(seconds: 3),
    this.dotColor = const Color(0xFF1673FF),
    this.dotSize = 8.0,
    this.textStyle,
  });

  @override
  State<ConnectingAnimation> createState() => _ConnectingAnimationState();
}

class _ConnectingAnimationState extends State<ConnectingAnimation>
    with TickerProviderStateMixin {
  late AnimationController _dotsController;
  late AnimationController _fadeController;
  late List<Animation<double>> _dotAnimations;
  bool _showConnected = false;

  @override
  void initState() {
    super.initState();

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
            curve: Curves.easeInOut,
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

  @override
  void dispose() {
    _dotsController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _showConnected ? "Connected" : "Connecting",
          style:
              widget.textStyle ??
              const TextStyle(
                fontSize: 16,
                color: Color(0xFF1673FF),
                fontWeight: FontWeight.w500,
              ),
        ),
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
              child: Icon(Icons.check_circle, color: widget.dotColor, size: 20),
            ),
          ),
      ],
    );
  }
}
