# stream_listener

[![Pub](https://img.shields.io/pub/v/stream_listener.svg)](https://pub.dev/packages/stream_listener)
[![Build Status](https://travis-ci.com/felangel/stream_listener.svg?branch=master)](https://travis-ci.com/felangel/stream_listener)
[![codecov](https://codecov.io/gh/felangel/stream_listener/branch/master/graph/badge.svg)](https://codecov.io/gh/felangel/stream_listener)
[![style: effective dart](https://img.shields.io/badge/style-effective_dart-40c4ff.svg)](https://github.com/tenhobi/effective_dart)

Flutter widgets the help manage streams and subscriptions.

## StreamListener

A `Widget` which manages a `Subscription` to a `Stream` and exposes callbacks: `onData`, `onError`, and `onDone`.

```dart
StreamListener<int>(
  stream: Stream.fromIterable([0, 1, 2, 3]), // Stream being subscribed to
  onData: (data) {
    // React to the emitted data
  },
  onError: (error) {
    // Optionally handle errors in the Stream
  },
  onDone: () {
    // Optionally react to when the Stream is closed
  },
  cancelOnError: true, // Defaults to false
  child: Container(),
)
```
