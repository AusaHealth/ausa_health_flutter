import 'package:get/get.dart';
import '../model/vital_reading.dart';
import '../model/blood_pressure_reading.dart';
import '../model/spo2_heart_rate_reading.dart';
import '../model/blood_glucose_reading.dart';
import '../model/body_temperature_reading.dart';
import '../model/ecg_reading.dart';

class VitalsHistoryController extends GetxController {
  // Current selected tab
  final RxInt currentTabIndex = 0.obs;

  // Loading state
  final RxBool isLoading = false.obs;

  // Selected reading for chart display
  final Rx<VitalReading?> selectedReading = Rx<VitalReading?>(null);

  // Selected parameter for blood pressure readings
  final RxString selectedBPParameter = ''.obs;

  // Vitals data storage
  final RxList<BloodPressureReading> bloodPressureReadings =
      <BloodPressureReading>[].obs;
  final RxList<SpO2HeartRateReading> spO2HeartRateReadings =
      <SpO2HeartRateReading>[].obs;
  final RxList<BloodGlucoseReading> bloodGlucoseReadings =
      <BloodGlucoseReading>[].obs;
  final RxList<BodyTemperatureReading> bodyTemperatureReadings =
      <BodyTemperatureReading>[].obs;
  final RxList<ECGReading> ecgReadings = <ECGReading>[].obs;

  // Tab configuration
  final List<Map<String, dynamic>> tabs = [
    {'title': 'Blood Pressure', 'type': VitalType.bloodPressure},
    {'title': 'Blood Oxygen', 'type': VitalType.spO2HeartRate},
    {'title': 'Blood Glucose', 'type': VitalType.bloodGlucose},
    {'title': 'Body Temperature', 'type': VitalType.bodyTemperature},
    {'title': 'ECG', 'type': VitalType.ecg},
  ];

  @override
  void onInit() {
    super.onInit();
    _initializeDummyData();
    // Pre-select the latest reading
    final latest = latestReading;
    if (latest != null) {
      if (latest.type == VitalType.bloodPressure) {
        selectReading(latest, parameter: 'Systolic');
      } else {
        selectReading(latest);
      }
    }
  }

  // Switch between tabs
  void switchTab(int index) {
    currentTabIndex.value = index;
    clearSelection(); // Clear selection when switching tabs
  }

  // Get current vital type
  VitalType get currentVitalType => tabs[currentTabIndex.value]['type'];

  // Get current readings based on selected tab
  List<VitalReading> get currentReadings {
    switch (currentVitalType) {
      case VitalType.bloodPressure:
        return bloodPressureReadings;
      case VitalType.spO2HeartRate:
        return spO2HeartRateReadings;
      case VitalType.bloodGlucose:
        return bloodGlucoseReadings;
      case VitalType.bodyTemperature:
        return bodyTemperatureReadings;
      case VitalType.ecg:
        return ecgReadings;
    }
  }

  // Get readings for chart based on selected reading
  List<VitalReading> get chartReadings {
    final allReadings = currentReadings;
    if (allReadings.isEmpty) return [];

    // If no reading is selected, use the latest 5 readings
    if (selectedReading.value == null) {
      return allReadings.take(5).toList();
    }

    // Find the index of selected reading
    final selectedIndex = allReadings.indexOf(selectedReading.value!);
    if (selectedIndex == -1) {
      return allReadings.take(5).toList();
    }

    // Get 5 readings starting from selected reading (selected + 4 previous)
    final endIndex = selectedIndex + 5;
    final readings = allReadings.sublist(
      selectedIndex,
      endIndex > allReadings.length ? allReadings.length : endIndex,
    );

    return readings;
  }

  // Check if current readings are empty
  bool get hasNoReadings => currentReadings.isEmpty;

  // Get latest reading for current vital type
  VitalReading? get latestReading {
    final readings = currentReadings;
    if (readings.isEmpty) return null;
    return readings.first;
  }

  // Select a reading for chart display
  void selectReading(VitalReading reading, {String? parameter}) {
    selectedReading.value = reading;

    // For blood pressure, also set the selected parameter
    if (reading.type == VitalType.bloodPressure && parameter != null) {
      selectedBPParameter.value = parameter;
    } else {
      selectedBPParameter.value = '';
    }
  }

  // Check if a reading is selected
  bool isReadingSelected(VitalReading reading) {
    return selectedReading.value?.id == reading.id;
  }

  // Check if a specific parameter is selected for blood pressure
  bool isBPParameterSelected(VitalReading reading, String parameter) {
    if (!isReadingSelected(reading) ||
        reading.type != VitalType.bloodPressure) {
      return false;
    }

    // Systolic and Diastolic are grouped together
    if ((parameter == 'Systolic' || parameter == 'Diastolic') &&
        (selectedBPParameter.value == 'Systolic' ||
            selectedBPParameter.value == 'Diastolic')) {
      return true;
    }

    return selectedBPParameter.value == parameter;
  }

