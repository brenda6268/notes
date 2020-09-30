# 不耐心程序员的 JavaScript 教程

<!--
ID: bc23d4ff-c8aa-4c0e-aa21-8b387d8a0d4d
Status: draft
Date: 2019-09-07T00:00:00
Modified: 2020-05-28T15:13:05
wp_id: 1189
-->

## 安装

本文以 Node.js **12** 为准，所以首先要安装或者升级 Node：

```bash
% brew install node
% node -v
v12.12.0
```

当然，在浏览器的 F12 控制台中也可以运行大多数的例子，但是关于模块方面就不能测试了。

## 语法

### Hello World

`console.log` 是最常用的打印语句。如果想要输出到 stderr 可以使用 `console.error`。

```javascript
console.log("hello, world");
```

console.log 还支持多个参数，也支持百分号格式化输出字符串

```javascript
console.log("hello, ", "world"); // -> hello, world
console.log("hello, %s", "world"); // -> hello, world
```

和 Python 等其他语言相比，除了 `%s` 和 `%d` 等之外，字符串格式化多了 `%o` 和 `%j` 参数，分别用于格式化输出对象和 JSON。

### 变量

和大多数语言一样， JavaScript 的变量是需要声明的，声明和复制可以是两个分开的步骤，不像 Python 中赋值就是声明。JavaScript 是弱类型的动态语言。

<small>
1. 其实 JavaScript 也是支持不使用 let 关键字的，但是这是上古时期的奇怪用法了，千万不要这么写，会有神奇的错误；
2. JavaScript 中还有一个 var 关键字，但是会有 hoisting 等等神奇的问题，现在也不推荐使用了。
</small>

之所以说 JS 是弱类型的语言，是因为 `1 == '1'` 或者 `'3'*'7'` 这种神奇的语法，不过实际项目中**绝对不要使用 `==`，而应该使用 `===`**。三个等号会比较类型，而不会自动转换类型。

注释和 C++ 和 Java 类似，采用 // 或者 `/**/`。

```javascript
// 声明并赋值一个变量
let foo = "bar";
// 声明并赋值一个常量
const foo = "bar";

// == 和 === 的区别
1 == "1" // true
0 == [] // true
1 === "1" // false
```

在 JavaScript 中，`$` 也是一个合法的变量名。尤其是浏览器中经常使用 `$` 作为变量名，不要把它理解为一个神奇的语法。

### 坑爹的 null 和 undefined

正常的语言一般都只有一个值表示没有值，不管是 None，还是 nil，还是 null。但是，在 JavaScript 中，有两个值来表示没有值，分别是 null 和 undefined。语义上来说，null 表示主动设定的不存在，undefined 表示被动不存在，尚未初始化。两个的具体区别后面还会说到。

```javascript
null == undefined; // true
null === undefined; // False

// 出现 undefined 的地方

let foo;  // 未初始化的变量
foo === undefined; // true

function func1(x) { return x };
func1() === undefined; // undefined，未传递的参数（在 JS 里不是语法错误）

obj = {}
obj.foo === undefined;  // 未定义的属性

function func2() {};
func2() === undefined; // 没有 return 语句的函数

// 出现 null 的地方

/a/.exec('x') === null; // 正则表达式
JSON.stringify({a: undefined, b: null}); // '{"b":null}', JSON 只支持 null
```

null 和 undefined 还不能获取任何属性，会抛出异常，这也是比较坑爹的地方。其他的所有值如果属性不存在都会返回 undefined。

```javascript
> null.a
Thrown:
TypeError: Cannot read property 'a' of null
> undefined.a
Thrown:
TypeError: Cannot read property 'a' of undefined
> true.a
undefined
```

## 布尔型

布尔值是 true 和 false，而不是 True 和 False。如果需要把一个值转换为布尔值，可以使用 Boolean(x)，传统方法是 `!!x`，新的代码千万不要这么写了，可读性太差。

### falsy value

在 Python 中，0, "", [], {} 等一切空的内置类型都是 falsy 的，而在 JS 中，所有对象都是真的，而 [] 也是一种对象，也就是说：[] 和 {} 都是真的。当然，0 和 "" 还是假的。另外：

- Boolean({}) 返回 true，因为所有的对象都是 true
- Boolean([]) 返回 true，因为数组也是一个对象

