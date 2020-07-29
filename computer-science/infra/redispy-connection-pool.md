# Python Redis 客户端连接池解析


<!--
ID: 2489a8b3-5fad-44c0-8fea-8a7ed4873e63
Status: publish
Date: 2018-11-21T22:47:00
Modified: 2020-05-16T11:06:50
wp_id: 617
-->


Python Redis 的客户端使用了链接池机制，通过复用链接可以减低服务器的压力并在失败时重试。连接池其实是一种很通用的机制，在实现客户端是是一个经常需要（或许其实不需要）重复发明的轮子。

Redis 客户端一共涉及到了三个类：

- Connection，表示一个到服务器的链接
- ConnectionPool，链接池
- Redis，使用连接池，并在失败时重试

# Connection 类解析

Connection 类主要负责建立和 Redis 服务器的一个 Socket 链接，并且沟通相关信息。下面的代码是 Connection 类和 socket 处理相关的代码。

```
class Connection(object):
    
    def __del__(self):
        try:
            self.disconnect()
        except Exception:
            pass

    def connect(self):
        """
        连接 Redis 服务器
        """
        if self._sock:
            return
        try:
            sock = self._connect()
        except socket.timeout:
            raise TimeoutError("Timeout connecting to server")
        except socket.error:
            e = sys.exc_info()[1]
            raise ConnectionError(self._error_message(e))

        self._sock = sock
        try:
            self.on_connect()
        except RedisError:
            # clean up after any error in on_connect
            self.disconnect()
            raise

        # run any user callbacks. right now the only internal callback
        # is for pubsub channel/pattern resubscription
        for callback in self._connect_callbacks:
            callback(self)

    def _connect(self):
        """
        建立链接的具体过程, 主要是 socket 操作
        """

    def disconnect(self):
        """
        关闭链接
        """
        self._parser.on_disconnect()
        if self._sock is None:
            return
        try:
            self._sock.shutdown(socket.SHUT_RDWR)
            self._sock.close()
        except socket.error:
            pass
        self._sock = None

    def send_packed_command(self, command):
        if not self._sock:
            self.connect()
        。。。
        # 发送命令到服务器
```

可以看出，Connection 类主要是在 socket 上的一层薄薄封装。当然，这个 Connection 不是线程安全的。

# ConnectionPool 类解析

redis.py 的代码中 ConnectionPool 分了两个类，基类 ConnectionPool，还有一个子类 BlockingConnectionPool。这里我感到有些不解，既然只有一个子类，不知道为什么还要分成两个类呢？可能是开始时候规划了好几个子类，最后只实现了一个吧……

其中 BlockingConnection 类不只是线程安全的，还是进程安全的。

