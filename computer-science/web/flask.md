# flask 全家桶学习笔记（未完待续）

<!--
ID: 8e6863c0-2b2e-4ee9-b45b-1e059c76749d
Status: publish
Date: 2019-08-15T20:33:56
Modified: 2020-05-16T10:51:51
wp_id: 298
-->

看到标题有的同学可能就问了，flask 是一个微框架，哪儿来的全家桶啊。其实作为一个框架来说，除非你提供的只有静态页面，那么肯定要和数据库打交道的，肯定是要有后台登录管理以及提供 API 等等一大堆常规工作要做的，这时候就需要各种全家桶组件了，那么这篇文章里介绍的就是 flask + 插件 + uwsgi 等等一系列的工具。

## hello world

```python
from flask import Flask, request

app = Flask(__name__)

@app.route("/")
def hello():
    return "hello, world"

app.url_map.strict_slashes = False  # 关闭 url 结尾的 `/` 检查
app.run()
```

Flask 中直接使用 request 对象访问请求的数据，比如：

- request.form, Post 的数据字典
- request.args, GET 参数
- request.values, 以上两个都包括
- request.json, 或者 request.get_json() 属性，不过 flask 会要求请求 header 必须是 `Content-Type: application/json` 类型的，这个是一个坑。

## 基于类的视图

Flask 默认采用的是基于函数和装饰器的视图。而有时候对于一些 CRUD 的资源，还是使用类更清晰一些，Flask 也是支持的。

```py
from flask.views import MethodView

class PostView(MethodView):
    def get(self, id):
        if id is None:
            ...  # return a list of objects
        else:
            ...  # return a single object

    def post(self):
        ...

    def put(self, id):
        ...

    def delete(self, id):
        ...

def add_resource_view(app, view, url):
    view_func = view.as_view(view.__class__.__name__)
    url = url.rstrip("/")
    app.add_url_rule(url, defaults={"id": None}, view_func=view_func, methods=["GET"])
    app.add_url_rule(url, view_func=view_func, methods=["POST"])
    app.add_url_rule(url + "/<id>", view_func=view_func, methods=["GET", "PUT", "DELETE"])

add_resource_view(app, PostView, "/post")
```

## 使用 blueprints

在 Flask 中如果需要切分应用的话，那么需要使用 Blueprints. 比如说，我们有下面这样的目录：

```
app.py
views/
  posts.py
```

两个文件的内容分别是：

```py
# posts.py
from flask import Blueprint, render_template

posts_bp = Blueprint('posts', __name__)

@posts_bp.route("/")
def index():
    return [{"title": "hello world"}, ...]
```

```py
# app.py
from views.posts import posts_bp

app = Flask(__name__)
app.register_blueprint(posts_bp, "/posts")
```

一般在刚开始搭建的时候，也没必要一定要分 blueprints, 等函数太多了再分也不迟。

## Application Factory Pattern

在前面的例子中，我们都直接在模块中 `app = Flask(__name__)` 了，这样做实际上是有问题的。官方推荐使用 app factory pattern。

app factory pattern 其实也很简单，就是把 app 的创建包装在了 `create_app` 函数中，这样做的好处主要有两点：

### 方便多环境部署

直接导入 app 的话，已经初始化了，无法再更改 app 的配置
```python
from example import app
```

如果把 app 的创建包装在一个函数中，可以在创建 app 的时候传递不同的参数，可以区分开发测试等不同环境。

```python
def create_app(**kwargs):
    app = Flask(**kwargs)
    return app

from example import create_app
app = create_app(DB_CONN="production")
```

### 方便依赖管理

默认情况下，代码可能是这样的，所有的代码都得依赖 app.py

```python
# app.py
app = Flask(__name__)
db = SQLAlchemy(app)

# models.py
from example import db

class User(db.Model):
    pass
```

使用了 app factory pattern 之后，每个模块都可以不依赖 app.py，而是使用自己的 blueprint

```python
def create_app():
    app = Flask(__name__)
    from example.models import db
    db.init_app(app)
    return app

# models.py
db = SQLAlchemy()

class User(db.Model):
    pass
```

## 搭建 flask 的后台系统

## cookie & session & login

### Basic Auth

通过使用 Flask-BasicAuth 插件，虽然这个插件很久没更新了，但是还可以用。

