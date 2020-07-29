# nginx 使用基础


<!--
ID: 64dda4fe-f24a-4dcf-a980-65f0099742cd
Status: draft
Date: 2018-01-14T00:20:00
Modified: 2020-05-16T11:29:26
wp_id: 611
-->


## 最小配置文件

```nginx
events {
}

http {
    include      mime.types;
    default_type application/octet-stream;
    sendfile     on;

    server {
        listen      80;
        server_name localhost;

        location / {
            root /var/www;
            autoindex on;  # list directory
        }
    }
}
```

# Nginx 进程模型

* 主进程必须有 root 权限才能使用 80 和 443 端口（小于 1024)
* The worker process are automatically spawned by the master process and they will run as nobody and nogroup if not specified.

# Start nginx:

    /path/to/sbin/nginx # just run the command and the daemon will be started
    nginx -s [stop|quit|reopen|reload] # send different signals
    nginx -t # check configuration file syntax
    nginx -c # set configuration file location
    nginx -V # this will show the configuration parameters
    nginx -g # set configuration directives

# Configuration Syntax

Imagine all the directives are functions taking different parameters.
Each block enable an environment, and some directives are only available inside a block.
Last but not least, configuration is inherited within children blocks.

## Core Module

This is the largest module provides the http functionality

### Directives:

    http -> server -> location

A server defines a server or a virtual host

