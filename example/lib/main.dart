import 'package:flutter/material.dart';
import 'package:stream_listener/stream_listener.dart';

void main() => runApp(MyApp());

/// Example StreamListener Flutter App
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

/// StatefulWidget which illustrates how to use [StreamListener].
class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int data = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('StreamListener Example'),
      ),
      body: StreamListener(
        stream: Stream.periodic(Duration(seconds: 1), (x) => x + 1).take(10),
        onData: (d) => setState(() {
          data = d;
        }),
        onError: (e) => print('onError $e'),
        onDone: () => print('onDone'),
        child: Center(
          child: Text('Stream Emitted $data'),
        ),
      ),
    );
  }
}
