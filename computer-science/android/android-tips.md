# Android 开发的一些 tips

<!--
ID: 49ec3452-ab24-481f-816e-f00dcbc572b5
Status: publish
Date: 2018-04-04T06:00:00
Modified: 2020-05-16T11:33:46
wp_id: 530
-->

Prefer Maven dependency resolution instead of importing jar files. If you explicitly include jar files in your project, they will be of some specific frozen version, such as 2.1.1. Downloading jars and handling updates is cumbersome, this is a problem that Maven solves properly, and is also encouraged in Android Gradle builds. For example:

```
dependencies {
    compile "com.squareup.okhttp:okhttp:2.2.0"
    compile "com.squareup.okhttp:okhttp-urlconnection:2.2.0"
}
```

Use different package name for non-release builds Use applicationIdSuffix for debug build type to be able to install both debug and release apk on the same device (do this also for custom build types, if you need any). This will be especially valuable later on in the app's lifecycle, after it has been published to the store.

```
android {
    buildTypes {
        debug {
            applicationIdSuffix ".debug"
            versionNameSuffix "-DEBUG"
        }
release {
            // ...
        }
    }
}
```

Use different icons to distinguish the builds installed on a device—for example with different colors or an overlaid "debug" label. Gradle makes this very easy: with default project structure, simply put debug icon in app/src/debug/res and release icon in app/src/release/res. You could also change app name per build type, as well as versionName (as in the above example).

use stetho

不要在application中存储全局变量
尽量少使用globalobject，最好使用intent
