//
//  Generated code. Do not modify.
//  source: aidog.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'aidog.pb.dart' as $0;

export 'aidog.pb.dart';

@$pb.GrpcServiceName('aidog.Aidog')
class AidogClient extends $grpc.Client {
  static final _$ask = $grpc.ClientMethod<$0.QaRequest, $0.QaResponse>(
      '/aidog.Aidog/Ask',
      ($0.QaRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.QaResponse.fromBuffer(value));

  AidogClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.QaResponse> ask($0.QaRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$ask, request, options: options);
  }
}

@$pb.GrpcServiceName('aidog.Aidog')
abstract class AidogServiceBase extends $grpc.Service {
  $core.String get $name => 'aidog.Aidog';

  AidogServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.QaRequest, $0.QaResponse>(
        'Ask',
        ask_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.QaRequest.fromBuffer(value),
        ($0.QaResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.QaResponse> ask_Pre($grpc.ServiceCall call, $async.Future<$0.QaRequest> request) async {
    return ask(call, await request);
  }

  $async.Future<$0.QaResponse> ask($grpc.ServiceCall call, $0.QaRequest request);
}
