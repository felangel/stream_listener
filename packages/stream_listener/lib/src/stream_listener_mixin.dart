import 'dart:async';

/// Mixin which enables multiple stream subscriptions
/// and exposes overrides for [onData], [onError], and [onDone] callbacks.
mixin StreamListenerMixin {
  final _subscriptions = <StreamSubscription<dynamic>>[];

  /// Invokes [Stream.listen] on the provided [Stream]
  /// and propagates emitted data to the
  /// [onData], [onError], and [onDone] methods.
  ///
  /// Note: All [StreamListenerMixin] instances which
  /// invoke [subscribe] must also invoke [cancel] in order to
  /// cancel all pending `StreamSubscriptions`.
  void subscribe(Stream stream) {
    _subscriptions.add(stream.listen(
      (data) => onData(stream, data),
      onDone: () => onDone(stream),
      onError: (error, stackTrace) => onError(stream, error, stackTrace),
      cancelOnError: cancelOnError(stream),
    ));
  }

  /// Invoked for each data event from the `stream`.
  void onData(Stream stream, dynamic data);

  /// Invoked on stream errors with the error object and possibly a stack trace.
  void onError(Stream stream, dynamic error, StackTrace stackTrace);

  /// Invoked if the stream closes.
  void onDone(Stream stream);

  /// Flag to determine whether or not to cancel the
  /// subscription if an error is emitted.
  /// Defaults to false.
  bool cancelOnError(Stream stream) => false;

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
