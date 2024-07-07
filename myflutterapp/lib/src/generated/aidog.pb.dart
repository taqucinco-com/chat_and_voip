//
//  Generated code. Do not modify.
//  source: aidog.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class QaRequest extends $pb.GeneratedMessage {
  factory QaRequest({
    $core.String? question,
  }) {
    final $result = create();
    if (question != null) {
      $result.question = question;
    }
    return $result;
  }
  QaRequest._() : super();
  factory QaRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QaRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'QaRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'aidog'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'question')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QaRequest clone() => QaRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QaRequest copyWith(void Function(QaRequest) updates) => super.copyWith((message) => updates(message as QaRequest)) as QaRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static QaRequest create() => QaRequest._();
  QaRequest createEmptyInstance() => create();
  static $pb.PbList<QaRequest> createRepeated() => $pb.PbList<QaRequest>();
  @$core.pragma('dart2js:noInline')
  static QaRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QaRequest>(create);
  static QaRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get question => $_getSZ(0);
  @$pb.TagNumber(1)
  set question($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasQuestion() => $_has(0);
  @$pb.TagNumber(1)
  void clearQuestion() => clearField(1);
}

class QaResponse extends $pb.GeneratedMessage {
  factory QaResponse({
    $core.String? answer,
  }) {
    final $result = create();
    if (answer != null) {
      $result.answer = answer;
    }
    return $result;
  }
  QaResponse._() : super();
  factory QaResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QaResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'QaResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'aidog'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'answer')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QaResponse clone() => QaResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QaResponse copyWith(void Function(QaResponse) updates) => super.copyWith((message) => updates(message as QaResponse)) as QaResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static QaResponse create() => QaResponse._();
  QaResponse createEmptyInstance() => create();
  static $pb.PbList<QaResponse> createRepeated() => $pb.PbList<QaResponse>();
  @$core.pragma('dart2js:noInline')
  static QaResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QaResponse>(create);
  static QaResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get answer => $_getSZ(0);
  @$pb.TagNumber(1)
  set answer($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAnswer() => $_has(0);
  @$pb.TagNumber(1)
  void clearAnswer() => clearField(1);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
