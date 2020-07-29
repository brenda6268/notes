# 如何使用 letsencrypt

<!--
ID: 3dcde1bb-190e-4fe3-9acd-f689dfd946c9
Status: publish
Date: 2017-07-01T02:48:00
Modified: 2020-05-16T11:44:48
wp_id: 598
-->

letsencrypt 现在终于支持通配符证书了。

certbot 比较坑爹的一点是renew时候使用的是和创建证书相同的参数, 而且不能更改, 也就是最好在创建证书的时候就选择使用webroot的方式.

## install certbot


see ~/.dotfiles/installs/install_certbot.sh

## create new cert

sudo certbot certonly --webroot -w /opt/spider/nginx/html/ -d shujutuzi.com -d www.shujutuzi.com

sudo certbot certonly --standalone --agree-tos --email kongyifei@gmail.com --domain g.yifei.me --preferred-challenges http --non-interactive

the cert is placed at /etc/letsencrypt/live/shujutuzi.com/

there will be four certs:

- cert.pem: server certificate only.
- chain.pem: root and intermediate certificates only.
- fullchain.pem: combination of server, root and intermediate certificates (replaces cert.pem and chain.pem).
- privkey.pem: private key (do not share this with anyone!).

## install the cert

https://gist.github.com/cecilemuller/a26737699a7e70a7093d4dc115915de8

## auto renew

create a cron job to run renew peroidcally

cerbot renew --pre-hook "/opt/nginx/sbin/nginx -s stop" --post-hook "/opt/nginx/sbin/nginx -s start" --quiet


optionally, you could generate a Strong Diffie-Hellman Group

sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048

Third, change you defautl server settings:

```nginx
server {
    listen 443 ssl;
    server_name example.com www.example.com;
    ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;

// optional

    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
        ssl_prefer_server_ciphers on;
        ssl_dhparam /etc/ssl/certs/dhparam.pem;
        ssl_ciphers 'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA';
        ssl_session_timeout 1d;
        ssl_session_cache shared:SSL:50m;
        ssl_stapling on;
        ssl_stapling_verify on;
        add_header Strict-Transport-Security max-age=15768000;
}
```

Side Notes:

what is a pem file?

pem	container format, may contain one or many certs, short for Privacy Enhanced Main
key	just the private key file of pem format
cert, cer, crt	just pem file with different extendsion, used on windows