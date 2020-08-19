# Sentry

<!--
ID: 05771516-bfca-41b4-b8bc-d67986b142cf
Status: draft
Date: 2019-10-07T00:00:00
Modified: 2020-07-08T12:13:56
wp_id: 960
-->

## Sentry 是什么

Sentry 是一个异常事件收集系统。相比于从日志中查找异常信息，使用 Sentry 可以查看聚合之后的异常信息，还可以针对异常问题进行分配和跟踪，例如指派团队的某个成员去处理某一类问题，对于长时间没有再发生的问题自动标记为解决等等。

Sentry 并不是像 ELK 一样的日志收集系统，而是对于异常日志的收集系统。对于开发者来说，一半也是出了问题采取查看日志。事实上我觉得对于 debug 来说，把日志存在 ES 中是一种很傻的行为，还是简单收集之后 tail + grep 最方便了。日志存在 ES 中只是为了做用户行为分析方便一点，debug 时候用要多傻逼有多傻逼。

## 搭建

按照 getsentry/onpremise 中的介绍一步一步安装就好了，非常简单。

```
git clone https://github.com/getsentry/onpremise
cd onpremise
docker volume create --name=sentry-data && docker volume create --name=sentry-postgres # 创建两个 volume
cp -n .env.example .env - create env config file
docker-compose build # Build and tag the Docker services
docker-compose run --rm web config generate-secret-key # Generate a secret key. Add it to .env as SENTRY_SECRET_KEY.
# 还要把生成的 key 拷贝到 .env 中
docker-compose run --rm web upgrade - Build the database. # Use the interactive prompts to create a user account.
docker-compose up -d  # Lift all services (detached/background mode).
```

Access your instance at localhost:9000!

## 参考文献

1. https://betacat.online/posts/2018-05-11/collect-error-events-via-sentry/
2. https://learnku.com/articles/4235/sentry-automation-exception-alert
