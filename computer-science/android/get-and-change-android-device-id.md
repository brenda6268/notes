# get and change android device id

<!--
ID: 2c86d32d-9dcb-43c5-8c89-a30b20cee938
Status: publish
Date: 2017-05-29T14:48:00
Modified: 2017-05-29T14:48:00
wp_id: 537
-->

## get device id

`String id = Secure.getString(getContentResolver(), Secure.ANDROID_ID);`

## set device id

As far as Settings.Secure.ANDROID_ID goes, this should do the trick:

`adb shell sqlite3 /data/data/com.android.providers.settings/databases/settings.db "UPDATE secure SET value='newid' WHERE name='android_id'"`

Where newid is usually the 16 hex digit code (i.e. don't append "Android_" to it).
I only tried this on the emulator. I imagine a real phone would need to be rooted first.

## Reference

1. http://stackoverflow.com/questions/4686263/change-the-device-id-on-an-android-emulator
2. http://stacktips.com/tutorials/android/get-device-id-example-in-android