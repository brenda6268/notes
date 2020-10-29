# Nextjs 中遇到的一些坑

<!--
ID: 6e3a0606-da82-447d-aedf-1dad43b24fb9
Status: publish
Date: 2020-09-25T17:42:21
Modified: 2020-09-25T17:42:21
wp_id: 2042
-->

## nextjs 的 Link 无法自定义 escape

nextjs 中的 Link 的 href 对象如果传的是字典，直接调用的是 nodejs 的 URL 库，不能自定义 escape, 比如说空格会被强制格式化成加好，而不是 %20. 而且好像它使用的这个 API 在 11.0 已经 deprecated 了，所以需要啥 url 的话，还是自己格式化吧~

## 不支持 loading spinner

Nextjs 不支持在页面跳转的时候触发 Loading Spinner, 也就是转动的小圆圈，所以需要自己实现一下，可以用 nprogress

在 _app.js 中：

```jsx
import Router from 'next/router';
import NProgress from 'nprogress'; //nprogress module
import 'nprogress/nprogress.css'; //styles of nprogress

//Binding events. 
Router.events.on('routeChangeStart', () => NProgress.start());
Router.events.on('routeChangeComplete', () => NProgress.done());
Router.events.on('routeChangeError', () => NProgress.done());

function MyApp({ Component, pageProps }) {
    return <Component {...pageProps} />
}
export default MyApp;
```

## 代理后端 API 服务器

在 next.config.js 中配置重定向：

```js
module.exports = {
  async rewrites() {
    return [
      {
        source: '/api/proxy/:path*',
        destination: `${process.env.NEXT_PUBLIC_API_URL}/:path*`,
      },
    ]
  },
}
```

## 参考

1. https://levelup.gitconnected.com/improve-ux-of-your-next-js-app-in-3-minutes-with-page-loading-indicator-3a422113304d
2. https://github.com/vercel/next.js/discussions/14057
3. https://nextjs.org/docs/api-reference/next.config.js/rewrites