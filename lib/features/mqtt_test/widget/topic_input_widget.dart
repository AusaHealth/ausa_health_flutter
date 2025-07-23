import 'package:flutter/material.dart';

class TopicInputWidget extends StatelessWidget {
  final TextEditingController topicCtl;
  final TextEditingController msgCtl;
  final VoidCallback onPublish;
  final VoidCallback onSub;
  final VoidCallback onUnsub;
  const TopicInputWidget({
    super.key,
    required this.topicCtl,
    required this.msgCtl,
    required this.onPublish,
    required this.onSub,
    required this.onUnsub,
  });
  @override
  Widget build(BuildContext context) => Column(children: [
        TextField(controller: topicCtl, decoration: const InputDecoration(labelText: 'Topic')),
        const SizedBox(height: 8),
        TextField(controller: msgCtl, decoration: const InputDecoration(labelText: 'Message')),
        const SizedBox(height: 8),
        Row(children: [
          ElevatedButton(onPressed: onPublish, child: const Text('Publish')),
          const SizedBox(width: 8),
          ElevatedButton(onPressed: onSub, child: const Text('Subscribe')),
          const SizedBox(width: 8),
          ElevatedButton(onPressed: onUnsub, child: const Text('Unsub')),
        ]),
      ]);
}