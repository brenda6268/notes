# installing nightmare


ID: 458
Status: draft
Date: 2018-01-17 22:50:00
Modified: 2020-05-16 11:29:38


electorn bugs

It's because electorn uses a prebuilt file which is located at github, and with GFW, the network offen times out. use taobao mirror to avoid this.

```
export ELECTRON_MIRROR=&quot;https://npm.taobao.org/mirrors/electron/&quot;

npm cache clean

rm $HOME/.electron   # rm electorn local cache
rm .npm

sudo apt-get install libgtk2.0-0 libnotify-bin libgconf-2-4 libnss3

npm install electron -g
```