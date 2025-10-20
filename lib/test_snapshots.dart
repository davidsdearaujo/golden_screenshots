// ignore_for_file: unnecessary_library_name

@Deprecated('DO NOT PUSH TESTS TO CODEBASE USING THIS LIBRARY')

/// This library automatically generates screenshots of widget tests.
/// <br/>
/// It uses the golden tests structure from Flutter to generate the screenshots.
///
/// ### How to use
/// Simply replace the import `pagkage:flutter_test/flutter_test.dart` with
/// this library in the test file that you want to generate screenshots for.
///
/// ### When it will take screenshots
/// - pumpWidget
/// - pumpAndSettle
/// - pump
/// - expect (only when failing)
library test_snapshots;

export 'src/flutter_test.dart';
