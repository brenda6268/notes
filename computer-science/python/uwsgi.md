# uwsgi 的使用和性能优化配置


wp_id: 290
Status: publish
Date: 2019-07-24 19:50:10
Modified: 2020-05-16 10:52:03


假设我们编写了如下的 flask 应用，要用 uwsgi 部署，希望性能越高越好，那么下面是一份还说得过去的配置。

```python
from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello():
    return "world"

if __name__ == "__main__":
    app.run()
```

对应的 uwsgi 配置

```ini
[uwsgi]
wsgi-file=app.py  # 应用的主文件
callable=app  # 应用中的 flask 实例
chdir=/opt/app  # chdir 到给定目录
env= XXX=XXX  # 额外的环境变量

# 以下三者任选其一
http=0.0.0.0:5000  # 如果直接暴露 uwsgi 的话用这个
http-socekt=0.0.0.0:5001  # 如果用nginx反向代理的话，用这个
socket=:3031  # 在 3031 使用 uwsgi 协议，nginx 中使用 uwsgi_pass 更高效

chmod-socket = 664

pidfile=xxx  # pid 文件路径
venv=xxx  # 虚拟环境路径
logto = /var/log/www.log

# 并发设置
workers = 2  # 一般为 CPU 核数 * 2
threads = 2  # 线程比进程开销更小一点。如果没有使用 threads 那么 thread 直接不工作的，必须使用 enable_threads。
max-requests = 100000  # 处理过多少个请求后重启进程，目的是防止内存泄露
master = true  # 使用 max-requests 必须采用这个选项
listen = 65536  # 每个进程排队的请求数量，默认为 100 太小了。并发数 = procsses * threads * listen
buffer-size = 65536  # header 的 buffer 大小，默认是 4 k
thunder-lock = true  # 避免惊群效应
uid=www-data
gid=www-data
harakiri=30  # 所有进程在 30s 没有响应后傻屌
log-slow=3000  # 记录满于 3000 毫秒的请求
# lazy-apps  # 不使用 prefork，而是在需要时才启动进程

# 监控设置
stats = 127.0.0.1:9191  # 可以使用 uwsgi top 监控
python-autoreload=1  # 自动重载，开发时非常方便

# 静态文件
check-static = /var/static  # 尝试从该目录下加载静态文件
static-map = /static=/var/static  # 把对应目录映射
route = /static/(.*)\.png static:/var/www/images/pngs/$1/highres.png  # 使用高级路由模式
offload-threads = 10  # 让 uwsgi 启动额外的进程处理
```


# 参考

1. https://blog.zengrong.net/post/2568.html
2. https://stackoverflow.com/questions/34255044/why-use-uwsgi-max-requests-option/34255744
3. https://blog.csdn.net/apple9005/article/details/76232852、
4. https://mhl.xyz/Python/uwsgi.html
5. https://stackoverflow.com/questions/34824487/when-is-thunder-lock-beneficial