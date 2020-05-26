# Go语言处理 CSV 文件


ID: 727
Status: publish
Date: 2018-07-15 04:59:00
Modified: 2020-05-16 11:18:58


在 Go 语言中可以使用 `encoding/csv` 包来处理 csv 文件。

csv 包中主要有两个 struct，Reader 和 Writer。Reader 从一个 io.Reader
中读取每一行的内容，同时提供了一些设置的选项。Writer 用来写入 csv 文件。

# Reader

```go
r := csv.NewReader(strings.NewReader(in))

for {
    record, err := r.Read()
    if err == io.EOF {
        break
    }
    if err != nil {
        log.Fatal(err)
    }

    fmt.Println(record)
}
```

函数签名 | 说明
---------|--------
`func NewReader(r io.Reader) *Reader`
`func (r *Reader) Read() (record []string, err error)` | 返回 []string 类型数据
`func (r *Reader) ReadAll() (records [][]string, err error)` | 直接返回所有数据

# Writer

```go
records := [][]string{
    {&quot;first_name&quot;, &quot;last_name&quot;, &quot;username&quot;},
    {&quot;Rob&quot;, &quot;Pike&quot;, &quot;rob&quot;},
    {&quot;Ken&quot;, &quot;Thompson&quot;, &quot;ken&quot;},
    {&quot;Robert&quot;, &quot;Griesemer&quot;, &quot;gri&quot;},
}

w := csv.NewWriter(os.Stdout)

for _, record := range records {
    if err := w.Write(record); err != nil {
        log.Fatalln(&quot;error writing record to csv:&quot;, err)
    }
}

// Write any buffered data to the underlying writer (standard output).
w.Flush()

if err := w.Error(); err != nil {
    log.Fatal(err)
}
```

函数签名 | 说明
---------|-------
`func NewWriter(w io.Writer) *Writer` |
`func (w *Writer) Error() error`
`func (w *Writer) Flush()`
`func (w *Writer) Write(record []string) error`
`func (w *Writer) WriteAll(records [][]string) error`