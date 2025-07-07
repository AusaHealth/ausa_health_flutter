import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<String?> showBottomSheetModal(
  BuildContext context, {
  String? selected,
  required List<String> listItems,
}) {
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
    ),
    isScrollControlled: false,
    builder: (context) {
      return Container(
        padding: const EdgeInsets.fromLTRB(32, 32, 32, 32),
        height: Get.height * 0.3,
        width: Get.width,
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Select', style: TextStyle(fontSize: 20)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children:
                  listItems.map((gender) {
                    final isSelected = selected == gender;
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(gender),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? Colors.black
                                    : Colors.blue.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Text(
                            gender,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.blue,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ],
        ),
      );
    },
  );
}
