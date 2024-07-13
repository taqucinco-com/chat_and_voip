import 'package:grpc/grpc.dart';

typedef ClientChannelEstablisher = ClientChannel Function(Object host,
    {int port, ChannelOptions options});
