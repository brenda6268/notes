# Nextjs 中遇到的一些坑

<!--
ID: 6e3a0606-da82-447d-aedf-1dad43b24fb9
Status: draft
Date: 2020-09-25T17:42:21
Modified: 2020-09-25T17:42:21
wp_id: 2042
-->

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



## 参考

1. https://levelup.gitconnected.com/improve-ux-of-your-next-js-app-in-3-minutes-with-page-loading-indicator-3a422113304d
2. https://github.com/vercel/next.js/discussions/14057
3. https://nextjs.org/docs/api-reference/next.config.js/rewrites