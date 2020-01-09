import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_stream_listener/flutter_stream_listener.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Initialization', () {
    testWidgets('throws AssertionError if stream is null', (tester) async {
      try {
        await tester.pumpWidget(
          StreamListener<int>(
            stream: null,
            onData: (_) {},
            child: Container(),
          ),
        );
      } on dynamic catch (error) {
        expect(error, isAssertionError);
      }
    });

    testWidgets('throws AssertionError if onData is null', (tester) async {
      try {
        await tester.pumpWidget(
          StreamListener<int>(
            stream: Stream.fromIterable([0]),
            onData: null,
            child: Container(),
          ),
        );
      } on dynamic catch (error) {
        expect(error, isAssertionError);
      }
    });

    testWidgets('throws AssertionError if child is null', (tester) async {
      try {
        await tester.pumpWidget(
          StreamListener<int>(
            stream: Stream.fromIterable([0]),
            onData: (_) {},
            child: null,
          ),
        );
      } on dynamic catch (error) {
        expect(error, isAssertionError);
      }
    });
  });

  group('onData', () {
    testWidgets('is called when a single piece of data is emitted',
        (tester) async {
      final emittedData = <int>[];
      await tester.pumpWidget(
        StreamListener<int>(
          stream: Stream.fromIterable([0]),
          onData: emittedData.add,
          child: Container(),
        ),
      );
      await tester.pumpAndSettle();
      expect(emittedData, [0]);
    });

    testWidgets('is called when multiple pieces of data are emitted',
        (tester) async {
      final emittedData = <int>[];
      await tester.pumpWidget(
        StreamListener<int>(
          stream: Stream.fromIterable([0, 1, 2, 3]),
          onData: emittedData.add,
          child: Container(),
        ),
      );
      await tester.pumpAndSettle();
      expect(emittedData, [0, 1, 2, 3]);
    });

    testWidgets('is called when data is emitted irregularly', (tester) async {
      final emittedData = <int>[];
      final controller = StreamController<int>();
      await tester.pumpWidget(
        StreamListener<int>(
          stream: controller.stream,
          onData: emittedData.add,
          child: Container(),
        ),
      );
      await tester.pumpAndSettle();
      expect(emittedData, isEmpty);

      controller.add(0);
      await tester.pumpAndSettle();
      expect(emittedData, [0]);

      controller.add(0);
      controller.add(0);
      await tester.pumpAndSettle();
      expect(emittedData, [0, 0, 0]);

      controller.close();
    });
  });

  group('onError', () {
    testWidgets('is called when an error occurs', (tester) async {
      final emittedData = <int>[];
      final emittedErrors = <dynamic>[];
      final controller = StreamController<int>();
      final expectedError = Exception('oops');
      await tester.pumpWidget(
        StreamListener<int>(
          stream: controller.stream,
          onData: emittedData.add,
          onError: (e, s) => emittedErrors.add(e),
          child: Container(),
        ),
      );
      await tester.pumpAndSettle();
      expect(emittedData, isEmpty);

      controller.addError(expectedError);
      await tester.pumpAndSettle();
      expect(emittedData, isEmpty);
      expect(emittedErrors, [expectedError]);

      controller.close();
    });

    testWidgets('is called and does not cancel subscription by default',
        (tester) async {
      final emittedData = <int>[];
      final emittedErrors = <dynamic>[];
      final controller = StreamController<int>();
      final expectedError = Exception('oops');
      await tester.pumpWidget(
        StreamListener<int>(
          stream: controller.stream,
          onData: emittedData.add,
          onError: (e, s) => emittedErrors.add(e),
          child: Container(),
        ),
      );
      await tester.pumpAndSettle();
      expect(emittedData, isEmpty);

      controller.addError(expectedError);
      await tester.pumpAndSettle();
      expect(emittedData, isEmpty);
      expect(emittedErrors, [expectedError]);

      controller.add(0);
      controller.add(0);
      await tester.pumpAndSettle();
      expect(emittedData, [0, 0]);

      controller.close();
    });

    testWidgets('is called and cancels subscription when cancelOnError is true',
        (tester) async {
      final emittedData = <int>[];
      final emittedErrors = <dynamic>[];
      final controller = StreamController<int>();
      final expectedError = Exception('oops');
      await tester.pumpWidget(
        StreamListener<int>(
          stream: controller.stream,
          onData: emittedData.add,
          onError: (e, s) => emittedErrors.add(e),
          cancelOnError: true,
          child: Container(),
        ),
      );
      await tester.pumpAndSettle();
      expect(emittedData, isEmpty);

      controller.addError(expectedError);
      await tester.pumpAndSettle();
      expect(emittedData, isEmpty);
      expect(emittedErrors, [expectedError]);

      controller.add(0);
      controller.add(0);
      await tester.pumpAndSettle();
      expect(emittedData, []);

      controller.close();
    });
  });

  group('onDone', () {
    testWidgets('is called when the stream is closed', (tester) async {
      final emittedData = <int>[];
      var doneCalled = false;
      final controller = StreamController<int>();
      await tester.pumpWidget(
        StreamListener<int>(
          stream: controller.stream,
          onData: emittedData.add,
          onDone: () => doneCalled = true,
          child: Container(),
        ),
      );
      await tester.pumpAndSettle();
      expect(emittedData, isEmpty);
      expect(doneCalled, isFalse);

      controller.close();
      await tester.pumpAndSettle();
      expect(doneCalled, isTrue);
    });
  });
}
