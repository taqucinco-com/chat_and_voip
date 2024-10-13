# chat_and_voip

## 初回設定

## gRPC

https://grpc.io/docs/protoc-installation/

### golang server

1. GolangのgRPCサーバーを起動する

```
$ docker compose exec app bash
# cd example.com
# go mod init example.com/myapp # この手順は新規で作成する場合に必要
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

1. GolangのREST APIサーバーを起動する

```
# cd /usr/src/app/myapp
go run main.go(_main copy.go_をmain.goに変える)
curl -i localhost:8080/auth/verify -H 'Authorization: Bearer {firebase idToken}'
curl -i -X POST localhost:8080/ai -d '{"question": "c言語の歴史を１００文字程度で教えてください"}'
```

1. Golangのアプリサーバーを起動する

```
# cd /usr/src/app/myapp
go run main.go(main.goをそのまま使う)
grpcurl -plaintext -d '{"question": "teach me about Flutter"}' -rpc-header 'Authorization: Bearer {your-token}' localhost:50051 aidog.Aidog.Ask
```

### flutter client

https://grpc.io/docs/languages/dart/quickstart/

1. Protocl bufferのdart pluginをインストール

```
$ brew install protobuf
$ dart pub global activate protoc_plugin
$ export PATH="$PATH:$HOME/.pub-cache/bin"
```

1. dartコードを生成する

```
$ cd myflutterapp
$ mkdir lib/src/generated -p
$ protoc --dart_out=grpc:lib/src/generated --proto_path ../grpc/src/example.com/helloworld/ helloworld.proto --plugin=protoc-gen-dart=$HOME/.pub-cache/bin/protoc-gen-dart 
```
## server stream

### proto

1. helloworld.protoを編集する

### golang

1. `helloworld.proto`のgolang生成コマンドを実行する
1. `{protoファイル名}_grpc.pb.go`から`Unimplemented{サービス名}Server`の定義を探す
1. `server.go`にインターフェースを実装する

### flutter

1. `helloworld.proto`のgolang生成コマンドを実行する
1. `{protoファイル名}.pbgrpc.dart`から`$async.Future<$0.FooResponse> barMethod($grpc.ServiceCall call, $0.FooRequest request);`の定義を探す
1. [dart公式サンプル](https://github.com/grpc/grpc-dart/blob/master/example/helloworld/bin/client.dart)を参考にインターフェースを実装する

## アプリ

```
dart pub run build_runner build
```