# influxdb+grafana+telegraf 监控系统搭建


<!--
ID: e9735bdd-8615-49cf-9d27-dc38e321d4f8
Status: publish
Date: 2018-09-20T19:05:00
Modified: 2020-05-16T11:24:11
wp_id: 740
-->


本文基于 ubuntu 18.04

# 要不要用 docker？

这是一个哲学问题，用不用其实都有各自的好处。不过在这里我倾向于不用。因为 influxdb 和 grafana 都有好多的状态，而且不是都可以写到 mysql 中的，所以既然还得 mount 出来，何苦用 docker 呢？telegraf 需要采集系统的相关信息，更不适合放在 docker 里面。

- InfluxDB，开源的时间序列数据库
- Grafana，开源的数据可视化工具

# 搭建过程

## influxdb && telegraf

因为这两个都是一家的产品，所以安装步骤都是一样的。按照 [官网](https://docs.influxdata.com/influxdb/v1.6/introduction/installation/) 给的安装步骤，其实很简单的。

```sh
curl -sL https://repos.influxdata.com/influxdb.key | sudo apt-key add -
source /etc/lsb-release
echo "deb https://repos.influxdata.com/${DISTRIB_ID,,} ${DISTRIB_CODENAME} stable" | sudo tee /etc/apt/sources.list.d/influxdb.list

sudo apt-get update &amp;&amp; sudo apt-get install influxdb telegraf
sudo systemctl start influxdb telegraf
```

我们暂时就不配置了，直接使用默认配置。可以通过 `systemctl status influxdb` 来查看状态

## grafana

同样参考 [官网](http://docs.grafana.org/installation/debian/) 的教程。

## 基本概念

Grafana 从数据源中读取数据，数据源一般是时间序列数据库。their data can be mixed in a single panel.

Grafana 使用 `orginazations` and `users` to manage permissions.

A dashboard consists of rows, rows consist of panels. for each panel, there is a query editor to edit which data the panel should show.

```sh
VERSION=5.1.4
wget https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana_${VERSION}_amd64.deb
apt-get install -y adduser libfontconfig
dpkg -i grafana_${VERSION}_amd64.deb

sudo systemctl daemon-reload
sudo systemctl enable grafana-server
sudo systemctl start grafana-server
```

然后就 ok 啦，打开 http://ip:3000 就能访问 grafana 的界面了，默认用户名和密码是 admin。如果是在阿里云等云上面，注意要在安全组里面开一下 3000 端口。

# 配置

## 配置 telegraf 的插件

## 配置 grafana 的 datasource

未完待续

## 参考资料

1. https://blog.csdn.net/w958660278/article/details/80484486
2. https://juejin.im/post/5b4568c851882519790c72f3
3. https://grafana.com/dashboards/928
4. http://docs.grafana.org/guides/gettingstarted/
5. http://docs.grafana.org/guides/basic_concepts/