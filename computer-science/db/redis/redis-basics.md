# 学习 redis 的基础命令

<!--
ID: 3b1f53dc-20e9-4e50-ac25-2dd4103b6868
Status: publish
Date: 2017-06-08T10:19:00
Modified: 2020-05-16T12:05:24
wp_id: 571
-->

basically, redis is a data structure server

string list set sorted set hash

## key related

```
keys <pattern>	list all keys share the pattern
exists key	
del key	
expire key expiration	
expireat key timestamp	
ttl key	
rename key	
type key	
```

## string related

```
set key value	set mystr "hello world"
setex key timeout value	set key with expiration
setnx key value	set only not exist
get key -> value	get mystr
getset key new -> old	get old and set new
setrange key offset value	
getrange key start end	returns the value, inclusive
mget key...	returns a list of values
```

```
incr key	mynum
decr key	mynum
incrby key value	mynum
decrby key value	mynum
getset	
```

# hash

```
hmset key f v ...	store kv pair in hash
hgetall key	
hdel key f	
hexists key f	
hkeys key	
hlen key	
hvals key	
```

# lists

list is implemented as a double-linked list

```
lpush key value1 value2 value3	 lpushx only pushes if not exist
rpush
lpop key	
rpop
rpoplpush src dst
blpop key... timeout	block until one value is avaliable
lindex key index
llen key
lrange key start end	inclusive
linsert key 
lrem key count value	
lset key index value	
ltrim key start end	
```

# tricks

to get all elements with lrange: use `lrange KYE 0 -1`

# Persistense

RDB
AOF

# Transaction

```
MULTI用来组装一个事务；
EXEC用来执行一个事务；
DISCARD用来取消一个事务；
WATCH用来监视一些key，一旦这些key在事务执行之前被改变，则取消事务的执行。
```

# zset
rank is which place the value ranked by score in the zset.

## add and remove cookies

```
zadd KEY SCORE MEMBER           # add a value to a zset
zincrby KEY SCORE MEMBER        # increment the member"s score NOTE redis-py implements wrongly
zrem KEY MEMBER...              # remove a value from zset
zremrangebyrank KEY START STOP  # removes all values in the set within the give index
zremrangebyscore KEY MIN MAX    # removes all values in the set within the given scores
```

## get zset stats

this is zismember command, just use zscore KEY MEMBER is None to check
```
zcard KEY                       # get the number of elements in a zset
zcount KEY MIN MAX              # count the members in a sorted set with scores within the given scores
zrank KEY MEMBER                # get the index of member in zset
zrevrank KEY MEMBER             # the reverse index of member
zscore KEY MEMBER               # get the score of member in zset
```

## read member(s)

```
zrange KEY START END            # a range of members by index
zrevrange KEY START END         # a range of memvers by index, sorted from high to low
zrangebyscore KEY MIN MAX       # a range of members within given scores
zrevrangebyscore KEY MAX MIN    # a range of members within given scores, from max to min
```

## set manipulation