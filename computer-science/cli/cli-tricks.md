# 命令行的一些小技巧

<!--
ID: fc4803ef-0aee-4c03-82cb-9d80d1ec716c
Status: publish
Date: 2018-01-28T19:51:00
Modified: 2020-05-16T11:30:28
wp_id: 437
-->

最近工作中经常用到的一些组合命令，本来想提交到 commandlinefu.com 上，但是忘记了密码，怎么也登录不上去了，记到这里吧

* 脚本所在的目录

```
dirname $0
```

* 文件夹下面按照占用空间大小排序

```
du -sh &#x60;ls&#x60; | sort -rh
```

* 返回上一个目录

```
cd -
```

* 显示所有的日志的最后几行

```
tail *
```

* set

```
set -x # 显示每个执行的命令
set -e # 当有程序返回非0值时直接退出，相当于抛出异常
```

* here doc

```
cat << EOF > /tmp/yourfilehere
These contents will be written to the file.
        This line is indented.
EOF
```

* 删除包含某个关键字的所有行

```
fd -t f -0 | xargs -0 sed -i /KeyWord/d
```

* 在 shell 中，所有字符串都要用引号包围

Always quote strings in bash. If you string is empty and you are testing it with == or !=, then there will be a "== is not uniary operator" error

* 替换一个文件夹下的所有文件

```
fd . -t file -0 | xargs -0 sed -i -e "s/make_redis_client/create_redis_client/g"
```
from: https://stackoverflow.com/questions/6758963/find-and-replace-with-sed-in-directory-and-sub-directories
