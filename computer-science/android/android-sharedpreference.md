# Android SharedPreference

<!--
ID: 729b483b-0c72-48c8-906e-0f6493d2216b
Status: publish
Date: 2018-04-04T06:01:00
Modified: 2018-04-04T06:01:00
wp_id: 524
-->

用来在应用中存储键值对配置

context.getSharedPreferences("prefName", Context.MODE_PRIVATE)	get SharedPreferecnes instance
sharedPref.getXXX("keyName", defaultValue)	get value from SharedPreferences
sharedPref.edit()	get editor(SharedPreference.Editor)
editor.putXXX("key-name", value)	put value
editor.commit()	commit the changes