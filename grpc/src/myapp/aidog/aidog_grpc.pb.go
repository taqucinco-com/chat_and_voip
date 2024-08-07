// Code generated by protoc-gen-go-grpc. DO NOT EDIT.
// versions:
// - protoc-gen-go-grpc v1.2.0
// - protoc             v3.21.12
// source: aidog/aidog.proto

package aidog

import (
	context "context"
	grpc "google.golang.org/grpc"
	codes "google.golang.org/grpc/codes"
	status "google.golang.org/grpc/status"
)

// This is a compile-time assertion to ensure that this generated file
// is compatible with the grpc package it is being compiled against.
// Requires gRPC-Go v1.32.0 or later.
const _ = grpc.SupportPackageIsVersion7

// AidogClient is the client API for Aidog service.
//
// For semantics around ctx use and closing/ending streaming RPCs, please refer to https://pkg.go.dev/google.golang.org/grpc/?tab=doc#ClientConn.NewStream.
type AidogClient interface {
	Ask(ctx context.Context, in *QaRequest, opts ...grpc.CallOption) (*QaResponse, error)
}

type aidogClient struct {
	cc grpc.ClientConnInterface
}

func NewAidogClient(cc grpc.ClientConnInterface) AidogClient {
	return &aidogClient{cc}
}

func (c *aidogClient) Ask(ctx context.Context, in *QaRequest, opts ...grpc.CallOption) (*QaResponse, error) {
	out := new(QaResponse)
	err := c.cc.Invoke(ctx, "/aidog.Aidog/Ask", in, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

// AidogServer is the server API for Aidog service.
// All implementations must embed UnimplementedAidogServer
// for forward compatibility
type AidogServer interface {
	Ask(context.Context, *QaRequest) (*QaResponse, error)
	mustEmbedUnimplementedAidogServer()
}

// UnimplementedAidogServer must be embedded to have forward compatible implementations.
type UnimplementedAidogServer struct {
}

func (UnimplementedAidogServer) Ask(context.Context, *QaRequest) (*QaResponse, error) {
	return nil, status.Errorf(codes.Unimplemented, "method Ask not implemented")
}
func (UnimplementedAidogServer) mustEmbedUnimplementedAidogServer() {}

// UnsafeAidogServer may be embedded to opt out of forward compatibility for this service.
// Use of this interface is not recommended, as added methods to AidogServer will
// result in compilation errors.
type UnsafeAidogServer interface {
	mustEmbedUnimplementedAidogServer()
}

func RegisterAidogServer(s grpc.ServiceRegistrar, srv AidogServer) {
	s.RegisterService(&Aidog_ServiceDesc, srv)
}

func _Aidog_Ask_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(QaRequest)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(AidogServer).Ask(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: "/aidog.Aidog/Ask",
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(AidogServer).Ask(ctx, req.(*QaRequest))
	}
	return interceptor(ctx, in, info, handler)
}

// Aidog_ServiceDesc is the grpc.ServiceDesc for Aidog service.
// It's only intended for direct use with grpc.RegisterService,
// and not to be introspected or modified (even as a copy)
var Aidog_ServiceDesc = grpc.ServiceDesc{
	ServiceName: "aidog.Aidog",
	HandlerType: (*AidogServer)(nil),
	Methods: []grpc.MethodDesc{
		{
			MethodName: "Ask",
			Handler:    _Aidog_Ask_Handler,
		},
	},
	Streams:  []grpc.StreamDesc{},
	Metadata: "aidog/aidog.proto",
}
