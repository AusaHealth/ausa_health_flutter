import 'package:ausa/common/widget/buttons.dart';
import 'package:ausa/constants/app_images.dart';
import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/radius.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/features/settings/page/know_more_page.dart';
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
      style: AppTypography.body(
        color: AppColors.textlightColor,
        weight: AppTypographyWeight.regular,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isOn = _settingController.isSmartPromptOn.value;
      return Row(
        children: [
          // Left panel
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.xl3),
                image: DecorationImage(
                  image: AssetImage(AppImages.notificationBg),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  top: AppSpacing.xl6,
                  left: AppSpacing.xl2,
                  right: AppSpacing.xl2,
                  bottom: AppSpacing.xl4,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Smart Prompt',
                      style: AppTypography.body(
                        color: Colors.white,
                        weight: AppTypographyWeight.medium,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      isOn ? 'Is turned On' : 'To alert you when its needed.',
                      style: AppTypography.body(
                        color: Colors.white,
                        weight: AppTypographyWeight.regular,
                      ),
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AusaButton(
                          size: ButtonSize.lg,
                          backgroundColor: AppColors.bodyTextColor,
                          textColor: Colors.white,
                          variant: ButtonVariant.secondary,
                          text: 'Know more',
                          borderColor: Colors.white,
                          onPressed: () {
                            Get.to(() => SmartPromptDialog());
                          },
                        ),
                        SizedBox(width: AppSpacing.md),
                        SizedBox(
                          width: 120, // Adjust as needed to fit your design
                          child: AusaButton(
                            size: ButtonSize.lg,
                            variant: ButtonVariant.primary,
                            text: isOn ? 'Turn Off' : 'Turn On',
                            onPressed: () {
                              _settingController.toggleSmartPrompt();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: AppSpacing.lg),
          // Right panel
          Expanded(
            flex: 1,
            child: Opacity(
              opacity: isOn ? 0.5 : 1.0,
              child: IgnorePointer(
                ignoring: isOn,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl4,
                    vertical: AppSpacing.xl4,
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.xl3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      _sectionHeader('Or enter code below to authenticate'),
                      SizedBox(height: AppSpacing.xl),
                      Obx(
                        () => SwitchTabWidget(
                          title: 'Alert wifi issues',
                          value: _settingController.alertWifiIssues.value,
                          onChanged:
                              (v) =>
                                  _settingController.updateAlertWifiIssues(v),
                        ),
                      ),
                      SizedBox(height: AppSpacing.xl),

                      Obx(
                        () => SwitchTabWidget(
                          title: 'Voice alerts',
                          value: _settingController.voiceAlerts.value,
                          onChanged:
                              (v) => _settingController.updateVoiceAlerts(v),
                        ),
                      ),

                      SizedBox(height: AppSpacing.xl),
                      _sectionHeader('When health condition critical'),
                      SizedBox(height: AppSpacing.xl),
                      Obx(
                        () => SwitchTabWidget(
                          title: 'Alert care team',
                          value: _settingController.alertCareTeam.value,
                          onChanged:
                              (v) => _settingController.updateAlertCareTeam(v),
                        ),
                      ),
                      SizedBox(height: AppSpacing.xl),
                      Obx(
                        () => SwitchTabWidget(
                          title: 'Alert family',
                          value: _settingController.alertFamily.value,
                          onChanged:
                              (v) => _settingController.updateAlertFamily(v),
                        ),
                      ),
                      SizedBox(height: AppSpacing.xl),

                      _sectionHeader('Mode of Alert'),
                      SizedBox(height: AppSpacing.xl),
                      Obx(
                        () => SwitchTabWidget(
                          title: 'SMS',
                          value: _settingController.smsAlert.value,
                          onChanged:
                              (v) => _settingController.updateSmsAlert(v),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
