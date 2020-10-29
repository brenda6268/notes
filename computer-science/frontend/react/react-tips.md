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

```
# .env 文件
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

## 何时获取数据

对于页面组件，直接在组件中使用 useEffect(fn, []) 加载数据就好了，对于需要动态增删的数据，使用 Redux 比较合适。

### 问题

- 在 useEffect 中获取数据之后触发 action, 还是通过触发一个 action 来获取数据。
- 页面跳转/组件卸载时，是否要删除上一个页面的数据
- 

## 参考

1. https://mp.weixin.qq.com/s?__biz=MzI1NDU3NzM5Mg==&mid=2247483990&idx=1&sn=59758dc47d1e6e6ccc2041761c554355
2. https://stackoverflow.com/questions/29755065/es6-import-from-root