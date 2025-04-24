package com.example.grpcClient.tracker

import com.example.grpcClient.tracker.TrackerGrpc.getServiceDescriptor
import com.google.protobuf.Empty
import io.grpc.CallOptions
import io.grpc.CallOptions.DEFAULT
import io.grpc.Channel
import io.grpc.Metadata
import io.grpc.MethodDescriptor
import io.grpc.ServerServiceDefinition
import io.grpc.ServerServiceDefinition.builder
import io.grpc.ServiceDescriptor
import io.grpc.Status
import io.grpc.Status.UNIMPLEMENTED
import io.grpc.StatusException
import io.grpc.kotlin.AbstractCoroutineServerImpl
import io.grpc.kotlin.AbstractCoroutineStub
import io.grpc.kotlin.ClientCalls
import io.grpc.kotlin.ClientCalls.bidiStreamingRpc
import io.grpc.kotlin.ClientCalls.serverStreamingRpc
import io.grpc.kotlin.ClientCalls.unaryRpc
import io.grpc.kotlin.ServerCalls
import io.grpc.kotlin.ServerCalls.bidiStreamingServerMethodDefinition
import io.grpc.kotlin.ServerCalls.serverStreamingServerMethodDefinition
import io.grpc.kotlin.ServerCalls.unaryServerMethodDefinition
import io.grpc.kotlin.StubFor
import kotlin.String
import kotlin.coroutines.CoroutineContext
import kotlin.coroutines.EmptyCoroutineContext
import kotlin.jvm.JvmOverloads
import kotlin.jvm.JvmStatic
import kotlinx.coroutines.flow.Flow

/**
 * Holder for Kotlin coroutine-based client and server APIs for Tracker.
 */
public object TrackerGrpcKt {
  public const val SERVICE_NAME: String = TrackerGrpc.SERVICE_NAME

  @JvmStatic
  public val serviceDescriptor: ServiceDescriptor
    get() = TrackerGrpc.getServiceDescriptor()

  public val createUserMethod:
      MethodDescriptor<TrackerOuterClass.Username, TrackerOuterClass.UserResponse>
    @JvmStatic
    get() = TrackerGrpc.getCreateUserMethod()

  public val getUsersMethod: MethodDescriptor<Empty, TrackerOuterClass.UserResponse>
    @JvmStatic
    get() = TrackerGrpc.getGetUsersMethod()

  public val getUserMethod:
      MethodDescriptor<TrackerOuterClass.Username, TrackerOuterClass.UserResponse>
    @JvmStatic
    get() = TrackerGrpc.getGetUserMethod()

  public val getLocationMethod:
      MethodDescriptor<TrackerOuterClass.Username, TrackerOuterClass.UserResponse>
    @JvmStatic
    get() = TrackerGrpc.getGetLocationMethod()

  public val getCurrentLocationMethod:
      MethodDescriptor<TrackerOuterClass.Username, TrackerOuterClass.LocationResponse>
    @JvmStatic
    get() = TrackerGrpc.getGetCurrentLocationMethod()

  public val getLastPathMethod:
      MethodDescriptor<TrackerOuterClass.Username, TrackerOuterClass.LocationResponse>
    @JvmStatic
    get() = TrackerGrpc.getGetLastPathMethod()

  public val getPathMethod:
      MethodDescriptor<TrackerOuterClass.PathRequest, TrackerOuterClass.LocationResponse>
    @JvmStatic
    get() = TrackerGrpc.getGetPathMethod()

  public val moveUserMethod:
      MethodDescriptor<TrackerOuterClass.Username, TrackerOuterClass.UserResponse>
    @JvmStatic
    get() = TrackerGrpc.getMoveUserMethod()

  public val takeTripMethod:
      MethodDescriptor<TrackerOuterClass.Username, TrackerOuterClass.UserResponse>
    @JvmStatic
    get() = TrackerGrpc.getTakeTripMethod()

  public val getLocationsMethod:
      MethodDescriptor<TrackerOuterClass.Username, TrackerOuterClass.LocationResponse>
    @JvmStatic
    get() = TrackerGrpc.getGetLocationsMethod()

