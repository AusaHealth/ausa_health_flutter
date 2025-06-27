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
