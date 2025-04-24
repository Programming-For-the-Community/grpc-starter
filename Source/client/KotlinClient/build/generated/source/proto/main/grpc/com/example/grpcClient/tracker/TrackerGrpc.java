package com.example.grpcClient.tracker;

import static io.grpc.MethodDescriptor.generateFullMethodName;

/**
 */
@javax.annotation.Generated(
    value = "by gRPC proto compiler (version 1.56.0)",
    comments = "Source: tracker.proto")
@io.grpc.stub.annotations.GrpcGenerated
public final class TrackerGrpc {

  private TrackerGrpc() {}

  public static final String SERVICE_NAME = "Tracker";

  // Static method descriptors that strictly reflect the proto.
  private static volatile io.grpc.MethodDescriptor<com.example.grpcClient.tracker.TrackerOuterClass.Username,
      com.example.grpcClient.tracker.TrackerOuterClass.UserResponse> getCreateUserMethod;

  @io.grpc.stub.annotations.RpcMethod(
      fullMethodName = SERVICE_NAME + '/' + "CreateUser",
      requestType = com.example.grpcClient.tracker.TrackerOuterClass.Username.class,
      responseType = com.example.grpcClient.tracker.TrackerOuterClass.UserResponse.class,
      methodType = io.grpc.MethodDescriptor.MethodType.UNARY)
  public static io.grpc.MethodDescriptor<com.example.grpcClient.tracker.TrackerOuterClass.Username,
      com.example.grpcClient.tracker.TrackerOuterClass.UserResponse> getCreateUserMethod() {
    io.grpc.MethodDescriptor<com.example.grpcClient.tracker.TrackerOuterClass.Username, com.example.grpcClient.tracker.TrackerOuterClass.UserResponse> getCreateUserMethod;
    if ((getCreateUserMethod = TrackerGrpc.getCreateUserMethod) == null) {
      synchronized (TrackerGrpc.class) {
        if ((getCreateUserMethod = TrackerGrpc.getCreateUserMethod) == null) {
          TrackerGrpc.getCreateUserMethod = getCreateUserMethod =
              io.grpc.MethodDescriptor.<com.example.grpcClient.tracker.TrackerOuterClass.Username, com.example.grpcClient.tracker.TrackerOuterClass.UserResponse>newBuilder()
              .setType(io.grpc.MethodDescriptor.MethodType.UNARY)
              .setFullMethodName(generateFullMethodName(SERVICE_NAME, "CreateUser"))
              .setSampledToLocalTracing(true)
              .setRequestMarshaller(io.grpc.protobuf.ProtoUtils.marshaller(
                  com.example.grpcClient.tracker.TrackerOuterClass.Username.getDefaultInstance()))
              .setResponseMarshaller(io.grpc.protobuf.ProtoUtils.marshaller(
                  com.example.grpcClient.tracker.TrackerOuterClass.UserResponse.getDefaultInstance()))
              .setSchemaDescriptor(new TrackerMethodDescriptorSupplier("CreateUser"))
              .build();
        }
      }
    }
    return getCreateUserMethod;
  }

  private static volatile io.grpc.MethodDescriptor<com.google.protobuf.Empty,
      com.example.grpcClient.tracker.TrackerOuterClass.UserResponse> getGetUsersMethod;

  @io.grpc.stub.annotations.RpcMethod(
      fullMethodName = SERVICE_NAME + '/' + "GetUsers",
      requestType = com.google.protobuf.Empty.class,
      responseType = com.example.grpcClient.tracker.TrackerOuterClass.UserResponse.class,
      methodType = io.grpc.MethodDescriptor.MethodType.SERVER_STREAMING)
  public static io.grpc.MethodDescriptor<com.google.protobuf.Empty,
      com.example.grpcClient.tracker.TrackerOuterClass.UserResponse> getGetUsersMethod() {
    io.grpc.MethodDescriptor<com.google.protobuf.Empty, com.example.grpcClient.tracker.TrackerOuterClass.UserResponse> getGetUsersMethod;
    if ((getGetUsersMethod = TrackerGrpc.getGetUsersMethod) == null) {
      synchronized (TrackerGrpc.class) {
        if ((getGetUsersMethod = TrackerGrpc.getGetUsersMethod) == null) {
          TrackerGrpc.getGetUsersMethod = getGetUsersMethod =
              io.grpc.MethodDescriptor.<com.google.protobuf.Empty, com.example.grpcClient.tracker.TrackerOuterClass.UserResponse>newBuilder()
              .setType(io.grpc.MethodDescriptor.MethodType.SERVER_STREAMING)
              .setFullMethodName(generateFullMethodName(SERVICE_NAME, "GetUsers"))
              .setSampledToLocalTracing(true)
              .setRequestMarshaller(io.grpc.protobuf.ProtoUtils.marshaller(
                  com.google.protobuf.Empty.getDefaultInstance()))
              .setResponseMarshaller(io.grpc.protobuf.ProtoUtils.marshaller(
                  com.example.grpcClient.tracker.TrackerOuterClass.UserResponse.getDefaultInstance()))
              .setSchemaDescriptor(new TrackerMethodDescriptorSupplier("GetUsers"))
              .build();
        }
      }
    }
    return getGetUsersMethod;
  }

  private static volatile io.grpc.MethodDescriptor<com.example.grpcClient.tracker.TrackerOuterClass.Username,
      com.example.grpcClient.tracker.TrackerOuterClass.UserResponse> getGetUserMethod;

  @io.grpc.stub.annotations.RpcMethod(
      fullMethodName = SERVICE_NAME + '/' + "GetUser",
      requestType = com.example.grpcClient.tracker.TrackerOuterClass.Username.class,
      responseType = com.example.grpcClient.tracker.TrackerOuterClass.UserResponse.class,
      methodType = io.grpc.MethodDescriptor.MethodType.UNARY)
  public static io.grpc.MethodDescriptor<com.example.grpcClient.tracker.TrackerOuterClass.Username,
      com.example.grpcClient.tracker.TrackerOuterClass.UserResponse> getGetUserMethod() {
    io.grpc.MethodDescriptor<com.example.grpcClient.tracker.TrackerOuterClass.Username, com.example.grpcClient.tracker.TrackerOuterClass.UserResponse> getGetUserMethod;
    if ((getGetUserMethod = TrackerGrpc.getGetUserMethod) == null) {
      synchronized (TrackerGrpc.class) {
        if ((getGetUserMethod = TrackerGrpc.getGetUserMethod) == null) {
          TrackerGrpc.getGetUserMethod = getGetUserMethod =
              io.grpc.MethodDescriptor.<com.example.grpcClient.tracker.TrackerOuterClass.Username, com.example.grpcClient.tracker.TrackerOuterClass.UserResponse>newBuilder()
              .setType(io.grpc.MethodDescriptor.MethodType.UNARY)
              .setFullMethodName(generateFullMethodName(SERVICE_NAME, "GetUser"))
              .setSampledToLocalTracing(true)
              .setRequestMarshaller(io.grpc.protobuf.ProtoUtils.marshaller(
                  com.example.grpcClient.tracker.TrackerOuterClass.Username.getDefaultInstance()))
              .setResponseMarshaller(io.grpc.protobuf.ProtoUtils.marshaller(
                  com.example.grpcClient.tracker.TrackerOuterClass.UserResponse.getDefaultInstance()))
              .setSchemaDescriptor(new TrackerMethodDescriptorSupplier("GetUser"))
              .build();
        }
      }
    }
    return getGetUserMethod;
  }

