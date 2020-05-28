# Android SharedPreference


wp_id: 524
Status: publish
Date: 2018-04-04 06:01:00
Modified: 2018-04-04 06:01:00


用来在应用中存储键值对配置

context.getSharedPreferences("prefName", Context.MODE_PRIVATE)	get SharedPreferecnes instance
sharedPref.getXXX("keyName", defaultValue)	get value from SharedPreferences
sharedPref.edit()	get editor(SharedPreference.Editor)
editor.putXXX("key-name", value)	put value
editor.commit()	commit the changes