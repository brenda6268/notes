# shell 编程教程

<!--
ID: 34869392-edd7-4194-8f68-263e06f1d17a
Status: publish
Date: 2017-07-16T01:38:00
Modified: 2020-05-16T11:46:09
wp_id: 430
-->

# 变量和值

variables are referenced by $var or ${var}. Global variables are visible to all sub bash sessions, and are often called env variables, local variables are only visible to local session, not subsessions.

Global variables can be viewed as `env`, and can be created by `export`.

    TEST=testing; export $TEST # or
    export TEST=testing # NOTE: no $

## Useful variables

```
HOME	Same to ~
IFS
PATH	Search path
EUID	User id
GROUPS	Groups for current user
HOSTNAME	Hostname
LANG
LC_ALL
OLDPWD
PWD
```

## 定义和使用变量

定义变量，注意因为 shell 中的语法使用空格作为命令分割的限制，等于号前后不能加空格。

```
FOO=bar
```

使用变量，需要添加上 `$` 符号。

```
echo $FOO
```

字符串在双引号中可以直接插入，这时候要加上大括号来指示变量名的起始位置。

```
echo "${FOO}xxx"
```

变量默认实在当前的回话中可见的，而不会作为环境变量传递给调用的命令。可以使用 export 导出变量，或者在命令前加上指定的环境变量。

```
-> % cat env.py
import os
print("FOO env variable is: ", os.environ.get("FOO"))

-> % python3 env.py
FOO env variable is:  None

-> % FOO=bar python3 env.py
FOO env variable is:  bar
```

使用 export

```
-> % export FOO=bar
-> % python3 env.py
FOO env variable is:  bar
```

## 一些有用的内置变量

```
$HOME     家目录，比如 /home/kongyifei
$IFS      默认的分隔符，和 for 循环紧密相关
$PATH     搜索路径，当你执行 ls 的时候，shell 会在这个变量中查找 ls 命令
$EUID     当前有效用户 ID
$LANG
$LC_ALL
$OLDPWD   上一个工作目录
$PWD      当前工作目录

```

## 数组

使用小括号来定义一个数组，关于 for 循环随后会讲

```
A=(1 2 3)

for el in ${A[@]}; do
    echo $el
done
```

## 字符串操作

大括号里面的字符串会被展开成独立的字符串

```
% echo {1,2,3,4}
1 2 3 4
% mkdir -p test/{a,b,c,d}{1,2,3,4}
% ls test/
a1  a2  a3  a4  b1  b2  b3  b4  c1  c2  c3  c4  d1  d2  d3  d4
% mv test/{a,c}.conf  # 这个命令的意思是：mv test/a.conf test/c.conf
```

切片：`${string:start:length}`

默认值 `${var:-default}`

设定值 `${var:=default}`

长度 `${#var}`

### 字符串 Expansion and slice

[zorro@zorrozou-pc0 bash]$ mkdir -p test/zorro/{a,b,c,d}{1,2,3,4}
[zorro@zorrozou-pc0 bash]$ ls test/zorro/
a1  a2  a3  a4  b1  b2  b3  b4  c1  c2  c3  c4  d1  d2  d3  d4

[zorro@zorrozou-pc0 bash]$ mv test/{a,c}.conf
这个命令的意思是：mv test/a.conf test/c.conf

${string:start :length} string slice

default value: ${var:-default}
set value: ${var:=default}