  // Get the selected parameter for chart display
  String get chartSelectedParameter {
    if (selectedReading.value?.type == VitalType.bloodPressure &&
        selectedBPParameter.value.isNotEmpty) {
      // Map individual parameters to chart parameters
      switch (selectedBPParameter.value) {
        case 'Systolic':
        case 'Diastolic':
          return 'BP';
        case 'MAP':
          return 'MAP';
        case 'Pulse Pressure':
          return 'PP';
        default:
          return 'BP';
      }
    }
    return '';
  }

  // Clear selection (revert to latest readings)
  void clearSelection() {
    selectedReading.value = null;
    selectedBPParameter.value = '';
  }

  // Initialize dummy data
  void _initializeDummyData() {
    _generateDummyBloodPressureData();
    _generateDummySpO2HeartRateData();
    _generateDummyBloodGlucoseData();
    _generateDummyBodyTemperatureData();
    _generateDummyECGData();
  }

  void _generateDummyBloodPressureData() {
    final now = DateTime.now();
    bloodPressureReadings.value = [
      BloodPressureReading(
        id: '1',
        timestamp: now,
        status: VitalStatus.normal,
        systolic: 128,
        diastolic: 80,
        map: 96,
        pulsePressure: 48,
      ),
      BloodPressureReading(
        id: '10',
        timestamp: now,
        status: VitalStatus.normal,
        systolic: 123,
        diastolic: 83,
        map: 93,
        pulsePressure: 43,
      ),
      BloodPressureReading(
        id: '11',
        timestamp: now,
        status: VitalStatus.normal,
        systolic: 123,
        diastolic: 83,
        map: 93,
        pulsePressure: 43,
      ),
      BloodPressureReading(
        id: '2',
        timestamp: now.subtract(const Duration(days: 1)),
        status: VitalStatus.high,
        systolic: 145,
        diastolic: 92,
        map: 110,
        pulsePressure: 53,
      ),
      BloodPressureReading(
        id: '12',
        timestamp: now.subtract(const Duration(days: 1)),
        status: VitalStatus.high,
        systolic: 145,
        diastolic: 92,
        map: 110,
        pulsePressure: 53,
      ),
      BloodPressureReading(
        id: '13',
        timestamp: now.subtract(const Duration(days: 1)),
        status: VitalStatus.high,
        systolic: 145,
        diastolic: 92,
        map: 110,
        pulsePressure: 53,
      ),
      BloodPressureReading(
        id: '3',
        timestamp: now.subtract(const Duration(days: 2)),
        status: VitalStatus.normal,
        systolic: 120,
        diastolic: 75,
        map: 90,
        pulsePressure: 45,
      ),
      BloodPressureReading(
        id: '4',
        timestamp: now.subtract(const Duration(days: 3)),
        status: VitalStatus.normal,
        systolic: 115,
        diastolic: 78,
        map: 90,
        pulsePressure: 37,
      ),
      BloodPressureReading(
        id: '5',
        timestamp: now.subtract(const Duration(days: 4)),
        status: VitalStatus.normal,
        systolic: 122,
        diastolic: 82,
        map: 95,
        pulsePressure: 40,
      ),
      BloodPressureReading(
        id: '6',
        timestamp: now.subtract(const Duration(days: 5)),
        status: VitalStatus.high,
        systolic: 155,
        diastolic: 98,
        map: 117,
        pulsePressure: 57,
      ),
      BloodPressureReading(
        id: '7',
        timestamp: now.subtract(const Duration(days: 6)),
        status: VitalStatus.normal,
        systolic: 118,
        diastolic: 76,
        map: 90,
        pulsePressure: 42,
      ),
      BloodPressureReading(
        id: '8',
        timestamp: now.subtract(const Duration(days: 7)),
        status: VitalStatus.low,
        systolic: 95,
        diastolic: 62,
        map: 73,
        pulsePressure: 33,
      ),
      BloodPressureReading(
        id: '9',
        timestamp: now.subtract(const Duration(days: 8)),
        status: VitalStatus.normal,
        systolic: 125,
        diastolic: 85,
        map: 98,
        pulsePressure: 40,
      ),
    ];
  }

