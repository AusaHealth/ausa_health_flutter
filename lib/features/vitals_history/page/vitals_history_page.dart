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
        child: Column(
          children: [
            // Header
            const AppBackHeader(title: 'Vitals'),

            // Tab buttons
            Obx(
              () => AppTabButtons(
                tabs: _getTabData(controller),
                selectedIndex: controller.currentTabIndex.value,
                onTabSelected: (index) {
                  controller.switchTab(index);
                  _clearParameterSelection();
                },
              ),
            ),

            // Main content
              AppMainContainer(
              child:
              Container(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.xl2),
                      ),
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
                                          controller
                                                  .chartSelectedParameter
                                                  .isNotEmpty
                                              ? controller
                                                  .chartSelectedParameter
                                              : null,
                                      onParameterTap: (chartParam) {
                                        // Only relevant for Blood Pressure where multiple parameters exist
                                        if (controller.currentVitalType ==
                                            VitalType.bloodPressure) {
                                          // Map chart-level parameter back to the underlying reading parameter
                                          switch (chartParam) {
                                            case 'BP':
                                              controller
                                                  .selectedBPParameter
                                                  .value = 'Systolic';
                                              break;
                                            case 'MAP':
                                              controller
                                                  .selectedBPParameter
                                                  .value = 'MAP';
                                              break;
                                            case 'PP':
                                              controller
                                                  .selectedBPParameter
                                                  .value = 'Pulse Pressure';
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
                          Expanded(
                            flex: 1,
                            child: _buildReadingsSection(controller),
                          ),
                        ],
                ),
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
            onParameterTap: (parameter) => _selectParameter(reading, parameter),
            isParameterSelected:
                (parameter) => _isParameterSelected(reading, parameter),
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

  List<AppTabData> _getTabData(VitalsHistoryController controller) {
    final Map<String, IconData> tabIcons = {
      'Blood Pressure': Icons.favorite,
      'SpO2 & Heart Rate': Icons.monitor_heart,
      'Blood Glucose': Icons.bloodtype,
      'Temperature': Icons.thermostat,
      'ECG': Icons.timeline,
    };

    return controller.tabs.map((tab) {
      final title = tab['title'] as String;
      final icon = tabIcons[title] ?? Icons.medical_information;
      return AppTabData(text: title, icon: icon);
    }).toList();
  }
}
