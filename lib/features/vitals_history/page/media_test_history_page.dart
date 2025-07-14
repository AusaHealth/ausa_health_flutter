import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/constants.dart';
import '../controller/media_test_history_controller.dart';
import '../model/media_test_reading.dart';
import '../widget/media_test_card_widget.dart';
import '../widget/media_empty_state_widget.dart';
import 'package:ausa/common/widget/app_back_header.dart';
import 'package:ausa/common/widget/app_main_container.dart';
import 'package:ausa/common/widget/app_tab_buttons.dart';
import 'package:ausa/common/widget/buttons.dart';

class MediaTestHistoryPage extends StatefulWidget {
  const MediaTestHistoryPage({super.key});

  @override
  _MediaTestHistoryPageState createState() => _MediaTestHistoryPageState();
}

class _MediaTestHistoryPageState extends State<MediaTestHistoryPage> {
  late final MediaTestHistoryController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<MediaTestHistoryController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      body: SafeArea(
        child: Column(
          children: [
            AppBackHeader(
              title: 'Media',
              onBackPressed: () => Get.back(),
            ),
            Obx(
              () => Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl6,
                  vertical: AppSpacing.lg,
                ),
                child: Row(children: _buildTabButtons(controller)),
              ),
            ),
            Obx(() {
              if (controller.hasNoReadings) {
                return MediaEmptyStateWidget(
                  mediaType: controller.currentMediaType,
                  onTakeFirstTest: () => controller.fetchMediaTests(),
                );
              }

              return _buildMediaTestList();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaTestList() {
    return AppMainContainer(
      child: Stack(
        children: [
          Obx(() {
            final readings = controller.currentReadings;
            if (readings.isEmpty) {
              return MediaEmptyStateWidget(
                mediaType: controller.currentMediaType,
                onTakeFirstTest: () => controller.fetchMediaTests(),
              );
            }

            return _buildGroupedReadingsList(readings);
          }),
          // Action button (Select / Delete) positioned at top right
          Positioned(
            top: 20,
            right: 20,
            child: Obx(() {
              // If NOT in selection mode, show the "Select" control
              if (!controller.isSelectionMode.value) {
                return GestureDetector(
                  onTap: () => controller.enterSelectionMode(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.circle_outlined,
                        size: 16.0,
                        color: AppColors.primary700,
                      ),
                      SizedBox(width: AppSpacing.md),
                      Text(
                        'Select',
                        style: AppTypography.body(color: AppColors.primary700),
                      ),
                    ],
                  ),
                );
              }

              // In selection mode : show DELETE button
              final bool hasSelection =
                  controller.selectedReadingIds.isNotEmpty;

              return AusaButton(
                text: 'Delete',
                onPressed: hasSelection ? _showDeleteConfirmationDialog : null,
                variant: ButtonVariant.primary,
                backgroundColor:
                    hasSelection
                        ? Colors.orange
                        : Colors.orange.withOpacity(0.4),
                textColor: Colors.white,
                leadingIcon: Icon(
                  Icons.delete_outline,
                  size: 20,
                  color: Colors.white,
                ),
                isEnabled: hasSelection,
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupedReadingsList(List<MediaTestReading> readings) {
    // Group readings by date
    final Map<String, List<MediaTestReading>> groupedReadings = {};

    for (final reading in readings) {
      final dateKey = _getDateKey(reading.timestamp);
      if (!groupedReadings.containsKey(dateKey)) {
        groupedReadings[dateKey] = [];
      }
      groupedReadings[dateKey]!.add(reading);
    }

    // Sort date keys in descending order (newest first)
    final sortedDateKeys =
        groupedReadings.keys.toList()..sort((a, b) => b.compareTo(a));

    return ListView.builder(
      padding: EdgeInsets.only(
        bottom: AppSpacing.xl,
        left: AppSpacing.xl,
        right: AppSpacing.xl,
      ),
      itemCount: sortedDateKeys.length,
      itemBuilder: (context, index) {
        final dateKey = sortedDateKeys[index];
        final dayReadings = groupedReadings[dateKey]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date header
            _buildDateHeader(dateKey),

            // Grid of readings for this date
            _buildReadingsGrid(dayReadings),

            SizedBox(height: AppSpacing.lg),
          ],
        );
      },
    );
  }

  Widget _buildReadingsGrid(List<MediaTestReading> readings) {
    return Container(
      padding: EdgeInsets.only(top: AppSpacing.lg),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
          childAspectRatio: 2, // Slightly taller than wide
        ),
        itemCount: readings.length,
        itemBuilder: (context, index) {
          return Obx(
            () => MediaTestCardWidget(
              reading: readings[index],
              isSelected: controller.isReadingSelected(readings[index].id),
              isSelectionMode: controller.isSelectionMode.value,
              onTap: () => _handleReadingTap(readings[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDateHeader(String dateKey) {
    final isToday = dateKey == _getDateKey(DateTime.now());
    final displayText = _formatDateFromKey(dateKey);

    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.md, top: AppSpacing.md),
      child: Row(
        children: [
          Text(
            displayText,
            style: AppTypography.body(
              color: Colors.black87,
              weight: AppTypographyWeight.semibold,
            ),
          ),
          if (isToday) ...[
            SizedBox(width: AppSpacing.md),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary700.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppRadius.xl3),
              ),
              child: Text(
                'Today',
                style: AppTypography.callout(
                  color: AppColors.primary700,
                  weight: AppTypographyWeight.semibold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _handleReadingTap(MediaTestReading reading) {
    if (controller.isSelectionMode.value) {
      controller.toggleReadingSelection(reading.id);
    } else {
      controller.selectReadingForDetail(reading);
      // TODO: Navigate to media test detail page or play recording
    }
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 300,
              padding: EdgeInsets.all(AppSpacing.xl2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.xl2),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon + title
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.delete_outline,
                          color: Colors.orange,
                        ),
                      ),
                      SizedBox(width: AppSpacing.md),
                      Text(
                        'Delete?',
                        style: AppTypography.callout(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.md),
                  Text(
                    'Are you sure you want to delete?',
                    style: AppTypography.body(color: Colors.black54),
                  ),
                  SizedBox(height: AppSpacing.xl2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Cancel Button
                      Expanded(
                        child: AusaButton(
                          text: 'Cancel',
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          variant: ButtonVariant.secondary,
                          borderColor: Colors.orange,
                          textColor: Colors.orange,
                        ),
                      ),
                      SizedBox(width: AppSpacing.lg),
                      // Yes Delete Button
                      Expanded(
                        child: AusaButton(
                          text: 'Yes, delete',
                          onPressed: () async {
                            Navigator.of(context).pop();
                            await controller.deleteSelectedReadings();
                          },
                          variant: ButtonVariant.primary,
                          backgroundColor: Colors.orange,
                          textColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _formatDateFromKey(String dateKey) {
    final parts = dateKey.split('-');
    final year = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final day = int.parse(parts[2]);

    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[month - 1]} $day, $year';
  }

  List<AppTabButton> _buildTabButtons(MediaTestHistoryController controller) {
    return controller.tabs.asMap().entries.map((entry) {
      final index = entry.key;
      final tab = entry.value;
      final title = tab['title'] as String;

      return AppTabButton(
        text: title,
        isSelected: controller.currentTabIndex.value == index,
        onTap: () => controller.switchTab(index),
      );
    }).toList();
  }
}
