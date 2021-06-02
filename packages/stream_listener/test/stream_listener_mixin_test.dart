// ignore_for_file: type_annotate_public_apis

import 'dart:async';

import 'package:stream_listener/stream_listener.dart';
import 'package:test/test.dart';

class EmptyClass with StreamListenerMixin {
  EmptyClass({
    required Stream<dynamic> stream,
  }) {
    subscribe(stream);
  }

  void close() => cancel();

  @override
  void onData(Stream stream, data) {}

  @override
  void onDone(Stream stream) {}

  @override
  void onError(Stream stream, error, StackTrace stackTrace) {}
}

class PopulatedClass with StreamListenerMixin {
  PopulatedClass({
    required Stream<dynamic> stream,
    this.onDataCallback,
    this.onErrorCallack,
    this.onDoneCallback,
    this.cancelOnErrorFlag = false,
  }) {
    subscribe(stream);
  }

  final void Function(dynamic d)? onDataCallback;
  final void Function(dynamic error, StackTrace stackTrace)? onErrorCallack;
  final void Function()? onDoneCallback;
  final bool cancelOnErrorFlag;

  void close() => cancel();

  @override
  void onData(stream, data) => onDataCallback?.call(data);

  @override
  void onError(stream, error, stackTrace) =>
      onErrorCallack?.call(error, stackTrace);

  @override
  bool cancelOnError(stream) => cancelOnErrorFlag;

  @override
  void onDone(stream) => onDoneCallback?.call();
}

void main() {
  group('StreamListenerMixin', () {
    test('does nothing by default', () async {
      final controller = StreamController<int>();

      EmptyClass(
        stream: controller.stream,
      );

      controller
        ..add(0)
        ..addError('oops');
      await controller.close();
    });

    test('cancels all subscriptions', () async {
      final emittedData = <dynamic>[];
      final controller = StreamController<int>();
      PopulatedClass(
        stream: controller.stream,
        onDataCallback: emittedData.add,
      ).close();
      await _tick();
      controller.add(0);
      expect(emittedData, isEmpty);
    });

    group('onData', () {
      test('is called when a single piece of data is emitted', () async {
        final emittedData = <dynamic>[];
        PopulatedClass(
          stream: Stream.fromIterable([0]),
          onDataCallback: emittedData.add,
        );
        await _tick();
        expect(emittedData, [0]);
      });

      test('is called when multiple pieces of data are emitted', () async {
        final emittedData = <dynamic>[];
        PopulatedClass(
          stream: Stream.fromIterable([0, 1, 2, 3]),
          onDataCallback: emittedData.add,
        );
        await _tick();
        expect(emittedData, [0, 1, 2, 3]);
      });

      test('is called when stream emits data irregularly', () async {
        final emittedData = <dynamic>[];
        final controller = StreamController<int>();
        PopulatedClass(
          stream: controller.stream,
          onDataCallback: emittedData.add,
        );
        controller.add(0);
        await _tick();
        expect(emittedData, [0]);

        controller.add(0);
        await _tick();
        expect(emittedData, [0, 0]);

        controller.add(0);
        await _tick();
        expect(emittedData, [0, 0, 0]);
      });
    });

    group('onError', () {
      test('is called when an error occurs', () async {
        final emittedData = <int>[];
        final emittedErrors = <dynamic>[];
        final controller = StreamController<int>();
        final expectedError = Exception('oops');

        PopulatedClass(
          stream: controller.stream,
          onDataCallback: emittedData.add as void Function(dynamic)?,
          onErrorCallack: (e, s) => emittedErrors.add(e),
        );

        await _tick();
        expect(emittedData, isEmpty);

        controller.addError(expectedError);
        await _tick();
        expect(emittedData, isEmpty);
        expect(emittedErrors, [expectedError]);

        await controller.close();
      });

      test('is called and does not cancel subscription by default', () async {
        final emittedData = <int>[];
        final emittedErrors = <dynamic>[];
        final controller = StreamController<int>();
        final expectedError = Exception('oops');

        PopulatedClass(
          stream: controller.stream,
          onDataCallback: emittedData.add as void Function(dynamic)?,
          onErrorCallack: (e, s) => emittedErrors.add(e),
        );

        await _tick();
        expect(emittedData, isEmpty);

        controller.addError(expectedError);
        await _tick();
        expect(emittedData, isEmpty);
        expect(emittedErrors, [expectedError]);

        controller..add(0)..add(0);
        await _tick();
        expect(emittedData, [0, 0]);

        await controller.close();
      });

      test('is called and cancels subscription when cancelOnError is true',
          () async {
        final emittedData = <int>[];
        final emittedErrors = <dynamic>[];
        final controller = StreamController<int>();
        final expectedError = Exception('oops');
        PopulatedClass(
          stream: controller.stream,
          onDataCallback: emittedData.add as void Function(dynamic)?,
          onErrorCallack: (e, s) => emittedErrors.add(e),
          cancelOnErrorFlag: true,
        );

        await _tick();
        expect(emittedData, isEmpty);

        controller.addError(expectedError);
        await _tick();
        expect(emittedData, isEmpty);
        expect(emittedErrors, [expectedError]);

        controller..add(0)..add(0);
        await _tick();
        expect(emittedData, []);

        await controller.close();
      });
    });

    group('onDone', () {
      test('is called when the stream is closed', () async {
        final emittedData = <int>[];
        var doneCalled = false;
        final controller = StreamController<int>();
        PopulatedClass(
          stream: controller.stream,
          onDataCallback: emittedData.add as void Function(dynamic)?,
          onDoneCallback: () => doneCalled = true,
        );

        await _tick();
        expect(emittedData, isEmpty);
        expect(doneCalled, isFalse);

        await controller.close();
        await _tick();
        expect(doneCalled, isTrue);
      });
    });
  });
}

Future<void> _tick() => Future.delayed(const Duration(microseconds: 0));
