//
//  Generated code. Do not modify.
//  source: tracker.proto
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

import 'tracker.pb.dart' as $0;

export 'tracker.pb.dart';

@$pb.GrpcServiceName('tracker.Tracker')
class TrackerClient extends $grpc.Client {
  static final _$createUser = $grpc.ClientMethod<$0.Username, $0.UserResponse>(
      '/tracker.Tracker/CreateUser',
      ($0.Username value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.UserResponse.fromBuffer(value));
  static final _$getUsers = $grpc.ClientMethod<$0.Empty, $0.UserResponse>(
      '/tracker.Tracker/GetUsers',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.UserResponse.fromBuffer(value));
  static final _$getUser = $grpc.ClientMethod<$0.Username, $0.UserResponse>(
      '/tracker.Tracker/GetUser',
      ($0.Username value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.UserResponse.fromBuffer(value));
  static final _$getLocation = $grpc.ClientMethod<$0.Username, $0.UserResponse>(
      '/tracker.Tracker/GetLocation',
      ($0.Username value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.UserResponse.fromBuffer(value));
  static final _$getCurrentLocation = $grpc.ClientMethod<$0.Username, $0.LocationResponse>(
      '/tracker.Tracker/GetCurrentLocation',
      ($0.Username value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.LocationResponse.fromBuffer(value));
  static final _$getLastPath = $grpc.ClientMethod<$0.Username, $0.LocationResponse>(
      '/tracker.Tracker/GetLastPath',
      ($0.Username value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.LocationResponse.fromBuffer(value));
  static final _$getPath = $grpc.ClientMethod<$0.PathRequest, $0.LocationResponse>(
      '/tracker.Tracker/GetPath',
      ($0.PathRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.LocationResponse.fromBuffer(value));
  static final _$moveUser = $grpc.ClientMethod<$0.Username, $0.UserResponse>(
      '/tracker.Tracker/MoveUser',
      ($0.Username value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.UserResponse.fromBuffer(value));
  static final _$takeTrip = $grpc.ClientMethod<$0.Username, $0.UserResponse>(
      '/tracker.Tracker/TakeTrip',
      ($0.Username value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.UserResponse.fromBuffer(value));
  static final _$getLocations = $grpc.ClientMethod<$0.Username, $0.LocationResponse>(
      '/tracker.Tracker/GetLocations',
      ($0.Username value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.LocationResponse.fromBuffer(value));

  TrackerClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.UserResponse> createUser($0.Username request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$createUser, request, options: options);
  }

  $grpc.ResponseStream<$0.UserResponse> getUsers($0.Empty request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$getUsers, $async.Stream.fromIterable([request]), options: options);
  }

  $grpc.ResponseFuture<$0.UserResponse> getUser($0.Username request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getUser, request, options: options);
  }

  $grpc.ResponseStream<$0.UserResponse> getLocation($0.Username request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$getLocation, $async.Stream.fromIterable([request]), options: options);
  }

  $grpc.ResponseFuture<$0.LocationResponse> getCurrentLocation($0.Username request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getCurrentLocation, request, options: options);
  }

  $grpc.ResponseStream<$0.LocationResponse> getLastPath($0.Username request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$getLastPath, $async.Stream.fromIterable([request]), options: options);
  }

  $grpc.ResponseStream<$0.LocationResponse> getPath($0.PathRequest request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$getPath, $async.Stream.fromIterable([request]), options: options);
  }

  $grpc.ResponseFuture<$0.UserResponse> moveUser($0.Username request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$moveUser, request, options: options);
  }

  $grpc.ResponseFuture<$0.UserResponse> takeTrip($0.Username request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$takeTrip, request, options: options);
  }

  $grpc.ResponseStream<$0.LocationResponse> getLocations($async.Stream<$0.Username> request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$getLocations, request, options: options);
  }
}

@$pb.GrpcServiceName('tracker.Tracker')
abstract class TrackerServiceBase extends $grpc.Service {
  $core.String get $name => 'tracker.Tracker';

  TrackerServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Username, $0.UserResponse>(
        'CreateUser',
        createUser_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Username.fromBuffer(value),
        ($0.UserResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.UserResponse>(
        'GetUsers',
        getUsers_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.UserResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Username, $0.UserResponse>(
        'GetUser',
        getUser_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Username.fromBuffer(value),
        ($0.UserResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Username, $0.UserResponse>(
        'GetLocation',
        getLocation_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.Username.fromBuffer(value),
        ($0.UserResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Username, $0.LocationResponse>(
        'GetCurrentLocation',
        getCurrentLocation_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Username.fromBuffer(value),
        ($0.LocationResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Username, $0.LocationResponse>(
        'GetLastPath',
        getLastPath_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.Username.fromBuffer(value),
        ($0.LocationResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.PathRequest, $0.LocationResponse>(
        'GetPath',
        getPath_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.PathRequest.fromBuffer(value),
        ($0.LocationResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Username, $0.UserResponse>(
        'MoveUser',
        moveUser_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Username.fromBuffer(value),
        ($0.UserResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Username, $0.UserResponse>(
        'TakeTrip',
        takeTrip_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Username.fromBuffer(value),
        ($0.UserResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Username, $0.LocationResponse>(
        'GetLocations',
        getLocations,
        true,
        true,
        ($core.List<$core.int> value) => $0.Username.fromBuffer(value),
        ($0.LocationResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.UserResponse> createUser_Pre($grpc.ServiceCall call, $async.Future<$0.Username> request) async {
    return createUser(call, await request);
  }

  $async.Stream<$0.UserResponse> getUsers_Pre($grpc.ServiceCall call, $async.Future<$0.Empty> request) async* {
    yield* getUsers(call, await request);
  }

  $async.Future<$0.UserResponse> getUser_Pre($grpc.ServiceCall call, $async.Future<$0.Username> request) async {
    return getUser(call, await request);
  }

  $async.Stream<$0.UserResponse> getLocation_Pre($grpc.ServiceCall call, $async.Future<$0.Username> request) async* {
    yield* getLocation(call, await request);
  }

  $async.Future<$0.LocationResponse> getCurrentLocation_Pre($grpc.ServiceCall call, $async.Future<$0.Username> request) async {
    return getCurrentLocation(call, await request);
  }

  $async.Stream<$0.LocationResponse> getLastPath_Pre($grpc.ServiceCall call, $async.Future<$0.Username> request) async* {
    yield* getLastPath(call, await request);
  }

  $async.Stream<$0.LocationResponse> getPath_Pre($grpc.ServiceCall call, $async.Future<$0.PathRequest> request) async* {
    yield* getPath(call, await request);
  }

  $async.Future<$0.UserResponse> moveUser_Pre($grpc.ServiceCall call, $async.Future<$0.Username> request) async {
    return moveUser(call, await request);
  }

  $async.Future<$0.UserResponse> takeTrip_Pre($grpc.ServiceCall call, $async.Future<$0.Username> request) async {
    return takeTrip(call, await request);
  }

  $async.Future<$0.UserResponse> createUser($grpc.ServiceCall call, $0.Username request);
  $async.Stream<$0.UserResponse> getUsers($grpc.ServiceCall call, $0.Empty request);
  $async.Future<$0.UserResponse> getUser($grpc.ServiceCall call, $0.Username request);
  $async.Stream<$0.UserResponse> getLocation($grpc.ServiceCall call, $0.Username request);
  $async.Future<$0.LocationResponse> getCurrentLocation($grpc.ServiceCall call, $0.Username request);
  $async.Stream<$0.LocationResponse> getLastPath($grpc.ServiceCall call, $0.Username request);
  $async.Stream<$0.LocationResponse> getPath($grpc.ServiceCall call, $0.PathRequest request);
  $async.Future<$0.UserResponse> moveUser($grpc.ServiceCall call, $0.Username request);
  $async.Future<$0.UserResponse> takeTrip($grpc.ServiceCall call, $0.Username request);
  $async.Stream<$0.LocationResponse> getLocations($grpc.ServiceCall call, $async.Stream<$0.Username> request);
}
