import 'dart:async';

/// Mixin on [Object] which allows the [Object]
/// to [subscribe] to multiple `Streams`
/// and exposes overrides for [onData], [onError], and [onDone] callbacks.
mixin StreamListenerMixin on Object {
  final _subscriptions = <StreamSubscription<dynamic>>[];

  /// Invokes [listen] on the provided [Stream]
  /// and propagates emitted data to the
  /// [onData], [onError], and [onDone] methods.
  ///
  /// Note: All [StreamListenerMixin] instances which
  /// invoke [subscribe] must also invoke [cancel] in order to
  /// cancel all pending `StreamSubscriptions`.
  void subscribe(Stream stream) {
    _subscriptions.add(stream.listen(
      onData,
      onDone: onDone,
      onError: onError,
      cancelOnError: cancelOnError,
    ));
  }

  /// Invoked for each data event from the `stream`.
  void onData(dynamic data) => {};

  /// Invoked on stream errors with the error object and possibly a stack trace.
  void onError(dynamic error, StackTrace stackTrace) => {};

  /// Invoked if the stream closes.
  void onDone() => {};

  /// Flag to determine whether or not to cancel the
  /// subscription if an error is emitted.
  /// Defaults to false.
  bool get cancelOnError => false;

  /// Cancels all existing `StreamSubscriptions`.
  /// If [subscribe] is invoked, then [cancel] should
  /// also be invoked when subscriptions are no longer needed.
  void cancel() {
    for (final s in _subscriptions) {
      s.cancel();
    }
    _subscriptions.clear();
  }
}
