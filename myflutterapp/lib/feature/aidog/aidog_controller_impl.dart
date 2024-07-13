import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';
import 'package:myflutterapp/driver/http/client_channel_establisher.dart';
import 'package:myflutterapp/feature/aidog/aidog_controller.dart';
import 'package:myflutterapp/src/generated/aidog.pbgrpc.dart';

AiDogAskInterface askFunc =
    (String question, ClientChannelEstablisher establishChannel) async {
  final channel = establishChannel(
    'localhost',
    port: 50051,
    options: const ChannelOptions(
      credentials: ChannelCredentials.insecure(),
    ),
  );
  final stub = AidogClient(channel);

  try {
    final response = await stub.ask(
      QaRequest()..question = question,
    );
    return response.answer;
  } catch (e) {
    if (kDebugMode) print('Caught error: $e');
    rethrow;
  } finally {
    await channel.shutdown();
  }
};
