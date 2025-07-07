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
      style: AppTypography.callout(
        color: const Color(0xFFB0B0B0), // grey
      ).copyWith(fontSize: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 24),
            _sectionHeader('Privacy'),
            const SizedBox(height: 8),
            Obx(
              () => SwitchTabWidget(
                title: 'Blur background during call',
                value: _settingController.blurBackground.value,
                onChanged: (v) => _settingController.updateBlurBackground(v),
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => SwitchTabWidget(
                title: 'Automatically hide video when taking tests',
                value: _settingController.hideVideoWhenTesting.value,
                onChanged:
                    (v) => _settingController.updateHideVideoWhenTesting(v),
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => SwitchTabWidget(
                title: 'Keep camera off when joining calls',
                value: _settingController.keepCameraOff.value,
                onChanged: (v) => _settingController.updateKeepCameraOff(v),
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => SwitchTabWidget(
                title: 'Disable call transcription',
                value: _settingController.disableTranscription.value,
                onChanged:
                    (v) => _settingController.updateDisableTranscription(v),
              ),
            ),
            const SizedBox(height: 20),
            _sectionHeader('General'),
            const SizedBox(height: 8),
            Obx(
              () => SwitchTabWidget(
                title: 'Enable closed captions',
                value: _settingController.enableClosedCaptions.value,
                onChanged:
                    (v) => _settingController.updateEnableClosedCaptions(v),
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => SwitchTabWidget(
                title: 'Display AR guides for tests',
                value: _settingController.enableARGuides.value,
                onChanged: (v) => _settingController.updateEnableARGuides(v),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
