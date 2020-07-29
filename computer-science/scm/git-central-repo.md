# 搭建 git 服务器（中心仓库）

<!--
ID: 62a7dc3a-3201-4706-a99c-ce93ee036b20
Status: publish
Date: 2018-01-20T22:50:00
Modified: 2020-05-16T11:30:22
wp_id: 604
-->

# 使用 gitea


# 手工搭建 git 服务器

假设服务器的名字是 git.example.com.
首先，添加一个叫做git的用户`adduser git`。

然后如果不存在的话, 为这个用户新建一个主目录`mkdir /home/git`，然后把这个目录设为git所有`chown git ~git`

再在本地把你的ssh公钥拷贝到服务器上 
    ssh-copy-id git@git.example.com

服务器就这样搞好了

## 使用

1. 在服务器上新建仓库

首先，在服务器新建一个项目, 其中 new_project 是你的项目的名字.

```
ssh git@git.example.com "mkdir <new_project>.git &amp;&amp; cd <new_project>.git &amp;&amp; git init -bare"
```

当然这么一长串实在是太烦了, 我们可以把它写成一行脚本new_repo.sh


```
#!/bin/bash
ssh git@git.example "mkdir $1\.git &amp;&amp; cd $1\.git &amp;&amp; git init --bare"
echo "New git repo git@git.example.com:$1.git"
```

然后 chmod +x new_repo.sh
以后就可以这样调用了 ./new_repo.sh foobar 就可以了

2. 和本地建立连接

如果是新项目

然后 clone 到本地就好了：

git clone git@git.example.com:new_project.git

如果是老项目

如果你已经在本地有了项目, 并且初始化了 git 仓库, 不是采用clone，而是直接设置上游服务器，那就推送到服务器上

```
git remote add origin git@git.example.com:new_project.git
git push -u origin master
```

# gitlab

~~建议使用 gitlab 搭建，只需要一个命令就可以了~~
强烈不建议使用 gitlab，实在是太卡了。

```
docker run --detach \
    --hostname gitlab.example.com \
    --publish 443:443 --publish 80:80 --publish 22:22 \
    --name gitlab \
    --restart always \
    --volume /srv/gitlab/config:/etc/gitlab \
    --volume /srv/gitlab/logs:/var/log/gitlab \
    --volume /srv/gitlab/data:/var/opt/gitlab \
    gitlab/gitlab-ce:latest
```

source: https://docs.gitlab.com/omnibus/docker/README.html