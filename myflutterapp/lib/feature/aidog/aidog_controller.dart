import 'dart:async';

import 'package:myflutterapp/driver/http/client_channel_establisher.dart';

typedef AiDogAskInterface = Future<String> Function(
    String question, ClientChannelEstablisher establishChannel);
