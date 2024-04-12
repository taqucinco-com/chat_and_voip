// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:myflutterapp/feature/auth/auth_proxy.dart';
import 'package:myflutterapp/src/generated/helloworld.pbgrpc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DebugPage extends HookConsumerWidget {
  const DebugPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final log = useState<List<String>>([]);

    void unary() async {
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
        log.value = [
          ...log.value,
          'Greeter unary received: ${response.message}'
        ];
      } catch (e) {
        print('Caught error: $e');
        await channel.shutdown();
      }
    }

    void serverStream() async {
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
          log.value = [
            ...log.value,
            'Greeter server streaming received: ${response.message}'
          ];
        }
        log.value = [...log.value, 'Greeter server streaming closed'];
      } catch (e) {
        print('Caught error: $e');
      } finally {
        await channel.shutdown();
      }
    }

    void clientStream() async {
      final channel = ClientChannel(
        'localhost',
        port: 50051,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure()),
      );
      final stub = GreeterClient(channel);

      Stream<HelloRequest> requestStream() async* {
        yield HelloRequest()..name = 'taro';
        log.value = [...log.value, 'Greeter client streaming send: taro'];
        await Future.delayed(const Duration(milliseconds: 1000));
        yield HelloRequest()..name = 'hanako';
        log.value = [...log.value, 'Greeter client streaming send: hanako'];
        await Future.delayed(const Duration(milliseconds: 1000));
        log.value = [...log.value, 'Greeter client streaming close'];
      }

      final response = await stub.sayHelloToMany(requestStream());
      log.value = [
        ...log.value,
        'Greeter client streaming received: ${response.message}'
      ];
    }

    void biDirectional() async {
      final channel = ClientChannel(
        'localhost',
        port: 50051,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure()),
      );
      final stub = GreeterClient(channel);

      Stream<HelloRequest> requestStream() async* {
        yield HelloRequest()..name = 'taro';
        log.value = [...log.value, 'Greeter bi-directional send: taro'];
        await Future.delayed(const Duration(milliseconds: 5000));
        yield HelloRequest()..name = 'hanako';
        log.value = [...log.value, 'Greeter bi-directional send: hanako'];
        await Future.delayed(const Duration(milliseconds: 5000));
      }

      final responseStream = stub.sayChat(requestStream());
      await for (var response in responseStream) {
        log.value = [
          ...log.value,
          'Greeter bi-directional received: ${response.message}'
        ];
      }
      log.value = [...log.value, 'Greeter bi-directional close'];
    }

    void testIdToken() async {
      final dio = Dio();
      final idToken = await getIdToken() ?? "";
      final response = await dio.get(
        'http://localhost:8080',
        options: Options(
          headers: {
            'Authorization': 'Bearer $idToken',
          },
        ),
      );
      log.value = [...log.value, 'Response: ${response.data}'];
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(title),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: log.value.map((v) => Text(v)).toList(),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end, // FABを右端に配置
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                onPressed: () async {
                  unary();
                },
                tooltip: 'unary',
                child: const Text('unary'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                onPressed: () async {
                  serverStream();
                },
                tooltip: 'server stream',
                child: const Text('server stream'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                onPressed: () async {
                  clientStream();
                },
                tooltip: 'client stream',
                child: const Text('client stream'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                onPressed: () async {
                  biDirectional();
                },
                tooltip: 'bi-directional',
                child: const Text('bi-directional'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                onPressed: () async {
                  testIdToken();
                },
                tooltip: 'id token',
                child: const Text('id token'),
              ),
            ),
          ],
        ));
  }
}
