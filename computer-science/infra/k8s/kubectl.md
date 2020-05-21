Date: 2019-11-08

进入容器中

kubectl exec -it PODNAME -- bash

获取各种资源列表

kubectl get node/pod/deploy/svc

设置返回参数 -o wide/yaml/name

详细描述资源

kubectl describe node/pod/deploy/svc

-n 指定命名空间

kubectl top node/pod 显示当前节点的一些信息

kubectl port-forward my-pod 5000:6000，本地5000端口转发到 pod 6000

kubectl edit deployment/my-nginx 编辑 kubernetes 的配置文件