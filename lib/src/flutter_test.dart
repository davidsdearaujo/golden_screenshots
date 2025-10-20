// ignore_for_file: avoid_init_to_null

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart' as flutter;
import 'package:leak_tracker_testing/leak_tracker_testing.dart';
import 'package:meta/meta.dart';

import 'helpers/helpers.dart';

export 'package:flutter_test/flutter_test.dart' hide expect, group, testWidgets;

var _goldenHelper = GoldenHelper.enabled(
  skipSnapshotsCount: GoldenScreenshotsConfig.skipSnapshotsCount,
  widgetType: GoldenScreenshotsConfig.widgetType,
);
final testsStructure = TestsTree();

void expect(dynamic actual, dynamic matcher, {String? reason, dynamic skip}) {
  try {
    flutter.expect(actual, matcher, reason: reason, skip: skip);
  } catch (e) {
    unawaited(_goldenHelper.generate('expect_failed'));
    rethrow;
  }
}

@isTest
void testWidgets(
  String name,
  Future<void> Function(CustomWidgetTester widgetTester) testFn, {
  bool? skip,
  flutter.Timeout? timeout,
  bool semanticsEnabled = true,
  flutter.TestVariant<Object?> variant = const flutter.DefaultTestVariant(),
  dynamic tags,
  int? retry,
  LeakTesting? experimentalLeakTesting,
}) {
  testsStructure.startTest(name);
  final testPath = testsStructure.getCurrentTestPath();
  flutter.testWidgets(
    retry: retry,
    semanticsEnabled: semanticsEnabled,
    skip: skip,
    tags: tags,
    timeout: timeout,
    variant: variant,
    experimentalLeakTesting: experimentalLeakTesting,
    name,
    (tester) async {
      String goldenPathBuilder() {
        final response = StringBuffer(
          GoldenScreenshotsConfig.screenshotsFolderName,
        );
        if (testPath.isNotEmpty) {
          final clearTestPath = testPath.withClearedName().join('/');
          response.write('/$clearTestPath');
        }
        if (variant is flutter.ValueVariant) {
          final variantIndex = variant.values //
              .toList()
              .indexOf(variant.currentValue);
          response.write('/variant_${variantIndex + 1}');
        }
        return response.toString();
      }

      final customTester = CustomWidgetTester(tester, _goldenHelper);
      await _goldenHelper.setUp(
        customTester,
        screenSize: GoldenScreenshotsConfig.forcedScreenSize,
        goldenPathGetter: goldenPathBuilder,
        initialCounter: 1,
      );
      await testFn(customTester);
    },
  );
  testsStructure.endTest();
}

@isTestGroup
void group(
  Object description,
  void Function() body, {
  dynamic skip,
  int? retry,
}) {
  testsStructure.startGroup(description);
  flutter.group(description, body, skip: skip, retry: retry);
  testsStructure.endGroup();
}

abstract interface class GoldenScreenshotsConfig {
  /// The screen size to use for the golden screenshots.
  static Size? forcedScreenSize = null;

  /// The name of the folder to use for the golden screenshots.
  static String screenshotsFolderName = '_screenshots';

  /// The number of snapshots to skip.
  static int skipSnapshotsCount = 0;

  /// The widget type to use for the golden screenshots.
  static Type widgetType = MaterialApp;

  static set({
    Size? forcedScreenSize,
    String? screenshotsFolderName,
    int? skipSnapshotsCount,
    Type? widgetType,
  }) {
    if (forcedScreenSize != null) {
      GoldenScreenshotsConfig.forcedScreenSize = forcedScreenSize;
    }
    if (screenshotsFolderName != null) {
      GoldenScreenshotsConfig.screenshotsFolderName = screenshotsFolderName;
    }
    if (skipSnapshotsCount != null) {
      GoldenScreenshotsConfig.skipSnapshotsCount = skipSnapshotsCount;
    }
    if (widgetType != null) {
      GoldenScreenshotsConfig.widgetType = widgetType;
    }

    _goldenHelper = GoldenHelper.enabled(
      skipSnapshotsCount: skipSnapshotsCount,
      widgetType: widgetType,
    );
  }
}
