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

