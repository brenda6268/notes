# 漫话包管理系统（未完）

<!--
ID: 7ade8bbe-d4e7-4733-a633-cf911d515877
Status: draft
Date: 2018-04-04T05:13:00
Modified: 2020-05-16T11:32:10
wp_id: 331
-->

包管理系统一般来说分为了几个维度：

1. 系统的包管理工具，像是 apt-get、homebrew、yum
2. 语言的包管理工具，像是 python 的 easy_install、pip 等等
3. 一个工程的包管理工具，可能更多地被称作依赖管理工具，像是 npm、pip+venv、maven 等等

其中第二个和第三个的界限是非常模糊的，好多时候是同一个工具提供了两者的作用，比如npm。

系统的包管理工具一般用来安装一些工具和或者是库。比如

```
% apt-get install docker-ce  # 安装docker
% apt-get install libcurl  # 安装C语言的库libcurl
% apt-get install python-sqlite3  # 安装python的sqlite3库
```

系统的包管理工具的仓库往往是由发行版的作者们来维护的，而不是包的作者，也就是说比如debian的维护者来手工收集 docker 或者 curl 的源文件，然后打包编译好。这样的好处就是稳定，但是坏处就是往往会比较滞后，比如像是 docker 和 node 这种升级比较快的软件的版本经常会滞后不少。

使用系统的包管理器来给特定的语言安装库也会遇到同样的问题，往往会安装一个版本比较老的，不过对于 C 语言来说可能问题不大，好多时候安装 libxxx 还挺方便的，不过对于像是 Python 和 JS 来说，使用语言自身的包管理工具通用一些。

值得注意的是，系统的包管理工具往往都会安装到 /usr/local 这一类的目录，也就是说是给当前系统的左右用户都更新了。有两个问题：

1. 需要 sudo
2. 这时候如果另一个人依赖了某个库，可能造成另一个人无法编译

语言的包管理工具一般用来安装依赖的库：

```
% pip install redis
```

这样我们就可以在程序中使用 redis 这个库了

import redis

不同的语言的工具对安装的位置有不同的选择，比如 easy_install 或者 就会默认把库安装到 /usr/local 这样的系统目录，或者通过配置安装到用户的目录 ~/.local。这样的好处就是安装后所有的项目都可以使用，坏处就是不同的项目依赖不同的版本，无法统一。

另外也有一些工具通过语言的包管理工具来分发，比如 httpie 的安装命令是：

```
% pip install httpie
% http get https://www.example.com
```

综上来说，不管是系统的包管理工具还是语言的包管理工具，都会对不同项目的不同依赖可能造成影响，所以一般来说还是每一个不同的项目使用不同的依赖比较好，在 python 中可以使用 virturalenv/venv 来实现，而在 npm 中，这是默认的做法。

现代成熟的包管理系统往往都采用了一个manifest文件，一个lock文件。manifest 文件包含了当前依赖的 package 的列表，以及对于版本的要求；而 lock 文件包含了实际使用的依赖的具体版本。程序员应该手工或者自动更新的是 manifest 文件，而lock文件通常是包管理工具根据 manifest 文件自动生成的，比如说对于 node 的 npm 来说，就会生成 package.json 和 package_lock.json 两个文件。

之所以需要 lock 文件，是因为即使 manifest 文件约束了使用哪些版本，但是并没有制定具体的那个版本，这样也会造成一些潜在的bug。为什么需要 lock 的详细原因可以查看这里：https://medium.com/@Quigley_Ja/everything-you-wanted-to-know-about-package-lock-json-b81911aa8ab8。

比如说在头条，把所有的库都都存放在了一个目录下，姑且叫做 WORKPATH 吧，并且把 WORKPATH 添加进入了 PYTHONPATH，这样所有的包就可以直接import了。和GOPATH的做法其实是类似的。

go 有很多的包管理系统，而dep则是官方最近在维护的一个，个人感觉以后可能会融入到 go tool 里面，彻底废弃掉其他的像是 godeps、govendor 之类的包管理系统。

dep 也采用了一个 manifest 文件，一个 lock 文件的模式。

## 安装 dep

需要注意的是，官方不建议使用 go get 的方式来安装 dep，因为 master 上的代码可能是不稳定的，所以我们使用 `brew install dep` 来安装

## 使用

第一步，初始化一个项目，和所有其他的包管理器一样

dep init

这里会创建两个文件，Gopkg.toml、Gopkg.lock 文件，同时会创建一个目录 vendor 用来存放该项目的依赖。通过 dep 安装的包就会存在 vendor 目录，而不是存放在 `$GOPATH/src/...` 文件夹中。像其他的包管理器一样，最好把 Gopkg.toml 和 Gopkg.lock文件存放进版本管理系统中。

第二步，安装需要的包

dep ensure -add github.com/foo/bar github.com/baz/quux

这时候我们可以看到 Gopkg.toml 和 Gopkg.lock 文件发生了变化。就像 git 一样，dep ensure 这些命令可以运行在项目的任何一个子目录内。

这里需要注意的是，如果你需要同时添加多个依赖的话，需要向上面那样直接在一样命令中输入多个依赖，因为dep ensure 在第二次运行的时候如果发现你的源文件中没有import这个包，会把他从 vendor 文件夹中删除。当然另一种做法是，没添加一个依赖，就在代码中import 一下。

另外一种方法是直接在代码中 import，然后调用 `dep ensure`，不过这样可能会让goimports报错。但是想快速迭代的话，这种方法也不错。

如果需要更新包的话，可以使用

dep ensure -update [package_name...]

## Gopkg.toml 语法

Gopkg.toml 一共有五个基本规则：

required：基本相当于 import 语句
ignored：忽略一个路径
constraint: 限制当前的包
override：不只限制当前的包，同时把依赖的依赖的版本也覆盖掉
[prune]: 该删除那些文件

如果手工编辑了 Gopkg.toml 文件，可以使用  `dep ensure` 来应用操作。

## 生成可视化的依赖图

感觉这个是黑科技啊

brew install graphviz 
dep status -dot | dot -T png | open -f -a /Applications/Preview.app


[Go 官方关于 Package Management 的 Wiki 页面](https://github.com/golang/go/wiki/PackageManagementTools)