  void _generateDummySpO2HeartRateData() {
    final now = DateTime.now();
    spO2HeartRateReadings.value = [
      SpO2HeartRateReading(
        id: '1',
        timestamp: now,
        status: VitalStatus.normal,
        oxygenSaturation: 98.5,
        heartRate: 75,
      ),
      SpO2HeartRateReading(
        id: '2',
        timestamp: now.subtract(const Duration(days: 1)),
        status: VitalStatus.normal,
        oxygenSaturation: 97.8,
        heartRate: 82,
      ),
      SpO2HeartRateReading(
        id: '3',
        timestamp: now.subtract(const Duration(days: 2)),
        status: VitalStatus.low,
        oxygenSaturation: 94.2,
        heartRate: 78,
      ),
      SpO2HeartRateReading(
        id: '4',
        timestamp: now.subtract(const Duration(days: 3)),
        status: VitalStatus.normal,
        oxygenSaturation: 96.7,
        heartRate: 68,
      ),
      SpO2HeartRateReading(
        id: '5',
        timestamp: now.subtract(const Duration(days: 4)),
        status: VitalStatus.normal,
        oxygenSaturation: 99.1,
        heartRate: 72,
      ),
      SpO2HeartRateReading(
        id: '6',
        timestamp: now.subtract(const Duration(days: 5)),
        status: VitalStatus.high,
        oxygenSaturation: 98.9,
        heartRate: 105,
      ),
      SpO2HeartRateReading(
        id: '7',
        timestamp: now.subtract(const Duration(days: 6)),
        status: VitalStatus.normal,
        oxygenSaturation: 97.5,
        heartRate: 79,
      ),
      SpO2HeartRateReading(
        id: '8',
        timestamp: now.subtract(const Duration(days: 7)),
        status: VitalStatus.critical,
        oxygenSaturation: 88.3,
        heartRate: 92,
      ),
    ];
  }

  void _generateDummyBloodGlucoseData() {
    final now = DateTime.now();
    bloodGlucoseReadings.value = [
      BloodGlucoseReading(
        id: '1',
        timestamp: now,
        status: VitalStatus.normal,
        glucoseLevel: 95.0,
        measurementType: GlucoseMeasurementType.fasting,
      ),
      BloodGlucoseReading(
        id: '2',
        timestamp: now.subtract(const Duration(days: 1)),
        status: VitalStatus.high,
        glucoseLevel: 140.0,
        measurementType: GlucoseMeasurementType.postMeal,
      ),
      BloodGlucoseReading(
        id: '3',
        timestamp: now.subtract(const Duration(days: 2)),
        status: VitalStatus.normal,
        glucoseLevel: 88.5,
        measurementType: GlucoseMeasurementType.fasting,
      ),
      BloodGlucoseReading(
        id: '4',
        timestamp: now.subtract(const Duration(days: 3)),
        status: VitalStatus.normal,
        glucoseLevel: 122.0,
        measurementType: GlucoseMeasurementType.postMeal,
      ),
      BloodGlucoseReading(
        id: '5',
        timestamp: now.subtract(const Duration(days: 4)),
        status: VitalStatus.low,
        glucoseLevel: 68.0,
        measurementType: GlucoseMeasurementType.fasting,
      ),
      BloodGlucoseReading(
        id: '6',
        timestamp: now.subtract(const Duration(days: 5)),
        status: VitalStatus.normal,
        glucoseLevel: 103.0,
        measurementType: GlucoseMeasurementType.random,
      ),
      BloodGlucoseReading(
        id: '7',
        timestamp: now.subtract(const Duration(days: 6)),
        status: VitalStatus.high,
        glucoseLevel: 185.0,
        measurementType: GlucoseMeasurementType.postMeal,
      ),
      BloodGlucoseReading(
        id: '8',
        timestamp: now.subtract(const Duration(days: 7)),
        status: VitalStatus.normal,
        glucoseLevel: 92.0,
        measurementType: GlucoseMeasurementType.fasting,
      ),
    ];
  }

  void _generateDummyBodyTemperatureData() {
    final now = DateTime.now();
    bodyTemperatureReadings.value = [
      BodyTemperatureReading(
        id: '1',
        timestamp: now,
        status: VitalStatus.normal,
        temperature: 36.8,
        measurementLocation: TemperatureMeasurementLocation.oral,
      ),
      BodyTemperatureReading(
        id: '2',
        timestamp: now.subtract(const Duration(days: 1)),
        status: VitalStatus.high,
        temperature: 38.2,
        measurementLocation: TemperatureMeasurementLocation.oral,
      ),
      BodyTemperatureReading(
        id: '3',
        timestamp: now.subtract(const Duration(days: 2)),
        status: VitalStatus.normal,
        temperature: 37.1,
        measurementLocation: TemperatureMeasurementLocation.temporal,
      ),
      BodyTemperatureReading(
        id: '4',
        timestamp: now.subtract(const Duration(days: 3)),
        status: VitalStatus.normal,
        temperature: 36.5,
        measurementLocation: TemperatureMeasurementLocation.oral,
      ),
      BodyTemperatureReading(
        id: '5',
        timestamp: now.subtract(const Duration(days: 4)),
        status: VitalStatus.high,
        temperature: 39.1,
        measurementLocation: TemperatureMeasurementLocation.tympanic,
      ),
      BodyTemperatureReading(
        id: '6',
        timestamp: now.subtract(const Duration(days: 5)),
        status: VitalStatus.normal,
        temperature: 36.9,
        measurementLocation: TemperatureMeasurementLocation.oral,
      ),
      BodyTemperatureReading(
        id: '7',
        timestamp: now.subtract(const Duration(days: 6)),
        status: VitalStatus.low,
        temperature: 35.8,
        measurementLocation: TemperatureMeasurementLocation.axillary,
      ),
      BodyTemperatureReading(
        id: '8',
        timestamp: now.subtract(const Duration(days: 7)),
        status: VitalStatus.normal,
        temperature: 37.0,
        measurementLocation: TemperatureMeasurementLocation.temporal,
      ),
    ];
  }

