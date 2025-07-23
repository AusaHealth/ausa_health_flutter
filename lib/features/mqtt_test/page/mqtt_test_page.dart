import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import '../controller/mqtt_test_controller.dart';
import '../widget/topic_input_widget.dart';
import '../widget/log_console_widget.dart';

class MqttTestPage extends StatefulWidget {
  const MqttTestPage({super.key});
  @override
  State<MqttTestPage> createState() => _MqttTestPageState();
}

class _MqttTestPageState extends State<MqttTestPage> {
  final c = Get.put(MqttTestController());
  final _topicCtl = TextEditingController();
  final _msgCtl = TextEditingController();
  final _filterCtl = TextEditingController();
  bool _paused = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('MQTT Test Console')),
    body: _buildBody(context),
  );

  Widget _buildBody(BuildContext ctx) => SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // ------------------ Connection Settings ------------------
          Obx(() {
            final cfg = c.cfg.value;
            final conn = c.connection.value == MqttConnectionState.connected;
            return ExpansionTile(
              title: const Text('Connection Settings'),
              initiallyExpanded: true,
              children: [
                _rowField(
                  'Host',
                  cfg.host,
                  (v) => c.updateCfg((c) => c.host = v),
                ),
                _rowField(
                  'Port',
                  cfg.port.toString(),
                  (v) => c.updateCfg((c) => c.port = int.tryParse(v) ?? c.port),
                  keyboardType: TextInputType.number,
                ),
                SwitchListTile(
                  title: const Text('TLS'),
                  value: cfg.tls,
                  onChanged: (v) => c.updateCfg((c) => c.tls = v),
                ),
                _rowField(
                  'Keep‑alive (s)',
                  cfg.keepAlive.toString(),
                  (v) => c.updateCfg(
                    (c) => c.keepAlive = int.tryParse(v) ?? c.keepAlive,
                  ),
                  keyboardType: TextInputType.number,
                ),
                SwitchListTile(
                  title: const Text('Auto reconnect'),
                  value: cfg.autoReconnect,
                  onChanged: (v) => c.updateCfg((c) => c.autoReconnect = v),
                ),
                _rowField(
                  'Reconnect back‑off (ms)',
                  cfg.reconnectBackoffMs.toString(),
                  (v) => c.updateCfg(
                    (c) =>
                        c.reconnectBackoffMs =
                            int.tryParse(v) ?? c.reconnectBackoffMs,
                  ),
                  keyboardType: TextInputType.number,
                ),
                const Divider(),
                const Text('Last‑Will'),
                _rowField(
                  'Topic',
                  cfg.willTopic,
                  (v) => c.updateCfg((c) => c.willTopic = v),
                ),
                _rowField(
                  'Payload',
                  cfg.willPayload,
                  (v) => c.updateCfg((c) => c.willPayload = v),
                ),
                _dropdownQoS(
                  'QoS',
                  cfg.willQos,
                  (q) => c.updateCfg((c) => c.willQos = q),
                ),
                SwitchListTile(
                  title: const Text('Retain'),
                  value: cfg.willRetain,
                  onChanged: (v) => c.updateCfg((c) => c.willRetain = v),
                ),
                const Divider(),
                const Text('Publish Defaults'),
                _dropdownQoS(
                  'Default QoS',
                  cfg.defaultQos,
                  (q) => c.updateCfg((c) => c.defaultQos = q),
                ),
                SwitchListTile(
                  title: const Text('Default retain'),
                  value: cfg.defaultRetain,
                  onChanged: (v) => c.updateCfg((c) => c.defaultRetain = v),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: conn ? c.disconnect : c.connect,
                  child: Text(conn ? 'Disconnect' : 'Connect'),
                ),
              ],
            );
          }),
          const SizedBox(height: 12),
          // ------------------ Pub/Sub ------------------
          TopicInputWidget(
            topicCtl: _topicCtl,
            msgCtl: _msgCtl,
            onPublish: () => c.publish(_topicCtl.text, _msgCtl.text),
            onSub: () => c.subscribe(_topicCtl.text),
            onUnsub: () => c.unsubscribe(_topicCtl.text),
          ),
          const Divider(height: 32),
          // ------------------ Log Console ------------------
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _filterCtl,
                  decoration: const InputDecoration(labelText: 'Filter logs'),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              IconButton(
                icon: Icon(_paused ? Icons.play_arrow : Icons.pause),
                onPressed: () => setState(() => _paused = !_paused),
              ),
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => c.logs.clear(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 300, // Fixed height for log console
            child: Obx(
              () =>
                  !_paused
                      ? LogConsoleWidget(
                        logs: c.logs,
                        paused: _paused,
                        filter: _filterCtl.text,
                      )
                      : const Center(child: Text('Paused')),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _rowField(
    String label,
    String value,
    Function(String) onChanged, {
    TextInputType keyboardType = TextInputType.text,
  }) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: TextField(
            controller: TextEditingController(text: value)
              ..selection = TextSelection.collapsed(offset: value.length),
            onChanged: onChanged,
            keyboardType: keyboardType,
          ),
        ),
      ],
    ),
  );

  Widget _dropdownQoS(
    String label,
    MqttQos value,
    Function(MqttQos) onChanged,
  ) => Row(
    children: [
      SizedBox(
        width: 140,
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      DropdownButton<MqttQos>(
        value: value,
        onChanged: (v) => onChanged(v!),
        items:
            MqttQos.values
                .map(
                  (q) =>
                      DropdownMenuItem(value: q, child: Text('QoS ${q.index}')),
                )
                .toList(),
      ),
    ],
  );
}
