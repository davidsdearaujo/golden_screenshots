// Using local variables starting with underscore as workaround to avoid null checks
// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/foundation.dart';

import 'helpers.dart';

/// The tests tree.
///
/// Use to know groups and tests order to build the golden file path.
class TestsTree {
  TestsTree()
      : _rootNodes = [],
        _currentGroup = null;

  static const rootGroupName = '';

  final List<_TreeNode> _rootNodes;
  _GroupTreeNode? _currentGroup;
  _TestTreeNode? _currentTest;

  /// Starts a group in the tests tree.
  ///
  /// Should be called before the flutter.group to make sure
  /// the tree is correctly built.
  ///
  /// Don't forget to call [endGroup] after the group to make sure
  /// the tree is correctly closed.
  ///
  /// - [description] is the description of the group.
  void startGroup(Object description) {
    // Workaround to avoid null checks
    final _currentGroup = this._currentGroup;

    if (_currentGroup == null) {
      final newGroup = _GroupTreeNode(
        index: _rootNodes.length,
        name: description.toString(),
        parent: null,
      );
      _rootNodes.add(newGroup);
      this._currentGroup = newGroup;
    } else {
      final newGroup = _GroupTreeNode(
        index: _currentGroup.children.length,
        name: description.toString(),
        parent: _currentGroup,
      );
      _currentGroup.addChild(newGroup);
      this._currentGroup = newGroup;
    }
  }

  /// Closes the current group.
  ///
  /// Should be called after the flutter.group to make sure
  /// the tree is correctly built.
  ///
  /// Don't forget to call [startGroup] before the group to make sure
  /// the tree is correctly started.
  void endGroup() {
    _currentGroup = _currentGroup?.parent;
  }

  /// Adds a test to the tests tree.
  ///
  /// Should be called before the flutter.testWidgets to make sure
  /// the tree is correctly built.
  void startTest(String testName) {
    // Workaround to avoid null checks
    final _currentGroup = this._currentGroup;

    if (_currentGroup == null) {
      final newTest = _TestTreeNode(
        index: _rootNodes.length,
        name: testName,
        parent: null,
      );
      _rootNodes.add(newTest);
      _currentTest = newTest;
    } else {
      final newTest = _TestTreeNode(
        index: _currentGroup.children.length,
        name: testName,
        parent: _currentGroup,
      );
      _currentGroup.addChild(newTest);
      _currentTest = newTest;
    }
  }

  /// Ends the current test.
  ///
  /// Should be called after the flutter.testWidgets to make sure
  /// the tree is correctly closed.
  ///
  /// Don't forget to call [startTest] before the test to make sure
  /// the tree is correctly started.
  void endTest() {
    _currentTest = null;
  }

  /// Gets the path of the current test and all its ancestor groups.
  List<IndexedName> getCurrentTestPath() {
    // Workaround to avoid null checks
    final _currentTest = this._currentTest;
    if (_currentTest == null) throw Exception('No test started');

    final reversedPath = <IndexedName>[];

    final testName = IndexedName(_currentTest.index, _currentTest.name);
    reversedPath.add(testName);

    var group = _currentGroup;
    while (group != null) {
      final groupName = IndexedName(group.index, group.name);
      reversedPath.add(groupName);
      group = group.parent;
    }
    return reversedPath.reversed.toList();
  }

  /// Gets the current test number.
  int getCurrentTestNumber() => switch (_currentGroup) {
        null => _rootNodes.length,
        final _GroupTreeNode group => group.children.length,
      };
}

/// A class to represent a test or group.
///
/// Used by the tests tree to build the tree structure.
@immutable
sealed class _TreeNode {
  const _TreeNode({
    required this.index,
    required this.name,
    required this.parent,
  });

  final int index;

  /// The name of the test or group.
  final String name;

  /// The parent group.
  final _GroupTreeNode? parent;

  @override
  int get hashCode => name.hashCode ^ parent.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is _TreeNode &&
        runtimeType == other.runtimeType &&
        name == other.name &&
        parent == other.parent;
  }
}

class _TestTreeNode extends _TreeNode {
  const _TestTreeNode({
    required super.index,
    required super.name,
    required super.parent,
  });
}

class _GroupTreeNode extends _TreeNode {
  _GroupTreeNode({
    required super.index,
    required super.name,
    required super.parent,
    List<_TreeNode>? children,
  }) : children = children ?? [];

  /// List of children, which can be tests or groups.
  ///
  /// Only groups can have children.
  final List<_TreeNode> children;

  /// Adds the given [childNode] to the [children] list.
  void addChild(_TreeNode childNode) => children.add(childNode);

  @override
  int get hashCode => name.hashCode ^ children.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _GroupTreeNode &&
          name == other.name &&
          listEquals(children, other.children);
}
