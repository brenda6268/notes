# 一篇简单的 Python gRPC 教程


wp_id: 590
Status: publish
Date: 2018-07-15 05:22:00
Modified: 2020-05-16 11:19:21


# 安装

```
pip install grpcio grpcio-tools protobuf googleapis-common-protos
```

# IDL

grpc 使用 protobuf 来定义接口。按照 protobuf 的 [Style Guide](https://developers.google.com/protocol-buffers/docs/style) 的要求，service 和其中的方法都应该使用 CamelCase。

service 关键字定义一个服务，相当于一个接口。把下面的文件保存为 helloworld.proto

需要注意的是，grpc 中的方法只能接受一个参数，返回一个参数。

```
// The greeter service definition.
service Greeter {
  // Sends a greeting
  rpc SayHello (HelloRequest) returns (HelloReply) {}
}

// The request message containing the user"s name.
message HelloRequest {
  string name = 1;
}

// The response message containing the greetings
message HelloResponse {
  string message = 1;
}
```

## 生成 rpc 代码

```
python -m grpc_tools.protoc  --python_out=. --grpc_python_out=. helloworld.proto
```

生成了两个文件:

- helloworld_pb2，包含了 protobuf 中结构的定义
- helloworld_pb2_grpc, 包含了 protobuf grpc 接口的定义

## 实现 rpc 服务

```
from current.futures import ThreadPoolExecutor
from helloworld_pb2 import HelloRepsonse
from helloworld_pb2_grpc import GreeterServicer, add_GreeterServicer_to_server

class Greeter(GreeterServicer):

  def SayHello(self, request, context):
    return HelloResponse(message="Hello, %s!" % request.name)

  def SayHelloAgain(self, request, context):
    return HelloResponse(message="Hello again, %s!" % request.name)


def serve():
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    add_GreeterServicer_to_server(Greeter(), server)
    server.add_insecure_port("[::]:50051")
    server.start()
    try:
        while True:
            time.sleep(_ONE_DAY_IN_SECONDS)
    except KeyboardInterrupt:
        server.stop(0)
```

## 客户端调用

```
import grpc
from helloworld_pb2 import HelloRequest
from helloworld_pb2_grpc import GreeterStub


def run():
    # NOTE(gRPC Python Team): .close() is possible on a channel and should be
    # used in circumstances in which the with statement does not fit the needs
    # of the code.
    with grpc.insecure_channel("localhost:50051") as channel:
        stub = GreeterStub(channel)
        response = stub.SayHello(HelloRequest(name="you"))
    print("Greeter client received: " + response.message)
```

# 高级话题

stream

未完待续

# 参考

1. [A simplified guide to gRPC in Python](