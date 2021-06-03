import 'dart:async';

import 'package:flutter/widgets.dart';

/// Signature for the `onData` callback.
typedef StreamOnDataListener<T> = void Function(T data);

/// Signature for the `onError` callback.
typedef StreamOnErrorListener = void Function(
  dynamic error,
  StackTrace stackTrace,
);

/// Signature for the `onDone` callback.
typedef StreamOnDoneListener = void Function();

/// {@template stream_listener}
/// A `Widget` which manages a `Subscription` to a [Stream]
/// and exposes callbacks: [onData], [onError], and [onDone].
///
/// ```dart
/// StreamListener<int>(
///   stream: Stream.fromIterable([0, 1, 2, 3]), // Stream being subscribed to
///   onData: (data) {
///     // React to the emitted data
///   },
///   onError: (error) {
///     // Optionally handle errors in the Stream
///   },
///   onDone: () {
///     // Optionally react to when the Stream is closed
///   },
///   cancelOnError: true, // Defaults to false
///   child: Container(),
/// )
/// ```
/// {@endtemplate}
class StreamListener<T> extends StatefulWidget {
  /// {@macro stream_listener}
  const StreamListener({
    Key? key,
    required this.stream,
    required this.onData,
    required this.child,
    this.onError,
    this.onDone,
    this.cancelOnError = false,
  }) : super(key: key);

  /// The [Stream] which will be subscribed to.
  final Stream<T> stream;

  /// On each data event from the [stream],
  /// the subscriber's [onData] handler is called.
  final StreamOnDataListener<T> onData;

  /// The widget which will be rendered
  /// as a direct descendant of the [StreamListener].
  final Widget child;

  /// On errors from this stream, the [onError] handler is called with the
  /// error object and possibly a stack trace.
  ///
  /// The [onError] callback must be of type `void onError(error)` or
  /// `void onError(error, StackTrace stackTrace)`. If [onError] accepts
  /// two arguments it is called with the error object and the stack trace
  /// (which could be `null` if this stream itself received an error without
  /// stack trace).
  /// Otherwise it is called with just the error object.
  /// If [onError] is omitted,
  /// any errors on this stream are considered unhandled,
  /// and will be passed to the current [Zone]'s error handler.
  /// By default unhandled async errors are treated
  /// as if they were uncaught top-level errors.
  final StreamOnErrorListener? onError;

  /// If this stream closes and sends a done event, the [onDone] handler is
  /// called. If [onDone] is `null`, nothing happens.
  final StreamOnDoneListener? onDone;

  /// If [cancelOnError] is true, the subscription is automatically canceled
  /// when the first error event is delivered. The default is `false`.
  final bool cancelOnError;

  @override
  _StreamListenerState createState() => _StreamListenerState<T>();
}

class _StreamListenerState<T> extends State<StreamListener<T>> {
  late final StreamSubscription<T> _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = widget.stream.listen(
      widget.onData,
      onError: widget.onError,
      onDone: widget.onDone,
      cancelOnError: widget.cancelOnError,
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
