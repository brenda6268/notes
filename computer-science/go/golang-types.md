# 无标题

<!--
ID: 90bb91ba-48e7-4a05-b601-b40fee5692b8
Status: draft
Date: 2020-07-29T20:15:59
Modified: 2020-07-29T20:15:59
wp_id: 1125
-->

在 Go 语言中没有 private 和 public 这些关键字。如果变量名字是大写字母开头的，那么就是导出的，如果是小写字母开头的，那么就是包内私有的变量。

```
var i int
i = 42
```

或者直接使用简写：

```
i := 42
```

# 数据类型

Go 语言有四种类型：基础类型、聚合类型、引用类型和接口类型。

## 基础类型

整型包括了: int, int8/16/32/64, uint, uint8/16/32/64 几种类型。另外 byte 是 uint8 的别名，rune 是 int32 的别名。

比如定义了 size 函数，虽然返回的合法值都是 uint范围内的，但是可能使用 -1 等表示非法值。所以除非要使用比特位操作，尽量使用 int，而不是 uint。

浮点型也包括了：float32 和 float64 两种类型，注意没有单独的 float 类型。其中 math.MaxFloat32 和 math.MaxFloat64 表示最大值。默认的浮点数是 float64。

Go 中还包含了复数类型：complex64 和 complex128，不过就像 Python 中的复数类型一样，从来没用过。

Go 中的字符串，实际上是一个 byte 的只读数组，如果使用索引访问的话，是按照 byte 为单位来访问的。但是在打印和 range 的时候会直接按照 utf-8 解码输出。如果需要按照 rune（Go 语言对 unicode code point 的称呼）来访问，需要使用 unicode/utf8 这个包中的函数。

```
s := "世界"

len(s)  // -> 6
utf8.RuneCountInString(s)  // -> 2

// 使用 range 遍历
for r := range s {
    fmt.Printf("%s", r)
}

// 使用 DecodeRuneInString
for i := 0; i < len(s) {
    r, size := utf8.DecodeRuneInString(s[i:])
    fmt.Printf("%d\t%c\n", i, r)
}

// 全部转换成 rune
r := []rune(s)
fmt.Printf("%x\n", r)
```

即使字符串不是 utf-8的，或者不管怎样用错了编码，至少不会 panic，而是把不能解析的字符替换成 \uFFFD。而python中时不时就会抛出UnicodeDecodeError，非常蛋疼。

Go 语言中的字符串函数并没有作为 string 类型的方法，而是单独放在了 `strings` 包中，比如 `strings.Split`，`strings.Join` 函数。因为 `[]byte` 类型和 string 类型也比较类似，因此 `strings` 包中提供的方法，在 `bytes` 包中也可以找到类似的。

## 复合类型

### 数组

数组的类型是 `[x]type`，比如 `[1]int` 和 `[2]int` 是不同的类型

```
var a [3]int = [3]int{1, 2, 3}
b := [3]int{1, 2, 3}
c := [...]int{1,2,3}
d := [...]{99: -1}
```

如果数组的元素是可以比较的(comparable)，那么数组也是也以比较的，也就是可以用来做 map 的 key。

默认情况下，数组是按照值传递的，这一点和 C 语言默认传递指针不一样。

### 切片——变长数组

像是好多动态语言一样，Go 也支持切片操作：`a[i:j]`。不过和其他语言不一样的是，Go 的切片操作符产生了新的类型：切片，而不是数组。切片是对源数组的部分元素的一个引用。他们指向的是同一个内存单元。

切片可以当做一个变长数组使用，实际上我们不会每次都构造一个数组，然后获取切片，而是直接使用切片字面量。

```
a = []int{1, 2, 3}
```

和数组字面量很像，区别是没有指定长度。

和数组不同的一点是，切片是不能比较的，不管他内部的元素是什么。

Slice 底层引用了数组，但是并不会自动扩容，因此想往其中添加元素需要注意不能越界，提前扩充容量。可以使用 make 函数提前指定大小，或者使用 append 函数动态扩展切片大小。

```
make([]T, len)
make([]T, len, cap)
```
```
var x []int
x = append(x, 1)
```

### Map

Go 语言也原生支持字典。

```
a := make(map[string]int)
a := map[string]int {
    "alice": 12,
    "bob": 12,
}
```

Go 语言和其他语言不同的是，尝试访问不存在的键也不会报错，而是会返回对应类型的零值，不过可以采用两个参数来验证是否存在这个键

```
v := a["foo"]
v, ok := a["foo"]

if v, ok : a["foo"]; ok {
    fmt.Print(v)
}
```

向 nil 的 slice 中直接存入元素是不合法的，向 nil 的 map 中直接存入元素也是不合法的。所以最好使用 make 来声明map。

### Struct

定义一个 struct 如下：

```
type A struct {
    foo int
    bar int
}
```

Go 中也有指针的概念，不过没有 `->` 这个关键字，统一使用 `.` 操作。如果一个 struct 中的所有字段都是可以比较的，整个 struct 就也是可以比较的。

####  Struct 嵌入

Go 语言支持一种特殊的骚操作，叫做 struct 嵌入。这样一个 struct 就可以直接调用被嵌入的 struct 的属性和方法，听起来有点像继承，而且的确实现了继承的功能，但的确不是继承，而是复合。

### json

动态语言，比如 Python 和 JavaScript 会把 json 直接解析成数组和字典，而静态语言，比如 Java，则需要实现定义好和 Json 对象对应的类型，才能解析。Go 语言作为一种静态语言，自然也是需要定义对应的类型。

为了处理 Go 语言中的字段和 json 中的字段不对应的问题，Go 中可以使用 `json:"xxx"`
作为字段的 tag，来说明应该在 json 中使用什么字段。

```
import "encoding/json"

type Movie struct {
    Year int `json:"year"`
    Color bool `json:"color,omitempty"`
}

movies := []Movie {
    {
        Year: 1926,
        color: true,
    },
    {
        Year: 1027,
        Color: false,
    },
}

data, err := jso.Marshal(movies)
if err != nil {
    log.Fatalf("JSON marshaling failed: %s", err)
}
fmt.Printf("%s\n", data)
```

还可以使用 json.MarshalIndent 来格式化 json 字符串。


Go 语言是一门有 gc 的语言，所以所有变量的生命周期并不是严格限定于作用域的，由编译器来决定使用栈上还是堆上的空间。