### Server directives

    listen [address][:port] [options{default_server|ssl|spdy…]
        which address to listen
    server_name [hostname1][hostname2…]
        accepts wildcards by defualt, also accepts re, in nginx , re starts with `~`
    sendfile
        this shoule be on to use the `sendfile` system call
    root
        set the htdocs root
    alias
        addition htdocs directory
    error_page code1 [code2…] [=repalcement code] [@block|URL]
        set error page or substitute
    access_log
        set access log location
    log_format
        set log format
    if_modified_since
        define if_modified_since behavior
    index // accepts variables
        define the index page name
    autoindex on|off
        shows the directory structure
    add_header [name] [value] [always]
        add headers, always is set for error codes
    expires off|[time_value]|epoch|max
        automatically set expires header
    charset [charset]|off
        set response charset
    try_files // accept variables
        try to server files in different name
    limit_except METHOD1 [METHOD2] {
        allow | deny | auth_basic …
    }
    limit_rate
        configure the tranfic
    location
        allow ip/CIDR/unix/all
        deny [see above]
        auth_basic on/off
        auth-basic_user_file // file_format user:password
        satisfy

### Variables

Request headers are avaiable as $http_[header_name] format
Reponse headers are avaible as $sent_http_[header_name] format, but they only exist after the header has been sent.
Use set to define variables
Important Nginx variables

```
$arg_XXX	Get parameters
$args/$query_string	All parameters in a query string
$cookie_XXX	Cookie variable
$document_root	Root directory of current request
$document_uri/$uri	Current serving document
$host	Http host header
$hostname	Server"s hostname
$https	"on" if its https request
$is_args	&#x60;?&#x60; if args exist, empty other wise
$msec	Current time in milliseconds
$remote_addr/port/user	Remote address/port/user
$request_body	&#x60;-&#x60; if empty
$request_body_file	/path/to/temp/file if body was saved
$request_method/time/uri	Request method/time/uri
$scheme	Http or https
$server_addr	This call is expensive
$server_name/port/protocol	Server"s name/port/protocol
$time_iso8601/local	Time
```

## Location Block

`Location [modifiers] pattern {…}`

### Modifiers

Nothing	Accept trailing slash and extra characters

```
=	Exact match, no extra characters
~	Re
~*	Case insensitive re
^~	Re, but stops searching for other patterns if conditions are met, this is usually what you want
@	Define a block
```

# Proxy Module

This module reverse proxies nginx requests to upstream servers

    proxy_pass http(s)://[address|unix_socket|upstream]
    upstream [name] {
        server address;
        ...
    }
    proxy_method METHOD
        rewrite the proxy method
    proxy_redirect off|default|<url rewrite>

## Proxy Caching

    proxy_cache zonename
        defines a cache zone
    proxy_cache_key [a string consists of $vars]
        defines a cache key
    proxy_cache_path path [use_temp_path=on|off] [levels=numbers keys_zone=name:size inactive=time max_size=size]
        use_temp_path will use the path defined in proxy_temp_path
        `levels` is usually 1:2
        `keys_zone` defines zone's size in memory
        `inactive` TTL
        `max_size` the maximum size of the ENTIRE cache
    proxy_temp_path
        path for proxy temporary files
    proxy_cache_methods METHOD1 [METHOD2]
        defines the methods used for cache
    proxy_cache_min_uses 1
        defines how many hits we need to cache the key
    proxy_cache_valid code time
        defines valid time of cache for each method
    proxy_cache_use_stale [updating] [error] [timeout] [invalid_header] [http_500]
        whether nginx should use stale content if the following conditions are met
    proxy_max_temp_file_size
        maximum temp file size of proxy cache
    proxy_temp_file_write_size
        size of write buffer
    proxy_set_body
        set the body transferred to backend server
    proxy_set_header
        set the header transfeerred to backend server
    proxy_store
        store a binary representation of a request without expiration
    proxy_store_access
        defines file access of proxy store
    proxy_http_version 1.0|1.1
        defaults to 1.0, need to be set to 1.1 if you want to use keepalive
    proxy_cookie_domain/path
        modifies the cookie domain or path on the fly
    proxy_timeout and next_stream settings not covered

## Proxy Variables

```
$proxy_host	Hostname of the BACKEND server
$proxy_port 	Port of the BACKEND server
```
## proxy_store vs proxy_cache
 
Nginx has two methods to cache content:

* proxy_store is when Nginx builds a mirror. That is, it will store the file preserving the same path, while proxying from the upstream. After that Nginx will serve the mirrored file for all the subsequent requests to the same URI. The downside is that Nginx does not control expiration, however you are able to remove (and add) files at your will.
* proxy_cache is when Nginx manages a cache, checking expiration, cache size, etc. 

From <http://stackoverflow.com/questions/9137755/nginx-can-proxy-caching-be-configured-so-files-are-saved-without-http-headers>

## load balancing

```
http {
    upstream myapp1 {
        server srv1.example.com;
        server srv2.example.com;
        server srv3.example.com;
    }

    server {
        listen 80;

        location / {
            proxy_pass http://myapp1;
        }
    }
}
```

The most important issue is session affinity. By default, nginx uses the round-robin algorithm to maintain no session affinity.

    upstream [name] {
        server ip:port [weight=1] [fail_timeout=x] [max_fails=x] [backup] [down]
        hash $var; // use some variable to distribute the traffic and maintain session affinity

There exists a module called `stream` which implements TCP layer 4 load balancing, so no http variables can be used

    stream {
        upstream {
            hash $no_http_var;

        }
    }

# Nginx and CGI

Nginx supports FastCGI, WSSI and SCGI, and their directives are identical.

    fastcgi_pass address|unix:/path/to/unix.socket|upstream
    fastcgi_param PARAM_NAME value // SCRIPT_FILENAME and QUERY_STRINIG is required
    fastcgi_store on|off // store generated html file to local disk
    fastcgi_cache zonename

# Miscellaneous

Apache still does not know the real ip of remote user, we might need a plugin called mod_rpaf.

# Nginx requests

External requests originate from the client side. Internal requests are triggered by nginx via specific directives. Internal requests consist of internal redirects and sub-requests.
    
`rewrite [re] [repalcement] [flags]`, this is the key of rewriting

Note: nginx automatically add query string to the repalcement url, if you don't like that, you should add a `?` to the url

You might get yourself into infinite loop, nginx stop that by set max rewrite times to 10, redirect more than 10 times gives a 500 error

If statement

The if statement in nginx is like the if statement in shell script, it uses `=/!=/~/-f/-d/-e/-x` to determine whether the conditions are met.

# load balancing

https://www.nginx.com/resources/glossary/layer-7-load-balancing/
https://www.nginx.com/resources/glossary/layer-4-load-balancing/
https://www.nginx.com/resources/glossary/load-balancing/
https://www.nginx.com/resources/glossary/round-robin-load-balancing/
https://devcentral.f5.com/articles/intro-to-load-balancing-for-developers-ndash-the-algorithms

from: https://gist.github.com/jemmanuel/481bdac23690aa002c894cfc3a691b6f