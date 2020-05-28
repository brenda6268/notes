# Python 操作 ssh


wp_id: 644
Status: publish
Date: 2018-06-22 10:21:00
Modified: 2020-05-16 11:13:52


```py
import paramiko
ip="server ip"
port=22
username="username"
password="password"
cmd="some useful command" 
ssh=paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect(ip,port,username,password)
stdin,stdout,stderr=ssh.exec_command(cmd)
outlines=stdout.readlines()
resp="".join(outlines)
print(resp)
```