${#var} get variable length


# Redirection

input: <, output >, append >>

cat > file << EOF
this
line
will
be redirected to
file
EOF

# pipe

pipe commands will be run simultaneously, but the second command will wait for the input

# Sub shell

use $(expression)


# 控制语句

## 条件语句

if 语句成立的条件是 `expr` 返回值为 0。

```
if expr; then
    statement;
elif expr; then
    statement;
else
    statement;
fi
```

## test command

虽然可以使用任意的语句作为判断条件，不过我们一般情况下都是用 `[` 这个命令来作为判断条件的，需要注意的是 `[` 并不是一个语法，而是一个命令。不过由于 `[` 这个上古命令实在功能太少，现在一般采用 `[[` 来作为判断条件。

```
if [[ "a" == "b" ]]; then
    echo "wtf"
else
    echo "meh"
fi
```

`[[`支持的条件有

1 数值比较，仅限整数，注意不能使用 `>` `<` 等符号。

```
n1 -eq n2	equal
n1 -ge n2	greater or equal
n1 -gt n2	greater
n1 -le n2       less or equal
n1 -lt n2	less
n1 -ne n2	not equal
```

2 字符串比较

Note: Variables may contain space, so the best way to comparison is to add quotes: `"$var1" = "$var2"`

```
str1 == str2	equal
str1 != str2	not equal
str1 < str2	less
str1 > str2	greater
-z str	zero
-n str	not zero length
```

3 file comparison

	-d	is directory?
	-e	exist?
	-f	is regular file?
	-r	exist and readable?
	-s	exist and has content
	-w 	exist and writable
	-x 	exist and executealbe
	-O	exist and owned
	-G	exist and in same group
	file -nt file2	newer than
	file1 -ot file2 	older than

## case

case var in
parttern | pattern2) commands;;
pattern3) commands2;
*) default commnads;;
esac

## Loops

### foreach 语句

for var in list; do
     echo $var
done

其中 list 可以是一个数组，也可以是一个被 $IFS 分割的字符串。默认情况下，$IFS 是 " \n\t"。其中包含了空格。

如果要覆盖 IFS，一般这样使用：

OLDIFS=$IFS
IFS="\n" # new seperator
# do things
IFS=$OLDIFS

### while-loop

until/while expr; do
    # commands
done

### pipe

the result of a for loop is pipe-able to other command

```
for city in beijing shanghai; do
    echo $city is big
done > cities.txt
# will save the result in cities.txt
```

# 输入输出

## 命令行参数

parameters to a script can be obtained as $1, $2, $3...。 $0 is the script name, remember to check whether the parameter is empty. $# is the number of parameters(without script name).

```
$0	script name / function name
$1...$x	command line arguments / parameters
$#	number of arguments(without $0)
$*	all parameters as a string
$@	all parameters as a string list
```

### shift

processing parameters using shift,

while [ -n "$1" ]; do
    case "$1" in
        -a) echo "option -a" ;;
        --) shift
            break;;
        *) echo "$1" is not a option ;;
    esac
    shift
done

## read

read OPTIONS VARNAME read input to variables

- read -p	Prompt
- read -t	timeout
- read -s 	hide input

we can use read to read file or stdin

## redirection

2>	redirect STDERR
m>&n	redirect fd m to fd n's associated file

Note: you have to use command >> command.log 2>&1 (put 2>&1 at the end), since this means redirect 2 to 1's
in a scirpt
exec 2> filename # reopen stdout to filename

# Signal

trap commnad signal is used to handle signals in shell

# Functions

有两种定义函数的方式

```
function name {
    # function body
}

foo() {
    # function body
}
```

要调用上面这个函数，直接就输入

```
foo
```

就好了

## return

shell functions behave like a small script, and it does NOT return a computed value...It retures a exit code, which is between 0 and 255. if no return is specified, the exit code of last command will be returned

You can read the return value by $? like any normal commands

the right way to to return a value from function, you will have to echo out the value, and put the function is subshell

```
function foo {
    # do some compute
    echo $result;
}

retval=$(foo)
```

Note: any thing that echos in the function body will be captured, so please keep that from happen

## parameters

like a shell script, $0 holds the function name, $1 ... $9 holds the parameters, $# is the num of parameters

## local variables

use `local` to declare local variables


# alias

```
alias new_name="command string"
$ \command  # bypass alias
```

# debugging

DEBUG macro

# multiprocess

PID_ARRAY=()
for file in filelist; do
    md5sum file &;
    PID_ARRAY+=("$!")
done
wait ${PID_ARRAY[@]}
