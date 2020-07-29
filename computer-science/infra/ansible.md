# 使用 Ansible 部署服务


<!--
ID: 5970c396-3db9-4d81-aa7d-fec411c32b1b
Status: publish
Date: 2018-06-18T03:16:00
Modified: 2020-05-16T11:26:40
wp_id: 615
-->


ansible 的操作是幂等的，也就是说可以进行任意次操作而不会造成副作用。ansible 基于 ssh，不需要在目标机器上运行任何特殊的 agent。

# 安装

```
sudo pip3 install ansible
```

# Hosts 文件

ansible 使用 `hosts` 文件来管理主机，每个Hosts中定义多个 Inventory，可以认为是分组的主机

默认位置: `/etc/ansible/hosts`。可以使用 `-i` 来指定 Inventory 文件

format

```ini
[inventory_name]
192.168.0.1
# 或者域名
```

如果需要改变登录使用的用户名，可以在当前目录的 `ansible.cfg` 或者 `$HOME/.ansible.cfg` 或者 `/etc/ansible/ansible.cfg` 中指定：

```ini
[defaults]
remote_user=rabbit
```

## 动态 Inventory

see ec2.py

## Builtin Variables

see https://github.com/lorin/ansible-quickref


# 运行命令

ansible 使用module来组织命令。

## 选项

```
-m	module to run
-s	use sudo
-k	ask for key/password
-u 	user
-a	传递给 module 的参数
```

## 例子

```bash
ansible -i ./hosts all -m ping 
ansible -i ./hosts all -m shell -a "apt-get install nginx"
ansible -i ./hosts all -s -m apt -a "pkg=nginx state=installed update_cache=true"
```

响应

```
host | state >> {
    "changed": false # whether the host is affected by the command
}
```

ansible 内置的 module 有: ping, shell


# Playbook

ansible 可以直接在命令行使用，但是最终需要的命令可能很长，不过最好的方式还是使用 playbook 来把需要运行的命令写成 yaml 文件。就像是 docker 相关的命令可以写成 docker-compose 的配置文件一样。

```yaml
- hosts: local
  # define variables
  vars:
   - docroot: /var/www/serversforhackers.com/public
  # more options goes here
  # ...

  # tasks are the basic action unit
  tasks:
   - name: Add Nginx Repository
     # module apt_repository
     apt_repository: repo="ppa:nginx/stable" state=present
     # register an event
     register: ppastable

   - name: Install Nginx
     apt: pkg=nginx state=installed update_cache=true
     # listen an event, run only it happens
     when: ppastable|success
     register: nginxinstalled
    # notify calles handlers
     notify:
      - Start Nginx

   - name: Create Web Root
     when: nginxinstalled|success
     file: dest={{ "{{" }} docroot {{ "}}" }} mode=775 state=directory owner=www-data group=www-data
     notify:
      - Reload Nginx

  # handlers are like functions, called by &#x60;notify&#x60;
  handlers:
   - name: Start Nginx
     service: name=nginx state=started

    - name: Reload Nginx
      service: name=nginx state=reloaded
```

# 部署 docker

[使用 ansible 部署 docker 镜像](http://yifei.me/note/569)

# REF

这篇文章主要参考[这里](https://serversforhackers.com/c/an-ansible2-tutorial)