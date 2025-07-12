import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/common/widget/base_scaffold.dart';
import 'package:ausa/routes/routes.dart';
import 'package:flutter/material.dart';
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
                  childAspectRatio: 0.8,
                  children: [
                    _buildNavigationCard(
                      title: 'Appointments',
                      subtitle: 'Schedule',
                      icon: Icons.calendar_month,
                      color: Colors.blue,
                      onTap: () => Get.toNamed(AppRoutes.appointmentSchedule),
                    ),
                    _buildNavigationCard(
                      title: 'Scheduled',
                      subtitle: 'Appointments',
                      icon: Icons.event_available,
                      color: Colors.green,
                      onTap: () => Get.toNamed(AppRoutes.appointmentScheduled),
                    ),
                    _buildNavigationCard(
                      title: 'Health',
                      subtitle: 'Schedule',
                      icon: Icons.schedule,
                      color: Colors.orange,
                      onTap: () => Get.toNamed(AppRoutes.healthSchedule),
                    ),
                    _buildNavigationCard(
                      title: 'Meal',
                      subtitle: 'Times',
                      icon: Icons.restaurant,
                      color: Colors.amber,
                      onTap: () => Get.toNamed(AppRoutes.mealTimes),
                    ),
                    _buildNavigationCard(
                      title: 'Vitals',
                      subtitle: 'History',
                      icon: Icons.favorite,
                      color: Colors.red,
                      onTap: () => Get.toNamed(AppRoutes.vitalsHistory),
                    ),
                    _buildNavigationCard(
                      title: 'Media Test',
                      subtitle: 'History',
                      icon: Icons.video_library,
                      color: Colors.purple,
                      onTap: () => Get.toNamed(AppRoutes.mediaTestHistory),
                    ),
                    _buildNavigationCard(
                      title: 'Test',
                      subtitle: 'Selection',
                      icon: Icons.quiz,
                      color: Colors.indigo,
                      onTap: () => Get.toNamed(AppRoutes.testSelection),
                    ),
                    _buildNavigationCard(
                      title: 'Settings',
                      subtitle: 'App Settings',
                      icon: Icons.settings,
                      color: Colors.blueGrey,
                      onTap: () => Get.toNamed(AppRoutes.settings),
                    ),
                    _buildNavigationCard(
                      title: 'Profile',
                      subtitle: 'User Profile',
                      icon: Icons.person,
                      color: Colors.deepPurple,
                      onTap: () => Get.toNamed(AppRoutes.profile),
                    ),
                    _buildNavigationCard(
                      title: 'Teleconsultation',
                      subtitle: 'Video Call',
                      icon: Icons.video_call,
                      color: Colors.pink,
                      onTap: () => Get.toNamed(AppRoutes.teleconsultation),
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
    required IconData icon,
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
                child: Icon(icon, color: color, size: 24),
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
