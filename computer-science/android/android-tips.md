# Android 开发的一些 tips


ID: 530
Status: publish
Date: 2018-04-04 06:00:00
Modified: 2020-05-16 11:33:46


Prefer Maven dependency resolution instead of importing jar files. If you explicitly include jar files in your project, they will be of some specific frozen version, such as 2.1.1. Downloading jars and handling updates is cumbersome, this is a problem that Maven solves properly, and is also encouraged in Android Gradle builds. For example:

```
dependencies {
    compile &#039;com.squareup.okhttp:okhttp:2.2.0&#039;
    compile &#039;com.squareup.okhttp:okhttp-urlconnection:2.2.0&#039;
}
```

Use different package name for non-release builds Use applicationIdSuffix for debug build type to be able to install both debug and release apk on the same device (do this also for custom build types, if you need any). This will be especially valuable later on in the app's lifecycle, after it has been published to the store.

```
android {
    buildTypes {
        debug {
            applicationIdSuffix &#039;.debug&#039;
            versionNameSuffix &#039;-DEBUG&#039;
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
