# My Coding Style

<!--
ID: c975bf71-311f-4d2d-98fa-6c2cc22dbce7
Status: draft
Date: 2019-01-02T00:00:00
Modified: 2020-07-29T23:37:30
wp_id: 1627
-->

Python docstring

使用 Google 的 docstring 规范

django

* 在admin后台自定义属性的时候，函数要加一个下划线后缀，以便和模型的属性区分

注释

要写成一个句子，不能写成不完整的一个短语。

变量名

英文：使用简洁易懂的英文，不要使用复杂的。例子：使用 copycat， 不使用 Plagiarism

产品名：对于国内产品，使用拼音，不使用英文名。例子：使用 weixin，不使用 wechat。

公司名：使用英文，不使用中文。例子：使用 tencent，不使用 tengxun

数量一律使用 num_something 命名。布尔值使用 is_adj(形容词) 或者 done 表示

* never use HN but prefix `is` for bool flags or methods e.g. `is_open`
* declare local variable as late as possible
* use `nullptr` not `NULL`


流程控制

符合预期的异常必须捕获。未捕获的异常必须表示某种未知的错误。

Python

禁止在代码中修改 PYTHONPATH

禁止直接连接服务，必须使用连接池，连接使用完毕之后放回到连接池。

严禁使用 kwargs

代码管理

采用 Google 的分支管理方式，所有人在主分支上开发，有功能则切出来新分支，但是合并的时候必须压缩，发布切单独的分支出来。https://trunkbaseddevelopment.com/

每一行日志都应该有对应的监控。

服务连接尽量使用 dsn 方式，不然太麻烦了。

Headers
------

* header file should use `*.hpp` NOT `*.h`
* always use #define guards 
* Reduce the number of #include files in header files. It will reduce build times. Instead, put include files in source code files and use forward declarations in header files. If a class in a header file does not need to know the size of a data member class or does not need to use the class's members then forward declare the class instead of including the file with #include. To avoid the need of a full class declaration, use references (or pointers) and forward declare the class. 

Namespaces
------

* never use `using namespace std`

Others
------

* put a space after `if` `for` `while` so that we know it's not invokation
* never use if (someVar == true) or if (someVar == false), it's silly

Documnetation and comments
------

* Documentations explain how to use code, and are for the users of your code
* Comments explain why, and are for the maintainers of your code
* use javadoc for documentations
* use `FIX` `BUG` `TODO` `???` `!!!` to show different kinds of comments


# 参考

http://python.net/~goodger/projects/pycon/2007/idiomatic/handout.html
http://google-styleguide.googlecode.com/svn/trunk/cppguide.xml
https://developer.mozilla.org/en-US/docs/Mozilla/Developer_guide/Coding_Style
http://www.yolinux.com/TUTORIALS/LinuxTutorialC++CodingStyle.html
https://stackoverflow.com/questions/3898572/what-is-the-standard-python-docstring-format
https://nedbatchelder.com/blog/201401/comments_should_be_sentences.html

