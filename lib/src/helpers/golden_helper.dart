import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../flutter_test.dart';
import 'helpers.dart';

class GoldenHelper {
  GoldenHelper._({
    required String? goldenPath,
    required this.isEnabled,
    required int? skipSnapshotsCount,
    required this.widgetType,
  })  : skipSnapshotsCount = skipSnapshotsCount ?? 0,
        _goldenFilePathBuilder = GoldenFilePathBuilder(
          count: 1,
          pathBuilder: goldenPath == null || goldenPath.isEmpty
              ? null
              : () => goldenPath,
        );

  factory GoldenHelper.enabled({
    String? goldenPath,
    Type? widgetType,
    int? skipSnapshotsCount,
  }) =>
      GoldenHelper._(
        isEnabled: true,
        goldenPath: goldenPath,
        skipSnapshotsCount: skipSnapshotsCount,
        widgetType: widgetType,
      );

  factory GoldenHelper.disabled({
    String? goldenPath,
    Type? widgetType,
    int? skipSnapshotsCount,
  }) =>
      GoldenHelper._(
        isEnabled: false,
        goldenPath: goldenPath,
        skipSnapshotsCount: 0,
        widgetType: widgetType,
      );

  final bool isEnabled;
  final int skipSnapshotsCount;
  Type? widgetType;

  bool _isFontsLoaded = false;
  final GoldenFilePathBuilder _goldenFilePathBuilder;

  /// Sets up the golden helper.
  ///
  /// This method will load the custom fonts if needed
  /// and apply the screen size.
  ///
  /// - [initialCounter] is the initial counter value to use for
  /// the golden file. If null, the counter will not be used.
  /// - [loadFonts] is a flag to load the custom fonts if needed.
  /// - [screenSize] is the screen size to apply to the tester.
  Future<void> setUp(
    WidgetTester tester, {
    required int? initialCounter,
    ValueGetter<String>? goldenPathGetter,
    bool loadFonts = true,
    Size? screenSize,
  }) async {
    if (isEnabled) {
      _goldenFilePathBuilder.reset(
        pathBuilder: goldenPathGetter,
        count: initialCounter,
      );
      if (loadFonts && !_isFontsLoaded) {
        // Only needed for golden file updates
        await loadAppFonts();
        _isFontsLoaded = true;
      }
      if (screenSize != null) {
        await ScreenSize.apply(tester, screenSize);
      }
    }
  }

  /// Generates the golden file for the current state of the widget.
  ///
  /// This method will not check the golden file, it will only generate it
  /// when tests are run with the [autoUpdateGoldenFiles] flag set to true.
  ///
  /// Example: `flutter test --update-goldens`
  Future<void> generate(
    String name, {
    Type? forceWidgetType,
    bool skip = false,
  }) async {
    if (!isEnabled || skip) return;

    final shouldSkipByCount =
        _goldenFilePathBuilder.count <= skipSnapshotsCount;
    if (shouldSkipByCount) {
      _goldenFilePathBuilder.incrementCount();
      return;
    }

    try {
      autoUpdateGoldenFiles = true;
      final widgetType = _resolveType(forceWidgetType);

      final goldenFilePath = _goldenFilePathBuilder.build(fileName: name);

      await expectLater(
          find.byType(widgetType), matchesGoldenFile(goldenFilePath));
      _goldenFilePathBuilder.incrementCount();
    } catch (e) {
      rethrow;
    } finally {
      // Make sure to reset the flag to false so it doesn't affect
      // other test operations (like real golden tests).
      autoUpdateGoldenFiles = false;
    }
  }

  /// Resolves the type to use for the golden file.
  ///
  /// This method will return the type passed as a parameter if provided,
  /// otherwise it will return the type defined at the class level if provided,
  /// otherwise it will return MaterialApp as default type.
  Type _resolveType(Type? forcedType) {
    // return forcedType if provided
    if (forcedType != null && forcedType != dynamic) return forcedType;

    // return TWidget defined at the class level if provided
    if (widgetType != null && widgetType != dynamic) return widgetType!;

    // return ChildUpdateWrapper as default type if no type is provided
    // Not MaterialApp to avoid the debug banner
    return MaterialApp;
  }
}

class GoldenFilePathBuilder {
  GoldenFilePathBuilder({
    required int? count,
    required ValueGetter<String>? pathBuilder,
  })  : _count = count,
        _pathBuilder = pathBuilder;

  ValueGetter<String>? _pathBuilder;

  int? _count;

  /// The current count to append to the file name.
  ///
  /// {@template golden_helper.count_related}
  ///
  /// See also:
  ///
  /// - [incrementCount]
  /// {@endtemplate}
  int get count => _count ?? 0;

  /// Increments the count.
  ///
  /// If the current [_count] is null, nothing happens.
  ///
  /// {@macro golden_helper.count_related}
  void incrementCount() {
    if (_count == null) return;
    _count = _count! + 1;
  }

  void validate() {
    // if (_extension == null) throw ArgumentError.notNull('extension');
  }

  String build({required String fileName}) {
    validate();

    final path = () {
      final path = _pathBuilder?.call();
      if (path == null || path.isEmpty) return null;
      return path;
    }();

    // Sequence is important here
    final response = StringBuffer();
    if (path != null) response.write('$path/');
    if (_count != null) response.write('$_count. ');
    response.write('$fileName.png');

    return response.toString();
  }

  /// Creates a new [GoldenFilePathBuilder] with the same properties but with
  /// the provided [count] and [pathBuilder] values.
  ///
  /// - [count] is always set to the provided value;
  /// - If [pathBuilder] is null, the current [_pathBuilder] value will be used.
  void reset({required int? count, ValueGetter<String>? pathBuilder}) {
    _count = count;
    if (pathBuilder != null) _pathBuilder = pathBuilder;
  }
}
