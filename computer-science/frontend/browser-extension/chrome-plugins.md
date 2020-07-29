# Chrome 扩展插件开发

<!--
ID: 04f5b2ef-8f73-48dd-b8a3-cf47acb3b9f0
Status: publish
Date: 2017-06-09T05:11:00
Modified: 2020-05-16T12:05:04
wp_id: 721
-->

A chrome extension can inject script into the page, this is called content script.

https://developer.chrome.com/extensions/getstarted
https://developer.chrome.com/extensions/content_scripts
https://developer.chrome.com/extensions/messaging

图标变灰的问题

Add browser_action.default_icon in your manifest.json file

```json
{
  ...

  "browser_action": {
    "default_icon": "icons/icon-32.png";
  },

  ...
}
```