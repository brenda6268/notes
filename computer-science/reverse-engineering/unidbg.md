# unidbg 教程

<!--
ID: 5de007cd-a9f9-42b0-9a23-6105b5e0ffd4
Status: publish
Date: 2019-06-15T14:38:03
Modified: 2020-05-16T11:00:50
wp_id: 54
-->

## 介绍

unidbg 是一个基于 unicorn 的逆向工具，可以黑盒调用安卓和 iOS 中的 so 文件。unidbg 是一个标准的 java 项目。

由于现在的大多数 app 把签名算法已经放到了 so 文件中，所以要想破解签名算法，必须能够破解 so 文件。但是我们知道，C++ 的逆向远比 Java 的逆向要难得多了，所以好多时候是没法破解的，那么这个时候还可以采用 hook 的方法，直接读取程序中算出来的签名，但是这样的话，需要实际运行这个应用，需要模拟器或者真机，效率又不是很高。

unidbg 就是一个很巧妙地解决方案，他不需要直接运行 app，也无需逆向 so 文件，而是通过在 app 中找到对应的 JNI 接口，然后用 unicorn 引擎直接执行这个 so 文件，所以效率也比较高。

### 工具

逆向三剑客，unicorn，keystone，capstone，以及 unicorn_java

1. [capstone](https://www.capstone-engine.org/documentation.html) 反编译框架
2. [unicorn](https://www.unicorn-engine.org/) 基于 QEMU 的模拟器

### Unicorn 介绍

[基础介绍](https://bbs.pediy.com/thread-224315.htm)

比如我们单纯只是需要模拟代码的执行而非需要一个真的CPU去完成那些操作, 又或者想要更安全地分析恶意代码, 检测病毒特征, 或者想要在逆向过程中验证某些代码的含义. 使用CPU模拟器可以很好地帮助我们提供便捷.

## Java 基础

由于好久没用 java了，一直都用 Python 比较多，先回忆一下需要用到的 java 知识。

java -D 用于指定参数。比如 -Djava.library.path=xxx.so

-cp 用于指定 classpath

Java 中加载 so 文件。

1. 使用 System.load(String) 可以加载 so 文件
2. 使用 java.library.path 指定路径
3. java.library.path 会默认从 LD_LIBRARY_PATH 中读取

Unsatisfied linked error 的解决

一般是由于缺少库导致的，到作者的帖子中下载对应的

### Maven 项目介绍

https://www.cnblogs.com/now-fighting/p/4858982.html 

未完待续

## 参考

1. [加载 jar 包中的动态库](https://blog.csdn.net/10km/article/details/87898189)
2. [java 的 -D 选项](https://www.jianshu.com/p/ffe477a5de87)
3. [java.library.path](https://blog.csdn.net/submorino/article/details/41041309)
4. unidbg: [作者原贴](https://bbs.pediy.com/thread-249732-1.htm)
5. unicorn 基础教程，强烈推荐 (https://bbs.pediy.com/thread-225018.htm)
6. 包含 C 代码的 unicorn 教程[英文](http://eternal.red/2018/unicorn-engine-tutorial/), [中文](https://bbs.pediy.com/thread-224330.htm)
7. Unicorn 教程 (https://ctf-wiki.github.io/ctf-wiki/reverse/unicorn/introduction/)
8. unicorn 原理介绍，必读 (https://zhuanlan.zhihu.com/p/30612805)
9. 逆向常用工具合集 (https://5alt.me/wiki/%E9%80%86%E5%90%91)
10. [unicorn 的流程图](http://galaxylab.org/%E5%9F%BA%E4%BA%8E-unicorn-%E7%9A%84%E5%8D%95%E4%B8%AA%E5%87%BD%E6%95%B0%E6%A8%A1%E6%8B%9F%E6%89%A7%E8%A1%8C%E5%92%8C-fuzzer-%E5%AE%9E%E7%8E%B0/)
11. [https://o0xmuhe.github.io/2018/01/15/Unicorn-Engine%E5%88%9D%E4%BD%93%E9%AA%8C/]
13. pwn tools http://docs.pwntools.com/en/stable/