  private static volatile io.grpc.MethodDescriptor<com.example.grpcClient.tracker.TrackerOuterClass.Username,
      com.example.grpcClient.tracker.TrackerOuterClass.UserResponse> getGetLocationMethod;

  @io.grpc.stub.annotations.RpcMethod(
      fullMethodName = SERVICE_NAME + '/' + "GetLocation",
      requestType = com.example.grpcClient.tracker.TrackerOuterClass.Username.class,
      responseType = com.example.grpcClient.tracker.TrackerOuterClass.UserResponse.class,
      methodType = io.grpc.MethodDescriptor.MethodType.SERVER_STREAMING)
  public static io.grpc.MethodDescriptor<com.example.grpcClient.tracker.TrackerOuterClass.Username,
      com.example.grpcClient.tracker.TrackerOuterClass.UserResponse> getGetLocationMethod() {
    io.grpc.MethodDescriptor<com.example.grpcClient.tracker.TrackerOuterClass.Username, com.example.grpcClient.tracker.TrackerOuterClass.UserResponse> getGetLocationMethod;
    if ((getGetLocationMethod = TrackerGrpc.getGetLocationMethod) == null) {
      synchronized (TrackerGrpc.class) {
        if ((getGetLocationMethod = TrackerGrpc.getGetLocationMethod) == null) {
          TrackerGrpc.getGetLocationMethod = getGetLocationMethod =
              io.grpc.MethodDescriptor.<com.example.grpcClient.tracker.TrackerOuterClass.Username, com.example.grpcClient.tracker.TrackerOuterClass.UserResponse>newBuilder()
              .setType(io.grpc.MethodDescriptor.MethodType.SERVER_STREAMING)
              .setFullMethodName(generateFullMethodName(SERVICE_NAME, "GetLocation"))
              .setSampledToLocalTracing(true)
              .setRequestMarshaller(io.grpc.protobuf.ProtoUtils.marshaller(
                  com.example.grpcClient.tracker.TrackerOuterClass.Username.getDefaultInstance()))
              .setResponseMarshaller(io.grpc.protobuf.ProtoUtils.marshaller(
                  com.example.grpcClient.tracker.TrackerOuterClass.UserResponse.getDefaultInstance()))
              .setSchemaDescriptor(new TrackerMethodDescriptorSupplier("GetLocation"))
              .build();
        }
      }
    }
    return getGetLocationMethod;
  }

  private static volatile io.grpc.MethodDescriptor<com.example.grpcClient.tracker.TrackerOuterClass.Username,
      com.example.grpcClient.tracker.TrackerOuterClass.LocationResponse> getGetCurrentLocationMethod;

  @io.grpc.stub.annotations.RpcMethod(
      fullMethodName = SERVICE_NAME + '/' + "GetCurrentLocation",
      requestType = com.example.grpcClient.tracker.TrackerOuterClass.Username.class,
      responseType = com.example.grpcClient.tracker.TrackerOuterClass.LocationResponse.class,
      methodType = io.grpc.MethodDescriptor.MethodType.UNARY)
  public static io.grpc.MethodDescriptor<com.example.grpcClient.tracker.TrackerOuterClass.Username,
      com.example.grpcClient.tracker.TrackerOuterClass.LocationResponse> getGetCurrentLocationMethod() {
    io.grpc.MethodDescriptor<com.example.grpcClient.tracker.TrackerOuterClass.Username, com.example.grpcClient.tracker.TrackerOuterClass.LocationResponse> getGetCurrentLocationMethod;
    if ((getGetCurrentLocationMethod = TrackerGrpc.getGetCurrentLocationMethod) == null) {
      synchronized (TrackerGrpc.class) {
        if ((getGetCurrentLocationMethod = TrackerGrpc.getGetCurrentLocationMethod) == null) {
          TrackerGrpc.getGetCurrentLocationMethod = getGetCurrentLocationMethod =
              io.grpc.MethodDescriptor.<com.example.grpcClient.tracker.TrackerOuterClass.Username, com.example.grpcClient.tracker.TrackerOuterClass.LocationResponse>newBuilder()
              .setType(io.grpc.MethodDescriptor.MethodType.UNARY)
              .setFullMethodName(generateFullMethodName(SERVICE_NAME, "GetCurrentLocation"))
              .setSampledToLocalTracing(true)
              .setRequestMarshaller(io.grpc.protobuf.ProtoUtils.marshaller(
                  com.example.grpcClient.tracker.TrackerOuterClass.Username.getDefaultInstance()))
              .setResponseMarshaller(io.grpc.protobuf.ProtoUtils.marshaller(
                  com.example.grpcClient.tracker.TrackerOuterClass.LocationResponse.getDefaultInstance()))
              .setSchemaDescriptor(new TrackerMethodDescriptorSupplier("GetCurrentLocation"))
              .build();
        }
      }
    }
    return getGetCurrentLocationMethod;
  }

  private static volatile io.grpc.MethodDescriptor<com.example.grpcClient.tracker.TrackerOuterClass.Username,
      com.example.grpcClient.tracker.TrackerOuterClass.LocationResponse> getGetLastPathMethod;