```javascript
Boolean(1) === true;
Boolean(0) === false;
Boolean(NaN) === false;
Boolean({}) === true;
Boolean([]) === true;
Boolean("") === false;
Boolean("false") === true; // 只要不是空字符串，都是 true
```

关于数组和对象，后面还会讲到。

## 数字和数学运算

JavaScript 中只有一个数字—— IEEE754 浮点数，**没有整数**。因为 JS 只有浮点数一种类型，根据 IEEE754 的规范，只有 52 位用来表示整数，所以在 JS 中对于大整数是没法完整表示的，这是前后端传递大整数时候的一大坑，一般情况下是后端把大整数转换为字符串传递个前端。

```javascript
98 === 98.0; // true
0b11 === 3; // true
0o11 === 9; // True
0xe7 === 231;

1 / 0 === Infinity; // 没有抛出异常，这点非常值得称赞，比其他语言都好
```

正无穷是 Infinity，负无穷是 -Infinity，NaN 就是 NaN。

四则运算就不赘述了，和其他语言里一样，没有什么坑的地方。JS 还支持 C 语言中的 ++ 和 -- 运算符。

尽量使用内置的 Number(x) 来装换成数字，传统方法是使用 +x 或者 parseInt/parseFloat。注意 Number(undefined) 是 NaN，但是 Number(null) 是 0。对于对象来说，是取 valueOf 成员函数的值，这个后面再讲。

- to string 首先调用 toString()，如果没有然后调用 valueOf()
- to number 首先调用 valueOf(), 如果没有然后调用 toString()

```javascript
Number(123) === 123;  // -> true
Number("123") === 123;  // -> true
Number(undefined); // -> NaN
Number(null) === 0; // -> True
Number("aaa"); // -> NaN
```

数字也是有方法的：Number.toString()。 但是 7.toString() 在语法上是不合法的，你可以写成 (7).toString()。

### 数学运算

JavaScript 内置了 Number 和 Math 对象。在这两个对象中提供了一些常用的操作。

```javascript
Number.EPSILON;  // epsilon，一个极小值
Number.MAX_VALUE;  // 最大值
Number.MIN_VALUE;  // 最小的正数，注意这个是个正数
Number.NaN
Number.NEGATIVE_INFINITY
Number.POSITIVE_INFINITY

> Number.isFinite(Infinity)
false
> Number.isFinite(-Infinity)
false
> Number.isFinite(NaN)
false
> Number.isFinite(123)
true

> Number.isInteger(-17)
true
> Number.isInteger(33)
true
> Number.isInteger(33.1)
false

> Number.isNaN(NaN)
true
> Number.isNaN(123)
false
> Number.isNaN('abc')
false

// 建议直接使用 Number，而不要使用 parseFloat，以免隐藏一些错误。
> Number.parseFloat(' 123.4#')
123.4
> Number(' 123.4#')
NaN

// Math 模块

Math.E; // 自然对数的底
Math.PI; // 圆周率
Math.SQRT2; // 根号 2

Math.log; // 自然对数
Math.log10;
Math.log2;
Math.sqrt; // 平方根

Math.ceil
Math.floor
Math.round
Math.trunc
Math.acos
Math.asin
Math.sin
Math.cos

Math.abs
Math.max(1, 2, 3) === 3;
Math.min(1, 2, 3) === 1;
Math.random();  // 0-1 之间的一个随机数
```

<small>
由于历史原因，JavaScript 提供了一些全局函数：isFinite, isNaN, parseFloat 和 parseInt。不过不推荐使用了，最好使用 Number 中的同名方法。
</small>

## 字符串

我们知道字符串这个东西还是比较复杂的，为了保证全世界都不乱码，我们现在都尽量使用 Unicode 字符集。Unicode 字符集中的每一个字符都使用一个数字来表示，我们称之为 code point。现在 Unicode 已经有上百万个字符了。在 Unicode 的前 128 个字符是和 ASCII 一致的，也就是 Unicode 其实是 ASCII 的一个超集。

我们知道最多需要使用一个 uint32 才能够存储一个 code point，那么如何使用字节表示一个 code point 又分成了 utf-8/16/32 这三种方式。

