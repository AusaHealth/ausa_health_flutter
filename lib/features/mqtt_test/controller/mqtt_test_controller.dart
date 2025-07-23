import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common/mqtt/mqtt_client_manager.dart';
import '../../../common/mqtt/mqtt_config.dart';

class MqttTestController extends GetxController {
  final _manager = MqttClientManager();

  // Reactive state for UI binding
  Rx<MqttConfig> cfg = MqttConfig().obs;
  Rx<MqttConnectionState> get connection => _manager.connectionState;
  RxList<LogEntry> get logs => _manager.logs;

  // --------------------------------- Persistence ---------------------------------
  static const _prefsKey = 'mqtt_cfg';

  @override
  void onInit() {
    super.onInit();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_prefsKey);
    if (json != null) cfg.value = MqttConfig.fromJson(Map<String, dynamic>.from(await Future.value({})..addAll(Map<String, dynamic>.from({}))));
  }

  Future<void> _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, cfg.value.toJson().toString());
  }

  // Update cfg field helpers
  void updateCfg(void Function(MqttConfig) updates) {
    updates(cfg.value);
    cfg.refresh();
    _savePrefs();
  }

  // Connection operations
  void connect() => _manager.connect(cfg.value);
  void disconnect() => _manager.disconnect();
  void publish(String topic, String message) => _manager.publish(topic, message);
  void subscribe(String topic) => _manager.subscribe(topic);
  void unsubscribe(String topic) => _manager.unsubscribe(topic);
}
