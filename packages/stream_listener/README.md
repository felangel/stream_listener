# stream_listener

[![Pub](https://img.shields.io/pub/v/stream_listener.svg)](https://pub.dev/packages/stream_listener)
[![Build Status](https://circleci.com/gh/felangel/stream_listener.svg?style=shield)](https://circleci.com/gh/felangel/stream_listener)
[![codecov](https://codecov.io/gh/felangel/stream_listener/branch/master/graph/badge.svg)](https://codecov.io/gh/felangel/stream_listener)
[![style: effective dart](https://img.shields.io/badge/style-effective_dart-40c4ff.svg)](https://github.com/tenhobi/effective_dart)
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
  void onData(data) {
    // React to data emitted from stream(s)
  }

  @override
  void onError(error, stackTrace) {
    // React to errors emitted from stream(s)
  }

  @override
  bool get cancelOnError => true; // Defaults to false

  @override
  void onDone() {
    // React to when one or more streams are closed
  }
}
```
