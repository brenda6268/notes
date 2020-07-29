# 无标题

<!--
ID: 9b2acecf-5d8c-447b-ae34-a6bbe073a9df
Status: draft
Date: 2020-05-28T14:15:55
Modified: 2020-05-28T14:15:55
wp_id: 1483
-->

实现真正的基于浏览器的抓取需要的功能

## 请求构造

```yaml
url: xxx # 要访问的 URL
metavars: {}# 要提交的变量
steps: # 要循环运行的步骤
  - click: //*[id="next"]
```