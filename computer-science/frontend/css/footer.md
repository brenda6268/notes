# 如何实现一个正确的 Footer

<!--
ID: 82784d54-1659-42c4-ae88-8c0c07bf62e5
Status: draft
Date: 2020-09-23T11:12:23
Modified: 2020-09-23T11:12:23
wp_id: 2038
-->

没想到 StackOverflow 上竟然有解决不了的问题.

```htm
<!DOCTYPE html>

<html>
 <head>
   <link rel="stylesheet" type="text/css" href="main.css" />
 </head>

<body>
 <div id="page-container">
   <div id="content-wrap">
     <!-- all other page content -->
   </div>
   <footer id="footer"></footer>
 </div>
</body>

</html>
```

```css
#page-container {
  position: relative;
  min-height: 100vh;
}

#content-wrap {
  padding-bottom: 2.5rem;    /* Footer height */
}

#footer {
  position: absolute;
  bottom: 0;
  width: 100%;
  height: 2.5rem;            /* Footer height */
}
```

## 参考

1. https://www.freecodecamp.org/news/how-to-keep-your-footer-where-it-belongs-59c6aa05c59c/