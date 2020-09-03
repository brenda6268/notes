# Linux 命令行文本处理（sed/awk/grep...）

<!--
ID: 31866fb4-9f7d-440a-97aa-15113056546a
Status: publish
Date: 2017-05-30T12:37:00
Modified: 2020-05-16T12:01:30
wp_id: 593
-->

# sort

```
-d 按照字典排序（默认）
-n 按照数字大小排序
-f 忽略大小写
-g 按照浮点数排序
-M 按照 Jan Feb 等排序

-r 逆序
-k 指定第 k 列排序 -t 指定分隔符
-b 忽略行首空格字符
-m 把两个已经排序的文件合并
```

# uniq 合并重复

uniq 命令假定文件是已经排序的，因此基本要接着 sort 使用

* `sort unsorted.txt | uniq` 删除重复行
* `sort unsorted.txt | uniq -c` 统计行数
* `sort unsorted.txt | uniq -d` 只显示重复行 -u 只显示不重复行

# tr 翻译指令

tr "source" "target" 如果目标字符串太短的化，使用最后一个字符填充
tr -d "source" remove
tr -s "source" squeeze extra characters, useful for piping to cut
-c 参数对第一个字符串的补集
可以使用区间 a-z 0-9 等
还可以使用字符类 [:class:]

* alnum：字母和数字
* alpha：字母
* digit：数字
* space：空白字符
* lower：小写
* upper：大写
* cntrl：控制（非可打印）字符
* print：可打印字符

cut 选取某一列 sort <mode> <which>
有三种模式 -b 按字节 -c 按字符 -f 按域 -d 指定分隔符
选取的列可以使用：

* i 第 i 行
* a,b  i 行和 j 行
* a-b 第 i 到 j 行

--completment 选取补集
--output-delimiter 输出

# wc

统计单词 -c 字符数 -w 单词数 -l 行数

# nl

给每行添加行号 -ba 所有行

# paste

按列合并文本

# xargs

xargs reformat the data it received and give it to next command. xargs squish all parameters into one line

-d set delemeters
-t 回显命令
-I 执行指定的 Instruction，需要指定操作符
如 ls *.md | xargs -t -I "%" cp "%" markdown/
-n output with n args on one line


# regular expression in shell

|Commands|BRE|ERE|PCRE|
|--------|---|---|----|
|sed |*|-E/-r||
|awk||*||
|grep|*|-E|-P|
|find||*| |

# Sed

## Basic format

```
sed options script file
```

by default, sed uses BRE, but you probably want sed -E to enable ERE, see http://liujiacai.net/blog/2014/12/07/regexp-favors/. basically, sed works line by line and do transformation

s for substitution

sed s/day/night/OPTION OLDFILE > NEWFILE

默认只替换第一处出现，/g 替换所有


/ 只是默认的分隔符，可以任意使用，推荐使用：

使用 & 作为匹配到的字符，使用 \1 \2 来表示匹配到的分组，这种表达方式倒是和 pcre 有些类似

使用 -r(linux) 或者 -E(mac) 才能够使用扩展的 posix 正则，一定要带上这两个

OPTION

处理命令行输入输出的时候可能经常需要 trim, 尤其是字符串带了、n 的情况

sed -n 's/PATTERN/&/p' file

sed '/PATTERN/p' file


## Options

```
-i	inplace
-i.bak	inplace with backup
-E/-r	use ERE
```

## script

sed command syntax: option/pattern/command parameters
pattern selects lines and do command with parameters on those lines

# awk

## basic usage

gawk options program varlist file

gawk, like sed, is also line-oriented

## vaiables

$0	the whole line
$1...$n	word in line
NR	number of rows
NF	number of fileds

## awk program

awk 'BEGIN{ } pattern { } END { }' file
BEGIN in used for initilization, and END is used to print out the result, pattern {} is run against each line

awk 'pattern' file
print lines with the pattern

# grep

```
grep pattern file1 file2...
grep pattern *
grep pattern -r <dir>
```

force grep to show file name:
    grep pattern file /dev/null

## options

-v	invert search
-r/-R	recursively
-c 	count matching lines
-o	printing matched part in differnet lines
-b -o	output offset
-n	with line numbers
-i 	ignore case
-l	list matched files
-f 	pattern from
--include	include files for grep
-Z	use \0 as delemeter
-q	no output only return value
-A n	lines after
-B n	lines before
-C n	lines combined

# ag

按文件过滤，支持多种文件类型，可以用`ag --list-file-types`查看支持的类型
