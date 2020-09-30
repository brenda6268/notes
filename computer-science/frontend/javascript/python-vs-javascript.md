# Python 和 JavaScript 语法对比

<!--
ID: 29f5d064-f64a-4e6a-8de7-e9ad3afe782d
Status: publish
Date: 2019-06-15T14:17:45
Modified: 2020-05-16T11:01:22
wp_id: 33
-->

## 命名

1. 注意使用驼峰变量名，不要使用下划线变量名

## 字符串

### 格式化

JavaScript:

```js
`hello ${name}`
```

Python:

```py
f"hello {name}"
```

## 文件

打开文件：

JavaScript：

```js
const fs = require(fs).promises;  // 使用 async/await 版本的 fs 模块

await fs.writeFile(filename, data);  // 写入文件

// 文件是否存在
try {
  await fs.stat(filename)
  exitst = true
} catch (e) {
  exists = false
}
```

Python:

```py
with open(filename, w) as f:
    f.write(data)

os.path.exists(filename)  # 文件是否存在
```

## 数组

切片：

JavaScript:

```js
const arr1 = arr2.slice(3, 5);
```

Python:

```py
arr1 = arr2[3:5]
```
