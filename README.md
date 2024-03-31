# chat_and_voip

## 初回設定

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

```
$ brew install grpcurl
$ grpcurl -plaintext localhost:50051 list
    // greeter.Greeter
    // grpc.reflection.v1.ServerReflection
    // grpc.reflection.v1alpha.ServerReflection
    // サービスを表示する
$ grpcurl -plaintext localhost:50051 list greeter.Greeter
    // サービスのメソッドを表示する
    // greeter.Greeter.SayHello
$ grpcurl -plaintext -d '{"name": "taro"}' localhost:50051 greeter.Greeter.SayHello
```
