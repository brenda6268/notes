# 安卓证书与代理自动配置


wp_id: 535
Status: publish
Date: 2018-02-24 18:08:00
Modified: 2020-05-16 11:30:40


Go to Settings > Security > Install from storage.

install programatically can be achived by from command line, by moving certs to 


replacing bks file solely is useless, it has to be combined with the password

https://github.com/danzeeeman/meerkat-decompiled/blob/master/io/fabric/sdk/android/services/network/PinningInfoProvider.java


set proxy programatically

1. set mannully for one
2. pull /data/misc/wifi/ipconfig.txt
3. push to other devices


如何安装证书

make certs like this tutorial,  http://forum.xda-developers.com/google-nexus-5/help/howto-install-custom-cert-network-t2533550
but push it to /data/misc/user/0/cacerts-added/