# chat_and_voip

## 初回設定

## gRPC

https://grpc.io/docs/protoc-installation/

### golang server

1. GOのサーバーを起動する

```
$ docker compose exec app bash
# go mod init example.com/myapp
    // go.modが作成される
$ protoc --go_out=. --go_opt=paths=source_relative \
    --go-grpc_out=. --go-grpc_opt=paths=source_relative \
    helloworld/helloworld.proto
    // helloworld.pb.go, helloworld_grpc.pb.goが作成される
$ go mod tidy
$ go run helloworld/greeter_server/server.go 
$ go run helloworld/greeter_client/client.go 
```

1. 確認方法

```
$ brew install grpcurl
$ grpcurl -plaintext localhost:50051 list
    // greeter.Greeter
    // grpc.reflection.v1.ServerReflection
    // grpc.reflection.v1alpha.ServerReflection
    // サービスを表示する
$ grpcurl -plaintext localhost:50051 list greeter.Greeter
    // サービスのメソッドを表示する
    // greeter.Greeter.SayChat
    // greeter.Greeter.SayHello
    // greeter.Greeter.SayHelloAgain
    // greeter.Greeter.SayHelloToMany
$ grpcurl -plaintext -d '{"name": "taro"}' localhost:50051 greeter.Greeter.SayHello
$ grpcurl -plaintext -d '{"name": "taro"}' localhost:50051 greeter.Greeter.SayHelloAgain
$ echo -e '{"name": "taro"}\n{"name": "hanako"}' | grpcurl -d @ -plaintext localhost:50051 greeter.Greeter.SayHelloToMany
$ echo -e '{"name": "taro"}\n{"name": "hanako"}' | grpcurl -d @ -plaintext localhost:50051 greeter.Greeter.SayChat
```

### flutter client

https://grpc.io/docs/languages/dart/quickstart/

1. Protocl bufferのdart pluginをインストール

```
$ dart pub global activate protoc_plugin
$ export PATH="$PATH:$HOME/.pub-cache/bin"
```

1. dartコードを生成する

```
$ cd myflutterapp
$ mkdir lib/src/generated -p
$ protoc --dart_out=grpc:lib/src/generated --proto_path ../grpc/src/helloworld/ helloworld.proto --plugin=protoc-gen-dart=$HOME/.pub-cache/bin/protoc-gen-dart 
```
## server stream

### proto

1. helloworld.protoを編集する

### golang

1. `helloworld.proto`のgolang生成コマンドを実行する
1. `{protoファイル名}_grpc.pb.go`から`Unimplemented{サービス名}Server`の定義を探す
1. `server.go`にインターフェースを実装する

### flutter
