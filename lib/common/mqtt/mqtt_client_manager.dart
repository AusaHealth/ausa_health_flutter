import 'dart:async';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'mqtt_config.dart';

enum LogLevel { info, warn, error, req, res }

class LogEntry {
  final LogLevel level;
  final DateTime time;
  final String message;
  LogEntry(this.level, this.time, this.message);
}

class MqttClientManager {
  static final MqttClientManager _i = MqttClientManager._internal();
  factory MqttClientManager() => _i;
  MqttClientManager._internal();

  late MqttServerClient _client;
  late MqttConfig _cfg;

  final Rx<MqttConnectionState> connectionState = Rx<MqttConnectionState>(
    MqttConnectionState.disconnected,
  );
  final RxList<LogEntry> logs = <LogEntry>[].obs;

  Future<void> connect(MqttConfig cfg) async {
    _cfg = cfg;
    // Build client anew every connect so host/port/tls apply.
    _client =
        MqttServerClient.withPort(
            cfg.host,
            'ausa_flutter_${DateTime.now().millisecondsSinceEpoch}',
            cfg.port,
          )
          ..logging(on: false)
          ..secure = cfg.tls
          ..keepAlivePeriod = cfg.keepAlive
          ..autoReconnect = cfg.autoReconnect
          ..resubscribeOnAutoReconnect = true
          ..onConnected = _onConnected
          ..onDisconnected = _onDisconnected
          ..onSubscribed = _onSubscribed
          ..onSubscribeFail = _onSubscribeFail
          ..onAutoReconnect = _onAutoReconnect
          ..pongCallback = _onPong
          ..setProtocolV311();

    _client.connectionMessage =
        MqttConnectMessage()
            .withClientIdentifier(_client.clientIdentifier)
            .startClean()
            .withWillTopic(cfg.willTopic)
            .withWillMessage(cfg.willPayload)
            .withWillQos(cfg.willQos)
            .withWillRetain();

    _log(
      LogLevel.info,
      'Connecting to ${cfg.host}:${cfg.port} TLS=${cfg.tls}…',
    );
    try {
      await _client.connect();
    } on Exception catch (e) {
      _log(LogLevel.error, 'Connection failed: $e');
      _client.disconnect();
    }
  }

  void disconnect() {
    if (connectionState.value == MqttConnectionState.connected) {
      _log(LogLevel.info, 'Disconnecting…');
      _client.disconnect();
    }
  }

  void publish(String topic, String payload) {
    if (connectionState.value != MqttConnectionState.connected) {
      _log(LogLevel.warn, 'Publish skipped – not connected');
      return;
    }
    final builder = MqttClientPayloadBuilder()..addString(payload);
    _client.publishMessage(
      topic,
      _cfg.defaultQos,
      builder.payload!,
      retain: _cfg.defaultRetain,
    );
    _log(LogLevel.req, '[PUB] ➡️ $topic : $payload');
  }

  void subscribe(String topic) {
    if (connectionState.value != MqttConnectionState.connected) {
      _log(LogLevel.warn, 'Subscribe skipped – not connected');
      return;
    }
    _log(LogLevel.info, 'Subscribing $topic');
    _client.subscribe(topic, _cfg.defaultQos);
  }

  void unsubscribe(String topic) {
    if (connectionState.value != MqttConnectionState.connected) {
      _log(LogLevel.warn, 'Unsubscribe skipped – not connected');
      return;
    }
    _log(LogLevel.info, 'Unsubscribing $topic');
    _client.unsubscribe(topic);
  }

  // --------------------------------------------------------------------------
  // Callbacks
  // --------------------------------------------------------------------------
  void _onConnected() {
    connectionState.value = MqttConnectionState.connected;
    _log(LogLevel.info, 'Connected');
    _client.updates?.listen((events) {
      final rec = events.first;
      final pub = rec.payload as MqttPublishMessage;
      final msg = MqttPublishPayload.bytesToStringAsString(pub.payload.message);
      _log(LogLevel.res, '[SUB] ⬅️ ${rec.topic} : $msg');
    });
  }

  void _onDisconnected() {
    connectionState.value = MqttConnectionState.disconnected;
    _log(LogLevel.info, 'Disconnected');
  }

  void _onSubscribed(String topic) {
    _log(LogLevel.info, 'Subscribed to $topic');
  }

  void _onSubscribeFail(String topic) {
    _log(LogLevel.error, 'Failed subscribe $topic');
  }

  void _onAutoReconnect() {
    _log(LogLevel.warn, 'Auto‑reconnect…');
  }

  void _onPong() {
    _log(LogLevel.info, 'PONG');
  }

  void _log(LogLevel level, String msg) =>
      logs.add(LogEntry(level, DateTime.now(), msg));
}
