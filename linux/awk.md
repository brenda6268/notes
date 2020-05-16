# awk 

awk 的程序构成是这样的：

```awk
Pattern1 { ACTIONS; }
Pattern2 { ACTIONS; }
...
```

awk 运行的时候，对输入文件每一行依次执行每个语句，直到文件结尾。

## awk 的数据结构

awk 中只有三种数据类型或者说结构：字符串、数字和字典（数组）。而且就像 JavaScript 一样，`==` 是不区分类型的，也就是 `'1' == 1`. 字典也很简单，就是 `var[key] = value`

另外，在 awk 中，每行都会按照空白字符分开，分别用 `$1 $2` 来表示：

```awk
# $1         $2    $3
# 00:35:23   GET   /foo/bar.html
# \_____________  _____________/
#               $0

# Hack attempt?
/admin.html$/ && $2 == "DELETE" {
  print "Hacker Alert!";
}
```

## 内置变量

```awk
BEGIN { # 用户可以修改
  FS = ",";   # Field Separator 字段分隔符
  RS = "\n";  # Record Separator (lines) 行分隔符
  OFS = " ";  # Output Field Separator 输出字段分隔符
  ORS = "\n"; # Output Record Separator (lines) 输出行分隔符
}
{ # 用户不能修改
  NF          # Number of Fields 当前行的字段数量
  NR          # Number of Records 第几行
  ARGV / ARGC # Script Arguments 脚本的参数
}
```

这里比较有意思的是我们可以用 NF 来作为变量的名字，比如说 `$(NF-1)` 实际上就是倒数第二个字段。

## 模式

模式可以分为三种：正则、布尔和特殊模式

正则就是普通的正则，比如说 `/^admin/`，这样是直接匹配整行。如果需要匹配某个字段的话，需要使用 `string ~ /regex/`，比如说 `$1 ~ /admin`

布尔自然就是两个模式结合一下，比如说 `/admin.html$/ && $2 == "DELETE"`

特殊表达式常用的有 `BEGIN` 和 `END` 分别表达在第一行之前和最后一行之后执行。

## 动作

```awk
{ print $0; }  # prints $0. In this case, equivalent to 'print' alone
{ exit; }      # ends the program
{ next; }      # skips to the next line of input
{ a=$1; b=$0 } # variable assignment
{ c[$1] = $2 } # variable assignment (array)

{ if (BOOLEAN) { ACTION }
  else if (BOOLEAN) { ACTION }
  else { ACTION }
}
{ for (i=1; i<x; i++) { ACTION } }
{ for (key in c) { ACTION } }
```

上边这些基本就够用了。需要注意的是，所有的变量都是全局的。

## 函数

awk 中还可以自定义函数，也有一些内置的数字和字符串处理函数。

```
function add1(val) {
     return val+1;
}
```

## 实战

如下的命令可以统计出 TCP 处于每个状态的链接都有多少。

```
netstat -ant | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'  

TIME_WAIT 856
CLOSE_WAIT 1
FIN_WAIT1 1
ESTABLISHED 666
SYN_RECV 2
LAST_ACK 1
```

解释：

1. 首先netstat -ant 的输出如下
    ```
    -> % netstat -ant | head
    Active Internet connections (including servers)
    Proto Recv-Q Send-Q  Local Address          Foreign Address        (state)
    tcp4       0      0  192.168.43.59.50058    23.23.149.218.443      ESTABLISHED
    tcp4       0      0  192.168.43.59.50056    174.129.217.243.443    ESTABLISHED
    tcp4       0      0  192.168.43.59.50052    47.102.138.102.443     ESTABLISHED
    tcp4       0      0  127.0.0.1.1086         127.0.0.1.50050        ESTABLISHED
    tcp4       0      0  127.0.0.1.50050        127.0.0.1.1086         ESTABLISHED
    tcp4       0      0  192.168.43.59.50048    211.159.235.178.80     ESTABLISHED
    tcp4       0      0  192.168.43.59.50032    99.86.193.8.443        ESTABLISHED
    tcp4       0      0  192.168.43.59.50031    99.86.193.8.443        ESTABLISHED
    ```
2. 我们可以看到在 TCP 链接都以 tcp 开头，所以 `/^tcp/` 匹配到了所有的 tcp 行
3. `{++S[$NF]}`，`$NF` 表示最后一个字段，而 `++S[$NF]` 表示在 `S` 这个字典中统计一下每个字段的数量
4. 最后在 `END` 块中遍历并输出统计结果 `S`

## 参考

1. https://blog.jpalardy.com/posts/skip-grep-use-awk/
2. [内置函数](https://www.gnu.org/software/gawk/manual/html_node/Built_002din.html#Built_002din)
3. https://ferd.ca/awk-in-20-minutes.html