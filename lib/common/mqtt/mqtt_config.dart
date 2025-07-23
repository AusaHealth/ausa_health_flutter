import 'package:mqtt_client/mqtt_client.dart';

class MqttConfig {
  String host;
  int port;
  bool tls;
  bool cleanSession;
  int keepAlive;
  bool autoReconnect;
  int reconnectBackoffMs;

  // Last‑Will
  String willTopic;
  String willPayload;
  MqttQos willQos;
  bool willRetain;

  // Messaging defaults
  MqttQos defaultQos;
  bool defaultRetain;

  MqttConfig({
    this.host = 'DataBroker',
    this.port = 8883,
    this.tls = true,
    this.cleanSession = true,
    this.keepAlive = 30,
    this.autoReconnect = true,
    this.reconnectBackoffMs = 2000,
    this.willTopic = 'ausa/lastWill',
    this.willPayload = 'offline',
    this.willQos = MqttQos.atLeastOnce,
    this.willRetain = false,
    this.defaultQos = MqttQos.atLeastOnce,
    this.defaultRetain = false,
  });

  Map<String, dynamic> toJson() => {
        'host': host,
        'port': port,
        'tls': tls,
        'cleanSession': cleanSession,
        'keepAlive': keepAlive,
        'autoReconnect': autoReconnect,
        'reconnectBackoffMs': reconnectBackoffMs,
        'willTopic': willTopic,
        'willPayload': willPayload,
        'willQos': willQos.index,
        'willRetain': willRetain,
        'defaultQos': defaultQos.index,
        'defaultRetain': defaultRetain,
      };

  factory MqttConfig.fromJson(Map<String, dynamic> json) => MqttConfig(
        host: json['host'] ?? 'DataBroker',
        port: json['port'] ?? 8883,
        tls: json['tls'] ?? true,
        cleanSession: json['cleanSession'] ?? true,
        keepAlive: json['keepAlive'] ?? 30,
        autoReconnect: json['autoReconnect'] ?? true,
        reconnectBackoffMs: json['reconnectBackoffMs'] ?? 2000,
        willTopic: json['willTopic'] ?? 'ausa/lastWill',
        willPayload: json['willPayload'] ?? 'offline',
        willQos: MqttQos.values[json['willQos'] ?? 1],
        willRetain: json['willRetain'] ?? false,
        defaultQos: MqttQos.values[json['defaultQos'] ?? 1],
        defaultRetain: json['defaultRetain'] ?? false,
      );
}