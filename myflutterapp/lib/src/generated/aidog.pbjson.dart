//
//  Generated code. Do not modify.
//  source: aidog.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use qaRequestDescriptor instead')
const QaRequest$json = {
  '1': 'QaRequest',
  '2': [
    {'1': 'question', '3': 1, '4': 1, '5': 9, '10': 'question'},
  ],
};

/// Descriptor for `QaRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List qaRequestDescriptor = $convert.base64Decode(
    'CglRYVJlcXVlc3QSGgoIcXVlc3Rpb24YASABKAlSCHF1ZXN0aW9u');

@$core.Deprecated('Use qaResponseDescriptor instead')
const QaResponse$json = {
  '1': 'QaResponse',
  '2': [
    {'1': 'answer', '3': 1, '4': 1, '5': 9, '10': 'answer'},
  ],
};

/// Descriptor for `QaResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List qaResponseDescriptor = $convert.base64Decode(
    'CgpRYVJlc3BvbnNlEhYKBmFuc3dlchgBIAEoCVIGYW5zd2Vy');

@$core.Deprecated('Use difyRequestDescriptor instead')
const DifyRequest$json = {
  '1': 'DifyRequest',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'question', '3': 2, '4': 1, '5': 9, '10': 'question'},
    {'1': 'conversation_id', '3': 3, '4': 1, '5': 9, '9': 0, '10': 'conversationId', '17': true},
  ],
  '8': [
    {'1': '_conversation_id'},
  ],
};

/// Descriptor for `DifyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List difyRequestDescriptor = $convert.base64Decode(
    'CgtEaWZ5UmVxdWVzdBISCgRuYW1lGAEgASgJUgRuYW1lEhoKCHF1ZXN0aW9uGAIgASgJUghxdW'
    'VzdGlvbhIsCg9jb252ZXJzYXRpb25faWQYAyABKAlIAFIOY29udmVyc2F0aW9uSWSIAQFCEgoQ'
    'X2NvbnZlcnNhdGlvbl9pZA==');

@$core.Deprecated('Use difyResponseDescriptor instead')
const DifyResponse$json = {
  '1': 'DifyResponse',
  '2': [
    {'1': 'task_id', '3': 1, '4': 1, '5': 9, '10': 'taskId'},
    {'1': 'conversation_id', '3': 2, '4': 1, '5': 9, '10': 'conversationId'},
    {'1': 'answer', '3': 3, '4': 1, '5': 9, '9': 0, '10': 'answer', '17': true},
  ],
  '8': [
    {'1': '_answer'},
  ],
};

/// Descriptor for `DifyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List difyResponseDescriptor = $convert.base64Decode(
    'CgxEaWZ5UmVzcG9uc2USFwoHdGFza19pZBgBIAEoCVIGdGFza0lkEicKD2NvbnZlcnNhdGlvbl'
    '9pZBgCIAEoCVIOY29udmVyc2F0aW9uSWQSGwoGYW5zd2VyGAMgASgJSABSBmFuc3dlcogBAUIJ'
    'CgdfYW5zd2Vy');

