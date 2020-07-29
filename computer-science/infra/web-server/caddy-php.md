# 使用 caddy 运行 php


<!--
ID: 4656403a-3637-469e-8b2c-978b0624319a
Status: publish
Date: 2019-06-15T15:11:02
Modified: 2020-05-16T10:58:22
wp_id: 93
-->


caddyfile

```
example.com {
    gzip
    root /srv
    fastcgi / 127.0.0.1:9000 php # php variant only
    on startup php-fpm7 # php variant only
}
```

example.com 记得改成自己的域名

docker-compose.yml

```yaml
version: "3"

services:
  caddy:
    image: abiosoft/caddy:php
    environment:
      ACME_AGREE: 1
    volumes:
      - "/etc/Caddyfile:/etc/Caddyfile"
      - "/etc/caddy:/root/.caddy"
      - "/var/www/html:/srv"
    ports:
      - "80:80"
      - "443:443"
      - "2015:2015"
```

参考

http://blog.extlux.com/2018/08/06/docker-%E8%BF%90%E8%A1%8C%E5%B8%A6php%E7%9A%84caddy/