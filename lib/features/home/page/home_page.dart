import 'package:ausa/common/widget/toast.dart';
import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/icons.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/common/widget/base_scaffold.dart';
import 'package:ausa/constants/utils.dart';
// import 'package:ausa/features/onboarding/view/onboarding_wrapper.dart';
import 'package:ausa/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: AppColors.gray50,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AUSA Health Hub',
                style: AppTypography.largeTitle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                'Testing Navigation',
                style: AppTypography.body(color: Colors.grey),
              ),
              SizedBox(height: AppSpacing.xl),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 5,
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                  childAspectRatio: 1,
                  children: [
                    _buildNavigationCard(
                      title: 'Appointments',
                      subtitle: 'Schedule',
                      iconPath: AusaIcons.calendar,
                      color: Colors.blue,
                      onTap: () => Get.toNamed(AppRoutes.appointmentSchedule),
                    ),
                    _buildNavigationCard(
                      title: 'Scheduled',
                      subtitle: 'Appointments',
                      iconPath: AusaIcons.calendarCheck01,
                      color: Colors.green,
                      onTap: () => Get.toNamed(AppRoutes.appointmentScheduled),
                    ),
                    _buildNavigationCard(
                      title: 'Health',
                      subtitle: 'Schedule',
                      iconPath: AusaIcons.clockCheck,
                      color: Colors.orange,
                      onTap: () => Get.toNamed(AppRoutes.healthSchedule),
                    ),
                    _buildNavigationCard(
                      title: 'Meal',
                      subtitle: 'Times',
                      iconPath: AusaIcons.clock,
                      color: Colors.amber,
                      onTap: () => Get.toNamed(AppRoutes.mealTimes),
                    ),
                    _buildNavigationCard(
                      title: 'Vitals',
                      subtitle: 'History',
                      iconPath: AusaIcons.activityHeart,
                      color: Colors.red,
                      onTap: () => Get.toNamed(AppRoutes.vitalsHistory),
                    ),
                    _buildNavigationCard(
                      title: 'Media Test',
                      subtitle: 'History',
                      iconPath: AusaIcons.videoRecorder,
                      color: Colors.purple,
                      onTap: () => Get.toNamed(AppRoutes.mediaTestHistory),
                    ),
                    _buildNavigationCard(
                      title: 'Test',
                      subtitle: 'Selection',
                      iconPath: AusaIcons.clipboardCheck,
                      color: Colors.indigo,
                      onTap: () => Get.toNamed(AppRoutes.testSelection),
                    ),
                    _buildNavigationCard(
                      title: 'Settings',
                      subtitle: 'App Settings',
                      iconPath: AusaIcons.settings01,
                      color: Colors.blueGrey,
                      onTap: () => Get.toNamed(AppRoutes.settings),
                    ),
                    _buildNavigationCard(
                      title: 'Profile',
                      subtitle: 'User Profile',
                      iconPath: AusaIcons.userCircle,
                      color: Colors.deepPurple,
                      onTap: () => Get.toNamed(AppRoutes.profile),
                    ),

                    _buildNavigationCard(
                      title: 'Onboarding',
                      subtitle: 'Page',
                      iconPath: AusaIcons.arrowRight,
                      color: Colors.cyan,
                      onTap: () {
                        // Show a success toast
                        // CustomToast.show(
                        //   message: 'Profile updated successfully!',
                        //   type: ToastType.success,
                        // );

                        // Show an error toast
                        // CustomToast.show(
                        //   message: 'Something went wrong!',
                        //   type: ToastType.error,
                        // );

                        // Show a warning toast
                        CustomToast.show(
                          message: 'Please check your input.',
                          type: ToastType.warning,
                        );
                        // CustomToast.show(
                        //   message: 'Coming Soon',
                        //   type: ToastType.error,
                        // );
                      },

                      // Get.toNamed(AppRoutes.onboarding),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationCard({
    required String title,
    required String subtitle,
    required String iconPath,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SvgPicture.asset(
                    iconPath,
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                    placeholderBuilder:
                        (context) =>
                            Icon(Icons.widgets, size: 24, color: color),
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                title,
                style: AppTypography.callout(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                subtitle,
                style: AppTypography.callout(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
