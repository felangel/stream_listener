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
  controller.close();
  await tick();

  // Don't forget to cancel all StreamSubscriptions!
  myClass.cancel();
}

Future<void> tick() => Future.delayed(Duration(seconds: 1));
