import 'package:flutter/material.dart';
import 'package:flutter_stream_listener/flutter_stream_listener.dart';

void main() => runApp(const MyApp());

/// {@template my_app}
/// Example StreamListener Flutter App
/// {@endtemplate}
class MyApp extends MaterialApp {
  /// {@macro my_app}
  const MyApp({Key? key}) : super(key: key, home: const MyHomePage());
}

/// {@template my_home_page}
/// StatefulWidget which illustrates how to use [StreamListener].
/// {@endtemplate}
class MyHomePage extends StatefulWidget {
  /// {@macro my_home_page}
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _data = 0;

  @override
  Widget build(BuildContext context) {
    const duration = Duration(seconds: 1);
    return Scaffold(
      appBar: AppBar(title: const Text('StreamListener Example')),
      body: StreamListener(
        stream: Stream.periodic(duration, (x) => x + 1).take(10),
        onData: (dynamic data) => setState(() => _data = data),
        onError: (error, stackTrace) {
          debugPrint('onError $error, $stackTrace');
        },
        onDone: () => debugPrint('onDone'),
        child: Center(child: Text('Stream Emitted $_data')),
      ),
    );
  }
}
