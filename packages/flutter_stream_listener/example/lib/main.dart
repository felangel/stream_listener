import 'package:flutter/material.dart';
import 'package:flutter_stream_listener/flutter_stream_listener.dart';

void main() => runApp(const MyApp());

/// Example StreamListener Flutter App
class MyApp extends StatelessWidget {
  // ignore: public_member_api_docs
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

/// StatefulWidget which illustrates how to use [StreamListener].
class MyHomePage extends StatefulWidget {
  // ignore: public_member_api_docs
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _data = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StreamListener Example'),
      ),
      body: StreamListener(
        stream:
            Stream.periodic(const Duration(seconds: 1), (x) => x + 1).take(10),
        onData: (dynamic data) => setState(() {
          _data = data;
        }),
        // ignore: avoid_print
        onError: (error, stackTrace) => debugPrint(
          'onError $error, $stackTrace',
        ),
        onDone: () => debugPrint('onDone'),
        child: Center(
          child: Text('Stream Emitted $_data'),
        ),
      ),
    );
  }
}
