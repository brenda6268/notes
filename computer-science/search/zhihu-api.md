# 知乎移动端接口分析

<!--
ID: dfdbd6c4-eab8-47f9-8ba1-b69c508b0d1d
Status: publish
Date: 2018-07-15T04:58:00
Modified: 2020-05-16T11:18:49
wp_id: 468
-->

最近想注册一些知乎的机器人玩玩儿，比如给自己点赞之类的，通过抓包分析，获得了完整注册登录流程。

# 抓包

```
1 POST https://api.zhihu.com/auth/digits
      ← 401 application/json 97b 246ms
2 GET https://api.zhihu.com/captcha
     ← 200 application/json 22b 233ms
3 PUT https://api.zhihu.com/captcha
     ← 202 application/json 5.46k 323ms
4 POST https://api.zhihu.com/captcha
      ← 201 application/json 16b 295ms
5 POST https://api.zhihu.com/sms/digits
      ← 201 application/json 16b 353ms
6 POST https://api.zhihu.com/validate/digits
      ← 201 application/json 16b 409ms
7 POST https://api.zhihu.com/validate/register_form
      ← 200 application/json 16b 279ms
8 POST https://api.zhihu.com/register
      ← 201 application/json 761b 529ms
```

逐行分析一下每个包:

1. 这个请求发送了 `username: +86155xxxxxxxx` 请求，然后返回了 `缺少验证码票据`，应该是表示缺少验证码。
2. 应该不是请求验证码，而是请求是否需要验证码，返回了`"show_captcha": false`，虽然表示的是不需要验证码，但是还是弹出了验证码，奇怪。
3. 注意这个请求是 PUT，POST 参数`height: 60, width: 240`。然后返回了验证码：`{"img_base64": ...}`, base64 解码后就是验证码
4. 这一步 POST 正确的 captcha 并通过验证，参数是：`input_text: nxa8`, 返回是：`{ "success": true }`
5. 这一步请求发送短信验证码，POST 参数是：`phone_no: +86155xxxxxxxx`, 发挥是：`{ "success": true }`
6. 提交验证码，POST 参数是: `phone_no: +86155xxxxxxxx, digits: xxxxxx`， 返回是：`{ "success": true }`
7. 填写用户信息，POST 参数是：`phone_no: +86155xxxxxxxx, gender: 0, fullname: XXX`,返回是：`{ "success": true }`
8. 上一步注册了用户，这一步是向知乎请求新的 access token。

    请求 POST 参数：
    ```
    digits:        865405
    fullname:      Lucindai
    phone_no:      +8615568995304
    register_type: phone_digits
    ```

    返回数据如下：
    ```
    {
    "access_token": "...",
    "cookie": { },
    "expires_in": 2592000,
    "lock_in": 1800,
    "old_id": 155681178,
    "refresh_token": "...",
    "token_type": "bearer",
    "uid": "...",
    "unlock_ticket": "...",
    "user_id":...
    }
    ```

    其中的 refresh token 和 access token 都是 OAuth2 中的参数，可以用于使用 OAuth2 访问知乎的 API。可以使用 zhihu_oauth 这个库来访问知乎。

知乎的 API 还需要在 header 中设定一些特殊参数，可以参考 zhihu_oauth 中的参数

再注册成功之后还应该设定密码，这样之后就可以使用密码登录了。

```
PUT https://api.zhihu.com/account/password
new_password=xxxxxx
```