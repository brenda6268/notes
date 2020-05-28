# CSS 布局基础知识


wp_id: 761
Status: publish
Date: 2018-04-30 07:56:00
Modified: 2020-05-16 11:37:42


# 布局

网页的布局是面向文档流的，也就是每个元素默认都是从左到右，从上到下依次排列的。当然就像文章一样，有些元素比如标题默认就会另起一行，并且单独占据这一行。

所有的元素都分为三类：inline、inline-block、和 block。
 
其中 block 元素占据了一行的位置，即使他们的宽度不够一行，并且他们有自己的宽度和高度，比如 h1 元素。

inline-block 结合了 inline 和 block 元素的特性，首先他布局是 inline 的，也就是不会另起一行，但是又可以设定单独的高度和宽度。

`display: none` 将会完全不渲染该元素, `visibility: hidden` 会渲染这个元素，只是在该显式的地方留下空白

## 使用 inline-box 的布局

![](https://ws1.sinaimg.cn/large/006tKfTcly1fquqqp791hj30kr0i1gpe.jpg)

# 定位

CSS 中元素的定位有如下几种，可以使用 position 指定

方法 | 说明
----|----
static|默认的定位方法，指的是在文档中的位置是静态的
relative|relative to its static positions, if set(top, left, bottom, right)
fixed|fixed to the viewport, if set(top, left, bottom, right)
absolute|behaves like fixed, but relative to nearest non-static ancestor
float|floated element will become a block element, but it will not occupy one row

使用 float 的布局

![](https://ws3.sinaimg.cn/large/006tKfTcly1fsktnrsi5dj30kc0hp781.jpg)

### 后续元素没有占据指定空间

元素浮动之后，它后面的元素就会去占据它的位置，然而我们往往并不想影响到后面的元素，所以应该指定它后面的元素清除浮动。

not stretching parent element
floating elements will also not stretching the element containing it, to fix that, add overflow: auto to the parent element

# 盒模型

## 讨厌的 content-box 模型

width set width of the content, and 

* padding will push out the border... 
* background-color only set for content area
* entire width is for border

![](https://ws3.sinaimg.cn/large/006tKfTcly1fqurrspk7ej30ah09gq39.jpg)

## 符合直觉的 border-box 模型

as shown by the picture, border-box width sets the entire width, contains border + padding + content

如下图所示，border-box 模型设定的快读包含了 **border + padding + content**

![](https://ws4.sinaimg.cn/large/006tKfTcly1fqurs7z1chj30ge094wgg.jpg)

# responsive design

query device width

```
@media screen and (mid/max-width: xxxpx)
```

set viewport

```
<meta name="viewport" content="width=device-width/320, initial-scale=0.5, maximum-scale=1, minimum-scale=3, user-scalable=no" />
```

# 记录 CSS 的一个坑

## 在 td 元素上无法使用 width

可以通过指定： table-layout: fixed 解决

## centering

```
margin: 0 auto;
```

## css columns

```
column-count: x;
column-gap: xpx;
```

## 通过 js 获得最终 CSS 属性

https://developer.mozilla.org/zh-CN/docs/Web/API/Window/getComputedStyle


# reference

[1] http://learnlayout.com