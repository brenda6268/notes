# 放弃 Next.js, 拥抱 react-router

<!--
ID: 8e96fee6-d463-4ac5-a6b7-5f437fc0eea5
Status: publish
Date: 2020-10-27T22:38:05
Modified: 2020-10-27T22:38:05
wp_id: 2121
-->

Next.js 是一个好库，设计上很优雅，实现上也没有什么大的问题。然而，考虑再三我还是决定暂时移除 next.js 了。不是我不想要服务端渲染，而是整个 JS 的生态圈大部分的库都没有考虑服务端渲染，这就导致我在学习和使用的过程中时不时要自己考虑如何处理服务端渲染的情形。本身我就是个初学者，连教程都看不太懂，再考虑服务端渲染，就一个头两个大了。另外一个原因就是组里另一个项目使用了 react-router, 没必要两个都搞了。这里姑且记录下移除 next.js, 添加 react-router 的过程，以便以后参考。

## 删除 nextjs

```
yarn remove next
```

更改 package.json scripts 部分的脚本：

```json
"scripts": {
    "start": "react-scripts start",
    "dev": "react-scripts dev",
    "test": "react-scripts test",
    "eject": "react-scripts eject"
  },
```

还好之前 create-react-app 创建的 index.js 和 App.js 还没删掉，直接就能用了。

## 样式

nextjs 中规定了只能用 module css 或者 scoped css, 而在 react 中没有硬性的规定。如果使用原生 CSS 的话自然最简单，但是容易名字冲突。鉴于另一个项目使用了 sass, 这里也用 sass 以统一下开发体验。

## 页面

暂时先保留 pages, components, layouts 三个文件夹，但是需要使用 react-router 路由。

```
yarn add react-router react-router-dom
```

在 index.js 中使用 router, 去掉 `<App/>`

## Link

更改所有的 `Link`. 从 `import Link from 'next/link'` 改成 `import {Link} from 'react-router-dom'`, 其中需要把 `href` 改为 `to`.

更改所有的 useRouter 的跳转，需要使用 `useHistory`.

## 获取数据

页面里的 getServerSideProps 显然是不能用了，需要改用 redux 的 thunk 来获取数据，所以需要以下几步：

1. 设置对后端 API 的代理，在 package.json 中添加 `"proxy": "http://localhost:4000",` 即可
2. 引入 redux, 设计 store 等
3. 调整请求接口到 redux 中

一般来说，我们把相应的 getServerSideProps 函数的逻辑转移到对应的 Page 组件的 `useEffect(fn, [])` 钩子中就可以了。