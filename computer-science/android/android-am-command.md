# Android am 命令

<!--
ID: 8cf83263-a393-4609-bcb5-73db47607d0e
Status: publish
Date: 2017-06-03T15:36:00
Modified: 2017-06-03T15:36:00
wp_id: 523
-->

am is short for activity manager, which is used to start and stop activity in android.

## basic syntax

### start an activity

you can get the activity name by decompiling the apk and view the androidmanifest.xml file

```
am start -n <package_name>/<activity_name> [parameters]
am start -n com.tencent.mm/com.tencent.mm.plugin.webview.ui.tools.WebViewUI http://zhihu.com
```

### stop an activity

```
am force-stop com.tencent.mm
```