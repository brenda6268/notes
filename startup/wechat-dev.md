# 微信开发笔记

<!--
ID: 83e46f40-de71-4676-992c-ddc68ec96a0a
Status: publish
Date: 2018-04-30T10:05:00
Modified: 2020-05-16T11:37:52
wp_id: 382
-->

可以使用微信的测试号学习如何开发
http://mp.weixin.qq.com/debug/cgi-bin/sandbox?t=sandbox/login

公众号对于消息的处理相当于使用了微信的服务器做转发代理, 发送到公众号的后端服务器, 而一旦进入网页就相当于直接同服务器通信了.  微信会使用 POST 发送消息到服务器

对于消息的处理有一个签名的过程, 这样后端服务器可以判断消息是否来自微信, 从而防止 API 被恶意滥用盗用.

所以这些繁杂的事情不如交个框架去处理

APPID/APPSECRET 相当于公众号的账号和密码, 通过这两个组合获取一个 access_token 用于平时访问, access_token 是有有效期的, 即使明文传送被泄露了也问题不大

问题是, 服务器需要记得去刷新这个 token, 所以这些东西应该交给框架最好了

微信开放了 JS SDK 可以使用图片语音地图等一系列的应用, 不错


常用的一些 meta 标签

1. <meta content=”width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0;” name=”viewport” /> 
2. <meta content=”yes” name=”apple-mobile-web-app-capable” />  <!--允许全屏模式浏览-->
3. <meta content=”black” name=”apple-mobile-web-app-status-bar-style” />  <!--滚动条样式-->
4. <meta content=”telephone=no” name=”format-detection” />  <!--禁止识别电话号码-->

iOS中浏览器直接访问站点时，navigator.standalone为false,从 主屏启动webapp 时，navigator.standalone为true
移动版本webkit 为 input元素提供了autocapitalize属性，通过指定autocapitalize=”off”来关闭键盘默认首字母大写
开发者指定 的 target属性就失效了，但是可以通过指定当前元素的-webkit-touch-callout样式属性为none来禁止iOS弹出这些按钮

同样为一个img标签指定-webkit-touch-callout为none也会禁止设备弹出列表按钮，这样用户就无法保存＼复制你的图片了
指定文字标签的-webkit-user-select属性为none便可以禁止iOS用户选中文字