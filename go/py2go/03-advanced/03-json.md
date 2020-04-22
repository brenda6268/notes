Go 语言是静态类型的，所以在 JSON 解析上和 Python 是完全不一样的，必须首先确定好对应的数据类型。如果和 JSON 中使用的字段不一致的话，需要使用注解来表明字段对应关系。

动态语言，比如 Python 和 JavaScript 会把 json 直接解析成数组和字典，而静态语言，比如 Java，则需要实现定义好和 Json 对象对应的类型，才能解析。Go 语言作为一种静态语言，自然也是需要定义对应的类型。
 
为了处理 Go 语言中的字段和 json 中的字段不对应的问题，Go 中可以使用 `json:"xxx"`
作为字段的 tag，来说明应该在 json 中使用什么字段。
 
```go
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

https://blog.golang.org/json-and-go
