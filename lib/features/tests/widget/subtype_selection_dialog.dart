import 'package:ausa/common/model/test.dart';
import 'package:ausa/common/widget/buttons.dart';
import 'package:ausa/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubTypeSelectionDialog extends StatefulWidget {
  final Test test;

  const SubTypeSelectionDialog({super.key, required this.test});

  @override
  State<SubTypeSelectionDialog> createState() => _SubTypeSelectionDialogState();
}

class _SubTypeSelectionDialogState extends State<SubTypeSelectionDialog> {
  // For multi-select we keep a Set, for single-select it will contain at most 1 id
  late Set<String> _selectedIds;

  bool get _isMultiSelect => widget.test.isMultiSelect;

  @override
  void initState() {
    super.initState();
    _selectedIds = widget.test.selectedSubTypeIds.toSet();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.test.hasSubTypes) return const SizedBox.shrink();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: BoxConstraints(maxWidth: 640, maxHeight: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Main content with image and text
            Expanded(
              child: Row(
                children: [
                  // Left side - Image with orange background
                  Container(
                    width: 240,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.orange.shade400,
                          Colors.orange.shade600,
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Image.asset(
                          widget.test.image,
                          width: 300,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  // Right side content
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.test.name,
                            style: AppTypography.largeTitle(
                              color: Colors.black,
                              weight: AppTypographyWeight.medium,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Select test ${_isMultiSelect ? 'types' : 'type'}:',
                            style: AppTypography.body(
                              color: Colors.black,
                              weight: AppTypographyWeight.semibold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Grid list
                          Expanded(
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                    childAspectRatio: 2,
                                  ),
                              itemCount: widget.test.subTypes!.length,
                              itemBuilder: (context, index) {
                                final subType = widget.test.subTypes![index];
                                final isSelected = _selectedIds.contains(
                                  subType.id,
                                );
                                return Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () => _toggleSelection(subType.id),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            isSelected
                                                ? AppColors.primary700
                                                    .withOpacity(0.1)
                                                : Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color:
                                              isSelected
                                                  ? AppColors.primary700
                                                  : Colors.grey.shade300,
                                          width: isSelected ? 2 : 1,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            subType.icon ?? '📋',
                                            style: const TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            TestDefinitions
                                                    .SubTypeDisplayNames[subType
                                                    .name] ??
                                                subType.name,
                                            style: AppTypography.callout(
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  isSelected
                                                      ? AppColors.primary700
                                                      : Colors.grey.shade900,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          // Action Buttons
                          Row(
                            children: [
                              Expanded(
                                child: AusaButton(
                                  text: 'Cancel',
                                  size: ButtonSize.lg,
                                  onPressed: () => Get.back(),
                                  variant: ButtonVariant.secondary,
                                  borderColor: AppColors.primary700,
                                  textColor: AppColors.primary700,
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: AusaButton(
                                  size: ButtonSize.lg,
                                  onPressed:
                                      _selectedIds.isNotEmpty
                                          ? () => Get.back(
                                            result: _selectedIds.toList(),
                                          )
                                          : null,
                                  variant: ButtonVariant.primary,
                                  backgroundColor: AppColors.primary700,
                                  textColor: Colors.white,
                                  text: 'Continue',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_isMultiSelect) {
        if (_selectedIds.contains(id)) {
          _selectedIds.remove(id);
        } else {
          _selectedIds.add(id);
        }
      } else {
        _selectedIds
          ..clear()
          ..add(id);
      }
    });
  }
}
