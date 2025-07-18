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

import 'tracker.pbenum.dart';

export 'tracker.pbenum.dart';

class Empty extends $pb.GeneratedMessage {
  factory Empty() => create();
  Empty._() : super();
  factory Empty.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Empty.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Empty', package: const $pb.PackageName(_omitMessageNames ? '' : 'tracker'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Empty clone() => Empty()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Empty copyWith(void Function(Empty) updates) => super.copyWith((message) => updates(message as Empty)) as Empty;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Empty create() => Empty._();
  Empty createEmptyInstance() => create();
  static $pb.PbList<Empty> createRepeated() => $pb.PbList<Empty>();
  @$core.pragma('dart2js:noInline')
  static Empty getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Empty>(create);
  static Empty? _defaultInstance;
}

class Username extends $pb.GeneratedMessage {
  factory Username({
    $core.String? name,
  }) {
    final $result = create();
    if (name != null) {
      $result.name = name;
    }
    return $result;
  }
  Username._() : super();
  factory Username.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Username.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Username', package: const $pb.PackageName(_omitMessageNames ? '' : 'tracker'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Username clone() => Username()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Username copyWith(void Function(Username) updates) => super.copyWith((message) => updates(message as Username)) as Username;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Username create() => Username._();
  Username createEmptyInstance() => create();
  static $pb.PbList<Username> createRepeated() => $pb.PbList<Username>();
  @$core.pragma('dart2js:noInline')
  static Username getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Username>(create);
  static Username? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);
}

