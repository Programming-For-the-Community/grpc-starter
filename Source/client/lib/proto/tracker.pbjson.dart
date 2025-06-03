//
//  Generated code. Do not modify.
//  source: tracker.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use trackerStatusDescriptor instead')
const TrackerStatus$json = {
  '1': 'TrackerStatus',
  '2': [
    {'1': 'OK', '2': 0},
    {'1': 'USER_ALREADY_EXISTS', '2': 400},
    {'1': 'USER_NOT_CREATED', '2': 401},
    {'1': 'USER_NOT_FOUND', '2': 402},
    {'1': 'PATH_NOT_FOUND', '2': 403},
  ],
};

/// Descriptor for `TrackerStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List trackerStatusDescriptor = $convert.base64Decode(
    'Cg1UcmFja2VyU3RhdHVzEgYKAk9LEAASGAoTVVNFUl9BTFJFQURZX0VYSVNUUxCQAxIVChBVU0'
    'VSX05PVF9DUkVBVEVEEJEDEhMKDlVTRVJfTk9UX0ZPVU5EEJIDEhMKDlBBVEhfTk9UX0ZPVU5E'
    'EJMD');

@$core.Deprecated('Use emptyDescriptor instead')
const Empty$json = {
  '1': 'Empty',
};

/// Descriptor for `Empty`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List emptyDescriptor = $convert.base64Decode(
    'CgVFbXB0eQ==');

@$core.Deprecated('Use usernameDescriptor instead')
const Username$json = {
  '1': 'Username',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `Username`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List usernameDescriptor = $convert.base64Decode(
    'CghVc2VybmFtZRISCgRuYW1lGAEgASgJUgRuYW1l');

@$core.Deprecated('Use userDescriptor instead')
const User$json = {
  '1': 'User',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'currentLocation', '3': 2, '4': 1, '5': 11, '6': '.tracker.Location', '10': 'currentLocation'},
    {'1': 'pathsTraveled', '3': 3, '4': 3, '5': 11, '6': '.tracker.User.PathsTraveledEntry', '10': 'pathsTraveled'},
  ],
  '3': [User_PathsTraveledEntry$json],
};

@$core.Deprecated('Use userDescriptor instead')
const User_PathsTraveledEntry$json = {
  '1': 'PathsTraveledEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 5, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 11, '6': '.tracker.Path', '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `User`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userDescriptor = $convert.base64Decode(
    'CgRVc2VyEhIKBG5hbWUYASABKAlSBG5hbWUSOwoPY3VycmVudExvY2F0aW9uGAIgASgLMhEudH'
    'JhY2tlci5Mb2NhdGlvblIPY3VycmVudExvY2F0aW9uEkYKDXBhdGhzVHJhdmVsZWQYAyADKAsy'
    'IC50cmFja2VyLlVzZXIuUGF0aHNUcmF2ZWxlZEVudHJ5Ug1wYXRoc1RyYXZlbGVkGk8KElBhdG'
    'hzVHJhdmVsZWRFbnRyeRIQCgNrZXkYASABKAVSA2tleRIjCgV2YWx1ZRgCIAEoCzINLnRyYWNr'
    'ZXIuUGF0aFIFdmFsdWU6AjgB');

@$core.Deprecated('Use locationDescriptor instead')
const Location$json = {
  '1': 'Location',
  '2': [
    {'1': 'x', '3': 1, '4': 1, '5': 2, '9': 0, '10': 'x', '17': true},
    {'1': 'y', '3': 2, '4': 1, '5': 2, '9': 1, '10': 'y', '17': true},
  ],
  '8': [
    {'1': '_x'},
    {'1': '_y'},
  ],
};

/// Descriptor for `Location`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List locationDescriptor = $convert.base64Decode(
    'CghMb2NhdGlvbhIRCgF4GAEgASgCSABSAXiIAQESEQoBeRgCIAEoAkgBUgF5iAEBQgQKAl94Qg'
    'QKAl95');

@$core.Deprecated('Use pathDescriptor instead')
const Path$json = {
  '1': 'Path',
  '2': [
    {'1': 'pathTraveled', '3': 1, '4': 3, '5': 11, '6': '.tracker.Location', '10': 'pathTraveled'},
  ],
};

/// Descriptor for `Path`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pathDescriptor = $convert.base64Decode(
    'CgRQYXRoEjUKDHBhdGhUcmF2ZWxlZBgBIAMoCzIRLnRyYWNrZXIuTG9jYXRpb25SDHBhdGhUcm'
    'F2ZWxlZA==');

@$core.Deprecated('Use userResponseDescriptor instead')
const UserResponse$json = {
  '1': 'UserResponse',
  '2': [
    {'1': 'status', '3': 1, '4': 1, '5': 14, '6': '.tracker.TrackerStatus', '10': 'status'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'user', '3': 3, '4': 1, '5': 11, '6': '.tracker.User', '9': 0, '10': 'user', '17': true},
  ],
  '8': [
    {'1': '_user'},
  ],
};

/// Descriptor for `UserResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userResponseDescriptor = $convert.base64Decode(
    'CgxVc2VyUmVzcG9uc2USLgoGc3RhdHVzGAEgASgOMhYudHJhY2tlci5UcmFja2VyU3RhdHVzUg'
    'ZzdGF0dXMSGAoHbWVzc2FnZRgCIAEoCVIHbWVzc2FnZRImCgR1c2VyGAMgASgLMg0udHJhY2tl'
    'ci5Vc2VySABSBHVzZXKIAQFCBwoFX3VzZXI=');

@$core.Deprecated('Use locationResponseDescriptor instead')
const LocationResponse$json = {
  '1': 'LocationResponse',
  '2': [
    {'1': 'status', '3': 1, '4': 1, '5': 14, '6': '.tracker.TrackerStatus', '10': 'status'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'userName', '3': 3, '4': 1, '5': 11, '6': '.tracker.Username', '10': 'userName'},
    {'1': 'location', '3': 4, '4': 1, '5': 11, '6': '.tracker.Location', '9': 0, '10': 'location', '17': true},
  ],
  '8': [
    {'1': '_location'},
  ],
};

/// Descriptor for `LocationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List locationResponseDescriptor = $convert.base64Decode(
    'ChBMb2NhdGlvblJlc3BvbnNlEi4KBnN0YXR1cxgBIAEoDjIWLnRyYWNrZXIuVHJhY2tlclN0YX'
    'R1c1IGc3RhdHVzEhgKB21lc3NhZ2UYAiABKAlSB21lc3NhZ2USLQoIdXNlck5hbWUYAyABKAsy'
    'ES50cmFja2VyLlVzZXJuYW1lUgh1c2VyTmFtZRIyCghsb2NhdGlvbhgEIAEoCzIRLnRyYWNrZX'
    'IuTG9jYXRpb25IAFIIbG9jYXRpb26IAQFCCwoJX2xvY2F0aW9u');

@$core.Deprecated('Use pathRequestDescriptor instead')
const PathRequest$json = {
  '1': 'PathRequest',
  '2': [
    {'1': 'userName', '3': 1, '4': 1, '5': 9, '10': 'userName'},
    {'1': 'pathKey', '3': 2, '4': 1, '5': 9, '10': 'pathKey'},
  ],
};

/// Descriptor for `PathRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pathRequestDescriptor = $convert.base64Decode(
    'CgtQYXRoUmVxdWVzdBIaCgh1c2VyTmFtZRgBIAEoCVIIdXNlck5hbWUSGAoHcGF0aEtleRgCIA'
    'EoCVIHcGF0aEtleQ==');

