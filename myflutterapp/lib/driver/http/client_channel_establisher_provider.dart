import 'package:grpc/grpc_connection_interface.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myflutterapp/driver/http/client_channel_establisher.dart';

final clientChannelEstablisherProvider = Provider<ClientChannelEstablisher>(
  (ref) => (
    Object host, {
    int port = 443,
    ChannelOptions options = const ChannelOptions(),
  }) =>
      ClientChannel(
        host,
        port: port,
        options: options,
      ),
);