  @io.grpc.stub.annotations.RpcMethod(
      fullMethodName = SERVICE_NAME + '/' + "GetLastPath",
      requestType = com.example.grpcClient.tracker.TrackerOuterClass.Username.class,
      responseType = com.example.grpcClient.tracker.TrackerOuterClass.LocationResponse.class,
      methodType = io.grpc.MethodDescriptor.MethodType.SERVER_STREAMING)
  public static io.grpc.MethodDescriptor<com.example.grpcClient.tracker.TrackerOuterClass.Username,
      com.example.grpcClient.tracker.TrackerOuterClass.LocationResponse> getGetLastPathMethod() {
    io.grpc.MethodDescriptor<com.example.grpcClient.tracker.TrackerOuterClass.Username, com.example.grpcClient.tracker.TrackerOuterClass.LocationResponse> getGetLastPathMethod;
    if ((getGetLastPathMethod = TrackerGrpc.getGetLastPathMethod) == null) {
      synchronized (TrackerGrpc.class) {
        if ((getGetLastPathMethod = TrackerGrpc.getGetLastPathMethod) == null) {
          TrackerGrpc.getGetLastPathMethod = getGetLastPathMethod =
              io.grpc.MethodDescriptor.<com.example.grpcClient.tracker.TrackerOuterClass.Username, com.example.grpcClient.tracker.TrackerOuterClass.LocationResponse>newBuilder()
              .setType(io.grpc.MethodDescriptor.MethodType.SERVER_STREAMING)
              .setFullMethodName(generateFullMethodName(SERVICE_NAME, "GetLastPath"))
              .setSampledToLocalTracing(true)
              .setRequestMarshaller(io.grpc.protobuf.ProtoUtils.marshaller(
                  com.example.grpcClient.tracker.TrackerOuterClass.Username.getDefaultInstance()))
              .setResponseMarshaller(io.grpc.protobuf.ProtoUtils.marshaller(
                  com.example.grpcClient.tracker.TrackerOuterClass.LocationResponse.getDefaultInstance()))
              .setSchemaDescriptor(new TrackerMethodDescriptorSupplier("GetLastPath"))
              .build();
        }
      }
    }
    return getGetLastPathMethod;
  }

  private static volatile io.grpc.MethodDescriptor<com.example.grpcClient.tracker.TrackerOuterClass.PathRequest,
      com.example.grpcClient.tracker.TrackerOuterClass.LocationResponse> getGetPathMethod;

  @io.grpc.stub.annotations.RpcMethod(
      fullMethodName = SERVICE_NAME + '/' + "GetPath",
      requestType = com.example.grpcClient.tracker.TrackerOuterClass.PathRequest.class,
      responseType = com.example.grpcClient.tracker.TrackerOuterClass.LocationResponse.class,
      methodType = io.grpc.MethodDescriptor.MethodType.SERVER_STREAMING)
  public static io.grpc.MethodDescriptor<com.example.grpcClient.tracker.TrackerOuterClass.PathRequest,
      com.example.grpcClient.tracker.TrackerOuterClass.LocationResponse> getGetPathMethod() {
    io.grpc.MethodDescriptor<com.example.grpcClient.tracker.TrackerOuterClass.PathRequest, com.example.grpcClient.tracker.TrackerOuterClass.LocationResponse> getGetPathMethod;
    if ((getGetPathMethod = TrackerGrpc.getGetPathMethod) == null) {
      synchronized (TrackerGrpc.class) {
        if ((getGetPathMethod = TrackerGrpc.getGetPathMethod) == null) {
          TrackerGrpc.getGetPathMethod = getGetPathMethod =
              io.grpc.MethodDescriptor.<com.example.grpcClient.tracker.TrackerOuterClass.PathRequest, com.example.grpcClient.tracker.TrackerOuterClass.LocationResponse>newBuilder()
              .setType(io.grpc.MethodDescriptor.MethodType.SERVER_STREAMING)
              .setFullMethodName(generateFullMethodName(SERVICE_NAME, "GetPath"))
              .setSampledToLocalTracing(true)
              .setRequestMarshaller(io.grpc.protobuf.ProtoUtils.marshaller(
                  com.example.grpcClient.tracker.TrackerOuterClass.PathRequest.getDefaultInstance()))
              .setResponseMarshaller(io.grpc.protobuf.ProtoUtils.marshaller(
                  com.example.grpcClient.tracker.TrackerOuterClass.LocationResponse.getDefaultInstance()))
              .setSchemaDescriptor(new TrackerMethodDescriptorSupplier("GetPath"))
              .build();
        }
      }
    }
    return getGetPathMethod;
  }

  private static volatile io.grpc.MethodDescriptor<com.example.grpcClient.tracker.TrackerOuterClass.Username,
      com.example.grpcClient.tracker.TrackerOuterClass.UserResponse> getMoveUserMethod;

  @io.grpc.stub.annotations.RpcMethod(
      fullMethodName = SERVICE_NAME + '/' + "MoveUser",
      requestType = com.example.grpcClient.tracker.TrackerOuterClass.Username.class,
      responseType = com.example.grpcClient.tracker.TrackerOuterClass.UserResponse.class,
      methodType = io.grpc.MethodDescriptor.MethodType.UNARY)
  public static io.grpc.MethodDescriptor<com.example.grpcClient.tracker.TrackerOuterClass.Username,
      com.example.grpcClient.tracker.TrackerOuterClass.UserResponse> getMoveUserMethod() {
    io.grpc.MethodDescriptor<com.example.grpcClient.tracker.TrackerOuterClass.Username, com.example.grpcClient.tracker.TrackerOuterClass.UserResponse> getMoveUserMethod;
    if ((getMoveUserMethod = TrackerGrpc.getMoveUserMethod) == null) {
      synchronized (TrackerGrpc.class) {
        if ((getMoveUserMethod = TrackerGrpc.getMoveUserMethod) == null) {
          TrackerGrpc.getMoveUserMethod = getMoveUserMethod =
              io.grpc.MethodDescriptor.<com.example.grpcClient.tracker.TrackerOuterClass.Username, com.example.grpcClient.tracker.TrackerOuterClass.UserResponse>newBuilder()
              .setType(io.grpc.MethodDescriptor.MethodType.UNARY)
              .setFullMethodName(generateFullMethodName(SERVICE_NAME, "MoveUser"))
              .setSampledToLocalTracing(true)
              .setRequestMarshaller(io.grpc.protobuf.ProtoUtils.marshaller(
                  com.example.grpcClient.tracker.TrackerOuterClass.Username.getDefaultInstance()))
              .setResponseMarshaller(io.grpc.protobuf.ProtoUtils.marshaller(
                  com.example.grpcClient.tracker.TrackerOuterClass.UserResponse.getDefaultInstance()))
              .setSchemaDescriptor(new TrackerMethodDescriptorSupplier("MoveUser"))
              .build();
        }
      }
    }
    return getMoveUserMethod;
  }

  private static volatile io.grpc.MethodDescriptor<com.example.grpcClient.tracker.TrackerOuterClass.Username,
      com.example.grpcClient.tracker.TrackerOuterClass.UserResponse> getTakeTripMethod;

