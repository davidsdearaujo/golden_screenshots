import 'dart:ui';

import '../flutter_test.dart';

sealed class ScreenSize {
  /// iPhone SE (3rd generation)
  static const iphoneSe = Size(375, 667); // 375x667
  /// iPhone 14/15 standard
  static const iphone14 = Size(390, 844); // 390x844
  /// iPhone 14 Pro/15 Pro
  static const iphone14Pro = Size(393, 852); // 393x852
  /// iPhone 14 Pro Max/15 Pro Max
  static const iphone14ProMax = Size(428, 926); // 428x926
  /// iPhone 15 (same as 14)
  static const iphone15 = Size(390, 844); // 390x844
  /// iPhone 15 Pro (same as 14 Pro)
  static const iphone15Pro = Size(393, 852); // 393x852
  /// iPhone 15 Pro Max (same as 14 Pro Max)
  static const iphone15ProMax = Size(428, 926); // 428x926

  static Future<void> apply(WidgetTester tester, Size size) async {
    await tester.binding.setSurfaceSize(size);
    addTearDown(() => tester.binding.setSurfaceSize(null));
  }
}