```
class ConnectionPool(object):
    def __init__(self, connection_class=Connection, max_connections=None,
                 **connection_kwargs):
        max_connections = max_connections or 2 ** 31
        if not isinstance(max_connections, (int, long)) or max_connections < 0:
            raise ValueError(""max_connections" must be a positive integer")

        self.connection_class = connection_class
        self.connection_kwargs = connection_kwargs
        self.max_connections = max_connections

        self.reset()  # 调用 reset 初始化一些属性

    def reset(self):
        self.pid = os.getpid()  # 通过 pid 检查实现进程安全
        self._created_connections = 0
        self._available_connections = []  # 直接使用一个 list 来存放连接
        self._in_use_connections = set()
        self._check_lock = threading.Lock()

    def _checkpid(self):
        # 如果当前的 connection 是 fork 来的，直接关闭链接
        if self.pid != os.getpid():
            with self._check_lock:
                if self.pid == os.getpid():
                    # 另一个线程已经检查了，直接返回
                    return
                self.disconnect()
                self.reset()

    def get_connection(self, command_name, *keys, **options):
        # 从连接池中取一个连接，注意这里是弹出，也就是同一个链接只有一个用户使用
        self._checkpid()
        try:
            connection = self._available_connections.pop()
        except IndexError:
            connection = self.make_connection()
        self._in_use_connections.add(connection)
        return connection

    def make_connection(self):
        # 创建一个新的连接
        if self._created_connections >= self.max_connections:
            raise ConnectionError("Too many connections")
        self._created_connections += 1
        return self.connection_class(**self.connection_kwargs)

    def release(self, connection):
        # 使用完毕连接后需要显式调用 release 把连接归还到连接池中。
        self._checkpid()
        if connection.pid != self.pid:
            return
        self._in_use_connections.remove(connection)
        self._available_connections.append(connection)

    def disconnect(self):
        # 断开所有连接
        all_conns = chain(self._available_connections,
                          self._in_use_connections)
        for connection in all_conns:
            connection.disconnect()


class BlockingConnectionPool(ConnectionPool):
    """
    这个连接池的实现是线程安全的
    """
    def __init__(self, max_connections=50, timeout=20,
                 connection_class=Connection, queue_class=LifoQueue,
                 **connection_kwargs):

        self.queue_class = queue_class  # 使用一个队列来存放连接
        self.timeout = timeout  # 增加了超时功能
        super(BlockingConnectionPool, self).__init__(
            connection_class=connection_class,
            max_connections=max_connections,
            **connection_kwargs)

    def reset(self):
        self.pid = os.getpid()
        self._check_lock = threading.Lock()

        # 首先在队列中填满 None，后面会用到，这里很关键
        self.pool = self.queue_class(self.max_connections)
        while True:
            try:
                self.pool.put_nowait(None)
            except Full:
                break

        # Keep a list of actual connection instances so that we can
        # disconnect them later.
        self._connections = []

    def make_connection(self):
        # 创建一个链接，貌似和上面的函数没有什么区别。。
        connection = self.connection_class(**self.connection_kwargs)
        self._connections.append(connection)
        return connection

    def get_connection(self, command_name, *keys, **options):
        """
        获取一个新的连接，最长等待 timeout 秒

        如果我们读取到的新连接是 None 的话，就会创建一个新的连接。因为我们使用的是 LIFO 队列，也就是栈，
        所以我们优先得到的是已经创建的链接，而不是最开始放进去的 None。也就是我们只有在需要的时候才会创建
        新的连接，也就是说连接数量是按需增长的。
        """
        # 确保没有更换进程
        self._checkpid()

        # 尝试获取一个连接，如果在 timeout 时间内失败的话，抛出 ConnectionError
        connection = None
        try:
            connection = self.pool.get(block=True, timeout=self.timeout)
        except Empty:
            # 需要注意的是这个错误并不会被 redis 捕获，需要用户自己处理
            raise ConnectionError("No connection available.")

        # 如果真的没有连接可用了，直接创建一个新的连接
        if connection is None:
            connection = self.make_connection()

        return connection

    def release(self, connection):
        # 释放连接到连接池
        self._checkpid()
        if connection.pid != self.pid:
            return

        # Put the connection back into the pool.
        try:
            self.pool.put_nowait(connection)
        except Full:
            # perhaps the pool has been reset() after a fork? regardless,
            # we don"t want this connection
            pass

    def disconnect(self):
        # 释放所有的连接
        for connection in self._connections:
            connection.disconnect()
```

# redis.Redis 类解析

Redis 类中使用了 ConnectionPool，如果没有显式创建的话，会自动创建一个线程池。所以每次你在使用 Redis 的时候，其实已经在使用线程池了。

```
class Redis:
    def __init__(self...):
        if not connection_pool:
            connection_pool = ConnectionPool(**kwargs)
        self.connection_pool = connection_pool
    def execute_command(self, *args, **options):
        # 执行每条命令都会调用该方法
        pool = self.connection_pool
        command_name = args[0]
        # 弹出一个连接
        connection = pool.get_connection(command_name, **options)
        try:
            # 尝试调用 redis
            connection.send_command(*args)
            return self.parse_response(connection, command_name, **options)
        except (ConnectionError, TimeoutError) as e:
            # 如果是连接问题，关闭有问题的连接，下面再次使用这个连接的时候会重新连接。
            connection.disconnect()
            if not connection.retry_on_timeout and isinstance(e, TimeoutError):
                raise
            # 再次尝试调用 redis
            connection.send_command(*args)
            return self.parse_response(connection, command_name, **options)
        finally:
            # 不管怎样都要把这个连接归还到连接池
            pool.release(connection)
```