  @io.grpc.stub.annotations.RpcMethod(
      fullMethodName = SERVICE_NAME + '/' + "TakeTrip",
      requestType = com.example.grpcClient.tracker.TrackerOuterClass.Username.class,
      responseType = com.example.grpcClient.tracker.TrackerOuterClass.UserResponse.class,
      methodType = io.grpc.MethodDescriptor.MethodType.UNARY)
  public static io.grpc.MethodDescriptor<com.example.grpcClient.tracker.TrackerOuterClass.Username,
      com.example.grpcClient.tracker.TrackerOuterClass.UserResponse> getTakeTripMethod() {
    io.grpc.MethodDescriptor<com.example.grpcClient.tracker.TrackerOuterClass.Username, com.example.grpcClient.tracker.TrackerOuterClass.UserResponse> getTakeTripMethod;
    if ((getTakeTripMethod = TrackerGrpc.getTakeTripMethod) == null) {
      synchronized (TrackerGrpc.class) {
        if ((getTakeTripMethod = TrackerGrpc.getTakeTripMethod) == null) {
          TrackerGrpc.getTakeTripMethod = getTakeTripMethod =
              io.grpc.MethodDescriptor.<com.example.grpcClient.tracker.TrackerOuterClass.Username, com.example.grpcClient.tracker.TrackerOuterClass.UserResponse>newBuilder()
              .setType(io.grpc.MethodDescriptor.MethodType.UNARY)
              .setFullMethodName(generateFullMethodName(SERVICE_NAME, "TakeTrip"))
              .setSampledToLocalTracing(true)
              .setRequestMarshaller(io.grpc.protobuf.ProtoUtils.marshaller(
                  com.example.grpcClient.tracker.TrackerOuterClass.Username.getDefaultInstance()))
              .setResponseMarshaller(io.grpc.protobuf.ProtoUtils.marshaller(
                  com.example.grpcClient.tracker.TrackerOuterClass.UserResponse.getDefaultInstance()))
              .setSchemaDescriptor(new TrackerMethodDescriptorSupplier("TakeTrip"))
              .build();
        }
      }
    }
    return getTakeTripMethod;
  }

  private static volatile io.grpc.MethodDescriptor<com.example.grpcClient.tracker.TrackerOuterClass.Username,
      com.example.grpcClient.tracker.TrackerOuterClass.LocationResponse> getGetLocationsMethod;

  @io.grpc.stub.annotations.RpcMethod(
      fullMethodName = SERVICE_NAME + '/' + "GetLocations",
      requestType = com.example.grpcClient.tracker.TrackerOuterClass.Username.class,
      responseType = com.example.grpcClient.tracker.TrackerOuterClass.LocationResponse.class,
      methodType = io.grpc.MethodDescriptor.MethodType.BIDI_STREAMING)
  public static io.grpc.MethodDescriptor<com.example.grpcClient.tracker.TrackerOuterClass.Username,
      com.example.grpcClient.tracker.TrackerOuterClass.LocationResponse> getGetLocationsMethod() {
    io.grpc.MethodDescriptor<com.example.grpcClient.tracker.TrackerOuterClass.Username, com.example.grpcClient.tracker.TrackerOuterClass.LocationResponse> getGetLocationsMethod;
    if ((getGetLocationsMethod = TrackerGrpc.getGetLocationsMethod) == null) {
      synchronized (TrackerGrpc.class) {
        if ((getGetLocationsMethod = TrackerGrpc.getGetLocationsMethod) == null) {
          TrackerGrpc.getGetLocationsMethod = getGetLocationsMethod =
              io.grpc.MethodDescriptor.<com.example.grpcClient.tracker.TrackerOuterClass.Username, com.example.grpcClient.tracker.TrackerOuterClass.LocationResponse>newBuilder()
              .setType(io.grpc.MethodDescriptor.MethodType.BIDI_STREAMING)
              .setFullMethodName(generateFullMethodName(SERVICE_NAME, "GetLocations"))
              .setSampledToLocalTracing(true)
              .setRequestMarshaller(io.grpc.protobuf.ProtoUtils.marshaller(
                  com.example.grpcClient.tracker.TrackerOuterClass.Username.getDefaultInstance()))
              .setResponseMarshaller(io.grpc.protobuf.ProtoUtils.marshaller(
                  com.example.grpcClient.tracker.TrackerOuterClass.LocationResponse.getDefaultInstance()))
              .setSchemaDescriptor(new TrackerMethodDescriptorSupplier("GetLocations"))
              .build();
        }
      }
    }
    return getGetLocationsMethod;
  }

  /**
   * Creates a new async stub that supports all call types for the service
   */
  public static TrackerStub newStub(io.grpc.Channel channel) {
    io.grpc.stub.AbstractStub.StubFactory<TrackerStub> factory =
      new io.grpc.stub.AbstractStub.StubFactory<TrackerStub>() {
        @java.lang.Override
        public TrackerStub newStub(io.grpc.Channel channel, io.grpc.CallOptions callOptions) {
          return new TrackerStub(channel, callOptions);
        }
      };
    return TrackerStub.newStub(factory, channel);
  }

  /**
   * Creates a new blocking-style stub that supports unary and streaming output calls on the service
   */
  public static TrackerBlockingStub newBlockingStub(
      io.grpc.Channel channel) {
    io.grpc.stub.AbstractStub.StubFactory<TrackerBlockingStub> factory =
      new io.grpc.stub.AbstractStub.StubFactory<TrackerBlockingStub>() {
        @java.lang.Override
        public TrackerBlockingStub newStub(io.grpc.Channel channel, io.grpc.CallOptions callOptions) {
          return new TrackerBlockingStub(channel, callOptions);
        }
      };
    return TrackerBlockingStub.newStub(factory, channel);
  }

  /**
   * Creates a new ListenableFuture-style stub that supports unary calls on the service
   */
  public static TrackerFutureStub newFutureStub(
      io.grpc.Channel channel) {
    io.grpc.stub.AbstractStub.StubFactory<TrackerFutureStub> factory =
      new io.grpc.stub.AbstractStub.StubFactory<TrackerFutureStub>() {
        @java.lang.Override
        public TrackerFutureStub newStub(io.grpc.Channel channel, io.grpc.CallOptions callOptions) {
          return new TrackerFutureStub(channel, callOptions);
        }
      };
    return TrackerFutureStub.newStub(factory, channel);
  }

  /**
   */
  public interface AsyncService {

    /**
     * <pre>
     * Create a user
     * </pre>
     */
    default void createUser(com.example.grpcClient.tracker.TrackerOuterClass.Username request,
        io.grpc.stub.StreamObserver<com.example.grpcClient.tracker.TrackerOuterClass.UserResponse> responseObserver) {
      io.grpc.stub.ServerCalls.asyncUnimplementedUnaryCall(getCreateUserMethod(), responseObserver);
    }

    /**
     * <pre>
     * Get all the created users
     * </pre>
     */
    default void getUsers(com.google.protobuf.Empty request,
        io.grpc.stub.StreamObserver<com.example.grpcClient.tracker.TrackerOuterClass.UserResponse> responseObserver) {
      io.grpc.stub.ServerCalls.asyncUnimplementedUnaryCall(getGetUsersMethod(), responseObserver);
    }

    /**
     * <pre>
     * Get the requested user
     * </pre>
     */
    default void getUser(com.example.grpcClient.tracker.TrackerOuterClass.Username request,
        io.grpc.stub.StreamObserver<com.example.grpcClient.tracker.TrackerOuterClass.UserResponse> responseObserver) {
      io.grpc.stub.ServerCalls.asyncUnimplementedUnaryCall(getGetUserMethod(), responseObserver);
    }

