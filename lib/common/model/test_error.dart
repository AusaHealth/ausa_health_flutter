import 'package:ausa/common/enums/test_error_type.dart';

class TestError {
  final String title;
  final String message;
  final String code;
  final TestErrorType type;


  TestError({required this.type, required this.title, required this.message, required this.code});
}

