<!--[![Fork](https://img.shields.io/github/forks/davidsdearaujo/colored_print?style=social)](https://github.com/davidsdearaujo/colored_print/fork) &nbsp; [![Star](https://img.shields.io/github/stars/davidsdearaujo/colored_print?style=social)](https://github.com/davidsdearaujo/colored_print/stargazers) &nbsp; [![Watches](https://img.shields.io/github/watchers/davidsdearaujo/colored_print?style=social)](https://github.com/davidsdearaujo/colored_print/) -->

[![Plugin](https://img.shields.io/badge/pub.dev-test_snapshots-blue)](https://pub.dev/packages/test_snapshots) &nbsp; <!--[![Example](https://img.shields.io/badge/example-ex-success)](https://pub.dev/packages/colored_print#-example-tab-)-->

This helper will use the golden tests structure to create snapshots of your
widget tests, no changes required in the tests itself.

## Features

- Group cascading structure;
- folders with index to avoid conflicts;
- variants support;
- automatically saves snapshots for these triggers:
  - `tester.pump()`
  - `tester.pumpWidget()`
  - `tester.pumpAndSettle()`
  - failed `expect()` calls

## Getting started

Add `test_snapshots` to the `dev_dependencies` section in your
`pubspec.yaml` file:

```yaml
dev_dependencies:
    test_snapshots: <version>
```

## Usage

Replace the import `package:flutter_test/flutter_test.dart` with
`package:test_snapshots/test_snapshots.dart` in the test file that you
want to generate screenshots for:

```dart
// import 'package:flutter_test/flutter_test.dart';
import 'package:test_snapshots/test_snapshots.dart';
```

Now you simply run your tests with the `flutter test` command and the snapshots
will be generated in the `_snapshots` folder.

## Additional information

<br/>

**Folder structure:**
```
_snapshots/<group_index>. <group_name>/<test_index>. <test_name>/<snapshot_index>. <trigger>.png
```

```
_snapshots/1. my group/2. my custom test/1. pumpWidget.png
_snapshots/2. HomeScreen/1. should render/1. pumpWidget.png
_snapshots/2. HomeScreen/2. should navigate to details page/1. pumpWidget.png
_snapshots/2. HomeScreen/2. should navigate to details page/2. pumpAndSettle.png
```
<br/>

You can find more information about the package in the
[documentation](https://pub.dev/documentation/test_snapshots/latest/).

You can also find the package in the
[pub.dev](https://pub.dev/packages/test_snapshots) page.

You can also contribute to the package by creating a pull request or by
reporting an issue.
