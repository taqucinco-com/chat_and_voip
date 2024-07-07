import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';
import 'package:myflutterapp/src/generated/aidog.pbgrpc.dart';

typedef AiDogAskInterface = Future<String> Function(String question);

AiDogAskInterface askFunc = (String question) async {
  final channel = ClientChannel(
    'localhost',
    port: 50051,
    options: const ChannelOptions(
      credentials: ChannelCredentials.insecure(),
      // codecRegistry: CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]),
    ),
  );
  final stub = AidogClient(channel);

  try {
    final response = await stub.ask(
      QaRequest()..question = question,
      options: CallOptions(compression: const GzipCodec()),
    );
    return response.answer;
  } catch (e) {
    if (kDebugMode) print('Caught error: $e');
    rethrow;
  } finally {
    await channel.shutdown();
  }
};