    /**
     * <pre>
     * Stream the location of the provided user
     * </pre>
     */
    default void getLocation(com.example.grpcClient.tracker.TrackerOuterClass.Username request,
        io.grpc.stub.StreamObserver<com.example.grpcClient.tracker.TrackerOuterClass.UserResponse> responseObserver) {
      io.grpc.stub.ServerCalls.asyncUnimplementedUnaryCall(getGetLocationMethod(), responseObserver);
    }

    /**
     * <pre>
     * Get the current location of the provided user
     * </pre>
     */
    default void getCurrentLocation(com.example.grpcClient.tracker.TrackerOuterClass.Username request,
        io.grpc.stub.StreamObserver<com.example.grpcClient.tracker.TrackerOuterClass.LocationResponse> responseObserver) {
      io.grpc.stub.ServerCalls.asyncUnimplementedUnaryCall(getGetCurrentLocationMethod(), responseObserver);
    }

    /**
     * <pre>
     * Get the last path traversed by the provided user
     * </pre>
     */
    default void getLastPath(com.example.grpcClient.tracker.TrackerOuterClass.Username request,
        io.grpc.stub.StreamObserver<com.example.grpcClient.tracker.TrackerOuterClass.LocationResponse> responseObserver) {
      io.grpc.stub.ServerCalls.asyncUnimplementedUnaryCall(getGetLastPathMethod(), responseObserver);
    }

    /**
     * <pre>
     * Get the request path traversed by the provided user
     * </pre>
     */
    default void getPath(com.example.grpcClient.tracker.TrackerOuterClass.PathRequest request,
        io.grpc.stub.StreamObserver<com.example.grpcClient.tracker.TrackerOuterClass.LocationResponse> responseObserver) {
      io.grpc.stub.ServerCalls.asyncUnimplementedUnaryCall(getGetPathMethod(), responseObserver);
    }

    /**
     * <pre>
     * Randomly move the user to a new location
     * </pre>
     */
    default void moveUser(com.example.grpcClient.tracker.TrackerOuterClass.Username request,
        io.grpc.stub.StreamObserver<com.example.grpcClient.tracker.TrackerOuterClass.UserResponse> responseObserver) {
      io.grpc.stub.ServerCalls.asyncUnimplementedUnaryCall(getMoveUserMethod(), responseObserver);
    }

    /**
     * <pre>
     * Move the user through a series of random locations, creating a path traveled
     * </pre>
     */
    default void takeTrip(com.example.grpcClient.tracker.TrackerOuterClass.Username request,
        io.grpc.stub.StreamObserver<com.example.grpcClient.tracker.TrackerOuterClass.UserResponse> responseObserver) {
      io.grpc.stub.ServerCalls.asyncUnimplementedUnaryCall(getTakeTripMethod(), responseObserver);
    }

    /**
     * <pre>
     * Get the current locations of the provided users
     * </pre>
     */
    default io.grpc.stub.StreamObserver<com.example.grpcClient.tracker.TrackerOuterClass.Username> getLocations(
        io.grpc.stub.StreamObserver<com.example.grpcClient.tracker.TrackerOuterClass.LocationResponse> responseObserver) {
      return io.grpc.stub.ServerCalls.asyncUnimplementedStreamingCall(getGetLocationsMethod(), responseObserver);
    }
  }

  /**
   * Base class for the server implementation of the service Tracker.
   */
  public static abstract class TrackerImplBase
      implements io.grpc.BindableService, AsyncService {

    @java.lang.Override public final io.grpc.ServerServiceDefinition bindService() {
      return TrackerGrpc.bindService(this);
    }
  }

  /**
   * A stub to allow clients to do asynchronous rpc calls to service Tracker.
   */
  public static final class TrackerStub
      extends io.grpc.stub.AbstractAsyncStub<TrackerStub> {
    private TrackerStub(
        io.grpc.Channel channel, io.grpc.CallOptions callOptions) {
      super(channel, callOptions);
    }

    @java.lang.Override
    protected TrackerStub build(
        io.grpc.Channel channel, io.grpc.CallOptions callOptions) {
      return new TrackerStub(channel, callOptions);
    }

    /**
     * <pre>
     * Create a user
     * </pre>
     */
    public void createUser(com.example.grpcClient.tracker.TrackerOuterClass.Username request,
        io.grpc.stub.StreamObserver<com.example.grpcClient.tracker.TrackerOuterClass.UserResponse> responseObserver) {
      io.grpc.stub.ClientCalls.asyncUnaryCall(
          getChannel().newCall(getCreateUserMethod(), getCallOptions()), request, responseObserver);
    }

    /**
     * <pre>
     * Get all the created users
     * </pre>
     */
    public void getUsers(com.google.protobuf.Empty request,
        io.grpc.stub.StreamObserver<com.example.grpcClient.tracker.TrackerOuterClass.UserResponse> responseObserver) {
      io.grpc.stub.ClientCalls.asyncServerStreamingCall(
          getChannel().newCall(getGetUsersMethod(), getCallOptions()), request, responseObserver);
    }

    /**
     * <pre>
     * Get the requested user
     * </pre>
     */
    public void getUser(com.example.grpcClient.tracker.TrackerOuterClass.Username request,
        io.grpc.stub.StreamObserver<com.example.grpcClient.tracker.TrackerOuterClass.UserResponse> responseObserver) {
      io.grpc.stub.ClientCalls.asyncUnaryCall(
          getChannel().newCall(getGetUserMethod(), getCallOptions()), request, responseObserver);
    }

    /**
     * <pre>
     * Stream the location of the provided user
     * </pre>
     */
    public void getLocation(com.example.grpcClient.tracker.TrackerOuterClass.Username request,
        io.grpc.stub.StreamObserver<com.example.grpcClient.tracker.TrackerOuterClass.UserResponse> responseObserver) {
      io.grpc.stub.ClientCalls.asyncServerStreamingCall(
          getChannel().newCall(getGetLocationMethod(), getCallOptions()), request, responseObserver);
    }

    /**
     * <pre>
     * Get the current location of the provided user
     * </pre>
     */
    public void getCurrentLocation(com.example.grpcClient.tracker.TrackerOuterClass.Username request,
        io.grpc.stub.StreamObserver<com.example.grpcClient.tracker.TrackerOuterClass.LocationResponse> responseObserver) {
      io.grpc.stub.ClientCalls.asyncUnaryCall(
          getChannel().newCall(getGetCurrentLocationMethod(), getCallOptions()), request, responseObserver);
    }

    /**
     * <pre>
     * Get the last path traversed by the provided user
     * </pre>
     */
    public void getLastPath(com.example.grpcClient.tracker.TrackerOuterClass.Username request,
        io.grpc.stub.StreamObserver<com.example.grpcClient.tracker.TrackerOuterClass.LocationResponse> responseObserver) {
      io.grpc.stub.ClientCalls.asyncServerStreamingCall(
          getChannel().newCall(getGetLastPathMethod(), getCallOptions()), request, responseObserver);
    }

    /**
     * <pre>
     * Get the request path traversed by the provided user
     * </pre>
     */
    public void getPath(com.example.grpcClient.tracker.TrackerOuterClass.PathRequest request,
        io.grpc.stub.StreamObserver<com.example.grpcClient.tracker.TrackerOuterClass.LocationResponse> responseObserver) {
      io.grpc.stub.ClientCalls.asyncServerStreamingCall(
          getChannel().newCall(getGetPathMethod(), getCallOptions()), request, responseObserver);
    }

    /**
     * <pre>
     * Randomly move the user to a new location
     * </pre>
     */
    public void moveUser(com.example.grpcClient.tracker.TrackerOuterClass.Username request,
        io.grpc.stub.StreamObserver<com.example.grpcClient.tracker.TrackerOuterClass.UserResponse> responseObserver) {
      io.grpc.stub.ClientCalls.asyncUnaryCall(
          getChannel().newCall(getMoveUserMethod(), getCallOptions()), request, responseObserver);
    }

    /**
     * <pre>
     * Move the user through a series of random locations, creating a path traveled
     * </pre>
     */
    public void takeTrip(com.example.grpcClient.tracker.TrackerOuterClass.Username request,
        io.grpc.stub.StreamObserver<com.example.grpcClient.tracker.TrackerOuterClass.UserResponse> responseObserver) {
      io.grpc.stub.ClientCalls.asyncUnaryCall(
          getChannel().newCall(getTakeTripMethod(), getCallOptions()), request, responseObserver);
    }

    /**
     * <pre>
     * Get the current locations of the provided users
     * </pre>
     */
    public io.grpc.stub.StreamObserver<com.example.grpcClient.tracker.TrackerOuterClass.Username> getLocations(
        io.grpc.stub.StreamObserver<com.example.grpcClient.tracker.TrackerOuterClass.LocationResponse> responseObserver) {
      return io.grpc.stub.ClientCalls.asyncBidiStreamingCall(
          getChannel().newCall(getGetLocationsMethod(), getCallOptions()), responseObserver);
    }
  }

