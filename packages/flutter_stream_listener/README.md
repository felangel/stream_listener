# flutter_stream_listener

[![Pub](https://img.shields.io/pub/v/flutter_stream_listener.svg)](https://pub.dev/packages/flutter_stream_listener)
[![flutter_stream_listener](https://github.com/felangel/stream_listener/actions/workflows/flutter_stream_listener.yaml/badge.svg)](https://github.com/felangel/stream_listener/actions/workflows/flutter_stream_listener.yaml)
[![codecov](https://codecov.io/gh/felangel/stream_listener/branch/master/graph/badge.svg)](https://codecov.io/gh/felangel/stream_listener)
[![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)
[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)

Flutter package the helps manage streams and subscriptions. Built in order to reduce the complexity of having to manually subscribe to streams and cancel subscriptions.

## StreamListener

A `Widget` which manages a `Subscription` to a `Stream` and exposes callbacks: `onData`, `onError`, and `onDone`.

```dart
StreamListener<int>(
  stream: Stream.fromIterable([0, 1, 2, 3]), // Stream being subscribed to
  onData: (data) {
    // React to the emitted data
  },
  onError: (error, stackTrace) {
    // Optionally handle errors in the Stream
  },
  onDone: () {
    // Optionally react to when the Stream is closed
  },
  cancelOnError: true, // Defaults to false
  child: const SizedBox(),
)
```
