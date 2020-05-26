# memcacheq


ID: 625
Status: publish
Date: 2017-05-30 08:10:00
Modified: 2017-05-30 08:10:00


memcacheq
======
 
memcacheq is based on memcachedb which is based on memcached and Berkeley DB
memcachedb adds persistent for memcached by using Berkeley DB and is fully compatible with the memcached API
 
memcached API http://www.tutorialspoint.com/memcached/memcached_set_data.htm
------
 
set key flags exptime bytes [noreply] 
value 
 
--> STORED // success
--> ERROR // error
 
get key
 
-->
VALUE key flags bytes
value
 
END
 
memcacheq http://memcachedb.org/memcacheq/
------
 
memcacheq uses only the get and set verb