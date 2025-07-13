//
//  Generated code. Do not modify.
//  source: tracker.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class TrackerStatus extends $pb.ProtobufEnum {
  static const TrackerStatus OK = TrackerStatus._(0, _omitEnumNames ? '' : 'OK');
  static const TrackerStatus USER_ALREADY_EXISTS = TrackerStatus._(400, _omitEnumNames ? '' : 'USER_ALREADY_EXISTS');
  static const TrackerStatus USER_NOT_CREATED = TrackerStatus._(401, _omitEnumNames ? '' : 'USER_NOT_CREATED');
  static const TrackerStatus USER_NOT_FOUND = TrackerStatus._(402, _omitEnumNames ? '' : 'USER_NOT_FOUND');
  static const TrackerStatus PATH_NOT_FOUND = TrackerStatus._(403, _omitEnumNames ? '' : 'PATH_NOT_FOUND');
  static const TrackerStatus NO_RECORDS = TrackerStatus._(404, _omitEnumNames ? '' : 'NO_RECORDS');
  static const TrackerStatus MISSING_USER_DATA = TrackerStatus._(405, _omitEnumNames ? '' : 'MISSING_USER_DATA');
  static const TrackerStatus USER_STREAM_ERROR = TrackerStatus._(406, _omitEnumNames ? '' : 'USER_STREAM_ERROR');

  static const $core.List<TrackerStatus> values = <TrackerStatus> [
    OK,
    USER_ALREADY_EXISTS,
    USER_NOT_CREATED,
    USER_NOT_FOUND,
    PATH_NOT_FOUND,
    NO_RECORDS,
    MISSING_USER_DATA,
    USER_STREAM_ERROR,
  ];

  static final $core.Map<$core.int, TrackerStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static TrackerStatus? valueOf($core.int value) => _byValue[value];

  const TrackerStatus._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
