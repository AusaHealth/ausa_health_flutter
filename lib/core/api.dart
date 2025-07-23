import 'dart:developer' as developer;

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class ApiRoutes {
  // MQTT Topics
  static const String wifiGet = '/wifi/get';
  static const String wifiNetworks = '/wifi/networks';
  static const String wifiConnect = '/wifi/connect';
  static const String wifiConnectAck = '/wifi/connect_ack';

  static const String otpSend = '/otp/send';
  static const String otpSendAck = '/otp/send_ack';
  static const String otpVerify = '/otp/verify';
  static const String otpVerifyAck = '/otp/verify_ack';

  static const String userGetProfile = '/user/get_profile';
  static const String userProfile = '/user/profile';
  static const String userUpdateProfile = '/user/update_profile';

  static const String userGetFamily = '/user/get_family';
  static const String userFamily = '/user/family';
  static const String userFamilyAdd = '/user/family/add';
  static const String userFamilyAddAck = '/user/family/add_ack';
  static const String userFamilyRemove = '/user/family/remove';
  static const String userFamilyRemoveAck = '/user/family/remove_ack';
  static const String userFamilyUpdate = '/user/family/update';
  static const String userFamilyUpdateAck = '/user/family/update_ack';

  static const String userGetCareProvider = '/user/get_care_provider';
  static const String userCareProvider = '/user/care_provider';
  static const String userCareProviderGetAvailability =
      '/user/care_provider/get_availability';
  static const String userCareProviderAvailability =
      '/user/care_provider/availability';
}

class Api {
  final MqttServerClient client;

  Api({required this.client});

  // Wifi Methods
  void getWifiNetworks(String requestId) {
    _publish(ApiRoutes.wifiGet, {'requestId': requestId});
  }

  void connectToWifi(String requestId, String name, String password) {
    _publish(ApiRoutes.wifiConnect, {
      'requestId': requestId,
      'name': name,
      'password': password,
    });
  }

  // OTP Methods
  void sendOtp(String requestId, String phoneNumber) {
    _publish(ApiRoutes.otpSend, {
      'requestId': requestId,
      'phoneNumber': phoneNumber,
    });
  }

  void verifyOtp(String requestId, String phoneNumber, String otp) {
    _publish(ApiRoutes.otpVerify, {
      'requestId': requestId,
      'phoneNumber': phoneNumber,
      'otp': otp,
    });
  }

  // User Profile Methods
  void getUserProfile(String requestId) {
    _publish(ApiRoutes.userGetProfile, {'requestId': requestId});
  }

  void updateUserProfile(String requestId, Map<String, dynamic> userModel) {
    _publish(ApiRoutes.userUpdateProfile, {
      'requestId': requestId,
      'user': userModel,
    });
  }

  // Family Methods
  void getFamily(String requestId) {
    _publish(ApiRoutes.userGetFamily, {'requestId': requestId});
  }

  void addFamilyMember(String requestId, Map<String, dynamic> familyModel) {
    _publish(ApiRoutes.userFamilyAdd, {
      'requestId': requestId,
      'family': familyModel,
    });
  }

  void removeFamilyMember(String requestId, String familyMemberId) {
    _publish(ApiRoutes.userFamilyRemove, {
      'requestId': requestId,
      'familyId': familyMemberId,
    });
  }

  void updateFamilyMember(String requestId, Map<String, dynamic> familyModel) {
    _publish(ApiRoutes.userFamilyUpdate, {
      'requestId': requestId,
      'family': familyModel,
    });
  }

  // Care Provider Methods
  void getCareProvider(String requestId) {
    _publish(ApiRoutes.userGetCareProvider, {'requestId': requestId});
  }

  void getCareProviderAvailability(String requestId, String doctorId) {
    _publish(ApiRoutes.userCareProviderGetAvailability, {
      'requestId': requestId,
      'doctorId': doctorId,
    });
  }

  // Helper method to publish messages
  void _publish(String topic, Map<String, dynamic> payload) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(payload.toString());
    developer.log('Publishing to $topic: ${payload.toString()}', name: 'MQTT');
    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }

  // Subscribe to topics
  void subscribeToTopics() {
    final topics = [
      ApiRoutes.wifiNetworks,
      ApiRoutes.wifiConnectAck,
      ApiRoutes.otpSendAck,
      ApiRoutes.otpVerifyAck,
      ApiRoutes.userProfile,
      ApiRoutes.userFamily,
      ApiRoutes.userFamilyAddAck,
      ApiRoutes.userFamilyRemoveAck,
      ApiRoutes.userFamilyUpdateAck,
      ApiRoutes.userCareProvider,
      ApiRoutes.userCareProviderAvailability,
    ];

    for (final topic in topics) {
      developer.log('Subscribing to topic: $topic', name: 'MQTT');
      client.subscribe(topic, MqttQos.atLeastOnce);
    }
  }

  // Add message handler for debugging
  void setupMessageHandler() {
    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
      for (final msg in messages) {
        final MqttPublishMessage recMess = msg.payload as MqttPublishMessage;
        final String message = MqttPublishPayload.bytesToStringAsString(
          recMess.payload.message,
        );

        developer.log(
          'Received message from ${msg.topic}: $message',
          name: 'MQTT',
        );
      }
    });

    // Log connection status changes
    client.onConnected = () {
      developer.log('Connected', name: 'MQTT');
    };

    client.onDisconnected = () {
      developer.log('Disconnected', name: 'MQTT');
    };

    client.onSubscribed = (String topic) {
      developer.log('Subscribed to $topic', name: 'MQTT');
    };
  }
}
