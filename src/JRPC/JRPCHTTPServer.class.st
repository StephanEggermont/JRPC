Class {
	#name : #JRPCHTTPServer,
	#superclass : #JRPCAbstractServer,
	#instVars : [
		'server'
	],
	#category : #'JRPC-Servers'
}

{ #category : #defaults }
JRPCHTTPServer class >> defaultPort [
	^ 4000
]

{ #category : #defaults }
JRPCHTTPServer >> defaultPort [
	^ self class defaultPort
]

{ #category : #'handling - jrpc' }
JRPCHTTPServer >> handleJRPCRequestObject: aJRPCRequestObject [
	[ | handler |
		handler := self handlerForName: aJRPCRequestObject method.
		
	] on: JRPCError
	do: [ :jrpcError |
		^ jrpcError asJRPCResponseWithId: aJRPCRequestObject id ]
]

{ #category : #'handling - http' }
JRPCHTTPServer >> handleRequest: aRequest [
	| jrpcRequest jrpcResponse |
	jrpcRequest := self parseSupposedJRPCMessageObjectFromString: aRequest contents.
	jrpcResponse := self handleJRPCRequestObject: jrpcRequest.
	
	
	^ ZnResponse ok: (ZnEntity json: (STONJSON toString: jrpcResponse asDictionary))
]

{ #category : #initialization }
JRPCHTTPServer >> initialize [
	super initialize.
	server := ZnServer defaultServerClass new.
	
	server
		port: self defaultPort;
		delegate: self
]

{ #category : #accessing }
JRPCHTTPServer >> port [
	^ server port
]

{ #category : #accessing }
JRPCHTTPServer >> port: anInteger [
	server port: anInteger
]

{ #category : #starting }
JRPCHTTPServer >> start [
	server start
]

{ #category : #starting }
JRPCHTTPServer >> stop [
	server stop
]