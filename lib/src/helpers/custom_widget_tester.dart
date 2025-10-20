import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import '../flutter_test.dart';
import 'helpers.dart';

class CustomWidgetTester extends WidgetController implements WidgetTester {
  CustomWidgetTester(this.tester, this.goldenHelper) : super(tester.binding);
  final WidgetTester tester;
  final GoldenHelper goldenHelper;

  @override
  Future<void> pumpWidget(
    Widget widget, {
    Duration? duration,
    EnginePhase phase = EnginePhase.sendSemanticsUpdate,
    bool wrapWithView = true,
  }) async {
    await tester.pumpWidget(widget,
        duration: duration, phase: phase, wrapWithView: wrapWithView);
    await goldenHelper.generate('pumpWidget');
  }

  @override
  Future<int> pumpAndSettle([
    Duration duration = const Duration(milliseconds: 100),
    EnginePhase phase = EnginePhase.sendSemanticsUpdate,
    Duration timeout = const Duration(minutes: 10),
  ]) async {
    final result = await tester.pumpAndSettle(duration, phase, timeout);
    await goldenHelper.generate('pumpAndSettle');
    return result;
  }

  @override
  Future<void> pump([
    Duration? duration,
    EnginePhase phase = EnginePhase.sendSemanticsUpdate,
  ]) async {
    await tester.pump(duration, phase);
    await goldenHelper.generate('pump');
  }

  /// The binding instance used by the testing framework.
  @override
  TestWidgetsFlutterBinding get binding => tester.binding;

  @override
  Ticker createTicker(TickerCallback onTick) => tester.createTicker(onTick);

  @override
  void dispatchEvent(PointerEvent event, HitTestResult result) =>
      tester.dispatchEvent(event, result);

  @override
  Future<void> enterText(FinderBase<Element> finder, String text) =>
      tester.enterText(finder, text);

  @override
  Future<TestRestorationData> getRestorationData() =>
      tester.getRestorationData();

  @override
  Future<List<Duration>> handlePointerEventRecord(
    Iterable<PointerEventRecord> records,
  ) =>
      tester.handlePointerEventRecord(records);

  @override
  bool get hasRunningAnimations => tester.hasRunningAnimations;

  @override
  Future<void> idle() => tester.idle();

  @override
  Future<void> pageBack() => tester.pageBack();

  @override
  Future<void> pumpBenchmark(Duration duration) =>
      tester.pumpBenchmark(duration);

  @override
  Future<void> pumpFrames(
    Widget target,
    Duration maxDuration, [
    Duration interval = const Duration(milliseconds: 16, microseconds: 683),
  ]) =>
      tester.pumpFrames(target, maxDuration, interval);

  @override
  Future<void> restartAndRestore() => tester.restartAndRestore();

  @override
  Future<void> restoreFrom(TestRestorationData data) =>
      tester.restoreFrom(data);

  @override
  Future<T?> runAsync<T>(
    Future<T> Function() callback, {
    @Deprecated(
      'This is no longer supported and has no effect. '
      'This feature was deprecated after v3.12.0-1.1.pre.',
    )
    Duration additionalTime = const Duration(milliseconds: 1000),
  }) =>
      tester.runAsync(callback);

  @override
  Future<void> showKeyboard(FinderBase<Element> finder) =>
      tester.showKeyboard(finder);

  @override
  List<CapturedAccessibilityAnnouncement> takeAnnouncements() =>
      tester.takeAnnouncements();

  @override
  dynamic takeException() => tester.takeException();

  @override
  String get testDescription => tester.testDescription;

  @override
  TestTextInput get testTextInput => tester.testTextInput;

  @override
  void verifyTickersWereDisposed([String when = 'when none should have been']) {
    tester.verifyTickersWereDisposed(when);
  }
}
