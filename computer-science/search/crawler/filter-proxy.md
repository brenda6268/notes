# filter proxy

<!--
ID: cf08a11d-4ece-4184-aae6-9b1c6a43d13d
Status: draft
Date: 2017-05-30T08:15:00
Modified: 2020-05-16T12:00:42
wp_id: 471
-->

filter_rules.yml

filter values and store them to redis



filters.yml

```
filters:
  - stage: response
    match:
      url: [contains, /rest/n/user/list]
      client: [ip, 10.0.0.0]
    capture: 
      - location: text  # capture can be text/header/cookie/url/
        processors:
          - [json_at, "."]

filters:
  - stage: request
    url: [contains, /profile_ext]
    capture:
      - location: url
        processors:
          - [get_url_param, ]
      - location: header
        processors:
          - [header_name, x-wechat-uin]
    set_response:
      - status_code: 200
      - text:

filters:
  - stage: request
    url: [contains, /getverifyinfo]
    capture:
      - location: url
        processors:
          - [get_url_param]
    set_response:
      - status_code: 200
      - text_file: ... 
```