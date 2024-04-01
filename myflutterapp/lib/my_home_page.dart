import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:myflutterapp/src/generated/helloworld.pbgrpc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _log = useState<List<String>>([]);

    void _unary() async {
      final channel = ClientChannel(
        'localhost',
        port: 50051,
        options: const ChannelOptions(
          credentials: ChannelCredentials.insecure(),
          // codecRegistry: CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]),
        ),
      );
      final stub = GreeterClient(channel);
      const name = 'flutter world';
      try {
        final response = await stub.sayHello(
          HelloRequest()..name = name,
          // options: CallOptions(compression: const GzipCodec()),
        );
        _log.value = [
          ..._log.value,
          'Greeter unary received: ${response.message}'
        ];
      } catch (e) {
        print('Caught error: $e');
        await channel.shutdown();
      }
    }

    void _serverStream() async {
      final channel = ClientChannel(
        'localhost',
        port: 50051,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure()),
      );
      final stub = GreeterClient(channel);
      const name = 'flutter world';

      try {
        final request = HelloRequest()..name = name;
        await for (var response in stub.sayHelloAgain(request)) {
          _log.value = [
            ..._log.value,
            'Greeter server streaming received: ${response.message}'
          ];
        }
      } catch (e) {
        print('Caught error: $e');
      } finally {
        await channel.shutdown();
      }
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(title),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: _log.value.map((v) => Text(v)).toList(),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end, // FABを右端に配置
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: FloatingActionButton(
                onPressed: () async {
                  _unary();
                },
                tooltip: 'unary',
                child: const Text('unary'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: FloatingActionButton(
                onPressed: () async {
                  _serverStream();
                },
                tooltip: 'server stream',
                child: const Text('server stream'),
              ),
            ),
          ],
        ));
  }
}
