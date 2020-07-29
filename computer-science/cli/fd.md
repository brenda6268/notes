# fd - 更好的 find 命令（fd - A nicer find command）

<!--
ID: 77830286-00ff-49ee-a90a-3cbf309f901f
Status: publish
Date: 2018-04-01T04:33:00
Modified: 2020-05-16T11:31:18
wp_id: 434
-->

`fd`（https://github.com/sharkdp/fd ） 是 `find` 命令的一个更现代的替换。

`fd`（https://github.com/sharkdp/fd ） is a modern and nicer replacement to the traditional `find` command.

# 对比一下 Some comparisons

## 查找名字含有某个字符的文件 Find a filename with certain string

OLD

```
-> % find . -name "*hello*"
./courses/hello_world.go
./courses/chapter_01/hello_world.go
./courses/chapter_01/hello_world
./examples/01_hello_world.go
```

NEW

```
-> % fd hello
courses/chapter_01/hello_world
courses/chapter_01/hello_world.go
courses/hello_world.go
examples/01_hello_world.go
```

## 使用正则表达式查找 Find files using regular expression

比如说查找符合 `\d{2}_ti` 模式的文件。`find` 使用的正则表达式非常古老，比如说在这里我们不能使用 `\d`，也不能使用 `{x}`  这种语法。因此我们需要对我们的正则表达式做一些改写。关于`find`支持的正则表达式这里就不展开了。

`fd` 默认就是使用的正则表达式作为模式，并且默认匹配的是文件名；而 `find` 默认匹配的是完整路径。另外 

For example, let's find a file whose name matches `\d{2}_ti`. `find` uses a very ancient form of regular expression. Neither can we use `\d`, nor can we use `{x}`. So we have to adjust our expression to these kind of limitations.

`fd`, by default, uses regular expression as patter, and matches filenames; on the other hand, `find` uses the `-regex` option to specify a regular expression, and it matches the whole path.

OLD 

```
-> % find . -regex ".*[0-9][0-9]_ti.*"
./examples/33_tickers.go
./examples/48_time.go
./examples/28_timeouts.go
./examples/50_time_format.go
./examples/32_timers.go

```

NEW

```
-> % fd "\d{2}_ti"
examples/28_timeouts.go
examples/32_timers.go
examples/33_tickers.go
examples/48_time.go
examples/50_time_format.go

```

## 指定目录 Find in a specific directory

`find` 的语法是 `find DIRECTORY OPTIONS`；而 `fd` 的语法是 `fd PATTERN [DIRECTORY]`。注意其中目录是可选的。这点个人认为非常好，因为大多数情况下，我们是在当前目录查找，每次都要写 `.` 非常烦。

`find` follows the syntax `find <directory> <options>`; meanwhile, `fd` uses `fd <pattern> [<directory>]`. Note that the directory part is optional. AFAIK, this is very convenient. Most of the times, we are just trying to find something in the working directory, typing `.` each time is very annoying.

OLD

```
-> % find examples -name "*hello*"
examples/01_hello_world.go
```

NEW

```
-> % fd hello examples
examples/01_hello_world.go
```

## 直接执行命令 Execute the command without arguments

find 会打印帮助信息，而 fd 则会显示当前目录的所有文件。

`find` will print help message, `fd` will print all the files in current directory

OLD

```
-> % find
usage: find [-H | -L | -P] [-EXdsx] [-f path] path ... [expression]
       find [-H | -L | -P] [-EXdsx] -f path [path ...] [expression]
```

NEW

```
-> % fd
courses
courses/chapter_01
courses/chapter_01/chapter_1.md
courses/chapter_01/chapter_1.pdf
courses/chapter_01/hello_world
courses/chapter_01/hello_world.go
```

## 按后缀名查找文件 Find files by extension

这是一个很常见的需求，`find` 中需要使用 `-name "*.xxx"` 来过滤，而 `fd` 直接提供了 `-e` 选项。

It's a very common use case. With `find`, you have to use `-name "*.xxx"`, while `fd` provides `-e` option directly.

OLD

```
-> % find . -name "*.md"
./courses/chapter_01/chapter_1.md
./courses/chapter_1.md
```

NEW

```
-> % fd -e md
courses/chapter_01/chapter_1.md
courses/chapter_1.md
```

## 查找中过滤掉 `.gitignore` 中的文件 Exclude files listed in `.gitignore`

`find` 并没有提供对 `.gitingnore` 文件的原生支持，更好的方法可能是使用 `git ls-files`。而作为一个现代工具，`fd` 则默认情况下就会过滤 `gitignore` 文件，更多情况请查阅文档。

可以使用 `-I` 来包含这些文件，使用 `-H` 添加隐藏文件。

`find` does not natively support `.gitignore` files, a practical way would be using `git ls-files`. As a modern tool, `fd` ignores files listed in `.gitignore` and hidden files by default.

You could use `-I` to include those files, `-H` to also include hidden files.


OLD

```
-> % git ls-files | grep xxx
```

NEW

```
-> % fd xxx
```

## 排除某个文件夹 Exclude a directory

`fd` provides a `-E` option to exclude directories. You could put the directories in `.fdignore`, too.

OLD

```
-> % find . -path ./examples -prune -o -name "*.go"
./courses/hello_world.go
./courses/chapter_01/hello_world.go
./examples
```

NEW

```
-> % fd -E examples ".go$"
courses/chapter_01/hello_world.go
courses/hello_world.go
```

## 使用 xargs Using xargs

一般来说，如果使用管道过滤的话，需要使用 '\0' 来作为字符串结尾，避免一些潜在的空格引起的问题。

在 `find` 中需要使用 `-print0` 来调整输出 '\0' 结尾的字符串，在 `xargs` 中需要使用 `-0` 表示接收这种字符串。而在 `fd` 中，和 `xargs` 保持了一直，使用 `-0` 参数就可以了。

If you are using pipes to filter results, using `\0` other than `\n` would be a better option to avoid some potential problems.

`find` with `-print0` will output `\0`-terminated strings, and `xargs`'s option is `-0` to process them. `fd` chooses `-0` as its option, which is consistent with `xargs`.


OLD

```
-> % find . -name "*.go" -print0 | xargs -0 wc -l
       7 ./courses/hello_world.go
       7 ./courses/chapter_01/hello_world.go
      50 ./examples/07_switch.go
...
```

NEW

```
-> % fd -0 -e go | xargs -0 wc -l
       7 courses/chapter_01/hello_world.go
       7 courses/hello_world.go
       7 examples/01_hello_world.go
...
```

总之，fd 命令相对于 find 来说相当简单易用了

As you can see, using `fd` can save you a lot of keystrokes.

# PS

## 使用 exec Using exec

OLD

```
-> % find . -name "*.md" -exec wc -l {} \;
     114 ./courses/chapter_01/chapter_1.md
     114 ./courses/chapter_1.md
```

NEW

You could also omit the `{}`

```
-> % fd -e md --exec wc -l {}
     114 courses/chapter_1.md
     114 courses/chapter_01/chapter_1.md
```