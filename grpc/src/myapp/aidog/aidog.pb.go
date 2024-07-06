// Code generated by protoc-gen-go. DO NOT EDIT.
// versions:
// 	protoc-gen-go v1.28.1
// 	protoc        v3.21.12
// source: aidog/aidog.proto

package aidog

import (
	protoreflect "google.golang.org/protobuf/reflect/protoreflect"
	protoimpl "google.golang.org/protobuf/runtime/protoimpl"
	reflect "reflect"
	sync "sync"
)

const (
	// Verify that this generated code is sufficiently up-to-date.
	_ = protoimpl.EnforceVersion(20 - protoimpl.MinVersion)
	// Verify that runtime/protoimpl is sufficiently up-to-date.
	_ = protoimpl.EnforceVersion(protoimpl.MaxVersion - 20)
)

type QaRequest struct {
	state         protoimpl.MessageState
	sizeCache     protoimpl.SizeCache
	unknownFields protoimpl.UnknownFields

	Question string `protobuf:"bytes,1,opt,name=question,proto3" json:"question,omitempty"`
}

func (x *QaRequest) Reset() {
	*x = QaRequest{}
	if protoimpl.UnsafeEnabled {
		mi := &file_aidog_aidog_proto_msgTypes[0]
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		ms.StoreMessageInfo(mi)
	}
}

func (x *QaRequest) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*QaRequest) ProtoMessage() {}

func (x *QaRequest) ProtoReflect() protoreflect.Message {
	mi := &file_aidog_aidog_proto_msgTypes[0]
	if protoimpl.UnsafeEnabled && x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use QaRequest.ProtoReflect.Descriptor instead.
func (*QaRequest) Descriptor() ([]byte, []int) {
	return file_aidog_aidog_proto_rawDescGZIP(), []int{0}
}

func (x *QaRequest) GetQuestion() string {
	if x != nil {
		return x.Question
	}
	return ""
}

type QaResponse struct {
	state         protoimpl.MessageState
	sizeCache     protoimpl.SizeCache
	unknownFields protoimpl.UnknownFields

	Answer string `protobuf:"bytes,1,opt,name=answer,proto3" json:"answer,omitempty"`
}

func (x *QaResponse) Reset() {
	*x = QaResponse{}
	if protoimpl.UnsafeEnabled {
		mi := &file_aidog_aidog_proto_msgTypes[1]
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		ms.StoreMessageInfo(mi)
	}
}

func (x *QaResponse) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*QaResponse) ProtoMessage() {}

