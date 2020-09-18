# Nextjs 教程

<!--
ID: 9b518166-0ded-4107-aca6-7174e2749ae0
Status: draft
Date: 2020-09-14T15:46:27
Modified: 2020-09-14T15:46:27
wp_id: 2028
-->

当我们要写一个稍微复杂的 React 应用的时候，就需要路由功能了，比较流行的路由是 react router. 这是一个很好的库，但是当我们已经用到路由的时候，下一步就该考虑如何做服务端渲染了，所以直接上 next.js 吧。

鉴于我已经使用 create-react-app 创建了 react 应用，需要手工安装一下 next.js

```
yarn add next
```

把 package.json 中的 scripts 替换掉

```
"scripts": {
  "dev": "next dev",
  "build": "next build",
  "start": "next start"
}
```

## 核心概念

next 的核心概念是页面，没啥可解释的吧。按照约定，放在 /pages 文件夹中的每一个组件都是一个页面，比较恶心的是每个组件需要使用 export default 导出。

当然，pages/index.js 对应的自然是首页了。

```jsx
function HomePage() {
  return <div>Welcome to Next.js!</div>
}

export default HomePage
```

然后就可以看到首页啦！啊啊啊

next.js 中，完全按照文件的物理路径来确定路由，比如如果你需要 `post/1` 这种路径，直接定义 `pages/post/[id].js`, 也是够直接了。

## 获取数据

在 nextjs 中，鼓励的方式是在服务端编译或者渲染的时候获取数据，而不是由客户端渲染数据。这里我们先不看 SSG 了，看现在最需要的 SSR.

在一个页面中，export 一个 async 函数 `getServerSideProps` 就可以实现获取服务端的数据。

```jsx
export async function getServerSideProps(context) {
  return {
    props: {}, // will be passed to the page component as props
  }
}
```

context 中比较重要的几个属性：

- params 路径中的参数，比如 {id: xxx}
- req/res 请求响应
- query query_string

在这个函数中，应该直接读取数据库或者外部 API.

除此之外，另一种方式自然是传统的在客户端获取数据了，可以使用 useSWR 库。

## 样式

next.js 中默认不让导入全局的 CSS, 所以你必须在 `pages/_app.js` 中导入全局的 css.

```jsx
import '../styles.css'

// This default export is required in a new `pages/_app.js` file.
export default function MyApp({ Component, pageProps }) {
  return <Component {...pageProps} />
}
```

对于每一个组件，把它们的样式文件放到 `[name].module.css` 中就好啦。然后需要导入

```jsx
import styles from 'Button.module.css';

export default function Button() {
  return <div className={styles.button}>Button</div>
}
```

另一种方式是使用 styled-jsx, 也就是把 CSS-in-JS 的方式, 我个人还是喜欢这种方式一些. 但是这种不好在 VSCode 中直接显示调色板.

```jsx
<style jsx>{`
  h1 {
    color: red;
  }
`}</style>


## 静态文件

也很简单，直接放到 `/public` 目录，然后就能在根路径访问了。

## 路由

使用 `[xxx]` 放在路径中作为参数就好了。

nextjs 中的链接是这样的：

```jsx
<Link href="/blog/[slug]" as={`/blog/${post.slug}`}>
    <a>{post.title}</a>
</Link>
```

## 外部接口



## 参考

1. https://haodong.io/render-client-side-only-component-in-next-js
2. https://github.com/vercel/next.js/blob/canary/examples/progressive-render/pages/index.js