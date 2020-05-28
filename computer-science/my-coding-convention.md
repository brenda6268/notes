# 我的编码规范


wp_id: 329
Status: publish
Date: 2017-08-05 03:29:00
Modified: 2020-05-16 11:47:42


# 指导思想

代码要做到[自文档化](http://jixianqianduan.com/article-translation/2016/06/22/ways-to-write-self-documenting-js.html)

# Python

* util模块使用util.py（单数形式），而不是utils.py，因为python标准库使用的是util
* 模块的命名：如果只有一个类，比如ItemProcessor，那么可以命名为item_processor.py，否则不能使用名词命名，使用描述性的短语『名词+动词』

## django

* 使用 queryset 的时候尽量使用 `.only()`，以减少对数据库的压力

# devops

* using mosh is recommended over plain ssh
* using tmux is recommended over screen
* all directories/repositories should use underscore NOT hyphen
* 应该使用json schema来验证json是否合规
* 每一个调用方都应该使用token或者caller来表明自己的身份，拒绝任何没有声明身份的服务。而生成token应该使用库来实现，而不是服务，以避免所有的服务都依赖token检测。

# coding

* 变量跨越的行数太多，否则不能看懂其中变量的用途，尽量是变量的生存周期短
* 函数不能写太多行（20行以内为宜，最多40行），不然读起来太费劲了，根本不知道是什么函数，如果太长，需要拆分
* 不要去变换API的签名，如果需要更改，做一个新的版本
* 如果没有很好的名字，使用ret作为返回值的名称
* 如果协议容易出现问题，那么在thrift中增加一个字version，每次校验是否是同一个版本
* variable names should use simple words if possible
* 不要起名字相同的函数
* 常量的定义，要把每个维度正交化，使用每个位来表示一个开关，或者几个位来表示一个组合


# 思维

* 如果在编码实现的过程中发现实际情况更加复杂，也不要直接改变思路，先实现原先想好的简单情况，在做拓展
* 类应该是 sans-IO的，如果需要IO，就写一些 load 函数，但是不要在构造函数中调用



Indent, spaces and newline
------

* use spaces around `+ - * / = ==`
* use spaces only after `,` `;`
* one blank line between functions and two between classes
* use `\n` as line endings
* end file with a new line
* always use 4 spaces to indent
* always use K&R braces

Naming and variables
------

* never use HN but prefix `is` for bool flags or methods e.g. `is_open`
* use CamelCase for class name
* use camelCase or snake_case for function, variable, method name, just be consistent
* declare local variable as late as possible
* use `nullptr` not `NULL`

Headers
------

* header file should use `*.hpp` NOT `*.h`
* always use #define guards 
* Reduce the number of #include files in header files. It will reduce build times. Instead, put include files in source code files and use forward declarations in header files. If a class in a header file does not need to know the size of a data member class or does not need to use the class's members then forward declare the class instead of including the file with #include. To avoid the need of a full class declaration, use references (or pointers) and forward declare the class. 

Namespaces
------

* never use `using namespace std`

其他
------

* put a space after `if` `for` `while` so that we know it's not invokation
* never use if (someVar == true) or if (someVar == false), it's silly

Documnetation and comments
------

* Documentations explain how to use code, and are for the users of your code
* Comments explain why, and are for the maintainers of your code
* use javadoc for documentations
* use `FIX` `BUG` `TODO` `???` `!!!` to show different kinds of comments


参考：

http://python.net/~goodger/projects/pycon/2007/idiomatic/handout.html
http://google-styleguide.googlecode.com/svn/trunk/cppguide.xml
https://developer.mozilla.org/en-US/docs/Mozilla/Developer_guide/Coding_Style
http://www.yolinux.com/TUTORIALS/LinuxTutorialC++CodingStyle.html