func (x *QaResponse) ProtoReflect() protoreflect.Message {
	mi := &file_aidog_aidog_proto_msgTypes[1]
	if protoimpl.UnsafeEnabled && x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use QaResponse.ProtoReflect.Descriptor instead.
func (*QaResponse) Descriptor() ([]byte, []int) {
	return file_aidog_aidog_proto_rawDescGZIP(), []int{1}
}

func (x *QaResponse) GetAnswer() string {
	if x != nil {
		return x.Answer
	}
	return ""
}

var File_aidog_aidog_proto protoreflect.FileDescriptor

var file_aidog_aidog_proto_rawDesc = []byte{
	0x0a, 0x11, 0x61, 0x69, 0x64, 0x6f, 0x67, 0x2f, 0x61, 0x69, 0x64, 0x6f, 0x67, 0x2e, 0x70, 0x72,
	0x6f, 0x74, 0x6f, 0x12, 0x05, 0x61, 0x69, 0x64, 0x6f, 0x67, 0x22, 0x27, 0x0a, 0x09, 0x51, 0x61,
	0x52, 0x65, 0x71, 0x75, 0x65, 0x73, 0x74, 0x12, 0x1a, 0x0a, 0x08, 0x71, 0x75, 0x65, 0x73, 0x74,
	0x69, 0x6f, 0x6e, 0x18, 0x01, 0x20, 0x01, 0x28, 0x09, 0x52, 0x08, 0x71, 0x75, 0x65, 0x73, 0x74,
	0x69, 0x6f, 0x6e, 0x22, 0x24, 0x0a, 0x0a, 0x51, 0x61, 0x52, 0x65, 0x73, 0x70, 0x6f, 0x6e, 0x73,
	0x65, 0x12, 0x16, 0x0a, 0x06, 0x61, 0x6e, 0x73, 0x77, 0x65, 0x72, 0x18, 0x01, 0x20, 0x01, 0x28,
	0x09, 0x52, 0x06, 0x61, 0x6e, 0x73, 0x77, 0x65, 0x72, 0x32, 0x35, 0x0a, 0x05, 0x41, 0x69, 0x64,
	0x6f, 0x67, 0x12, 0x2c, 0x0a, 0x03, 0x41, 0x73, 0x6b, 0x12, 0x10, 0x2e, 0x61, 0x69, 0x64, 0x6f,
	0x67, 0x2e, 0x51, 0x61, 0x52, 0x65, 0x71, 0x75, 0x65, 0x73, 0x74, 0x1a, 0x11, 0x2e, 0x61, 0x69,
	0x64, 0x6f, 0x67, 0x2e, 0x51, 0x61, 0x52, 0x65, 0x73, 0x70, 0x6f, 0x6e, 0x73, 0x65, 0x22, 0x00,
	0x42, 0x1b, 0x5a, 0x19, 0x74, 0x61, 0x71, 0x75, 0x63, 0x69, 0x6e, 0x63, 0x6f, 0x2e, 0x63, 0x6f,
	0x6d, 0x2f, 0x6d, 0x79, 0x61, 0x70, 0x70, 0x2f, 0x61, 0x69, 0x64, 0x6f, 0x67, 0x62, 0x06, 0x70,
	0x72, 0x6f, 0x74, 0x6f, 0x33,
}

var (
	file_aidog_aidog_proto_rawDescOnce sync.Once
	file_aidog_aidog_proto_rawDescData = file_aidog_aidog_proto_rawDesc
)

func file_aidog_aidog_proto_rawDescGZIP() []byte {
	file_aidog_aidog_proto_rawDescOnce.Do(func() {
		file_aidog_aidog_proto_rawDescData = protoimpl.X.CompressGZIP(file_aidog_aidog_proto_rawDescData)
	})
	return file_aidog_aidog_proto_rawDescData
}

var file_aidog_aidog_proto_msgTypes = make([]protoimpl.MessageInfo, 2)
var file_aidog_aidog_proto_goTypes = []interface{}{
	(*QaRequest)(nil),  // 0: aidog.QaRequest
	(*QaResponse)(nil), // 1: aidog.QaResponse
}
var file_aidog_aidog_proto_depIdxs = []int32{
	0, // 0: aidog.Aidog.Ask:input_type -> aidog.QaRequest
	1, // 1: aidog.Aidog.Ask:output_type -> aidog.QaResponse
	1, // [1:2] is the sub-list for method output_type
	0, // [0:1] is the sub-list for method input_type
	0, // [0:0] is the sub-list for extension type_name
	0, // [0:0] is the sub-list for extension extendee
	0, // [0:0] is the sub-list for field type_name
}

func init() { file_aidog_aidog_proto_init() }
func file_aidog_aidog_proto_init() {
	if File_aidog_aidog_proto != nil {
		return
	}
	if !protoimpl.UnsafeEnabled {
		file_aidog_aidog_proto_msgTypes[0].Exporter = func(v interface{}, i int) interface{} {
			switch v := v.(*QaRequest); i {
			case 0:
				return &v.state
			case 1:
				return &v.sizeCache
			case 2:
				return &v.unknownFields
			default:
				return nil
			}
		}
		file_aidog_aidog_proto_msgTypes[1].Exporter = func(v interface{}, i int) interface{} {
			switch v := v.(*QaResponse); i {
			case 0:
				return &v.state
			case 1:
				return &v.sizeCache
			case 2:
				return &v.unknownFields
			default:
				return nil
			}
		}
	}
	type x struct{}
	out := protoimpl.TypeBuilder{
		File: protoimpl.DescBuilder{
			GoPackagePath: reflect.TypeOf(x{}).PkgPath(),
			RawDescriptor: file_aidog_aidog_proto_rawDesc,
			NumEnums:      0,
			NumMessages:   2,
			NumExtensions: 0,
			NumServices:   1,
		},
		GoTypes:           file_aidog_aidog_proto_goTypes,
		DependencyIndexes: file_aidog_aidog_proto_depIdxs,
		MessageInfos:      file_aidog_aidog_proto_msgTypes,
	}.Build()
	File_aidog_aidog_proto = out.File
	file_aidog_aidog_proto_rawDesc = nil
	file_aidog_aidog_proto_goTypes = nil
	file_aidog_aidog_proto_depIdxs = nil
}
