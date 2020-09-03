# JavaScript 学习笔记

<!--
ID: c3f58e58-3ef5-4475-b558-92a9397b3b52
Status: publish
Date: 2017-05-30T07:53:00
Modified: 2020-05-16T12:00:32
wp_id: 500
-->

## Values

类型转换

Object to bool，全部转换为 True，包括 [] {}和 new Boolean(false)

to string 首先调用 toString()，如果没有然后调用 valueOf()

to number 首先调用 valueOf(), 如果没有然后调用 toString()

## Array

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


## ES5 functional array methods

they are both defined as Array.prototype.method and Array.method in firefox

### common pattern

array.method(function(value, index, array) {}, this) // second parameter is treated as this in the function

### using strings as arrays

Array.method.call(str, parameters)

## this

### normal function

in ES3 and ES5, this is window by default.
in ES5 strict mode, this is undefined.
in ES6 arrow function, this is inherited from outer function

### constructor function

```
function MyClass(x, y) {
    this.x = x;
    this.y = y;
}
```

`var m = new MyClass(3, 5);`

`this` is the new constructed object, But, if something is returned from the constructor, then the temporary object is thrown

```
function MyOtherClass(x, y) {
    return new MyClass(x, y);
}

var m = new MyOtherClass(x, y);
```

### method function

```
point.setX = function (x) {
    this.x = x;
}
```

`this` is the object

#### tricky closure

```
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

### call and apply

`func.call(obj, params...)` is equal to obj.func(params...)
`func.apply(obj, [params...])`
`func.bind(obj)` will return a function with `this` bound as obj to the function


call any method against null or undefined will result in TypeError
 
by default `this` for a function in strict mode is undefined
 
+ prefer both operands to be numbers, comparison prefers both operands to be strings
 
if a property is not found in a object, it's looked up in the prototype, if not, it's looked up
object created by new 's prototype is the constructor's prototype
object created by
 
 
# class
 
if two instances inherited from the same prototype, we say then are inherited from the same class. by default, the prototype is constructor's prototype
 
## subclassing
 
SubClass.prototype = Object.create(Base.prototype)
SubClass.prototype.constructor = SubClass
 
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
 
# Date
 
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
 
# Globals
 
encodeURI()
encode URI to %xx syntax
encodeURIComponent
encode every character including /?=+,#
decodeURI
 
decodeURIComponent
 
isFinite()
 
isNaN
 
parseInt
 
parseFloat
 
Infinity
 
 
 
# Math
 
Math.random() // -> random number between 0 and 1
 
Number
 
Number.MAX_VALUE, Number.MIN_VALUE, Number.NaN, Number.NEGATIVE_INFINITY, Number.POSITIVE_INFINITY
 
# String
 
String.charAt()
String.charCodeAt()
String.concat()
String.indexOf/lastIndexOf()
String.slice()
String.substr(start, length)
String.substring(from, to)
String.toLowerCase()/toUpperCase()
String.trim()
