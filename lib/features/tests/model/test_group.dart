import 'package:ausa/common/model/test.dart';
import 'package:ausa/constants/app_images.dart';
import 'package:ausa/constants/test_definitions.dart';

/// Logical grouping of tests displayed to the user in the first step of the flow.
class TestGroup {
  final String id; // slug (lowercase, no spaces)
  final String name;
  final String description;
  final String image;
  final List<TestType> testTypes;

  const TestGroup({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.testTypes,
  });
}

/// Helper that builds groups dynamically from static `TestDefinitions`.
class TestGroupFactory {
  static List<TestGroup> getGroups() {
    // Aggregate tests by their `group` field and capture a representative image
    final Map<String, List<TestType>> grouped = {};
    final Map<String, String> groupImages = {};

    for (final test in TestDefinitions.allTests.values) {
      // Previously, variant test types were skipped to avoid duplicate group items. However,
      // our new selection flow relies on every variant being part of its corresponding group so
      // that the user can choose between them in the subtype dialog. Therefore, **do not skip**
      // any variants here. Instead, simply aggregate all tests by their `group` field which will
      // naturally collapse variants under the same group key.

      grouped.putIfAbsent(test.group, () => <TestType>[]).add(test.type);

      // Capture the first image we encounter for each group so that every group can have
      // its own thumbnail in the selection grid.
      groupImages.putIfAbsent(test.group, () => test.image);
    }

    final List<TestGroup> groups = [];
    int index = 0;

    grouped.forEach((groupName, typeList) {
      groups.add(
        TestGroup(
          id: _slug(groupName),
          name: groupName,
          description: '',
          // Use the captured image for the group; fall back to placeholder just in case.
          image: groupImages[groupName] ?? _placeholderImage(index++),
          testTypes: typeList,
        ),
      );
    });

    return groups;
  }

  static String _slug(String text) => text.toLowerCase().replaceAll(' ', '_');

  // Groups for which the user can pick multiple concrete tests (shown with
  // a stepper inside the execution flow).
  static const Set<String> multiSelectGroupNames = {'Body Sounds', 'ENT'};

  /// Returns true if the provided group *name* supports the multi-select
  /// execution flow (stepper, inline Next button, no dialog).
  static bool isMultiSelectGroup(String groupName) =>
      multiSelectGroupNames.contains(groupName);

  // For now choose any placeholder image.
  static String _placeholderImage(int i) => AppImages.bloodPressure;
}