  /**
   * A stub to allow clients to do synchronous rpc calls to service Tracker.
   */
  public static final class TrackerBlockingStub
      extends io.grpc.stub.AbstractBlockingStub<TrackerBlockingStub> {
    private TrackerBlockingStub(
        io.grpc.Channel channel, io.grpc.CallOptions callOptions) {
      super(channel, callOptions);
    }

    @java.lang.Override
    protected TrackerBlockingStub build(
        io.grpc.Channel channel, io.grpc.CallOptions callOptions) {
      return new TrackerBlockingStub(channel, callOptions);
    }

    /**
     * <pre>
     * Create a user
     * </pre>
     */
    public com.example.grpcClient.tracker.TrackerOuterClass.UserResponse createUser(com.example.grpcClient.tracker.TrackerOuterClass.Username request) {
      return io.grpc.stub.ClientCalls.blockingUnaryCall(
          getChannel(), getCreateUserMethod(), getCallOptions(), request);
    }

    /**
     * <pre>
     * Get all the created users
     * </pre>
     */
    public java.util.Iterator<com.example.grpcClient.tracker.TrackerOuterClass.UserResponse> getUsers(
        com.google.protobuf.Empty request) {
      return io.grpc.stub.ClientCalls.blockingServerStreamingCall(
          getChannel(), getGetUsersMethod(), getCallOptions(), request);
    }

    /**
     * <pre>
     * Get the requested user
     * </pre>
     */
    public com.example.grpcClient.tracker.TrackerOuterClass.UserResponse getUser(com.example.grpcClient.tracker.TrackerOuterClass.Username request) {
      return io.grpc.stub.ClientCalls.blockingUnaryCall(
          getChannel(), getGetUserMethod(), getCallOptions(), request);
    }

    /**
     * <pre>
     * Stream the location of the provided user
     * </pre>
     */
    public java.util.Iterator<com.example.grpcClient.tracker.TrackerOuterClass.UserResponse> getLocation(
        com.example.grpcClient.tracker.TrackerOuterClass.Username request) {
      return io.grpc.stub.ClientCalls.blockingServerStreamingCall(
          getChannel(), getGetLocationMethod(), getCallOptions(), request);
    }

    /**
     * <pre>
     * Get the current location of the provided user
     * </pre>
     */
    public com.example.grpcClient.tracker.TrackerOuterClass.LocationResponse getCurrentLocation(com.example.grpcClient.tracker.TrackerOuterClass.Username request) {
      return io.grpc.stub.ClientCalls.blockingUnaryCall(
          getChannel(), getGetCurrentLocationMethod(), getCallOptions(), request);
    }

    /**
     * <pre>
     * Get the last path traversed by the provided user
     * </pre>
     */
    public java.util.Iterator<com.example.grpcClient.tracker.TrackerOuterClass.LocationResponse> getLastPath(
        com.example.grpcClient.tracker.TrackerOuterClass.Username request) {
      return io.grpc.stub.ClientCalls.blockingServerStreamingCall(
          getChannel(), getGetLastPathMethod(), getCallOptions(), request);
    }

    /**
     * <pre>
     * Get the request path traversed by the provided user
     * </pre>
     */
    public java.util.Iterator<com.example.grpcClient.tracker.TrackerOuterClass.LocationResponse> getPath(
        com.example.grpcClient.tracker.TrackerOuterClass.PathRequest request) {
      return io.grpc.stub.ClientCalls.blockingServerStreamingCall(
          getChannel(), getGetPathMethod(), getCallOptions(), request);
    }

    /**
     * <pre>
     * Randomly move the user to a new location
     * </pre>
     */
    public com.example.grpcClient.tracker.TrackerOuterClass.UserResponse moveUser(com.example.grpcClient.tracker.TrackerOuterClass.Username request) {
      return io.grpc.stub.ClientCalls.blockingUnaryCall(
          getChannel(), getMoveUserMethod(), getCallOptions(), request);
    }

    /**
     * <pre>
     * Move the user through a series of random locations, creating a path traveled
     * </pre>
     */
    public com.example.grpcClient.tracker.TrackerOuterClass.UserResponse takeTrip(com.example.grpcClient.tracker.TrackerOuterClass.Username request) {
      return io.grpc.stub.ClientCalls.blockingUnaryCall(
          getChannel(), getTakeTripMethod(), getCallOptions(), request);
    }
  }