  void _generateDummyECGData() {
    final now = DateTime.now();
    ecgReadings.value = [
      ECGReading(
        id: '1',
        timestamp: now,
        status: VitalStatus.normal,
        heartRate: 72,
        rhythm: ECGRhythm.normal,
        duration: 30,
      ),
      ECGReading(
        id: '2',
        timestamp: now.subtract(const Duration(days: 1)),
        status: VitalStatus.critical,
        heartRate: 45,
        rhythm: ECGRhythm.bradycardia,
        duration: 30,
      ),
      ECGReading(
        id: '3',
        timestamp: now.subtract(const Duration(days: 2)),
        status: VitalStatus.normal,
        heartRate: 78,
        rhythm: ECGRhythm.normal,
        duration: 60,
      ),
      ECGReading(
        id: '4',
        timestamp: now.subtract(const Duration(days: 3)),
        status: VitalStatus.high,
        heartRate: 125,
        rhythm: ECGRhythm.tachycardia,
        duration: 45,
      ),
      ECGReading(
        id: '5',
        timestamp: now.subtract(const Duration(days: 4)),
        status: VitalStatus.critical,
        heartRate: 88,
        rhythm: ECGRhythm.atrialFibrillation,
        duration: 30,
      ),
      ECGReading(
        id: '6',
        timestamp: now.subtract(const Duration(days: 5)),
        status: VitalStatus.normal,
        heartRate: 69,
        rhythm: ECGRhythm.normal,
        duration: 30,
      ),
      ECGReading(
        id: '7',
        timestamp: now.subtract(const Duration(days: 6)),
        status: VitalStatus.high,
        heartRate: 95,
        rhythm: ECGRhythm.prematureVentricularContractions,
        duration: 30,
      ),
      ECGReading(
        id: '8',
        timestamp: now.subtract(const Duration(days: 7)),
        status: VitalStatus.normal,
        heartRate: 75,
        rhythm: ECGRhythm.normal,
        duration: 60,
      ),
    ];
  }

  // API methods (ready for backend integration)
  Future<void> fetchVitals() async {
    try {
      isLoading.value = true;
      // TODO: Implement API call
      // final response = await VitalsService.fetchVitals();
      // Process response and update readings
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
    } catch (e) {
      // Handle error
      // TODO: Add proper error handling
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addVitalReading(VitalReading reading) async {
    try {
      isLoading.value = true;
      // TODO: Implement API call
      // final response = await VitalsService.addReading(reading);

      // Add to appropriate list based on type
      switch (reading.type) {
        case VitalType.bloodPressure:
          bloodPressureReadings.insert(0, reading as BloodPressureReading);
          break;
        case VitalType.spO2HeartRate:
          spO2HeartRateReadings.insert(0, reading as SpO2HeartRateReading);
          break;
        case VitalType.bloodGlucose:
          bloodGlucoseReadings.insert(0, reading as BloodGlucoseReading);
          break;
        case VitalType.bodyTemperature:
          bodyTemperatureReadings.insert(0, reading as BodyTemperatureReading);
          break;
        case VitalType.ecg:
          ecgReadings.insert(0, reading as ECGReading);
          break;
      }

      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Simulate API call
    } catch (e) {
      // Handle error
      // TODO: Add proper error handling
    } finally {
      isLoading.value = false;
    }
  }

  // Navigate to take first test
  void navigateToTakeFirstTest() {
    // TODO: Implement navigation to measurement screen
    // Get.to(() => VitalMeasurementPage(vitalType: currentVitalType));
  }

  // Update selected reading based on scroll position without altering the selected parameter
  void updateReadingFromScroll(VitalReading reading) {
    selectedReading.value = reading;
  }
}
