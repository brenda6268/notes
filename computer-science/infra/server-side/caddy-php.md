# 使用 caddy 运行 php


ID: 93
Status: publish
Date: 2019-06-15 15:11:02
Modified: 2020-05-16 10:58:22


<!-- wp:heading {"level":1} -->
<h1 id="使用_caddy_运行_php">使用 caddy 运行 PHP</h1>
<!-- /wp:heading -->

<!-- wp:paragraph -->
<p>
caddyfile
</p>
<!-- /wp:paragraph -->

<!-- wp:preformatted -->
<pre class="wp-block-preformatted">example.com {
    gzip
    root /srv
    fastcgi / 127.0.0.1:9000 php # php variant only
    on startup php-fpm7 # php variant only
}</pre>
<!-- /wp:preformatted -->

<!-- wp:paragraph -->
<p>
example.com 记得改成自己的域名
</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>
docker-compose.yml
</p>
<!-- /wp:paragraph -->

<!-- wp:preformatted -->
<pre class="wp-block-preformatted">version: "3"

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
      - "2015:2015"</pre>
<!-- /wp:preformatted -->

<!-- wp:paragraph -->
<p>
参考
</p>
<!-- /wp:paragraph -->

<!-- wp:list {"ordered":true} -->
<ol><li> <a href="http://blog.extlux.com/2018/08/06/docker-%E8%BF%90%E8%A1%8C%E5%B8%A6php%E7%9A%84caddy/" target="_blank" rel="noreferrer noopener">http://blog.extlux.com/2018/08/06/docker-%E8%BF%90%E8%A1%8C%E5%B8%A6php%E7%9A%84caddy/</a>
</li></ol>
<!-- /wp:list -->