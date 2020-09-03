# netcat

<!--
ID: 374bf90a-1ce5-4ab0-bead-ba7eb2ba24e4
Status: draft
Date: 2017-07-27T23:57:00
Modified: 2020-05-16T11:46:57
wp_id: 421
-->

replacement for telnet

nc www.google.com 80

chat with each other

nc -l -p 10086
nc localhost 10086

send files over network

## directory
tar -cf - /data | nc -l -p 666
nc 192.168.1.10 6666 | tar -xf -

## file
cat file | nc -l -p 6666

make any process a server

nc -l -p 12345 -e /bin/bash