```py
# pip install flask_basicauth
from flask_basicauth import BasicAuth
app.config["BASIC_AUTH_USERNAME"] = "username"
app.config["BASIC_AUTH_PASSWORD"] = "password"

basic_auth = BasicAuth(app)

@basic_auth.required
def hello():
    return hello
```

flask 使用了 itsdangerous 库生成和读取 Cookie。flask 默认的 session 也是通过 cookie 实现的。因为 Cookie 是储存在客户端的，所以：

1. 很难在 session 中存储数据
2. 每次都会携带 Cookie，影响 HTTP 请求大小
3. 不需要在服务端有任何存储，使用比较简单

### flask-login

flask-login 是 flask 的一个登录框架，它使用了 flask 本身的 session 机制，可以对接各种数据库后端。

#### 初始化 flask-login

```python
from flask_login import LoginManager

manager = LoginManager()
manager.init_app(app)
```

#### flask-login 的接口

##### 登录登出

用户登录。使用 login_user 方法登录后，flask_login 会设置 cookie。

```python
@app.route("/login")
def login():
    username = request.args.get("username")
    password = request.args.get("password")
    user = User.get(username=username)
    if user.check_password(password):
        login_user(user)
```

这时候之后的访问就都可以从 session 中加载出用户了。如果需要登出的话：

```python
@app.route("/logout")
@login_required  # 只有登录后可以访问
def logout():
    logout_user()
```

##### 加载用户

加载用户的接口。这里的 user_id 是直接从 session 中拿到的。

```python
@manager.user_loader
def load_user(user_id):
    return User.get(user_id)
```

当我们登录完成之后，就可以通过 current_user 这个代理来访问当前用户了。

```python
from flask_login import current_user
```

其中的 User 类需要提供以下四个方法，不过好在我们可以直接继承 flask_login.UserMixin 类就可以了。

```python
is_authenticated # 属性，默认返回 true
is_active # 属性，默认返回 true
is_anonymous # 属性，默认返回 False
get_id() # 方法，默认返回 id 属性的字符串表示
```

Flask-Login 内置了基于表单的一些辅助方法，在这里我们就不展开了。本文的开发方向是针对富客户端的应用，后端只提供 API。

除了直接利用 session 中的 user_id 来加载用户之外，还可以直接接管 request，从 request 中的 header 或者其他 token 来验证用户。

```python
@manager.request_loader
def login_from_request(request):
    token = request.headers.get("X-Token")
    user = get_user_with_token(token)
    return user
```

如果当一个请求没有读取到用户，也就是用户是 None 的时候，Flask-Login 会使用内置的 AnoynmousUserMixin 来生成一个匿名用户。

```python
is_authenticated # False
is_active # False
is_anonymous # True
get_id() # None
```

如果需要在用户未登录的时候，显示登录界面，或者返回 403 forbidden 等信息，应该使用 unauthorized_handler。

```python
@manager.unauthorized_handler
def handle_login():
    return {"error": "need login"}
```

##### 登录验证的 view

只需要添加 `@login_required` 就可以保护某个 view 需要登录了。

```python
from flask_login import login_required

@login_required
def settings():
    pass
```

##### fresh login

在一些敏感的操作，比如需要改密码的时候，我们一般都要重新验证一次密码，这时候可以使用 fresh login 这个概念。

这里先不展开了。

## 使用 swagger 生成文档

swagger 是一套定义 API 的工具，可以实现 API 的文档化和可交互。flasgger 是 flask 的一个插件，可以实现在注释中使用 swagger 语法。

swagger 本身是一套工具，但是后来被社区发展成了 OpenAPI 规范。最新版本是 OpenAPI 3.0，而现在用的最多的是 swagger 2.0。我们这里

## 完整的例子

## 使用 uwsgi 部署

开发阶段使用的是 flask 内置的 debug server 来提供服务的。在生产环境部署的时候，我们则需要使用 uwsgi 这种多线程的服务器来提供更好的性能。

## 参考文献

1. https://blog.csdn.net/u010466329/article/details/78522992
2. https://blog.csdn.net/qq_21794823/article/details/78194164
3. http://www.manongjc.com/article/48448.html
4. https://juejin.im/post/5964ce816fb9a06bb21abb23
5. https://www.cnblogs.com/whitewolf/p/4686154.html
6. [为什么要使用 APP Factory Pattern](https://tobywf.com/2016/06/flask-always-use-application-factories/)
7. https://flask-login.readthedocs.io/en/latest/
