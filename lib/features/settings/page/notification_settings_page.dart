import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/radius.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:flutter/material.dart';
import 'package:ausa/constants/typography.dart';
import 'package:get/get.dart';
import 'package:ausa/features/settings/controller/setting_controller.dart';
import 'package:ausa/features/settings/widget/switch_tab_widget.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  final SettingController _settingController = Get.find<SettingController>();

  Widget _sectionHeader(String text) {
    return Text(
      text,
      style: AppTypography.bodyRegular(color: AppColors.textlightColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left panel
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0B1836),
                  Color(0xFF1B2B4A),
                  Color(0xFF1B2B4A),
                  Color(0xFF0B1836),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppRadius.xl3),
            ),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Smart Prompt',
                    style: AppTypography.bodyMedium(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'To alert you when its needed.',
                    style: AppTypography.bodyRegular(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B2B4A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 16,
                          ),
                        ),
                        child: Text(
                          'Know more',
                          style: AppTypography.body(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(width: AppSpacing.xl),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 36,
                            vertical: 16,
                          ),
                        ),
                        child: Text(
                          'Turn On',
                          style: AppTypography.body(
                            color: const Color(0xFF1B2B4A),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        // Right panel
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  _sectionHeader('Or enter code below to authenticate'),
                  SizedBox(height: 8),
                  Obx(
                    () => SwitchTabWidget(
                      title: 'Alert wifi issues',
                      value: _settingController.alertWifiIssues.value,
                      onChanged:
                          (v) => _settingController.updateAlertWifiIssues(v),
                    ),
                  ),
                  Obx(
                    () => SwitchTabWidget(
                      title: 'Voice alerts',
                      value: _settingController.voiceAlerts.value,
                      onChanged: (v) => _settingController.updateVoiceAlerts(v),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _sectionHeader('When health condition critical'),
                  SizedBox(height: 8),
                  Obx(
                    () => SwitchTabWidget(
                      title: 'Alert care team',
                      value: _settingController.alertCareTeam.value,
                      onChanged:
                          (v) => _settingController.updateAlertCareTeam(v),
                    ),
                  ),
                  Obx(
                    () => SwitchTabWidget(
                      title: 'Alert family',
                      value: _settingController.alertFamily.value,
                      onChanged: (v) => _settingController.updateAlertFamily(v),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _sectionHeader('Mode of Alert'),
                  SizedBox(height: 8),
                  Obx(
                    () => SwitchTabWidget(
                      title: 'SMS',
                      value: _settingController.smsAlert.value,
                      onChanged: (v) => _settingController.updateSmsAlert(v),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