  /**
   * A stub for issuing RPCs to a(n) Tracker service as suspending coroutines.
   */
  @StubFor(TrackerGrpc::class)
  public class TrackerCoroutineStub @JvmOverloads constructor(
    channel: Channel,
    callOptions: CallOptions = DEFAULT,
  ) : AbstractCoroutineStub<TrackerCoroutineStub>(channel, callOptions) {
    public override fun build(channel: Channel, callOptions: CallOptions): TrackerCoroutineStub =
        TrackerCoroutineStub(channel, callOptions)

    /**
     * Executes this RPC and returns the response message, suspending until the RPC completes
     * with [`Status.OK`][Status].  If the RPC completes with another status, a corresponding
     * [StatusException] is thrown.  If this coroutine is cancelled, the RPC is also cancelled
     * with the corresponding exception as a cause.
     *
     * @param request The request message to send to the server.
     *
     * @param headers Metadata to attach to the request.  Most users will not need this.
     *
     * @return The single response from the server.
     */
    public suspend fun createUser(request: TrackerOuterClass.Username, headers: Metadata =
        Metadata()): TrackerOuterClass.UserResponse = unaryRpc(
      channel,
      TrackerGrpc.getCreateUserMethod(),
      request,
      callOptions,
      headers
    )

    /**
     * Returns a [Flow] that, when collected, executes this RPC and emits responses from the
     * server as they arrive.  That flow finishes normally if the server closes its response with
     * [`Status.OK`][Status], and fails by throwing a [StatusException] otherwise.  If
     * collecting the flow downstream fails exceptionally (including via cancellation), the RPC
     * is cancelled with that exception as a cause.
     *
     * @param request The request message to send to the server.
     *
     * @param headers Metadata to attach to the request.  Most users will not need this.
     *
     * @return A flow that, when collected, emits the responses from the server.
     */
    public fun getUsers(request: Empty, headers: Metadata = Metadata()):
        Flow<TrackerOuterClass.UserResponse> = serverStreamingRpc(
      channel,
      TrackerGrpc.getGetUsersMethod(),
      request,
      callOptions,
      headers
    )

    /**
     * Executes this RPC and returns the response message, suspending until the RPC completes
     * with [`Status.OK`][Status].  If the RPC completes with another status, a corresponding
     * [StatusException] is thrown.  If this coroutine is cancelled, the RPC is also cancelled
     * with the corresponding exception as a cause.
     *
     * @param request The request message to send to the server.
     *
     * @param headers Metadata to attach to the request.  Most users will not need this.
     *
     * @return The single response from the server.
     */
    public suspend fun getUser(request: TrackerOuterClass.Username, headers: Metadata = Metadata()):
        TrackerOuterClass.UserResponse = unaryRpc(
      channel,
      TrackerGrpc.getGetUserMethod(),
      request,
      callOptions,
      headers
    )

    /**
     * Returns a [Flow] that, when collected, executes this RPC and emits responses from the
     * server as they arrive.  That flow finishes normally if the server closes its response with
     * [`Status.OK`][Status], and fails by throwing a [StatusException] otherwise.  If
     * collecting the flow downstream fails exceptionally (including via cancellation), the RPC
     * is cancelled with that exception as a cause.
     *
     * @param request The request message to send to the server.
     *
     * @param headers Metadata to attach to the request.  Most users will not need this.
     *
     * @return A flow that, when collected, emits the responses from the server.
     */
    public fun getLocation(request: TrackerOuterClass.Username, headers: Metadata = Metadata()):
        Flow<TrackerOuterClass.UserResponse> = serverStreamingRpc(
      channel,
      TrackerGrpc.getGetLocationMethod(),
      request,
      callOptions,
      headers
    )

    /**
     * Executes this RPC and returns the response message, suspending until the RPC completes
     * with [`Status.OK`][Status].  If the RPC completes with another status, a corresponding
     * [StatusException] is thrown.  If this coroutine is cancelled, the RPC is also cancelled
     * with the corresponding exception as a cause.
     *
     * @param request The request message to send to the server.
     *
     * @param headers Metadata to attach to the request.  Most users will not need this.
     *
     * @return The single response from the server.
     */
    public suspend fun getCurrentLocation(request: TrackerOuterClass.Username, headers: Metadata =
        Metadata()): TrackerOuterClass.LocationResponse = unaryRpc(
      channel,
      TrackerGrpc.getGetCurrentLocationMethod(),
      request,
      callOptions,
      headers
    )

    /**
     * Returns a [Flow] that, when collected, executes this RPC and emits responses from the
     * server as they arrive.  That flow finishes normally if the server closes its response with
     * [`Status.OK`][Status], and fails by throwing a [StatusException] otherwise.  If
     * collecting the flow downstream fails exceptionally (including via cancellation), the RPC
     * is cancelled with that exception as a cause.
     *
     * @param request The request message to send to the server.
     *
     * @param headers Metadata to attach to the request.  Most users will not need this.
     *
     * @return A flow that, when collected, emits the responses from the server.
     */
    public fun getLastPath(request: TrackerOuterClass.Username, headers: Metadata = Metadata()):
        Flow<TrackerOuterClass.LocationResponse> = serverStreamingRpc(
      channel,
      TrackerGrpc.getGetLastPathMethod(),
      request,
      callOptions,
      headers
    )

    /**
     * Returns a [Flow] that, when collected, executes this RPC and emits responses from the
     * server as they arrive.  That flow finishes normally if the server closes its response with
     * [`Status.OK`][Status], and fails by throwing a [StatusException] otherwise.  If
     * collecting the flow downstream fails exceptionally (including via cancellation), the RPC
     * is cancelled with that exception as a cause.
     *
     * @param request The request message to send to the server.
     *
     * @param headers Metadata to attach to the request.  Most users will not need this.
     *
     * @return A flow that, when collected, emits the responses from the server.
     */
    public fun getPath(request: TrackerOuterClass.PathRequest, headers: Metadata = Metadata()):
        Flow<TrackerOuterClass.LocationResponse> = serverStreamingRpc(
      channel,
      TrackerGrpc.getGetPathMethod(),
      request,
      callOptions,
      headers
    )

    /**
     * Executes this RPC and returns the response message, suspending until the RPC completes
     * with [`Status.OK`][Status].  If the RPC completes with another status, a corresponding
     * [StatusException] is thrown.  If this coroutine is cancelled, the RPC is also cancelled
     * with the corresponding exception as a cause.
     *
     * @param request The request message to send to the server.
     *
     * @param headers Metadata to attach to the request.  Most users will not need this.
     *
     * @return The single response from the server.
     */
    public suspend fun moveUser(request: TrackerOuterClass.Username, headers: Metadata =
        Metadata()): TrackerOuterClass.UserResponse = unaryRpc(
      channel,
      TrackerGrpc.getMoveUserMethod(),
      request,
      callOptions,
      headers
    )

    /**
     * Executes this RPC and returns the response message, suspending until the RPC completes
     * with [`Status.OK`][Status].  If the RPC completes with another status, a corresponding
     * [StatusException] is thrown.  If this coroutine is cancelled, the RPC is also cancelled
     * with the corresponding exception as a cause.
     *
     * @param request The request message to send to the server.
     *
     * @param headers Metadata to attach to the request.  Most users will not need this.
     *
     * @return The single response from the server.
     */
    public suspend fun takeTrip(request: TrackerOuterClass.Username, headers: Metadata =
        Metadata()): TrackerOuterClass.UserResponse = unaryRpc(
      channel,
      TrackerGrpc.getTakeTripMethod(),
      request,
      callOptions,
      headers
    )

    /**
     * Returns a [Flow] that, when collected, executes this RPC and emits responses from the
     * server as they arrive.  That flow finishes normally if the server closes its response with
     * [`Status.OK`][Status], and fails by throwing a [StatusException] otherwise.  If
     * collecting the flow downstream fails exceptionally (including via cancellation), the RPC
     * is cancelled with that exception as a cause.
     *
     * The [Flow] of requests is collected once each time the [Flow] of responses is
     * collected. If collection of the [Flow] of responses completes normally or
     * exceptionally before collection of `requests` completes, the collection of
     * `requests` is cancelled.  If the collection of `requests` completes
     * exceptionally for any other reason, then the collection of the [Flow] of responses
     * completes exceptionally for the same reason and the RPC is cancelled with that reason.
     *
     * @param requests A [Flow] of request messages.
     *
     * @param headers Metadata to attach to the request.  Most users will not need this.
     *
     * @return A flow that, when collected, emits the responses from the server.
     */
    public fun getLocations(requests: Flow<TrackerOuterClass.Username>, headers: Metadata =
        Metadata()): Flow<TrackerOuterClass.LocationResponse> = bidiStreamingRpc(
      channel,
      TrackerGrpc.getGetLocationsMethod(),
      requests,
      callOptions,
      headers
    )
  }

