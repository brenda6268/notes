# Python 操作 ssh


ID: 644
Status: publish
Date: 2018-06-22 10:21:00
Modified: 2020-05-16 11:13:52


```
import paramiko
ip=&#039;server ip&#039;
port=22
username=&#039;username&#039;
password=&#039;password&#039;
cmd=&#039;some useful command&#039; 
ssh=paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect(ip,port,username,password)
stdin,stdout,stderr=ssh.exec_command(cmd)
outlines=stdout.readlines()
resp=&#039;&#039;.join(outlines)
print(resp)
```