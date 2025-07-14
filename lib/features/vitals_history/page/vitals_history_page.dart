import 'package:ausa/common/widget/app_back_header.dart';
import 'package:ausa/common/widget/app_main_container.dart';
import 'package:ausa/common/widget/app_tab_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../../constants/constants.dart';
import '../controller/vitals_history_controller.dart';
import '../widget/vitals_chart_widget.dart';
import '../widget/reading_card_widget.dart';
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

  // Generic parameter selection storage
  final RxMap<String, String> selectedParameters = <String, String>{}.obs;

  // Scrollbar state
  final RxDouble scrollPosition = 0.0.obs;
  final RxInt totalItems = 0.obs;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    controller = Get.find<VitalsHistoryController>();
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

    // Update scrollbar position
    if (!_isDragging) {
      final progress =
          topMost.index / (totalItems.value - 1).clamp(1, double.infinity);
      scrollPosition.value = progress.clamp(0.0, 1.0);
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
      backgroundColor: AppColors.gray50,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            AppBackHeader(
              title: 'Vitals',
            ),

            // Tab buttons
            Obx(
              () => Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl6,
                  vertical: AppSpacing.lg,
                ),
                child: Row(children: _buildTabButtons(controller)),
              ),
            ),

            // Main content
            AppMainContainer(
              padding: EdgeInsets.all(AppSpacing.md),
              opacity: 1,
              child: Row(
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
                                  controller.chartSelectedParameter.isNotEmpty
                                      ? controller.chartSelectedParameter
                                      : null,
                              onParameterTap: (chartParam) {
                                // Only relevant for Blood Pressure where multiple parameters exist
                                if (controller.currentVitalType ==
                                    VitalType.bloodPressure) {
                                  // Map chart-level parameter back to the underlying reading parameter
                                  switch (chartParam) {
                                    case 'BP':
                                      controller.selectedBPParameter.value =
                                          'Systolic';
                                      break;
                                    case 'MAP':
                                      controller.selectedBPParameter.value =
                                          'MAP';
                                      break;
                                    case 'PP':
                                      controller.selectedBPParameter.value =
                                          'Pulse Pressure';
                                      break;
                                    default:
                                      break;
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(width: AppSpacing.lg),

                  // Right side - Readings
                  Expanded(flex: 1, child: _buildReadingsSection(controller)),
                ],
              ),
            ),
          ],
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
                child: Stack(
                  children: [
                    // Main scrollable content
                    Positioned.fill(
                      right: 12, // Leave space for scrollbar
                      child: _buildGroupedReadingsList(readings, controller),
                    ),
                    // Custom scrollbar
                    _buildCustomScrollbar(readings),
                  ],
                ),
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

    final itemCount = _calculateTotalItems(groupedReadings, sortedDateKeys);
    totalItems.value = itemCount;

    return ScrollablePositionedList.builder(
      itemCount: itemCount,
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

  Widget _buildCustomScrollbar(List<VitalReading> readings) {
    if (readings.isEmpty) return const SizedBox();

    return Positioned(
      right: 0,
      top: 20,
      bottom: 20,
      child: Container(
        width: 6,
        child: Obx(() {
          final progress = scrollPosition.value;

          return GestureDetector(
            onPanStart: (details) {
              _isDragging = true;
            },
            onPanUpdate: (details) {
              final RenderBox renderBox =
                  context.findRenderObject() as RenderBox;
              final localPosition = renderBox.globalToLocal(
                details.globalPosition,
              );
              final containerHeight = renderBox.size.height;
              final newProgress = (localPosition.dy / containerHeight).clamp(
                0.0,
                1.0,
              );

              scrollPosition.value = newProgress;

              // Calculate target item index
              final targetIndex =
                  (newProgress * (totalItems.value - 1)).round();

              // Scroll to the target position
              _itemScrollController.scrollTo(
                index: targetIndex,
                duration: const Duration(milliseconds: 100),
              );
            },
            onPanEnd: (details) {
              _isDragging = false;
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primary50,
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                heightFactor: 0.3, // Thumb size relative to track
                alignment:
                    Alignment.lerp(
                      Alignment.topCenter,
                      Alignment.bottomCenter,
                      progress,
                    )!,
                child: Container(
                  width: 8,
                  decoration: BoxDecoration(
                    color: AppColors.primary800,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  int _calculateTotalItems(
    Map<String, List<VitalReading>> groupedReadings,
    List<String> sortedDateKeys,
  ) {
    int totalItems = 0;
    for (int i = 0; i < sortedDateKeys.length; i++) {
      final dateKey = sortedDateKeys[i];
      totalItems += 1; // Date header
      totalItems += groupedReadings[dateKey]!.length; // Readings for that date
      // Add separator after each group except the last one
      if (i < sortedDateKeys.length - 1) {
        totalItems += 1; // Separator
      }
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

    for (int dateIndex = 0; dateIndex < sortedDateKeys.length; dateIndex++) {
      final dateKey = sortedDateKeys[dateIndex];
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
            onParameterTap: (parameter) => _selectParameter(reading, parameter),
            isParameterSelected:
                (parameter) => _isParameterSelected(reading, parameter),
          );
        }
        currentIndex++;
      }

      // Check if this index is the separator (only for groups that are not the last)
      if (dateIndex < sortedDateKeys.length - 1) {
        if (currentIndex == index) {
          return _buildDottedSeparator();
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
      margin: EdgeInsets.only(bottom: AppSpacing.md, top: AppSpacing.xl2),
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
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary50,
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

  Widget _buildDottedSeparator() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              child: CustomPaint(
                painter: DottedLinePainter(
                  color: AppColors.gray300,
                  strokeWidth: 1,
                  dashLength: 4,
                  dashSpacing: 4,
                ),
              ),
            ),
          ),
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

  // Generic method to check if a parameter is selected for any vital type
  bool _isParameterSelected(VitalReading reading, String parameter) {
    if (!controller.isReadingSelected(reading)) {
      return false;
    }

    final readingKey = '${reading.id}_${reading.type.toString()}';
    final selectedParam = selectedParameters[readingKey];

    switch (reading.type) {
      case VitalType.bloodPressure:
        // Handle Blood Pressure grouping logic
        if ((parameter == 'Systolic' || parameter == 'Diastolic') &&
            (selectedParam == 'Systolic' || selectedParam == 'Diastolic')) {
          return true;
        }
        return selectedParam == parameter;

      case VitalType.spO2HeartRate:
        // Handle only SpO2 parameter
        return selectedParam == parameter;

      case VitalType.bloodGlucose:
        return selectedParam == parameter;

      case VitalType.bodyTemperature:
        return selectedParam == parameter;

      case VitalType.ecg:
        // Handle ECG grouping
        if ((parameter == 'ECG Heart Rate' || parameter == 'Rhythm') &&
            (selectedParam == 'ECG Heart Rate' || selectedParam == 'Rhythm')) {
          return true;
        }
        return selectedParam == parameter;
    }
  }

  // Generic method to handle parameter selection for all vital types
  void _selectParameter(VitalReading reading, String parameter) {
    controller.selectReading(reading);
    final readingKey = '${reading.id}_${reading.type.toString()}';
    selectedParameters[readingKey] = parameter;

    // Special handling for Blood Pressure to maintain chart compatibility
    if (reading.type == VitalType.bloodPressure) {
      controller.selectedBPParameter.value = parameter;
    }
  }

  // Clear parameter selection when switching tabs or readings
  void _clearParameterSelection() {
    selectedParameters.clear();
    controller.selectedBPParameter.value = '';
  }

  List<AppTabButton> _buildTabButtons(VitalsHistoryController controller) {
    return controller.tabs.asMap().entries.map((entry) {
      final index = entry.key;
      final tab = entry.value;
      final title = tab['title'] as String;

      return AppTabButton(
        text: title,
        isSelected: controller.currentTabIndex.value == index,
        onTap: () {
          controller.switchTab(index);
          _clearParameterSelection();
        },
      );
    }).toList();
  }
}

class DottedLinePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double dashSpacing;

  DottedLinePainter({
    required this.color,
    required this.strokeWidth,
    required this.dashLength,
    required this.dashSpacing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke;

    double startX = 0;
    final y = size.height / 2;

    while (startX < size.width) {
      final endX = (startX + dashLength).clamp(0.0, size.width);
      canvas.drawLine(Offset(startX, y), Offset(endX, y), paint);
      startX += dashLength + dashSpacing;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
