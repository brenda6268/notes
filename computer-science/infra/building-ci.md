# building ci


wp_id: 565
Status: draft
Date: 2017-07-05 09:59:00
Modified: 2020-05-16 11:45:00


生成 deploy_key: `ssh-keygen -q -t rsa -N '' -f KEY_FILE`

添加到 docker：

```
COPY KEY_FILE /
RUN \
  chmod 600 /KEY_FILE &amp;&amp; \  
  echo "IdentityFile /KEY_FILE" >> /etc/ssh/ssh_config &amp;&amp; \  
  echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config
```

把 KEY_FILE.pub 添加到 github 项目的 deploy keys

参见：https://stackoverflow.com/questions/23391839/clone-private-git-repo-with-dockerfile