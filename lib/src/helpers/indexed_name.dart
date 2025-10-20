import 'package:flutter/foundation.dart';

@immutable
class IndexedName {
  const IndexedName(this.index, this.name);
  final int? index;
  final String name;

  IndexedName copyWith({int? index, String? name}) {
    return IndexedName(index ?? this.index, name ?? this.name);
  }

  String asString({bool indexed = true, bool incrementIndex = true}) {
    // Workaround to avoid null checks
    final index = this.index;
    if (!indexed || index == null) return name;

    final number = incrementIndex ? index + 1 : index;
    return '$number. $name';
  }

  @override
  String toString() => asString(indexed: true);

  /// Returns a new instance of [IndexedName] with the name cleared.
  IndexedName withClearedName() {
    final regex = RegExp('[^a-zA-Z0-9 ]');
    final clearedName = name.replaceAll(regex, '');
    return copyWith(name: clearedName);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IndexedName && index == other.index && name == other.name;

  @override
  int get hashCode => index.hashCode ^ name.hashCode;
}

extension IndexedNameExtension on Iterable<IndexedName> {
  Iterable<IndexedName> withClearedName() => map((e) => e.withClearedName());
}
