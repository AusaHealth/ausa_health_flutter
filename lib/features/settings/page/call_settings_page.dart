import 'package:ausa/common/widget/app_sub_parent_container.dart';
import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/radius.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:flutter/material.dart';
import 'package:ausa/constants/typography.dart';
import 'package:get/get.dart';
import 'package:ausa/features/settings/controller/setting_controller.dart';
import 'package:ausa/features/settings/widget/switch_tab_widget.dart';

class CallSettingsPage extends StatefulWidget {
  const CallSettingsPage({super.key});

  @override
  State<CallSettingsPage> createState() => _CallSettingsPageState();
}

class _CallSettingsPageState extends State<CallSettingsPage> {
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
    return AppSubParentContainer(
      padding: EdgeInsets.symmetric(
        vertical: AppSpacing.xl4,
        horizontal: AppSpacing.xl3,
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(height: AppSpacing.smMedium),
          _sectionHeader('Privacy'),
          SizedBox(height: AppSpacing.xl),
          Obx(
            () => SwitchTabWidget(
              title: 'Blur background during call',
              value: _settingController.blurBackground.value,
              onChanged: (v) => _settingController.updateBlurBackground(v),
            ),
          ),
          SizedBox(height: AppSpacing.xl),
          Obx(
            () => SwitchTabWidget(
              title: 'Automatically hide video when taking tests',
              value: _settingController.hideVideoWhenTesting.value,
              onChanged:
                  (v) => _settingController.updateHideVideoWhenTesting(v),
            ),
          ),
          SizedBox(height: AppSpacing.xl),
          Obx(
            () => SwitchTabWidget(
              title: 'Keep camera off when joining calls',
              value: _settingController.keepCameraOff.value,
              onChanged: (v) => _settingController.updateKeepCameraOff(v),
            ),
          ),
          SizedBox(height: AppSpacing.xl),
          Obx(
            () => SwitchTabWidget(
              title: 'Disable call transcription',
              value: _settingController.disableTranscription.value,
              onChanged:
                  (v) => _settingController.updateDisableTranscription(v),
            ),
          ),
          SizedBox(height: AppSpacing.xl),
          _sectionHeader('General'),
          SizedBox(height: AppSpacing.xl),
          Obx(
            () => SwitchTabWidget(
              title: 'Enable closed captions',
              value: _settingController.enableClosedCaptions.value,
              onChanged:
                  (v) => _settingController.updateEnableClosedCaptions(v),
            ),
          ),
          SizedBox(height: AppSpacing.xl),
          Obx(
            () => SwitchTabWidget(
              title: 'Display AR guides for tests',
              value: _settingController.enableARGuides.value,
              onChanged: (v) => _settingController.updateEnableARGuides(v),
            ),
          ),
        ],
      ),
    );
  }
}
