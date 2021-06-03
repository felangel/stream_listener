# stream_listener

[![Pub](https://img.shields.io/pub/v/stream_listener.svg)](https://pub.dev/packages/stream_listener)
[![stream_listener](https://github.com/felangel/stream_listener/actions/workflows/stream_listener.yaml/badge.svg)](https://github.com/felangel/stream_listener/actions/workflows/stream_listener.yaml)
[![codecov](https://codecov.io/gh/felangel/stream_listener/branch/master/graph/badge.svg)](https://codecov.io/gh/felangel/stream_listener)
[![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)
[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)

Dart package the helps manage streams and subscriptions. Built in order to reduce the complexity of having to manually subscribe to streams and cancel subscriptions.

## StreamListenerMixin

A Dart `mixin` which allows any Dart Object to `subscribe` to one or more `Streams`.

```dart
class MyDartClass with StreamListenerMixin {
  MyDartClass(Stream stream) {
    // Subscribe to one or more streams
    subscribe(stream);
  }

  @override
  void onData(stream, data) {
    // React to data emitted from stream(s)
  }

  @override
  void onError(stream, error, stackTrace) {
    // React to errors emitted from stream(s)
  }

  @override
  bool cancelOnError(stream) => true; // Defaults to false

  @override
  void onDone(stream) {
    // React to when one or more streams are closed
  }
}
```

### Usage

```dart
import 'dart:async';
import 'package:stream_listener/stream_listener.dart';

class MyClass with StreamListenerMixin {
  MyClass(Stream stream) {
    subscribe(stream);
  }

  @override
  void onData(Stream stream, dynamic data) {
    print('onData $stream, $data');
  }

  @override
  void onError(Stream stream, dynamic error, StackTrace stackTrace) {
    print('onError $stream, $error, $stackTrace');
  }

  @override
  void onDone(Stream stream) {
    print('onDone $stream');
  }
}

void main() async {
  final controller = StreamController<int>();
  final myClass = MyClass(controller.stream);

  // onData Instance of '_ControllerStream<int>', 0
  controller.add(0);
  await tick();

  // onData Instance of '_ControllerStream<int>', 1
  controller.add(1);
  await tick();

  // onData Instance of '_ControllerStream<int>', 2
  controller.add(2);
  await tick();

  // onData Instance of '_ControllerStream<int>', 3
  controller.add(3);
  await tick();

  // onError Instance of '_ControllerStream<int>', oops!
  controller.addError('oops!');
  await tick();

  // onDone Instance of '_ControllerStream<int>'
  await controller.close();
  await tick();

  // Don't forget to cancel all StreamSubscriptions!
  myClass.cancel();
}

Future<void> tick() => Future.delayed(const Duration(seconds: 1));
```
