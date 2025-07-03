import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../../constants/constants.dart';
import '../controller/vitals_history_controller.dart';
import '../widget/vitals_chart_widget.dart';
import '../widget/reading_card_widget.dart';
import '../widget/empty_state_widget.dart';
import '../model/vital_reading.dart';

class VitalsHistoryPage extends StatefulWidget {
  const VitalsHistoryPage({super.key});

  @override
  _VitalsHistoryPageState createState() => _VitalsHistoryPageState();
}

class _VitalsHistoryPageState extends State<VitalsHistoryPage> {
  late final VitalsHistoryController controller;
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  @override
  void initState() {
    super.initState();
    controller = Get.put(VitalsHistoryController());
    _itemPositionsListener.itemPositions.addListener(_handleScroll);
  }

  void _handleScroll() {
    final positions = _itemPositionsListener.itemPositions.value;
    if (positions.isEmpty) return;

    // Find the top-most visible item (partially or fully visible)
    final topMost = positions
        .where((pos) => pos.itemTrailingEdge > 0)
        .reduce((a, b) => a.index < b.index ? a : b);

    final reading = _getReadingAtIndex(topMost.index);
    if (reading != null) {
      controller.updateReadingFromScroll(reading);
    }
  }

  VitalReading? _getReadingAtIndex(int targetIndex) {
    final readings = controller.currentReadings;
    String prevDateKey = '';
    int currentIndex = 0;

    for (final reading in readings) {
      final dateKey = _getDateKey(reading.timestamp);

      // Date header counts as an item
      if (dateKey != prevDateKey) {
        if (currentIndex == targetIndex) {
          return null; // It is a header, not a reading
        }
        currentIndex++;
        prevDateKey = dateKey;
      }

      // Reading item
      if (currentIndex == targetIndex) {
        return reading;
      }
      currentIndex++;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    // Ensure the UI reflects the selected reading when the page is loaded

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Header
              _buildHeader(controller),
              SizedBox(height: AppSpacing.md),

              // Tab buttons
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl5),
                child: _buildTabButtons(controller),
              ),

              SizedBox(height: AppSpacing.md),

              // Main content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: Container(
                    padding: EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.xl2),
                      color: Colors.white.withOpacity(0.5),
                    ),
                    child: Obx(() {
                      if (controller.hasNoReadings) {
                        return EmptyStateWidget(
                          onTakeFirstTest: controller.navigateToTakeFirstTest,
                        );
                      }

                      return Row(
                        children: [
                          // Left side - Chart
                          Expanded(
                            flex: 1,
                            child: Obx(
                              () => Column(
                                children: [
                                  // Chart
                                  Expanded(
                                    child: VitalsChartWidget(
                                      readings: controller.chartReadings,
                                      vitalType: controller.currentVitalType,
                                      selectedParameter:
                                          controller
                                                  .chartSelectedParameter
                                                  .isNotEmpty
                                              ? controller
                                                  .chartSelectedParameter
                                              : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(width: AppSpacing.lg),

                          // Right side - Readings
                          Expanded(
                            flex: 1,
                            child: _buildReadingsSection(controller),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(VitalsHistoryController controller) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black87,
                size: 16,
              ),
            ),
          ),

          SizedBox(width: AppSpacing.md),

          // Title
          Text('Vitals', style: AppTypography.headline(color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildTabButtons(VitalsHistoryController controller) {
    return Obx(
      () => Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children:
              controller.tabs.asMap().entries.map((entry) {
                final index = entry.key;
                final tab = entry.value;
                final isSelected = controller.currentTabIndex.value == index;

                return GestureDetector(
                  onTap: () => controller.switchTab(index),
                  child: Container(
                    margin: EdgeInsets.only(right: AppSpacing.md),
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl,
                      vertical: AppSpacing.lg,
                    ),
                    decoration: BoxDecoration(
                      gradient:
                          isSelected
                              ? const LinearGradient(
                                colors: [
                                  AppColors.primaryDarkColor,
                                  AppColors.primaryLightColor,
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              )
                              : const LinearGradient(
                                colors: [Colors.white, Colors.white],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                      borderRadius: BorderRadius.circular(60),
                      boxShadow:
                          isSelected
                              ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ]
                              : [],
                    ),
                    child: Text(
                      tab['title'],
                      style: AppTypography.callout(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget _buildReadingsSection(VitalsHistoryController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl2),
      ),
      child: Column(
        children: [
          // Readings list
          Expanded(
            child: Obx(() {
              final readings = controller.currentReadings;
              if (readings.isEmpty) {
                return const SizedBox();
              }

              return Container(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: _buildGroupedReadingsList(readings, controller),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupedReadingsList(
    List<VitalReading> readings,
    VitalsHistoryController controller,
  ) {
    // Group readings by date
    final Map<String, List<VitalReading>> groupedReadings = {};

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

    return ScrollablePositionedList.builder(
      itemCount: _calculateTotalItems(groupedReadings, sortedDateKeys),
      itemBuilder: (context, index) {
        return _buildItemAtIndex(
          groupedReadings,
          sortedDateKeys,
          index,
          controller,
        );
      },
      itemScrollController: _itemScrollController,
      itemPositionsListener: _itemPositionsListener,
    );
  }

  int _calculateTotalItems(
    Map<String, List<VitalReading>> groupedReadings,
    List<String> sortedDateKeys,
  ) {
    int totalItems = 0;
    for (final dateKey in sortedDateKeys) {
      totalItems += 1; // Date header
      totalItems += groupedReadings[dateKey]!.length; // Readings for that date
    }
    return totalItems;
  }

  Widget _buildItemAtIndex(
    Map<String, List<VitalReading>> groupedReadings,
    List<String> sortedDateKeys,
    int index,
    VitalsHistoryController controller,
  ) {
    int currentIndex = 0;

    for (final dateKey in sortedDateKeys) {
      final readingsForDate = groupedReadings[dateKey]!;

      // Check if this index is the date header
      if (currentIndex == index) {
        return _buildDateHeader(dateKey);
      }
      currentIndex++;

      // Check if this index is one of the readings for this date
      for (int i = 0; i < readingsForDate.length; i++) {
        if (currentIndex == index) {
          final reading = readingsForDate[i];
          final isToday = _isToday(reading.timestamp);
          final isSelected = controller.isReadingSelected(reading);
          return ReadingCardWidget(
            reading: reading,
            isToday: isToday,
            isSelected: isSelected,
            showDateHeader: false,
            onTap: () => controller.selectReading(reading),
            onParameterTap:
                (parameter) =>
                    controller.selectReading(reading, parameter: parameter),
            isParameterSelected:
                (parameter) =>
                    controller.isBPParameterSelected(reading, parameter),
          );
        }
        currentIndex++;
      }
    }

    return const SizedBox(); // Fallback
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
            style: AppTypography.callout(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (isToday) ...[
            SizedBox(width: AppSpacing.md),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppRadius.xl3),
              ),
              child: Text(
                'Today',
                style: AppTypography.callout(color: AppColors.primaryColor),
              ),
            ),
          ],
        ],
      ),
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

    final date = DateTime(year, month, day);
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

  bool _isToday(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(timestamp.year, timestamp.month, timestamp.day);
    return date == today;
  }

  String _formatDate(DateTime date) {
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
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
