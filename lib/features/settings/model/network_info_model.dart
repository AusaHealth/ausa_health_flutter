class NetworkInfo {
  final String name;
  final bool isSecure;
  final bool isConnected;
  final int signalStrength;

  NetworkInfo({
    required this.name,
    this.isSecure = false,
    this.isConnected = false,
    this.signalStrength = 3,
  });

  NetworkInfo copyWith({
    String? name,
    bool? isSecure,
    bool? isConnected,
    int? signalStrength,
  }) {
    return NetworkInfo(
      name: name ?? this.name,
      isSecure: isSecure ?? this.isSecure,
      isConnected: isConnected ?? this.isConnected,
      signalStrength: signalStrength ?? this.signalStrength,
    );
  }
}

class WifiModel {
  final String name;
  final String? password;
  final String security;
  final bool isConnected;

  WifiModel({
    required this.name,
    this.password,
    required this.security,
    required this.isConnected,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'password': password,
    'security': security,
    'isConnected': isConnected,
  };

  factory WifiModel.fromJson(Map<String, dynamic> json) => WifiModel(
    name: json['name'],
    password: json['password'],
    security: json['security'],
    isConnected: json['isConnected'],
  );
}
