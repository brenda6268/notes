# lua

<!--
ID: 1f6c92eb-323e-40af-8d7e-7cd6bd148fbd
Status: publish
Date: 2017-05-30T13:45:00
Modified: 2017-05-30T13:45:00
wp_id: 693
-->

lua_pcall 是使用 c 中的 setjmp 实现的, 对应在lua 中的函数就是 pcall

pcall/error 大概就相当于其他语言中的 try-catch /throw了

```
local ok, errorobject = pcall(function() 
    --here goes the protected code 
    ... 
end) 

if not ok then 
    --here goes the error handling code 
    --(errorobject has more information about the error) 
    ... 
end 
```

# 协程

对称协程只有一个关键字: transfer, 类似于 goto 语句, 把控制权移交给其他的任意一个协程; 而非对称协程一般有两个关键字:resume 和 yield, 使用 resume打开一个协程, 然后在这个协程中使用 yield 返回.


学习lua可以获得

* 怎样实现一门语言，编译原理，离散数学
* lua本身
* 虚拟机，jit
* C语言能力的增强

lua 的标准库补充 [Penlight](https://github.com/stevedonovan/Penlight)

![](http://ww4.sinaimg.cn/large/006tNbRwgy1fg3q43bjn9j31kw1rgk1j.jpg)

Programming in Lua

Lua编程手册

Lua Unofficial FAQ

知乎上 lua 相关的问题