  /**
   * A stub to allow clients to do ListenableFuture-style rpc calls to service Tracker.
   */
  public static final class TrackerFutureStub
      extends io.grpc.stub.AbstractFutureStub<TrackerFutureStub> {
    private TrackerFutureStub(
        io.grpc.Channel channel, io.grpc.CallOptions callOptions) {
      super(channel, callOptions);
    }

    @java.lang.Override
    protected TrackerFutureStub build(
        io.grpc.Channel channel, io.grpc.CallOptions callOptions) {
      return new TrackerFutureStub(channel, callOptions);
    }

    /**
     * <pre>
     * Create a user
     * </pre>
     */
    public com.google.common.util.concurrent.ListenableFuture<com.example.grpcClient.tracker.TrackerOuterClass.UserResponse> createUser(
        com.example.grpcClient.tracker.TrackerOuterClass.Username request) {
      return io.grpc.stub.ClientCalls.futureUnaryCall(
          getChannel().newCall(getCreateUserMethod(), getCallOptions()), request);
    }

    /**
     * <pre>
     * Get the requested user
     * </pre>
     */
    public com.google.common.util.concurrent.ListenableFuture<com.example.grpcClient.tracker.TrackerOuterClass.UserResponse> getUser(
        com.example.grpcClient.tracker.TrackerOuterClass.Username request) {
      return io.grpc.stub.ClientCalls.futureUnaryCall(
          getChannel().newCall(getGetUserMethod(), getCallOptions()), request);
    }

    /**
     * <pre>
     * Get the current location of the provided user
     * </pre>
     */
    public com.google.common.util.concurrent.ListenableFuture<com.example.grpcClient.tracker.TrackerOuterClass.LocationResponse> getCurrentLocation(
        com.example.grpcClient.tracker.TrackerOuterClass.Username request) {
      return io.grpc.stub.ClientCalls.futureUnaryCall(
          getChannel().newCall(getGetCurrentLocationMethod(), getCallOptions()), request);
    }

    /**
     * <pre>
     * Randomly move the user to a new location
     * </pre>
     */
    public com.google.common.util.concurrent.ListenableFuture<com.example.grpcClient.tracker.TrackerOuterClass.UserResponse> moveUser(
        com.example.grpcClient.tracker.TrackerOuterClass.Username request) {
      return io.grpc.stub.ClientCalls.futureUnaryCall(
          getChannel().newCall(getMoveUserMethod(), getCallOptions()), request);
    }

    /**
     * <pre>
     * Move the user through a series of random locations, creating a path traveled
     * </pre>
     */
    public com.google.common.util.concurrent.ListenableFuture<com.example.grpcClient.tracker.TrackerOuterClass.UserResponse> takeTrip(
        com.example.grpcClient.tracker.TrackerOuterClass.Username request) {
      return io.grpc.stub.ClientCalls.futureUnaryCall(
          getChannel().newCall(getTakeTripMethod(), getCallOptions()), request);
    }
  }

  private static final int METHODID_CREATE_USER = 0;
  private static final int METHODID_GET_USERS = 1;
  private static final int METHODID_GET_USER = 2;
  private static final int METHODID_GET_LOCATION = 3;
  private static final int METHODID_GET_CURRENT_LOCATION = 4;
  private static final int METHODID_GET_LAST_PATH = 5;
  private static final int METHODID_GET_PATH = 6;
  private static final int METHODID_MOVE_USER = 7;
  private static final int METHODID_TAKE_TRIP = 8;
  private static final int METHODID_GET_LOCATIONS = 9;

  private static final class MethodHandlers<Req, Resp> implements
      io.grpc.stub.ServerCalls.UnaryMethod<Req, Resp>,
      io.grpc.stub.ServerCalls.ServerStreamingMethod<Req, Resp>,
      io.grpc.stub.ServerCalls.ClientStreamingMethod<Req, Resp>,
      io.grpc.stub.ServerCalls.BidiStreamingMethod<Req, Resp> {
    private final AsyncService serviceImpl;
    private final int methodId;

    MethodHandlers(AsyncService serviceImpl, int methodId) {
      this.serviceImpl = serviceImpl;
      this.methodId = methodId;
    }

    @java.lang.Override
    @java.lang.SuppressWarnings("unchecked")
    public void invoke(Req request, io.grpc.stub.StreamObserver<Resp> responseObserver) {
      switch (methodId) {
        case METHODID_CREATE_USER:
          serviceImpl.createUser((com.example.grpcClient.tracker.TrackerOuterClass.Username) request,
              (io.grpc.stub.StreamObserver<com.example.grpcClient.tracker.TrackerOuterClass.UserResponse>) responseObserver);
          break;
        case METHODID_GET_USERS:
          serviceImpl.getUsers((com.google.protobuf.Empty) request,
              (io.grpc.stub.StreamObserver<com.example.grpcClient.tracker.TrackerOuterClass.UserResponse>) responseObserver);
          break;
        case METHODID_GET_USER:
          serviceImpl.getUser((com.example.grpcClient.tracker.TrackerOuterClass.Username) request,
              (io.grpc.stub.StreamObserver<com.example.grpcClient.tracker.TrackerOuterClass.UserResponse>) responseObserver);
          break;
        case METHODID_GET_LOCATION:
          serviceImpl.getLocation((com.example.grpcClient.tracker.TrackerOuterClass.Username) request,
              (io.grpc.stub.StreamObserver<com.example.grpcClient.tracker.TrackerOuterClass.UserResponse>) responseObserver);
          break;
        case METHODID_GET_CURRENT_LOCATION:
          serviceImpl.getCurrentLocation((com.example.grpcClient.tracker.TrackerOuterClass.Username) request,
              (io.grpc.stub.StreamObserver<com.example.grpcClient.tracker.TrackerOuterClass.LocationResponse>) responseObserver);
          break;
        case METHODID_GET_LAST_PATH:
          serviceImpl.getLastPath((com.example.grpcClient.tracker.TrackerOuterClass.Username) request,
              (io.grpc.stub.StreamObserver<com.example.grpcClient.tracker.TrackerOuterClass.LocationResponse>) responseObserver);
          break;
        case METHODID_GET_PATH:
          serviceImpl.getPath((com.example.grpcClient.tracker.TrackerOuterClass.PathRequest) request,
              (io.grpc.stub.StreamObserver<com.example.grpcClient.tracker.TrackerOuterClass.LocationResponse>) responseObserver);
          break;
        case METHODID_MOVE_USER:
          serviceImpl.moveUser((com.example.grpcClient.tracker.TrackerOuterClass.Username) request,
              (io.grpc.stub.StreamObserver<com.example.grpcClient.tracker.TrackerOuterClass.UserResponse>) responseObserver);
          break;
        case METHODID_TAKE_TRIP:
          serviceImpl.takeTrip((com.example.grpcClient.tracker.TrackerOuterClass.Username) request,
              (io.grpc.stub.StreamObserver<com.example.grpcClient.tracker.TrackerOuterClass.UserResponse>) responseObserver);
          break;
        default:
          throw new AssertionError();
      }
    }

    @java.lang.Override
    @java.lang.SuppressWarnings("unchecked")
    public io.grpc.stub.StreamObserver<Req> invoke(
        io.grpc.stub.StreamObserver<Resp> responseObserver) {
      switch (methodId) {
        case METHODID_GET_LOCATIONS:
          return (io.grpc.stub.StreamObserver<Req>) serviceImpl.getLocations(
              (io.grpc.stub.StreamObserver<com.example.grpcClient.tracker.TrackerOuterClass.LocationResponse>) responseObserver);
        default:
          throw new AssertionError();
      }
    }
  }

