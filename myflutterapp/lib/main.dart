import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:myflutterapp/src/generated/helloworld.pbgrpc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _counter = useState(0);

    void _test() async {
      _counter.value++;

      final channel = ClientChannel(
        'localhost',
        port: 50051,
        options: ChannelOptions(
          credentials: const ChannelCredentials.insecure(),
          // codecRegistry: CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]),
        ),
      );
      final stub = GreeterClient(channel);
      const name = 'flutter gRPC world';
      try {
        final response = await stub.sayHello(
          HelloRequest()..name = name,
          // options: CallOptions(compression: const GzipCodec()),
        );
        print('Greeter client received: ${response.message}');
      } catch (e) {
        print('Caught error: $e');
        await channel.shutdown();
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Test unary',
            ),
            Text(
              '${_counter.value}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _test,
        tooltip: 'test',
        child: const Icon(Icons.abc),
      ),
    );
  }
}