class User extends $pb.GeneratedMessage {
  factory User({
    $core.String? name,
    Location? currentLocation,
    $core.Map<$core.int, Path>? pathsTraveled,
  }) {
    final $result = create();
    if (name != null) {
      $result.name = name;
    }
    if (currentLocation != null) {
      $result.currentLocation = currentLocation;
    }
    if (pathsTraveled != null) {
      $result.pathsTraveled.addAll(pathsTraveled);
    }
    return $result;
  }
  User._() : super();
  factory User.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory User.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'User', package: const $pb.PackageName(_omitMessageNames ? '' : 'tracker'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOM<Location>(2, _omitFieldNames ? '' : 'currentLocation', protoName: 'currentLocation', subBuilder: Location.create)
    ..m<$core.int, Path>(3, _omitFieldNames ? '' : 'pathsTraveled', protoName: 'pathsTraveled', entryClassName: 'User.PathsTraveledEntry', keyFieldType: $pb.PbFieldType.O3, valueFieldType: $pb.PbFieldType.OM, valueCreator: Path.create, valueDefaultOrMaker: Path.getDefault, packageName: const $pb.PackageName('tracker'))
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  User clone() => User()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  User copyWith(void Function(User) updates) => super.copyWith((message) => updates(message as User)) as User;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static User create() => User._();
  User createEmptyInstance() => create();
  static $pb.PbList<User> createRepeated() => $pb.PbList<User>();
  @$core.pragma('dart2js:noInline')
  static User getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<User>(create);
  static User? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  @$pb.TagNumber(2)
  Location get currentLocation => $_getN(1);
  @$pb.TagNumber(2)
  set currentLocation(Location v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasCurrentLocation() => $_has(1);
  @$pb.TagNumber(2)
  void clearCurrentLocation() => clearField(2);
  @$pb.TagNumber(2)
  Location ensureCurrentLocation() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.Map<$core.int, Path> get pathsTraveled => $_getMap(2);
}

class Location extends $pb.GeneratedMessage {
  factory Location({
    $core.double? x,
    $core.double? y,
  }) {
    final $result = create();
    if (x != null) {
      $result.x = x;
    }
    if (y != null) {
      $result.y = y;
    }
    return $result;
  }
  Location._() : super();
  factory Location.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Location.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Location', package: const $pb.PackageName(_omitMessageNames ? '' : 'tracker'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'x', $pb.PbFieldType.OF)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'y', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Location clone() => Location()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Location copyWith(void Function(Location) updates) => super.copyWith((message) => updates(message as Location)) as Location;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Location create() => Location._();
  Location createEmptyInstance() => create();
  static $pb.PbList<Location> createRepeated() => $pb.PbList<Location>();
  @$core.pragma('dart2js:noInline')
  static Location getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Location>(create);
  static Location? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get x => $_getN(0);
  @$pb.TagNumber(1)
  set x($core.double v) { $_setFloat(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasX() => $_has(0);
  @$pb.TagNumber(1)
  void clearX() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get y => $_getN(1);
  @$pb.TagNumber(2)
  set y($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasY() => $_has(1);
  @$pb.TagNumber(2)
  void clearY() => clearField(2);
}

class Path extends $pb.GeneratedMessage {
  factory Path({
    $core.Iterable<Location>? pathTraveled,
  }) {
    final $result = create();
    if (pathTraveled != null) {
      $result.pathTraveled.addAll(pathTraveled);
    }
    return $result;
  }
  Path._() : super();
  factory Path.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Path.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Path', package: const $pb.PackageName(_omitMessageNames ? '' : 'tracker'), createEmptyInstance: create)
    ..pc<Location>(1, _omitFieldNames ? '' : 'pathTraveled', $pb.PbFieldType.PM, protoName: 'pathTraveled', subBuilder: Location.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Path clone() => Path()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Path copyWith(void Function(Path) updates) => super.copyWith((message) => updates(message as Path)) as Path;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Path create() => Path._();
  Path createEmptyInstance() => create();
  static $pb.PbList<Path> createRepeated() => $pb.PbList<Path>();
  @$core.pragma('dart2js:noInline')
  static Path getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Path>(create);
  static Path? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Location> get pathTraveled => $_getList(0);
}

class UserResponse extends $pb.GeneratedMessage {
  factory UserResponse({
    TrackerStatus? status,
    $core.String? message,
    User? user,
  }) {
    final $result = create();
    if (status != null) {
      $result.status = status;
    }
    if (message != null) {
      $result.message = message;
    }
    if (user != null) {
      $result.user = user;
    }
    return $result;
  }
  UserResponse._() : super();
  factory UserResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UserResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UserResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'tracker'), createEmptyInstance: create)
    ..e<TrackerStatus>(1, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: TrackerStatus.OK, valueOf: TrackerStatus.valueOf, enumValues: TrackerStatus.values)
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..aOM<User>(3, _omitFieldNames ? '' : 'user', subBuilder: User.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UserResponse clone() => UserResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UserResponse copyWith(void Function(UserResponse) updates) => super.copyWith((message) => updates(message as UserResponse)) as UserResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserResponse create() => UserResponse._();
  UserResponse createEmptyInstance() => create();
  static $pb.PbList<UserResponse> createRepeated() => $pb.PbList<UserResponse>();
  @$core.pragma('dart2js:noInline')
  static UserResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UserResponse>(create);
  static UserResponse? _defaultInstance;

  @$pb.TagNumber(1)
  TrackerStatus get status => $_getN(0);
  @$pb.TagNumber(1)
  set status(TrackerStatus v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);

  @$pb.TagNumber(3)
  User get user => $_getN(2);
  @$pb.TagNumber(3)
  set user(User v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasUser() => $_has(2);
  @$pb.TagNumber(3)
  void clearUser() => clearField(3);
  @$pb.TagNumber(3)
  User ensureUser() => $_ensure(2);
}

class RealTimeUserResponse extends $pb.GeneratedMessage {
  factory RealTimeUserResponse({
    TrackerStatus? status,
    $core.String? message,
    DynamoDBEvent? eventType,
    $core.String? userName,
    Location? currentLocation,
  }) {
    final $result = create();
    if (status != null) {
      $result.status = status;
    }
    if (message != null) {
      $result.message = message;
    }
    if (eventType != null) {
      $result.eventType = eventType;
    }
    if (userName != null) {
      $result.userName = userName;
    }
    if (currentLocation != null) {
      $result.currentLocation = currentLocation;
    }
    return $result;
  }
  RealTimeUserResponse._() : super();
  factory RealTimeUserResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RealTimeUserResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RealTimeUserResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'tracker'), createEmptyInstance: create)
    ..e<TrackerStatus>(1, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: TrackerStatus.OK, valueOf: TrackerStatus.valueOf, enumValues: TrackerStatus.values)
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..e<DynamoDBEvent>(3, _omitFieldNames ? '' : 'eventType', $pb.PbFieldType.OE, protoName: 'eventType', defaultOrMaker: DynamoDBEvent.INSERT, valueOf: DynamoDBEvent.valueOf, enumValues: DynamoDBEvent.values)
    ..aOS(4, _omitFieldNames ? '' : 'userName', protoName: 'userName')
    ..aOM<Location>(5, _omitFieldNames ? '' : 'currentLocation', protoName: 'currentLocation', subBuilder: Location.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RealTimeUserResponse clone() => RealTimeUserResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RealTimeUserResponse copyWith(void Function(RealTimeUserResponse) updates) => super.copyWith((message) => updates(message as RealTimeUserResponse)) as RealTimeUserResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RealTimeUserResponse create() => RealTimeUserResponse._();
  RealTimeUserResponse createEmptyInstance() => create();
  static $pb.PbList<RealTimeUserResponse> createRepeated() => $pb.PbList<RealTimeUserResponse>();
  @$core.pragma('dart2js:noInline')
  static RealTimeUserResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RealTimeUserResponse>(create);
  static RealTimeUserResponse? _defaultInstance;

  @$pb.TagNumber(1)
  TrackerStatus get status => $_getN(0);
  @$pb.TagNumber(1)
  set status(TrackerStatus v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);

  @$pb.TagNumber(3)
  DynamoDBEvent get eventType => $_getN(2);
  @$pb.TagNumber(3)
  set eventType(DynamoDBEvent v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasEventType() => $_has(2);
  @$pb.TagNumber(3)
  void clearEventType() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get userName => $_getSZ(3);
  @$pb.TagNumber(4)
  set userName($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasUserName() => $_has(3);
  @$pb.TagNumber(4)
  void clearUserName() => clearField(4);

  @$pb.TagNumber(5)
  Location get currentLocation => $_getN(4);
  @$pb.TagNumber(5)
  set currentLocation(Location v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasCurrentLocation() => $_has(4);
  @$pb.TagNumber(5)
  void clearCurrentLocation() => clearField(5);
  @$pb.TagNumber(5)
  Location ensureCurrentLocation() => $_ensure(4);
}

class LocationResponse extends $pb.GeneratedMessage {
  factory LocationResponse({
    TrackerStatus? status,
    $core.String? message,
    Username? userName,
    Location? location,
  }) {
    final $result = create();
    if (status != null) {
      $result.status = status;
    }
    if (message != null) {
      $result.message = message;
    }
    if (userName != null) {
      $result.userName = userName;
    }
    if (location != null) {
      $result.location = location;
    }
    return $result;
  }
  LocationResponse._() : super();
  factory LocationResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LocationResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LocationResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'tracker'), createEmptyInstance: create)
    ..e<TrackerStatus>(1, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: TrackerStatus.OK, valueOf: TrackerStatus.valueOf, enumValues: TrackerStatus.values)
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..aOM<Username>(3, _omitFieldNames ? '' : 'userName', protoName: 'userName', subBuilder: Username.create)
    ..aOM<Location>(4, _omitFieldNames ? '' : 'location', subBuilder: Location.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LocationResponse clone() => LocationResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LocationResponse copyWith(void Function(LocationResponse) updates) => super.copyWith((message) => updates(message as LocationResponse)) as LocationResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LocationResponse create() => LocationResponse._();
  LocationResponse createEmptyInstance() => create();
  static $pb.PbList<LocationResponse> createRepeated() => $pb.PbList<LocationResponse>();
  @$core.pragma('dart2js:noInline')
  static LocationResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LocationResponse>(create);
  static LocationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  TrackerStatus get status => $_getN(0);
  @$pb.TagNumber(1)
  set status(TrackerStatus v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);

  @$pb.TagNumber(3)
  Username get userName => $_getN(2);
  @$pb.TagNumber(3)
  set userName(Username v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasUserName() => $_has(2);
  @$pb.TagNumber(3)
  void clearUserName() => clearField(3);
  @$pb.TagNumber(3)
  Username ensureUserName() => $_ensure(2);

  @$pb.TagNumber(4)
  Location get location => $_getN(3);
  @$pb.TagNumber(4)
  set location(Location v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasLocation() => $_has(3);
  @$pb.TagNumber(4)
  void clearLocation() => clearField(4);
  @$pb.TagNumber(4)
  Location ensureLocation() => $_ensure(3);
}

class PathRequest extends $pb.GeneratedMessage {
  factory PathRequest({
    $core.String? userName,
    $core.String? pathKey,
  }) {
    final $result = create();
    if (userName != null) {
      $result.userName = userName;
    }
    if (pathKey != null) {
      $result.pathKey = pathKey;
    }
    return $result;
  }
  PathRequest._() : super();
  factory PathRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PathRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PathRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'tracker'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userName', protoName: 'userName')
    ..aOS(2, _omitFieldNames ? '' : 'pathKey', protoName: 'pathKey')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PathRequest clone() => PathRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PathRequest copyWith(void Function(PathRequest) updates) => super.copyWith((message) => updates(message as PathRequest)) as PathRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PathRequest create() => PathRequest._();
  PathRequest createEmptyInstance() => create();
  static $pb.PbList<PathRequest> createRepeated() => $pb.PbList<PathRequest>();
  @$core.pragma('dart2js:noInline')
  static PathRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PathRequest>(create);
  static PathRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userName => $_getSZ(0);
  @$pb.TagNumber(1)
  set userName($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserName() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserName() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get pathKey => $_getSZ(1);
  @$pb.TagNumber(2)
  set pathKey($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPathKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearPathKey() => clearField(2);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