  public static final io.grpc.ServerServiceDefinition bindService(AsyncService service) {
    return io.grpc.ServerServiceDefinition.builder(getServiceDescriptor())
        .addMethod(
          getCreateUserMethod(),
          io.grpc.stub.ServerCalls.asyncUnaryCall(
            new MethodHandlers<
              com.example.grpcClient.tracker.TrackerOuterClass.Username,
              com.example.grpcClient.tracker.TrackerOuterClass.UserResponse>(
                service, METHODID_CREATE_USER)))
        .addMethod(
          getGetUsersMethod(),
          io.grpc.stub.ServerCalls.asyncServerStreamingCall(
            new MethodHandlers<
              com.google.protobuf.Empty,
              com.example.grpcClient.tracker.TrackerOuterClass.UserResponse>(
                service, METHODID_GET_USERS)))
        .addMethod(
          getGetUserMethod(),
          io.grpc.stub.ServerCalls.asyncUnaryCall(
            new MethodHandlers<
              com.example.grpcClient.tracker.TrackerOuterClass.Username,
              com.example.grpcClient.tracker.TrackerOuterClass.UserResponse>(
                service, METHODID_GET_USER)))
        .addMethod(
          getGetLocationMethod(),
          io.grpc.stub.ServerCalls.asyncServerStreamingCall(
            new MethodHandlers<
              com.example.grpcClient.tracker.TrackerOuterClass.Username,
              com.example.grpcClient.tracker.TrackerOuterClass.UserResponse>(
                service, METHODID_GET_LOCATION)))
        .addMethod(
          getGetCurrentLocationMethod(),
          io.grpc.stub.ServerCalls.asyncUnaryCall(
            new MethodHandlers<
              com.example.grpcClient.tracker.TrackerOuterClass.Username,
              com.example.grpcClient.tracker.TrackerOuterClass.LocationResponse>(
                service, METHODID_GET_CURRENT_LOCATION)))
        .addMethod(
          getGetLastPathMethod(),
          io.grpc.stub.ServerCalls.asyncServerStreamingCall(
            new MethodHandlers<
              com.example.grpcClient.tracker.TrackerOuterClass.Username,
              com.example.grpcClient.tracker.TrackerOuterClass.LocationResponse>(
                service, METHODID_GET_LAST_PATH)))
        .addMethod(
          getGetPathMethod(),
          io.grpc.stub.ServerCalls.asyncServerStreamingCall(
            new MethodHandlers<
              com.example.grpcClient.tracker.TrackerOuterClass.PathRequest,
              com.example.grpcClient.tracker.TrackerOuterClass.LocationResponse>(
                service, METHODID_GET_PATH)))
        .addMethod(
          getMoveUserMethod(),
          io.grpc.stub.ServerCalls.asyncUnaryCall(
            new MethodHandlers<
              com.example.grpcClient.tracker.TrackerOuterClass.Username,
              com.example.grpcClient.tracker.TrackerOuterClass.UserResponse>(
                service, METHODID_MOVE_USER)))
        .addMethod(
          getTakeTripMethod(),
          io.grpc.stub.ServerCalls.asyncUnaryCall(
            new MethodHandlers<
              com.example.grpcClient.tracker.TrackerOuterClass.Username,
              com.example.grpcClient.tracker.TrackerOuterClass.UserResponse>(
                service, METHODID_TAKE_TRIP)))
        .addMethod(
          getGetLocationsMethod(),
          io.grpc.stub.ServerCalls.asyncBidiStreamingCall(
            new MethodHandlers<
              com.example.grpcClient.tracker.TrackerOuterClass.Username,
              com.example.grpcClient.tracker.TrackerOuterClass.LocationResponse>(
                service, METHODID_GET_LOCATIONS)))
        .build();
  }

  private static abstract class TrackerBaseDescriptorSupplier
      implements io.grpc.protobuf.ProtoFileDescriptorSupplier, io.grpc.protobuf.ProtoServiceDescriptorSupplier {
    TrackerBaseDescriptorSupplier() {}

    @java.lang.Override
    public com.google.protobuf.Descriptors.FileDescriptor getFileDescriptor() {
      return com.example.grpcClient.tracker.TrackerOuterClass.getDescriptor();
    }

    @java.lang.Override
    public com.google.protobuf.Descriptors.ServiceDescriptor getServiceDescriptor() {
      return getFileDescriptor().findServiceByName("Tracker");
    }
  }

  private static final class TrackerFileDescriptorSupplier
      extends TrackerBaseDescriptorSupplier {
    TrackerFileDescriptorSupplier() {}
  }

  private static final class TrackerMethodDescriptorSupplier
      extends TrackerBaseDescriptorSupplier
      implements io.grpc.protobuf.ProtoMethodDescriptorSupplier {
    private final String methodName;

    TrackerMethodDescriptorSupplier(String methodName) {
      this.methodName = methodName;
    }

    @java.lang.Override
    public com.google.protobuf.Descriptors.MethodDescriptor getMethodDescriptor() {
      return getServiceDescriptor().findMethodByName(methodName);
    }
  }

  private static volatile io.grpc.ServiceDescriptor serviceDescriptor;

  public static io.grpc.ServiceDescriptor getServiceDescriptor() {
    io.grpc.ServiceDescriptor result = serviceDescriptor;
    if (result == null) {
      synchronized (TrackerGrpc.class) {
        result = serviceDescriptor;
        if (result == null) {
          serviceDescriptor = result = io.grpc.ServiceDescriptor.newBuilder(SERVICE_NAME)
              .setSchemaDescriptor(new TrackerFileDescriptorSupplier())
              .addMethod(getCreateUserMethod())
              .addMethod(getGetUsersMethod())
              .addMethod(getGetUserMethod())
              .addMethod(getGetLocationMethod())
              .addMethod(getGetCurrentLocationMethod())
              .addMethod(getGetLastPathMethod())
              .addMethod(getGetPathMethod())
              .addMethod(getMoveUserMethod())
              .addMethod(getTakeTripMethod())
              .addMethod(getGetLocationsMethod())
              .build();
        }
      }
    }
    return result;
  }
}
