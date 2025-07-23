import 'package:flutter/material.dart';
import '../../../common/mqtt/mqtt_client_manager.dart';

class LogConsoleWidget extends StatelessWidget {
  final List<LogEntry> logs;
  final bool paused;
  final String filter;
  const LogConsoleWidget({
    super.key,
    required this.logs,
    required this.paused,
    required this.filter,
  });

  Color _color(LogLevel lvl) => switch (lvl) {
        LogLevel.info => Colors.blue,
        LogLevel.warn => Colors.orange,
        LogLevel.error => Colors.red,
        LogLevel.req => Colors.green,
        LogLevel.res => Colors.purple,
      };

  @override
  Widget build(BuildContext context) {
    final filtered = logs.where((e) => e.message.contains(filter)).toList();
    return ListView.builder(
      reverse: true,
      itemCount: filtered.length,
      itemBuilder: (_, i) {
        final entry = filtered[filtered.length - 1 - i];
        return Text(
          '[${entry.time.toIso8601String()}] ${entry.message}',
          style: TextStyle(fontFamily: 'monospace', color: _color(entry.level)),
        );
      },
    );
  }
}
