# Make 和 DAG 的关系

<!--
ID: b497a1ea-41b6-44d0-a11c-7b535bd90cbd
Status: publish
Date: 2017-07-27T01:21:00
Modified: 2020-05-16T11:46:39
wp_id: 407
-->

Make 实际上包含两部分，一部分是一个任务之间的依赖的逻辑关系（DAG)，另一部分是对 C 语言本身的一些实现知识，比如说 `o` 文件依赖 `c` 文件这些。


## 基本规则

Makefile 是一个 DSL，它的基础语法很简单：

```makefile
目标：依赖
    从依赖生成目标的命令
```

## Basic usage

In most projects, we have a `.h` file for functiont interfaces, and the whole program depends on it. Typically, all `.o` files are compiled from corresponding `.c` source files

```makefile
cc = gcc              # marco
prom = calc
deps = calc.h         # the one .h to rule them all
obj = main.o getch.o getop.o stack.o
$(prom): $(obj)
    $(CC) -o $(prom) $(obj)
%.o: %.c $(deps)      # pattern rule, which means all .o depends on all .c and $(deps)
    $(CC) -c $< -o $@ # $< means the depender and $@ means the dependee
```

## 如何传递参数

```
run: ./prog
    ./prog $(ARGS)

make run ARGS="asdf"
```


## Functions

we can make the file even smarter by using makefile funcions
Makefile function syntax $(func params)

```makefile
cc = gcc
prom = calc
deps = $(shell find ./ -name "*.h") # find all header files using the builtin shell function
src = $(shell find ./ -name "*.c")
obj = $(src:%.c=%.o)
$(prom): $(obj)
    $(CC) -o $(prom) $(obj)
%.o: %.c $(deps)
    $(CC) -c $< -o $@
clean: # 没有依赖的命令
    rm -rf $(obj) $(prom)
```

## 如何执行多个命令

在 Python 中，我们就需要进入到

# Autotools

Autotools is a collection of three tools:

1. autoconf — This is used to generate the “configure” shell script. As I mentioned earlier, this is the script that analyzes your system at compile-time. For example, does your system use “cc” or “gcc” as the C compiler?
2. automake — This is used to generate Makefiles. It uses information provided by Autoconf. For example, if your system has “gcc”, it will use “gcc” in the Makefile. Or, if it finds “cc” instead, will use “cc” in the Makefile.
3. libtool — This is used to create shared libraries, platform-independently.

```
$ autoscan                    #--> creates &#x60;autoscan.scan&#x60; file
$ mv autoscan.scan to &#x60;autoscan.ac&#x60; file
$ autoconf                    # --> use autoconf.ac to create &#x60;configure&#x60; file
# we need a &#x60;makefile.in&#x60; as the template for configure file to use
$ automake                    # --> use &#x60;makefile.in&#x60; to create &#x60;makefile&#x60;
$ autoheader                  # --> generate &#x60;config.h.in&#x60;
$ ./configure                 # --> generate the makefile and config.h
$ make &amp;&amp; make install        # horry!
```

To be continued at:
http://markuskimius.wikidot.com/programming:tut:autotools:5


# premake 基本用法

premake 可以生成 makefile
premake gmake
生成的 makefile 支持
make 默认构建
make help	查看帮助文件
make config=release	按照 release 构建
make clean	清除构建
make config=release clean	清除 release 构建

premake5 脚本的名字是 premake5.lua, 本质上就是一个 lua 脚本，每一行都是一个函数调用，因为参数恰好是字符串或者 table, 所以可以省略括号

```
-- premake5.lua
workspace "HelloWorld"
   configurations { "Debug", "Release" }
project "HelloWorld"
   kind "ConsoleApp"
   language "C"
   targetdir "bin/%{cfg.buildcfg}"
files { "**.h", "**.c" }
filter "configurations:Debug"
      defines { "DEBUG" }
      flags { "Symbols" }
filter "configurations:Release"
      defines { "NDEBUG" }
      optimize "On"
```

## 常用函数

```
workspace 	相当于 vs 的 solution
project	project
kind	 指定编译目标类型	ConsoleApp WindowedApp    SharedLib StaticLib
location	 指定编译目标目录
define	 定义常量
files	添加文件	文件名 *.ext **.ext
removefiles	 屏蔽文件
links	链接库
libdirs	添加库目录
configurations	指定不同的编译选项	需要通过 filter {"configurations:<name>"} 指定具体选项
platforms	 指定不同的平台	和 vs 的 platform 类似，但是也需要使用 filter 定义
includedirs	添加 include 目录
optimize	 设置优化选项	 Off On
buildoptions	编译选项	比如 -std=c99
```

## 作用范围

作用范围会发生继承，使用 `workspce '*'` 或者 `project '*'`代表选中了所有 workspace 或者 project

```
premake install

newaction {
   trigger     = "install",
   description = "Install the software",
   execute = function ()
      -- copy files, etc. here
   end
}
```

## 参考

1. https://stackoverflow.com/questions/2367284/how-does-the-make-j-option-actually-work
2. http://www.epubit.com.cn/article/546
3. https://stackoverflow.com/questions/2214575/passing-arguments-to-make-run
