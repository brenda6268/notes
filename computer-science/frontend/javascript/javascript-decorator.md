# JavaScript 中的装饰器 (decorator)

<!--
ID: 436edb6d-bfe6-48da-932e-21164631a106
Status: draft
Date: 2019-12-17T10:46:38
Modified: 2020-05-16T10:46:07
wp_id: 840
-->

JavaScript 的语法在这两年补了不少课，终于变得让你写起来不那么咬牙切齿了。Decorator 是 TC39 最近从 Python 中偷师的一种语法，可以说几乎就是完全拷贝了 Python 的语法。

本文假设你已经熟练掌握了装饰器模式和 Python 中的装饰器语法糖。

Decorator 其实很简单，就是一个高阶函数，给指定的函数添加了额外的功能，做了一层封装。也就是：

```javascript
fn = deco(fn);
```

# 没有语法糖的装饰器

直接上代码吧：

```javascript
// 原函数
function hello(name) {
    console.log("hello %s", name);
}

// 装饰器函数
function addLogging(fn) {
    return function(...args) {
        console.log("starting...");
        let result = fn(...args);
        console.log("ending...");
        return result;
    }
}

// 使用装饰器装饰函数
let hello = addLogging(hello);
```

下面我们来调用一下这个函数：

```javascript
hello("js");
// starting...
// hello js
// ending...
```

# 使用语法糖

在 JS 的新的提案中，增加了类似 Python 的语法支持 `@`。
