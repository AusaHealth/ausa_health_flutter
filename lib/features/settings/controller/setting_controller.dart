import 'package:get/get.dart';
import 'package:screen_brightness/screen_brightness.dart';

class SettingController extends GetxController {
  // Notification settings

  RxBool isSmartPrompt = false.obs;
  final RxBool alertWifiIssues = false.obs;
  final RxBool voiceAlerts = true.obs;
  final RxBool alertCareTeam = false.obs;
  final RxBool alertFamily = true.obs;
  final RxBool smsAlert = false.obs;

  // Call settings
  final RxBool blurBackground = false.obs;
  final RxBool hideVideoWhenTesting = true.obs;
  final RxBool keepCameraOff = true.obs;
  final RxBool disableTranscription = true.obs;
  final RxBool enableClosedCaptions = false.obs;
  final RxBool enableARGuides = false.obs;

  // Methods to update notification settings
  void updateAlertWifiIssues(bool value) => alertWifiIssues.value = value;
  void updateVoiceAlerts(bool value) => voiceAlerts.value = value;
  void updateAlertCareTeam(bool value) => alertCareTeam.value = value;
  void updateAlertFamily(bool value) => alertFamily.value = value;
  void updateSmsAlert(bool value) => smsAlert.value = value;

  // Methods to update call settings
  void updateBlurBackground(bool value) => blurBackground.value = value;
  void updateHideVideoWhenTesting(bool value) =>
      hideVideoWhenTesting.value = value;
  void updateKeepCameraOff(bool value) => keepCameraOff.value = value;
  void updateDisableTranscription(bool value) =>
      disableTranscription.value = value;
  void updateEnableClosedCaptions(bool value) =>
      enableClosedCaptions.value = value;
  void updateEnableARGuides(bool value) => enableARGuides.value = value;

  RxDouble brightness = 0.5.obs;

  final RxBool isSmartPromptOn = false.obs;

  void toggleSmartPrompt() {
    isSmartPromptOn.value = !isSmartPromptOn.value;
  }

  void setSmartPrompt(bool value) {
    isSmartPromptOn.value = value;
  }

  @override
  void onInit() {
    super.onInit();
    _initBrightness();
  }

  Future<void> _initBrightness() async {
    final current = await ScreenBrightness.instance.application;
    brightness.value = current;
  }

  Future<void> setBrightness(double value) async {
    brightness.value = value;
    print('value: $value');
    await ScreenBrightness.instance.setApplicationScreenBrightness(value);
  }
}
