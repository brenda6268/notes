# installing nightmare

<!--
ID: aed965ea-2559-4486-8500-f3c5e6a5c1da
Status: draft
Date: 2018-01-17T22:50:00
Modified: 2020-05-16T11:29:38
wp_id: 458
-->

electorn bugs

It's because electorn uses a prebuilt file which is located at github, and with GFW, the network offen times out. use taobao mirror to avoid this.

```
export ELECTRON_MIRROR="https://npm.taobao.org/mirrors/electron/"

npm cache clean

rm $HOME/.electron   # rm electorn local cache
rm .npm

sudo apt-get install libgtk2.0-0 libnotify-bin libgconf-2-4 libnss3

npm install electron -g
```