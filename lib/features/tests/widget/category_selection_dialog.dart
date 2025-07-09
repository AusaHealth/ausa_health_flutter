import 'package:ausa/common/model/test.dart';
import 'package:ausa/common/widget/buttons.dart';
import 'package:ausa/constants/typography.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategorySelectionDialog extends StatefulWidget {
  final Test test;

  const CategorySelectionDialog({super.key, required this.test});

  @override
  State<CategorySelectionDialog> createState() =>
      _CategorySelectionDialogState();
}

class _CategorySelectionDialogState extends State<CategorySelectionDialog> {
  String? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    // Pre-select the first category if none selected
    if (widget.test.categories != null && widget.test.categories!.isNotEmpty) {
      selectedCategoryId =
          widget.test.selectedCategory ?? widget.test.categories!.first.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.test.categories == null || widget.test.categories!.isEmpty) {
      return SizedBox.shrink();
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 600,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Main content with image and text
            Expanded(
              child: Row(
                children: [
                  // Left side - Image with orange background
                  Container(
                    width: 250,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.orange.shade400,
                          Colors.orange.shade600,
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Image.asset(
                          'assets/category/x.png',
                          width: 200,
                          height: 400,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  // Right side - Content
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header text
                          Text(
                            'Next test',
                            style: AppTypography.callout(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Test name
                          Text(
                            widget.test.name,
                            style: AppTypography.headline(
                              fontWeight: FontWeight.w700,
                              color: Colors.grey.shade900,
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Question text
                          Text(
                            'Select test category:',
                            style: AppTypography.callout(
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Categories list
                          Expanded(
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: 1.2,
                                  ),
                              itemCount: widget.test.categories!.length,
                              itemBuilder: (context, index) {
                                final category = widget.test.categories![index];
                                final isSelected =
                                    selectedCategoryId == category.id;
                                return Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () {
                                      setState(() {
                                        selectedCategoryId = category.id;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color:
                                            isSelected
                                                ? Colors.blue.shade50
                                                : Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color:
                                              isSelected
                                                  ? Colors.blue.shade500
                                                  : Colors.grey.shade300,
                                          width: isSelected ? 2 : 1,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color:
                                                  isSelected
                                                      ? Colors.blue.shade500
                                                      : Colors.grey.shade400,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Text(
                                                category.icon ?? '📋',
                                                style: TextStyle(fontSize: 24),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            category.name,
                                            style: AppTypography.callout(
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  isSelected
                                                      ? Colors.blue.shade700
                                                      : Colors.grey.shade900,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 4),
                                          if (category.metadata != null &&
                                              category
                                                  .metadata!
                                                  .isNotEmpty) ...[
                                            const SizedBox(height: 4),
                                          ],
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
                                  onPressed: () => Get.back(),
                                  variant: ButtonVariant.secondary,
                                  borderColor: Colors.blue.shade500,
                                  borderWidth: 2,
                                  textColor: Colors.blue.shade600,
                                  backgroundColor: Colors.transparent,
                                  borderRadius: 25,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: AusaButton(
                                  onPressed:
                                      selectedCategoryId != null
                                          ? () => Get.back(
                                            result: selectedCategoryId,
                                          )
                                          : null,
                                  variant: ButtonVariant.primary,
                                  backgroundColor: Colors.blue.shade600,
                                  textColor: Colors.white,
                                  borderRadius: 25,
                                  fontWeight: FontWeight.w600,
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
}
