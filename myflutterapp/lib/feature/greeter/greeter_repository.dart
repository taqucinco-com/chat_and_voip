import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';
import 'package:myflutterapp/src/generated/helloworld.pbgrpc.dart';

Future<String> hello() async {
  final channel = ClientChannel(
    'localhost',
    port: 50051,
    options: const ChannelOptions(
      credentials: ChannelCredentials.insecure(),
      // codecRegistry: CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]),
    ),
  );
  final stub = GreeterClient(channel);

  try {
    const name = 'flutter world';
    final response = await stub.sayHello(
      HelloRequest()..name = name,
      // options: CallOptions(compression: const GzipCodec()),
    );
    return response.message;
  } catch (e) {
    if (kDebugMode) print('Caught error: $e');
    rethrow;
  } finally {
    await channel.shutdown();
  }
}

Stream<String> helloAgain() async* {
  final channel = ClientChannel(
    'localhost',
    port: 50051,
    options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
  );
  final stub = GreeterClient(channel);

  try {
    const name = 'flutter world';
    final request = HelloRequest()..name = name;
    await for (var response in stub.sayHelloAgain(request)) {
      yield response.message;
    }
  } catch (e) {
    if (kDebugMode) print('Caught error: $e');
    rethrow;
  } finally {
    await channel.shutdown();
  }
}

Future<String> helloToMany() async {
  final channel = ClientChannel(
    'localhost',
    port: 50051,
    options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
  );
  final stub = GreeterClient(channel);

  Stream<HelloRequest> requestStream() async* {
    yield HelloRequest()..name = 'taro';
    await Future.delayed(const Duration(milliseconds: 1000));
    yield HelloRequest()..name = 'hanako';
    await Future.delayed(const Duration(milliseconds: 1000));
  }

  try {
    final response = await stub.sayHelloToMany(requestStream());
    return response.message;
  } catch (e) {
    if (kDebugMode) print('Caught error: $e');
    rethrow;
  } finally {
    await channel.shutdown();
  }
}

Stream<String> helloChat() async* {
  final channel = ClientChannel(
    'localhost',
    port: 50051,
    options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
  );
  final stub = GreeterClient(channel);

  Stream<HelloRequest> requestStream() async* {
    yield HelloRequest()..name = 'taro';
    await Future.delayed(const Duration(milliseconds: 5000));
    yield HelloRequest()..name = 'hanako';
    await Future.delayed(const Duration(milliseconds: 5000));
  }

  final responseStream = stub.sayChat(requestStream());
  try {
    await for (var response in responseStream) {
      yield response.message;
    }
  } catch (e) {
    if (kDebugMode) print('Caught error: $e');
    rethrow;
  } finally {
    await channel.shutdown();
  }
}

Stream<HelloResponse> establishChat(Stream<HelloRequest> request) {
  try {
    final channel = ClientChannel(
      'localhost',
      port: 50051,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );
    final stub = GreeterClient(channel);

    final controller = StreamController<HelloResponse>();
    final response = stub.sayChat(request);

    final subscription = response.listen((value) {
      controller.sink.add(value);
    });

    controller.onCancel = () async {
      await subscription.cancel();
      await response.cancel();
      await channel.shutdown();
    };

    return controller.stream;
  } catch (e) {
    if (kDebugMode) print(e);
    rethrow;
  }
}
