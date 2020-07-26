# 使用 Ansible Playbook 部署 Docker

wp_id: 597
Status: draft
Date: 2018-07-27 05:03:00
Modified: 2020-05-16 11:21:39

刚刚用 Google 搜 Ansible 部署 docker 竟然一篇教程都没有搜到，其实这个是一个非常简单的操作。对于早期的简单架构，直接在开发机上部署很方便。

Ansible 的基础用法不再赘述，参考 [使用 Ansible 部署服务](http://yifei.me/note/507)  Ansible 中部署 docker 镜像主要需要的是 docker_container, docker_image, docker_service 三个模块。其中 docker_container 用于部署 docker 容器，docker_image 用于编译镜像，docker_service 模块用于部署 docker compose。

# docker_container 模块

docker_container 模块依赖于 docker 这个 Python 包，需要在**宿主机和目标机上都安装**：

```
pip install docker
```

错误提示中可能说的是安装 docker-py 这个包，但是这个包已经被 docker 替代了。

在 playbook 中的 tasks 中利用 docker_container 模块指定容器的运行模式即可。具体的参数可以查看 [文档](https://docs.ansible.com/ansible/2.6/modules/docker_container_module.html)。比如下面的例子

```
---
- hosts: ynote
  remote_user: tiger
  tasks:
    - name: Deploy Ynote
      docker_container:
        name: ynote
        image: docker.yifei.me/ynote
        auto_remove: true
        published_ports:
          - "8000:80"
        env:
          DB_NAME: ynote
        pull: true
```

然后使用 ansible-playbook 部署

```
ansible-playbook -i hosts playbooks/ynote.yml
```