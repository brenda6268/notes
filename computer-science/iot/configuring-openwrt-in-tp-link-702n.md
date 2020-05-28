# Configuring OpenWrt in TP-Link 702n


wp_id: 442
Status: publish
Date: 2017-05-29 01:09:00
Modified: 2019-10-18 18:53:12


# 如何重置一个损坏的 OpenWrt

删除 overlay 下的文件即可

```
rm -rf /overlay/*
```

# 网络配置

### 1.Assign a Password for Root

    telnet 192.168.1.1
    passwd root
    exit

### 2.Interface config: `/etc/config/network`

```
        config interface "loopback"
            option ifname "lo"
            option proto "static"
            option ipaddr "127.0.0.1"
            option netmask "255.0.0.0"
        config interface "lan"
            option ifname "eth0"
            option proto "dhcp"
        config interface "wifi"
            option proto "static"
            option ipaddr "172.19.1.1"
            option netmask "255.255.255.0" 
```

### 3.Wireless Config: `/etc/config/wireless`
```
        1) **remove to enable wifi**
            # REMOVE THIS LINE TO ENABLE WIFI:
            option disabled 1
        2) config wifi interface
            config wifi-iface
                option device "radio0"
                option network "wifi"
                option mode "ap"
                option ssid "WR703n"
                option encryption "psk2"
                option key "secret"
```

### 4.DHCP Config: `/etc/config/dhcp`
```
        config dhcp wifi                                          
            option interface        wifi                      
            option start    100                               
            option limit    150                               
            option leasetime        12h                       
                                                          
        config dhcp lan                               
            option interface        lan           
            option ignore   1
```

###5.Firewall Config: `/etc/config/firewall`

```
        config defaults
            option syn_flood 1
            option input ACCEPT
            option output ACCEPT
            option forward ACCEPT
        config zone
            option name lan
            option network "lan"
            option input ACCEPT
            option output ACCEPT
            option forward ACCEPT
            option masq 1
            option mtu_fix 1
        config zone
            option name wifi
            option network "wifi"
            option input ACCEPT
            option output ACCEPT
            option forward ACCEPT
        config forwarding
            option src lan
            option dest wifi
        config forwarding
            option src wifi
            option dest lan 
    PS: to use pppoe, lan -> wan
```

###6.Reboot

2.Mount Exteral Drive and Extroot(pivot root)
---------------------------------------------

### 1.Add USB support
        opkg update && opkg install kmod-usb2
        insmod ehci-hcd
        opkg install kmod-usb-storage block-mount kmod-fs-ext4
    
###2.Copy the Entire `/` to USB Storage
        mkdir -p /mnt/sda1
        mount /dev/sda1 /mnt/sda1
        mkdir -p /tmp/cproot
        mount --bind / /tmp/cproot
        tar -C /tmp/cproot -cvf - . | tar -C /mnt/sda1 -xf -
        umount /tmp/cproot
        umount /mnt/sda1
###2.Edit `/etc/config/fstab` file
        config mount
            option target /  # this is curcial
            option device /dev/sda1
            option fstype ext4
            option options rw,sync
            option enabled 1 #remeber to change this
            option enabled_fsck 0 
3.(Necessary only if you are not extrooting) Opkg to Exteral Drive
------------------------------------------------------------------
###1.Edit `/etc/opkg.conf` file
        dest usb /mnt/usb
###2.Edit `/etc/profile` file
        export USB=/mnt/usb
        # it's crucial to make customized bin preceeds system ones
        export PATH=$USB/usr/bin:$USB/usr/sbin:$PATH
        export LD_LIBRARY_PATH=$USB/lib:$USB/usr/lib
###3.Remeber to use
        opkg isntall <package> -d usb
###4.fix
        run linkmaker to link /etc to /mnt/usb/etc
!!!!!!!!!!!!!!!!!!!!!below is down on extroot!!!!!!!!!!!!!!!!!!!!!!!

# 安装 Python

```
opkg install python
```

TODO: 不知道能否交叉编译一个 micropython

5.Samba configuration
---------------------
    1.Install Samba
        opkg install samba36-server
    2.mkdir ~/share
      chmod 777 ~/share
    3.Share Level Share
        1. Edit `/etc.config/samba` file
        config samba
            option 'name'                   'OpenWrt'
            option 'workgroup'              'WORKGROUP'
            option 'description'            'OpenWrt'
            option 'homes'                  '0' # disable ~ dir sharing
        config sambashare
            option name                     share
            option path                     /root/share
            option read_only                no # enable write
            option guest_ok                 yes # enable no passwd visit
            option create_mask              0777
            option dir_mask                 0777
        2. change security = user to security = share in /etc/samba/smb.conf.template
    
    4./etc/init.d/samba enable && /etc/init.d/samba start

# 免密码登录

```
scp ~/.ssh/id_rsa.pub root@ow:/etc/dropbear/authorized_keys
```

# 更改 banner

编辑 /etc/banner 即可


8.SSH Proxy
-----------
    1.install openssh and autossh
        mv /usr/bin/ssh /usr/bin/ssh.dropbear
        mv /usr/bin/scp /usr/bin/scp/dropbear
        opkg install openssh-client autossh

# 禁用 luci
```
/etc/init.d/uhttpd disable
```

10.Install Camera
-----------------
    1.install video support
        opkg install kmod-video-core kmod-video-uvc mjpg-streamer fswebcam
    2.Using fswebcam
        fswebcam capture.jpg -r 640x480
    3.Using mjpg-streamer

11.Static DHCP leases
---------------------
    1.vi /etc/config/dhcp
      http://wiki.openwrt.org/doc/uci/dhcp#static.leases