# EcmaScript 6

<!--
ID: f3763397-97e3-4389-ae8d-3808eb9d9633
Status: publish
Date: 2017-05-30T13:54:00
Modified: 2017-05-30T13:54:00
wp_id: 507
-->

## using es6 with babel

### debugging mode

```
<script src="node_modules/babel-core/browser.js"></script>
<script type="text/babel">
// Your ES6 code
</script>
```

### production mode

`babel script.js --out-file script-compiled.js`


## Yifei's Notes
the main impovements of ES6 are loops and generators, let/const, arrow functions, class syntax
small pieces are function arguments, destructuring

## Looping

there are 3 ways to loop a sequence in ES5, but there are problems

### ES5 Loops

// not concise
for (var index = 0; index < myArray.length; index++) {
    console.log(myArray[index]);
}

// no break or return
myArray.forEach(function (value) {
    console.log(value);
});

// for objects, not arrays
for (var index in myArray) {
    // don't actually do this
    console.log(myArray[index]);
}


### Introducing ES6 Loops

// concise and correct
for (let value of myArray) {
    console.log(value);
}

// also works on strings, sets and maps
for (let chr of "") {
    alert(chr);
}

// make a set from an array of words
 var uniqueWords = new Set(words);
for (let word of uniqueWords) {
  console.log(word);
}

for (var [key, value] of phoneBookMap) {
    console.log(key + "'s phone number is: " + value);
}


// you can even make it work with objects
// dump an object's own enumerable properties to the console
for (var key of Object.keys(someObject)) { console.log(key + ": " + someObject[key]); }


## Generator

Inside a generator-function, yield is a keyword, with syntax rather like return. The difference is that while a function (even a generator-function) can only return once, a generator-function can yield any number of times. The yield expression suspends execution of the generator so it can be resumed again later.

Generator functions are basically the pause-and-continue-able function. when you call a generator function, it returns an paused Generator object, which has a next() function, each time you call the next() function, a pair of yielded-value and status is returned.

In technical terms, each time a generator yields, its stack frame—the local variables, arguments, temporary values, and the current position of execution within the generator body—is removed from the stack. However, the Generator object keeps a reference to (or copy of) this stack frame, so that a later .next() call can reactivate it and continue execution.

function* fibs() {
  var a = 0;
  var b = 1;
  while (true) {
    yield a;
    [a, b] = [b, a + b];
  }
}


function* range(start, stop) { for (var i = start; i < stop; i++) yield i; }

// This should "ding" three times
for (var value of range(0, 3)) {
  alert("Ding! at floor #" + value);
}

This is possible because generators are iterators. All generators have a built-in implementation of .next() and [Symbol.iterator]().

## Template Strings

`Hello ${user.name}, welcome to our server for the ${times} times`

## Rest Parameters and Defaults

ES5 version

```
function containsAll(haystack) {
  for (var i = 1; i < arguments.length; i++) {
    var needle = arguments[i];
    if (haystack.indexOf(needle) === -1) {
      return false;
  }
}
return true;
}
```

ES6 version
```
function containsAll(haystack, ...needles) {
  for (var needle of needles) {
    if (haystack.indexOf(needle) === -1) {
      return false;
  }
}
return true;
}
```

ES6 supports default parameters, The default argument gets evaluated at call time, so unlike e.g. in Python, a new object is created each time the function is called.


## Class

ES6 support static method, supuer, getter/setter
you can even subclass builtin types

class Circle {
    constructor(radius) {
        this.radius = radius;
        Circle.circlesMade++;
    };

    static draw(circle, canvas) {
        // Canvas drawing code
    };

    static get circlesMade() {
        return !this._count ? 0 : this._count;
    };
    static set circlesMade(val) {
        this._count = val;
    };

    area() {
        return Math.pow(this.radius, 2) * Math.PI;
    };

    get radius() {
        return this._radius;
    };
    set radius(radius) {
        if (!Number.isInteger(radius))
            throw new Error("Circle radius must be an integer.");
        this._radius = radius;
    };
}



var [,,third] = ["foo", "bar", "baz"];
var [head, ...tail] = [1, 2, 3, 4];
console.log(tail);
// [2, 3, 4]


var robotA = { name: "Bender" };
var robotB = { name: "Flexo" };

var { name: nameA } = robotA;
var { name: nameB } = robotB;

console.log(nameA);
// "Bender"
console.log(nameB);
// "Flexo"

// this is a syntax sugar for variable and key share the same name
var { foo, bar } = { foo: "lorem", bar: "ipsum" };
console.log(foo);
// "lorem"
console.log(bar);
// "ipsum"

var [missing = true] = [];
console.log(missing);
// true

var { message: msg = "Something went wrong" } = {};
console.log(msg);
// "Something went wrong"

var { x = 3 } = {};
console.log(x);
// 3

// parameters
function removeBreakpoint({ url, line, column }) {
  // ...
}


// super works as expected, calling super constructor and access base properties

// you can even subclass builtin types


CommonJS

There is a special object called module.exports, when `require`ing, the value of module.exports is returned.

something like that...
var require = function(path) {
    // ...
    return module.exports;
};

ES6 export

use the export keyword

// lib.js
export function foo() {}
export class bar {}
// or
export {baz, foz};
export {foo as fart};

// use.js
import {foo, bar} from "lib.js";
import {foo as fart} from "lib.js"; // renaming
import {* as lib} from "lib.js"; // import everything and put in a object

ES6 import commonJS

most packages are written in commonJS, for using as ES6 modules:
import _ from "lodash" // which is
import {default as _} from "lodash" // which is
let _ = require("lodash");

you can also do module.exports in ES6
export default value;
