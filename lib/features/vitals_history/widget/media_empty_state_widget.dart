import 'package:ausa/common/widget/app_main_container.dart';
import 'package:flutter/material.dart';
import '../../../constants/constants.dart';
import '../model/media_test_reading.dart';
import '../../../common/widget/buttons.dart';

class MediaEmptyStateWidget extends StatelessWidget {
  final MediaTestType mediaType;
  final VoidCallback onTakeFirstTest;

  const MediaEmptyStateWidget({
    super.key,
    required this.mediaType,
    required this.onTakeFirstTest,
  });

  @override
  Widget build(BuildContext context) {
    return AppMainContainer(
      child: Center(
        child: Container(
          margin: EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primary700.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getEmptyStateIcon(),
                  size: 60,
                  color: AppColors.primary700.withOpacity(0.7),
                ),
              ),

              SizedBox(height: AppSpacing.xl),

              // Title
              Text(
                'No ${_getDisplayName()} recordings yet',
                style: AppTypography.headline(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: AppSpacing.md),

              // Description
              Text(
                _getDescription(),
                style: AppTypography.body(
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: AppSpacing.xl2),

              // CTA Button
              AusaButton(
                text: 'Take Your First Test',
                onPressed: onTakeFirstTest,
                variant: ButtonVariant.primary,
                width: 200,
                height: 48,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getEmptyStateIcon() {
    switch (mediaType) {
      case MediaTestType.bodySound:
        return Icons.graphic_eq;
      case MediaTestType.ent:
        return Icons.video_camera_front;
    }
  }

  String _getDisplayName() {
    switch (mediaType) {
      case MediaTestType.bodySound:
        return 'Body sounds';
      case MediaTestType.ent:
        return 'ENT';
    }
  }

  String _getDescription() {
    switch (mediaType) {
      case MediaTestType.bodySound:
        return 'Record and analyze heart, lung, stomach, and bowel sounds to monitor your health.';
      case MediaTestType.ent:
        return 'Perform ear, nose, and throat examinations to check for any irregularities.';
    }
  }
}
