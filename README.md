# grpc-starter
Sample gRPC server-client setup where the server is Typescript NodeJS and the client is in Dart.

As of commit hash 6e3d1ad, a NodeJS server was setup to communitcate with a Dart front-end and everything was functioning. As the project was deployed as flutter web build, it was disocvered that to transfer GRPC request via HTTP you needed to create a proxy server that sent the traffic from the static front-end to the GRPC host server. 

This was deemed to be too much effort and required a massive change as to how the front-end was developed, tested, and deployed, so this is where the code was left off. The Unary GRPC request endpoints are working fine, but the streaming endpoints are not functional as HTTP REST requests don't support steaming very well and the code is about halfway between true streaming and a polling of unary GRPC endpoints to replicate the streaming info.

The front end can no longer communicate with the GRPC server as it stuck halfway between the original direct comms to the GRPC server and the HTTP proxy server implementation