  /**
   * Skeletal implementation of the Tracker service based on Kotlin coroutines.
   */
  public abstract class TrackerCoroutineImplBase(
    coroutineContext: CoroutineContext = EmptyCoroutineContext,
  ) : AbstractCoroutineServerImpl(coroutineContext) {
    /**
     * Returns the response to an RPC for Tracker.CreateUser.
     *
     * If this method fails with a [StatusException], the RPC will fail with the corresponding
     * [Status].  If this method fails with a [java.util.concurrent.CancellationException], the RPC
     * will fail
     * with status `Status.CANCELLED`.  If this method fails for any other reason, the RPC will
     * fail with `Status.UNKNOWN` with the exception as a cause.
     *
     * @param request The request from the client.
     */
    public open suspend fun createUser(request: TrackerOuterClass.Username):
        TrackerOuterClass.UserResponse = throw
        StatusException(UNIMPLEMENTED.withDescription("Method Tracker.CreateUser is unimplemented"))

    /**
     * Returns a [Flow] of responses to an RPC for Tracker.GetUsers.
     *
     * If creating or collecting the returned flow fails with a [StatusException], the RPC
     * will fail with the corresponding [Status].  If it fails with a
     * [java.util.concurrent.CancellationException], the RPC will fail with status
     * `Status.CANCELLED`.  If creating
     * or collecting the returned flow fails for any other reason, the RPC will fail with
     * `Status.UNKNOWN` with the exception as a cause.
     *
     * @param request The request from the client.
     */
    public open fun getUsers(request: Empty): Flow<TrackerOuterClass.UserResponse> = throw
        StatusException(UNIMPLEMENTED.withDescription("Method Tracker.GetUsers is unimplemented"))

    /**
     * Returns the response to an RPC for Tracker.GetUser.
     *
     * If this method fails with a [StatusException], the RPC will fail with the corresponding
     * [Status].  If this method fails with a [java.util.concurrent.CancellationException], the RPC
     * will fail
     * with status `Status.CANCELLED`.  If this method fails for any other reason, the RPC will
     * fail with `Status.UNKNOWN` with the exception as a cause.
     *
     * @param request The request from the client.
     */
    public open suspend fun getUser(request: TrackerOuterClass.Username):
        TrackerOuterClass.UserResponse = throw
        StatusException(UNIMPLEMENTED.withDescription("Method Tracker.GetUser is unimplemented"))

    /**
     * Returns a [Flow] of responses to an RPC for Tracker.GetLocation.
     *
     * If creating or collecting the returned flow fails with a [StatusException], the RPC
     * will fail with the corresponding [Status].  If it fails with a
     * [java.util.concurrent.CancellationException], the RPC will fail with status
     * `Status.CANCELLED`.  If creating
     * or collecting the returned flow fails for any other reason, the RPC will fail with
     * `Status.UNKNOWN` with the exception as a cause.
     *
     * @param request The request from the client.
     */
    public open fun getLocation(request: TrackerOuterClass.Username):
        Flow<TrackerOuterClass.UserResponse> = throw
        StatusException(UNIMPLEMENTED.withDescription("Method Tracker.GetLocation is unimplemented"))

    /**
     * Returns the response to an RPC for Tracker.GetCurrentLocation.
     *
     * If this method fails with a [StatusException], the RPC will fail with the corresponding
     * [Status].  If this method fails with a [java.util.concurrent.CancellationException], the RPC
     * will fail
     * with status `Status.CANCELLED`.  If this method fails for any other reason, the RPC will
     * fail with `Status.UNKNOWN` with the exception as a cause.
     *
     * @param request The request from the client.
     */
    public open suspend fun getCurrentLocation(request: TrackerOuterClass.Username):
        TrackerOuterClass.LocationResponse = throw
        StatusException(UNIMPLEMENTED.withDescription("Method Tracker.GetCurrentLocation is unimplemented"))

    /**
     * Returns a [Flow] of responses to an RPC for Tracker.GetLastPath.
     *
     * If creating or collecting the returned flow fails with a [StatusException], the RPC
     * will fail with the corresponding [Status].  If it fails with a
     * [java.util.concurrent.CancellationException], the RPC will fail with status
     * `Status.CANCELLED`.  If creating
     * or collecting the returned flow fails for any other reason, the RPC will fail with
     * `Status.UNKNOWN` with the exception as a cause.
     *
     * @param request The request from the client.
     */
    public open fun getLastPath(request: TrackerOuterClass.Username):
        Flow<TrackerOuterClass.LocationResponse> = throw
        StatusException(UNIMPLEMENTED.withDescription("Method Tracker.GetLastPath is unimplemented"))

    /**
     * Returns a [Flow] of responses to an RPC for Tracker.GetPath.
     *
     * If creating or collecting the returned flow fails with a [StatusException], the RPC
     * will fail with the corresponding [Status].  If it fails with a
     * [java.util.concurrent.CancellationException], the RPC will fail with status
     * `Status.CANCELLED`.  If creating
     * or collecting the returned flow fails for any other reason, the RPC will fail with
     * `Status.UNKNOWN` with the exception as a cause.
     *
     * @param request The request from the client.
     */
    public open fun getPath(request: TrackerOuterClass.PathRequest):
        Flow<TrackerOuterClass.LocationResponse> = throw
        StatusException(UNIMPLEMENTED.withDescription("Method Tracker.GetPath is unimplemented"))

    /**
     * Returns the response to an RPC for Tracker.MoveUser.
     *
     * If this method fails with a [StatusException], the RPC will fail with the corresponding
     * [Status].  If this method fails with a [java.util.concurrent.CancellationException], the RPC
     * will fail
     * with status `Status.CANCELLED`.  If this method fails for any other reason, the RPC will
     * fail with `Status.UNKNOWN` with the exception as a cause.
     *
     * @param request The request from the client.
     */
    public open suspend fun moveUser(request: TrackerOuterClass.Username):
        TrackerOuterClass.UserResponse = throw
        StatusException(UNIMPLEMENTED.withDescription("Method Tracker.MoveUser is unimplemented"))

    /**
     * Returns the response to an RPC for Tracker.TakeTrip.
     *
     * If this method fails with a [StatusException], the RPC will fail with the corresponding
     * [Status].  If this method fails with a [java.util.concurrent.CancellationException], the RPC
     * will fail
     * with status `Status.CANCELLED`.  If this method fails for any other reason, the RPC will
     * fail with `Status.UNKNOWN` with the exception as a cause.
     *
     * @param request The request from the client.
     */
    public open suspend fun takeTrip(request: TrackerOuterClass.Username):
        TrackerOuterClass.UserResponse = throw
        StatusException(UNIMPLEMENTED.withDescription("Method Tracker.TakeTrip is unimplemented"))

    /**
     * Returns a [Flow] of responses to an RPC for Tracker.GetLocations.
     *
     * If creating or collecting the returned flow fails with a [StatusException], the RPC
     * will fail with the corresponding [Status].  If it fails with a
     * [java.util.concurrent.CancellationException], the RPC will fail with status
     * `Status.CANCELLED`.  If creating
     * or collecting the returned flow fails for any other reason, the RPC will fail with
     * `Status.UNKNOWN` with the exception as a cause.
     *
     * @param requests A [Flow] of requests from the client.  This flow can be
     *        collected only once and throws [java.lang.IllegalStateException] on attempts to
     * collect
     *        it more than once.
     */
    public open fun getLocations(requests: Flow<TrackerOuterClass.Username>):
        Flow<TrackerOuterClass.LocationResponse> = throw
        StatusException(UNIMPLEMENTED.withDescription("Method Tracker.GetLocations is unimplemented"))

    public final override fun bindService(): ServerServiceDefinition =
        builder(getServiceDescriptor())
      .addMethod(unaryServerMethodDefinition(
      context = this.context,
      descriptor = TrackerGrpc.getCreateUserMethod(),
      implementation = ::createUser
    ))
      .addMethod(serverStreamingServerMethodDefinition(
      context = this.context,
      descriptor = TrackerGrpc.getGetUsersMethod(),
      implementation = ::getUsers
    ))
      .addMethod(unaryServerMethodDefinition(
      context = this.context,
      descriptor = TrackerGrpc.getGetUserMethod(),
      implementation = ::getUser
    ))
      .addMethod(serverStreamingServerMethodDefinition(
      context = this.context,
      descriptor = TrackerGrpc.getGetLocationMethod(),
      implementation = ::getLocation
    ))
      .addMethod(unaryServerMethodDefinition(
      context = this.context,
      descriptor = TrackerGrpc.getGetCurrentLocationMethod(),
      implementation = ::getCurrentLocation
    ))
      .addMethod(serverStreamingServerMethodDefinition(
      context = this.context,
      descriptor = TrackerGrpc.getGetLastPathMethod(),
      implementation = ::getLastPath
    ))
      .addMethod(serverStreamingServerMethodDefinition(
      context = this.context,
      descriptor = TrackerGrpc.getGetPathMethod(),
      implementation = ::getPath
    ))
      .addMethod(unaryServerMethodDefinition(
      context = this.context,
      descriptor = TrackerGrpc.getMoveUserMethod(),
      implementation = ::moveUser
    ))
      .addMethod(unaryServerMethodDefinition(
      context = this.context,
      descriptor = TrackerGrpc.getTakeTripMethod(),
      implementation = ::takeTrip
    ))
      .addMethod(bidiStreamingServerMethodDefinition(
      context = this.context,
      descriptor = TrackerGrpc.getGetLocationsMethod(),
      implementation = ::getLocations
    )).build()
  }
}