1. utf-32，直接使用 4 byte 来保存一个 code point，是一种定长编码。好处是不需要转换，缺点是浪费空间，和 ASCII 不兼容；
2. utf-16，这种方式比较奇葩，既不是很省空间，也不是定长的，又和 ASCII 不兼容。为啥要这样搞呢？因为最开始的时候人们以为 65536 就足够了，直到他们想起来了中文；
3. utf-8，边长编码，好处是和 ASCII 完全兼容，省空间，确定是需要和 code point 之间做个映射。

其中 utf-8 的编码非常精妙，建议大家有空研究下。因为 utf-8 实现得如此优雅又有很哈的兼容性，所以已经是现在的事实标准了。

一般语言中都会有两种类型，unicode 和 bytes。第一个可以理解为 code point 的只读数组，后一个可以理解为 utf-8 字节的只读数组。然后具体 str 类型是哪种就看不同语言的取舍了。举两个例子：

1. Python 中 str 类型是 unicode code point 的数组，所以 len(s) 返回的永远是有多少个字符；
2. Golang 中 str 类型是 bytes，所以 len(s) 返回的是 s 中字节的长度。

<small>实际上这里还没有提到源代码的默认编码，不过这个一般都是 utf-8。</small>

好了，回到 JS，不出所料，他肯定是选择了最奇葩的一种方式：utf-16。在 JavaScript 中，字符串是 utf-16 编码的只读数组。

```JavaScript
> const foo = "bar";
> foo.length
2
> const smiley = '🙂';  // 表情符号一般需要用两个 utf-16 code units
> smiley.length
2
> smiley === '\uD83D\uDE42' // code units
true
```

<small>实际上现在更混乱的来了，有了 unicode 连字符以后，看起来是一个表情的东西也可能是好几个字符</small>

抛开编码方式来说，JavaScript 的字符串还是比较好用的，常见用法参考下面：

```javascript
const str = 'abc';
str[0] == 'a';

str.length === 3; // true
"hello" + "world" == "helloworld"; // true

// String 是内置的对象
String(undefined) === "undefined";
String(null) === "null";
String(true) === "true";
String(123.45) === "123.45";

// 当然，奇葩的来了
String({}) == '[object Object]';
String([1,2]) == '1,2';  // 这个还可以。

// 素质三连
> String([true])
'true'
> String(['true'])
'true'
> String(true)
'true'

String.charAt()
String.charCodeAt()
String.concat()
String.indexOf/lastIndexOf()
String.slice()
String.substr(start, length)
String.substring(from, to)
String.toLowerCase()/toUpperCase()
String.trim()

str.startsWith();
str.endsWith();
str.includes();
str.indexOf(s);
str.match(regexp);
str.search(regexp);
str.replace(s|regexp);
str.slice(start, end);
str.split(s|regex); // 这里又有奇葩，会把 emoji 拆成两个 utf-16 字符
str.padStart(s);  // 这个函数替代了 leftpad，leftpad 曾经引起了 JS 界的一场腥风血雨
str.padEnd(s);
str.repeat(n);  // 因为 * 会尝试转换为数字，所以要想重复字符串只能用这个。
str.normalize(format);  // 这个还挺重要的，但是涉及到 unicode 的一些知识，这里说不清楚
str.toUpperCase();
str.toLowerCase();
str.trim();
str.trimStart();
str.trimEnd();
```

### using strings as arrays

Array.method.call(str, parameters)

### 字符串插值

除了使用单引号和双引号表示字符串以外，还可以使用反引号 `\``。在反引号字符串中，可以使用插值。

```javascript
let a = "world";
console.log(`hello, ${a}`)
```

## 符号类型

在现代 JavaScript 中新增了一种类型：Symbol（符号）。限于篇幅，这里不讲了。


## 原始类型与复合类型

