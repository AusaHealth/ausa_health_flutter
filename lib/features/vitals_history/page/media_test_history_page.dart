import 'package:ausa/common/widget/base_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../constants/constants.dart';
import '../../../constants/icons.dart';
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
    return BaseScaffold(
      backgroundColor: AppColors.gray50,
      body: SafeArea(
        child: Column(
          children: [
            AppBackHeader(title: 'Media', onBackPressed: () => Get.back()),
            Obx(
              () => Padding(
                padding: EdgeInsets.only(
                  left: AppSpacing.xl6,
                  right: AppSpacing.xl6,
                  bottom: AppSpacing.xl,
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
                  child: Text(
                    'Select',
                    style: AppTypography.body(color: AppColors.primary700),
                  ),
                );
              }

              // In selection mode : show Cancel and Delete buttons
              final bool hasSelection =
                  controller.selectedReadingIds.isNotEmpty;

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Cancel Button
               
                  // Delete Button
                  AusaButton(
                    text: 'Delete',
                    size: ButtonSize.md,
                    onPressed:
                        hasSelection ? _showDeleteConfirmationDialog : null,
                    variant: ButtonVariant.primary,
                    backgroundColor:
                        hasSelection
                            ? Colors.orange
                            : Colors.orange.withOpacity(0.4),
                    textColor: Colors.white,
                    leadingIcon: SvgPicture.asset(
                      AusaIcons.trash01,
                      width: 20,
                      height: 20,
                      colorFilter: ColorFilter.mode(
                        hasSelection ? Colors.white : Colors.grey[500]!,
                        BlendMode.srcIn,
                      ),
                    ),
                    isEnabled: hasSelection,
                  ),
                  SizedBox(width: AppSpacing.lg),
                     AusaButton(
                    text: 'Cancel',
                    showShadow: true,
                    size: ButtonSize.md,
                    onPressed: () => controller.exitSelectionMode(),
                    variant: ButtonVariant.secondary,
                    borderColor: AppColors.white,
                    textColor: AppColors.primary700,
                    leadingIcon: SvgPicture.asset(
                      AusaIcons.x,
                      width: 20,
                      height: 20,
                      colorFilter: ColorFilter.mode(
                       AppColors.primary700 ,
                        BlendMode.srcIn,
                      ),
                    )
                  ),
                ],
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
              width: 400,
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        padding: EdgeInsets.all(AppSpacing.xl4),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: SvgPicture.asset(
                          AusaIcons.trash01,
                          colorFilter: ColorFilter.mode(
                            AppColors.accent,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      SizedBox(height: AppSpacing.xl3),
                      Text(
                        'Delete Media?',
                        style: AppTypography.headline(
                          color: AppColors.accent,
                          weight: AppTypographyWeight.medium,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.md),
                  Text(
                    'Are you sure you want to delete the selected media?',
                    style: AppTypography.body(color: Colors.black54, weight: AppTypographyWeight.medium),
                  ),
                  SizedBox(height: AppSpacing.xl2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Cancel Button
                      Expanded(
                        child: AusaButton(
                          text: 'Cancel',
                          size: ButtonSize.lg,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          variant: ButtonVariant.secondary,
                          borderColor: AppColors.primary700,
                          textColor: AppColors.primary700,
                        ),
                      ),
                      SizedBox(width: AppSpacing.lg),
                      // Yes Delete Button
                      Expanded(
                        child: AusaButton(
                          text: 'Yes',
                             size: ButtonSize.lg,
                          onPressed: () async {
                            Navigator.of(context).pop();
                            await controller.deleteSelectedReadings();
                          },
                          variant: ButtonVariant.primary,
                          backgroundColor: AppColors.primary700,
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
