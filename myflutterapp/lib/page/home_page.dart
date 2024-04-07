// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:myflutterapp/src/generated/helloworld.pbgrpc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _log = useState<List<String>>([]);

    void _biDirectional() async {
      final channel = ClientChannel(
        'localhost',
        port: 50051,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure()),
      );
      final stub = GreeterClient(channel);

      Stream<HelloRequest> requestStream() async* {
        yield HelloRequest()..name = 'taro';
        _log.value = [..._log.value, 'Greeter bi-directional send: taro'];
        yield HelloRequest()..name = 'hanako';
        _log.value = [..._log.value, 'Greeter bi-directional send: hanako'];
      }

      final responseStream = stub.sayChat(requestStream());
      await for (var response in responseStream) {
        _log.value = [
          ..._log.value,
          'Greeter bi-directional received: ${response.message}'
        ];
      }
      _log.value = [..._log.value, 'Greeter bi-directional close'];
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
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              onPressed: () async {
                _biDirectional();
              },
              tooltip: 'bi-directional',
              child: const Text('bi-directional'),
            ),
          ),
        ],
      ),
    );
  }
}
