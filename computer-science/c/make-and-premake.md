# make 和 premake


ID: 407
Status: publish
Date: 2017-07-27 01:21:00
Modified: 2020-05-16 11:46:39


# Rule

```makefile
target: dependencies(sepreated by spaces)
    command(s) to run to build the target from dependencies
```

# Basic usage 

in most projects, we have a `.h` file for functiont interfaces, and the whole program depends on it.
typically, all `.o` files are compiled from corresponding `.c` source files

```makefile
cc = gcc              # marco
prom = calc
deps = calc.h         # the one .h to rule them all
obj = main.o getch.o getop.o stack.o
$(prom): $(obj)
    $(CC) -o $(prom) $(obj)
%.o: %.c $(deps)      #pattern rule, which means all .o depends on all .c and $(deps)
    $(CC) -c $&lt; -o $@ # $&lt; means the depender and $@ means the dependee
```

# Functions

we can make the file even smarter by using makefile funcions
Makefile function syntax $(func params)

```makefile
cc = gcc
prom = calc
deps = $(shell find ./ -name &quot;*.h&quot;) # find all header files using the builtin shell function
src = $(shell find ./ -name &quot;*.c&quot;)
obj = $(src:%.c=%.o) 
$(prom): $(obj)
    $(CC) -o $(prom) $(obj)
%.o: %.c $(deps)
    $(CC) -c $&lt; -o $@
clean:                              # empty target to run a commnad
    rm -rf $(obj) $(prom)
```
# Reference

http://www.epubit.com.cn/article/546

# Autotools

Autotools is a collection of three tools:

1. autoconf — This is used to generate the “configure” shell script. As I mentioned earlier, this is the script that analyzes your system at compile-time. For example, does your system use “cc” or “gcc” as the C compiler?
2. automake — This is used to generate Makefiles. It uses information provided by Autoconf. For example, if your system has “gcc”, it will use “gcc” in the Makefile. Or, if it finds “cc” instead, will use “cc” in the Makefile.
3. libtool — This is used to create shared libraries, platform-independently.

```
$ autoscan                    #--&gt; creates &#x60;autoscan.scan&#x60; file
$ mv autoscan.scan to &#x60;autoscan.ac&#x60; file
$ autoconf                    # --&gt; use autoconf.ac to create &#x60;configure&#x60; file
# we need a &#x60;makefile.in&#x60; as the template for configure file to use
$ automake                    # --&gt; use &#x60;makefile.in&#x60; to create &#x60;makefile&#x60;
$ autoheader                  # --&gt; generate &#x60;config.h.in&#x60;
$ ./configure                 # --&gt; generate the makefile and config.h
$ make &amp;&amp; make install        # horry!
```

To be continued at:
http://markuskimius.wikidot.com/programming:tut:autotools:5


# premake 基本用法

premake 可以生成makefile
premake gmake
生成的 makefile 支持 
make 默认构建
make help	查看帮助文件
make config=release	按照 release 构建
make clean	清除构建
make config=release clean	清除 release 构建

premake5脚本的名字是 premake5.lua, 本质上就是一个 lua 脚本, 每一行都是一个函数调用, 因为参数恰好是字符串或者 table, 所以可以省略括号

```
-- premake5.lua
workspace &quot;HelloWorld&quot;
   configurations { &quot;Debug&quot;, &quot;Release&quot; }
project &quot;HelloWorld&quot;
   kind &quot;ConsoleApp&quot;
   language &quot;C&quot;
   targetdir &quot;bin/%{cfg.buildcfg}&quot;
files { &quot;**.h&quot;, &quot;**.c&quot; }
filter &quot;configurations:Debug&quot;
      defines { &quot;DEBUG&quot; }
      flags { &quot;Symbols&quot; }
filter &quot;configurations:Release&quot;
      defines { &quot;NDEBUG&quot; }
      optimize &quot;On&quot;
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
configurations	指定不同的编译选项	需要通过 filter {&quot;configurations:&lt;name&gt;&quot;} 指定具体选项
platforms	 指定不同的平台	和 vs 的 platform 类似, 但是也需要使用 filter 定义
includedirs	添加 include 目录	
optimize	 设置优化选项	 Off On
buildoptions	编译选项	比如-std=c99
```

## 作用范围

作用范围会发生继承, 使用 `workspce '*'` 或者 `project '*'`代表选中了所有workspace 或者 project

```
premake install

newaction {
   trigger     = &quot;install&quot;,
   description = &quot;Install the software&quot;,
   execute = function ()
      -- copy files, etc. here
   end
}
```