![JavaScript 对象体系](https://exploringjs.com/impatient-js/img-book/b8c834a3420a3b2d2df0d90dfa0c1dfd1f2ffbc9.svg)

- 原始类型有：undefined, null, boolean, number, string, symbol
- 所有其他类型都是 object，包括 array, function, 和用户自定义的类

两者的主要区别是：

- 原始类型按值传递，并且按值比较
- object 类型按引用传递，比较的是指针，也就是内存地址，或者说是不是同一个对象。

## 数组

JavaScript 中也有数组，和 Python 的语法可以说基本完全一样。在 JS 中，还有 typed array，也就是指定了类型的数组，限于篇幅，这里不展开了。另外，在 JavaScript 中，也没有额外的 tuple、slice 等类型。

```javascript
let a = [1, 2, 3];
let b = [1, "", 0.7];
```

## ES5 functional array methods

they are both defined as Array.prototype.method and Array.method in firefox

### common pattern

array.method(function(value, index, array) {}, this) // second parameter is treated as this in the function

数组的方法：

```javascript
let a = [1, 2, 3];
a.length; // -> 3
a.push(4); // push 支持多个元素
a.pop(); // -> 4
a.unshift(0); // 在前边插入
a.shift(); // 从前面删除
a.length = 1; // 通过赋值删除元素
[1, 2, 3].keys(); // 返回索引，也就是 0, 1, 2
[1, 2, 3].values();
[1, 2, 3].entries(); // 返回索引和值对应的二元组 [[0, 1], [1, 2], [2, 3]]

Array.isArray([1, 2, 3]); // 判断是否是数组，为什么不用 a instanceof Array 呢？因为有时候会出错，原因比较复杂，这里不展开了。

['c', 'b', 'a'].sort();  // 正常排序
[1, 13, 123].sort(); // 排序结果竟然是 [1, 123, 13]。WTF，原来 JS 默认是按照字典序排序的。如何修正在讲完函数后再说。

// 创建数组的其他方法
let a = new Array(3); // 这两行是等价的。又是个坑
let a = Array(3);  // 虽然一般情况下我们都使用 []，这种方式方便创建空数组
a.fill(0); // 把所有值初始化为 0
Array.of(1, 2, 3);

// 其他一些方法
a.reverse(); // 翻转数组
a.concat(); // 和另一个数组组合，其实相当于.push(...b)
a.join(","); // 组合成字符串
a.indexOf(e); //
a.includes(e); //
```

强大的函数式方法 map, every, filter 等在后面讲完函数后再提到。

```
Array.join()
Array.reverse()
Array.sort([func])  // function cmp(a, b) {return a - b;}, implace
Array.concat(val or array)  // combination of python append and extend, will not recursively smash array, return new
Array.slice(a, b)  // allow negative
Array.splice(a, b, replacements...)  // both a and b are inclusive
push/pop
unshift/shift
indexOf/lastIndexOf  // return the first find index or -1 if not found
forEach	 // no way to good stop the iteration
map	 // return a new array
filter	 //return the selected elements
every/some	// return true or false, return immediately after the result is dicided
reduce	//reduce(function(a, b) {}, initial_value), when not supplied, the first element is used as initial value on empty array, no initial value will throw error
```

### 展开操作符和解构

和 Python 中的 `args` 语法类似，JavaScript 中也有展开操作符 `...`。

```javascript

let a = ['a', 'b'];
let b = [...a, 'c', 'd', 'e']; // a, b, c, d, e
```

类似于 Python 中的 a, b = b, a，JS 中也有同样的结构语法。

```javascript
let [a, b] = [1, 2];
console.log(a); // 1
console.log(b); // 2
```

### 转换成数组

在浏览器环境中，还存在着许多类似数组，但是又不是数组的对象，比如 NodeList 等。可以使用 `...` 或者是 `Arrar.from` 来转换：

```javascript
// 这几行代码需要在浏览器中执行
let elements = document.getElementsByTagName("a");
let a = Array.from(elements);
// or
let a = [...elements]
```

<small>JavaScript 中的数组中间是可以有洞的，千万不要手动制造这样的数组，他们的行为非常怪异。</small>

## 坑爹的 typeof 和 instanceof 运算

typeof 运算符用来获得变量的类型，instanceof 运算符用来获得是否是某个类的实例。然而由于历史原因，JS 的 typeof 运算符的结果很奇葩。对于这两个运算符的使用原则是：对于原始类型可以使用 typeof，对于 object 类型使用 instanceof 判断。

```javascript
console.log(typeof undefined); // -> 'undefined'
console.log(typeof null);  // -> 'object'  WTF!
console.log(typeof true);  // -> 'boolean'
console.log(typeof 1);  // -> 'number'
console.log(typeof Symbol()); // -> 'symbol'
console.log(typeof function(){}); // -> 'function'
console.log(typeof 'abc'); // -> 'string'
console.log(typeof {}); // -> 'object'
console.log(typeof []); // -> 'object'  WTF!
```

这里有两个设计错误，typeof null 不应该是 'object'，typeof function(){} 也是 object，但是又有自己独立的类型，但是 array 又没有。

instanceof 的设计是没有问题的，可以判断是否是某个类的对象。

```javascript
// Function/Object/Array 是内置的类
function(){} instanceof Function; // -> true
({}) instanceof Object; // -> true
[] instanceof Array; // -> true
123 instanceof Number； // -> false
new Number(123) instanceof Number;  // -> true
class A {}
new A() instanceof A;  // -> true
```

## 作用域

在 JavaScript 中，作用域规则和 C/C++ 一致，每个块就是一个作用域。每个 `{}` 生成一个块。如果声明一个和上级作用域同名的变量，会遮盖上一级作用域中的变量。如果直接访问，那么使用的就是上一级作用域的变量。

<small>使用 var 创造的变量拥有函数作用域，千万不要使用</small>

```javascript
{ // // Scope A. Accessible: x
  let x = 0;
  let y = 0;
  { // Scope B. Accessible: x, y
    x = 1;  // 这里引用的是上级变量
    let y = 1;  // 声明了一个新变量，仅在当前作用域中有效
    console.log(x);  // -> 1
    console.log(y);  // -> 1
  }
  console.log(x, y);  // 这里的 x 已经被改掉了
  // -> 1 0
}
```

## 全局对象

在 JS 中，除了全局变量之外，还有一些内置的全局对象，他们都可以理解为特殊的全局对象`globalThis`的一个属性（你没看错，就是这么奇葩的名字）。在浏览器中，这个属性也叫做 `window`。在 Node 环境中，这个变量也叫做 `global`。不过现在最新的 JS 标注统一了这个变量。当然这个全局变量是递归定义的， `globalThis.globalThis` 就是自身。使用`globalThis`访问内置全局变量可能会引起性能问题，因此强烈建议不要使用这个对象。

```javascript
window.encodeURIComponent(str); // no
encodeURIComponent(str); // yes
```

### 其他一些 Globals
 
encodeURI() // encode URI to %xx syntax
encodeURIComponent // encode every character including /?=+,#
decodeURI
decodeURIComponent
Infinity

<small> 在上古 JS 中，普通函数的 this 确实是指向 window 对象的，所以 globalThis 这个变量名是有历史传承的 </small>

需要注意的是，使用 let/const 自定义的全局变量并不是 globalThis 的属性。

```javascript
let a = "foo";
console.log(globalThis.a);  // -> undefined
```

<small>
使用 var 定义的全局变量又是 globalThis 的属性，这也是为什么不用 var 的原因

```javascript
var a = "foo";
console.log(globalThis.a);  // 'foo'
```
</small>

注释和 C++ 和 Java 类似，采用 // 或者 `/**/`。

## 条件语句

基本的流程控制，和 C 系的语言比较类似，需要小括号和大括号。

```javascript
if (x < 0) { // is x less than zero?
  console.log("positive");
} else {
  console.log("negative");
}
```

## 数组和循环

要遍历一个数组可以使用两种风格，C 系和 Python 系风格：

```javascript
let a = [1, 2, 3];
for (let i = 0; i < a.length; i ++) {
    console.log(a);
}

// 注意这里是 for..of，不是 for..in
for (const e of a) {
    console.log(e);
}

for (const [index, element] of ['a', 'b'].entries()) {
  console.log(index, element);
}
// Output:
// 0, 'a'
// 1, 'b'
```

<small>JavaScript 中曾经有 for..in 循环，但是因为比较坑爹，所以换成了 for..of 循环</small>

### for-of 和字符串

JavaScript 中最常用作字典的对象就叫做 Object，完全可以和 Python 中的字典一样使用，语法也基本一致。不过之所以不叫做字典，而是叫做对象，是因为他确实是一个对象，而不只是字典。可以直接定义函数属性，并且调用。在方法中，this 指向的就是对象本身。

```javascript
let a = {"foo": "bar"};

const obj = {
  first: 'Jane', // property
  last: 'Doe', // property
  getFullName() { // property (method)
    return this.first + ' ' + this.last;
  },
};
obj.getFullName()  // -> Jane Doe
obj.first  // -> Jane
```

需要注意的是，JavaScript 中最好每行结尾都写上分号，以避免一些潜在的问题。限于本文篇幅，这里就不展开讲了，都加上就对了。

函数也是一种对象，也可以直接赋值给变量。

```javascript
function add1(a, b) {
  return a + b;
}

const add2 = (a, b) => { return a + b };

const add3 = (a, b) => a + b;
```

## 字符串

JS 源码本身是用 UTF-16 表示的，因为在当时觉得 UTF-16 就够了。字符串的长度是 bytes 数组的长度。但是用 for-of 循环是用 Unicode code point 循环的。

最好调用 String 转化为字符串，因为 undefined 和 null 没有 toString 方法。

# symbol

symbol 纯属多余，在 Python 中，字符串默认就会 internize，也就是说 symbol 是隐式的。

不过在 js 中，TC39 认为使用 magic method 是不好的，所以他们的 magic method 都是用 symbol 定义的。

array.entries 相当于 enumerate

# 函数

函数也是一种对象，也可以直接赋值给变量。

```js
function add1(a, b) {
  return a + b;
}

const add2 = (a, b) => { return a + b };

const add3 = (a, b) => a + b;
```

## this

### normal function

in ES3 and ES5, this is window by default.
in ES5 strict mode, this is undefined.
in ES6 arrow function, this is inherited from outer function

### call and apply

`func.call(obj, params...)` is equal to obj.func(params...)
`func.apply(obj, [params...])`
`func.bind(obj)` will return a function with `this` bound as obj to the function


call any method against null or undefined will result in TypeError
 
by default `this` for a function in strict mode is undefined
 
+ prefer both operands to be numbers, comparison prefers both operands to be strings
 
if a property is not found in a object, it's looked up in the prototype, if not, it's looked up object created by new 's prototype is the constructor's prototype object created by

#### tricky closure

```js
function constfuncs() {
    var funcs = [];
    for (var i = 0; i < 10; i++) {
        funcs[i] = function() {return i;} // they refers to only one i in the closure, which is 10 in the end
    }
    return funcs;
}

var funcs = constfuncs();
funcs[5]() // returns 10,
```

## 模块和包

和其他所有语言不一样的是，JS 中多了一个选项叫做 default import, 不要使用 default import, 因为这是一个非常迷惑的 feature。

在 JS 中，必须显示 export 出的对象才能够被别的包引入，普通的 import 必须指定名字。

```js
export function f() {}
export const one = 1;
export {foo, b as bar};

// other files
import {foo, bar as b} from "./some-module.js";
import * as mod from "./some-module.js";
```

### default import

直接使用，不需要使用大括号命名

```js
export default function () {}

import obj from "./some-module.js";
```

非常迷惑的是，竟然还可以混用普通 import 和 default import

```js
export function f() {}
export default function () {}

import someVar * as someModule from "./some-lib.js";
```

其中的模块路径相对于当前文件而言。

## 日期对象

## Constructs
 
new Data();
new Date(milliseconds);
new Data(datestring);
new Data(y, m, d, h, m, s, ms);
 
## methods
 
date.toString() return  a time string
date.valueOf() returns timestamp
Date.now() returns current timestamp
Date.parse() returns a timestamp
Date.UTC(y, m, d, h, m, s, ms) returns utc timestamp
 
 
# Regular Expression
 
syntax: /regexp/modifier
 
Modifiers:
 
i
ignore case
g
global, if not sepcified, return only one match
m
multiline
 
String expression methods:
 
String.search(pattern)
return first matched index or -1
String.replace(pattern, replacement)
back reference is used as $n, replacement can be a function
String.match(pattern)
return an array of matched groups, [0] is the whole match, [n] being each group
String.split(pattern)
return a splited elements
 
Regexp methods:
 
regexp.exec(String)
equals to String.match(regexp)
regexp.test(String)
true or false
regexp.exec(String) can be called multitimes for a string when regexp is not global mode. Each returns the
 

# Reference

1. https://exploringjs.com/impatient-js/toc.html
2. Philip Roberts: Help, I'm stuck in an event-loop.
3. https://developer.mozilla.org/en-US/docs/Web/API/HTML_DOM_API
4. https://developer.mozilla.org/en-US/docs/Web/API/Window
5. https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects
