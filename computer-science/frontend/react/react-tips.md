# React 小技巧

<!--
ID: dc95c9b9-ec45-4909-a1be-456599cdb77a
Status: draft
Date: 2020-10-09T10:57:43
Modified: 2020-10-09T10:57:43
wp_id: 2070
-->

## 添加到搜索路径 

把当前目录添加到搜索路径中：

.env 文件

```
NODE_PATH=src/
```

本来需要 `import x from ../../../components` 的，现在可以 `import x from components/xxx` 了

## useEffect 中使用 async function

```js
useEffect(fucntion() {
    (async function() {
        return await fetch();
    })();
}, [])
```

## JSX

使用循环：

```jsx
<tbody>
  {[...Array(10)].map((x, i) =>
    <ObjectRow key={i} />
  )}
</tbody>
```

## 参考

1. https://mp.weixin.qq.com/s?__biz=MzI1NDU3NzM5Mg==&mid=2247483990&idx=1&sn=59758dc47d1e6e6ccc2041761c554355
2. https://stackoverflow.com/questions/29755065/es6-import-from-root