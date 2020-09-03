# Bootstrap Basics

<!--
ID: a4ea0b4e-6963-483f-9196-542c4398b0a2
Status: publish
Date: 2017-06-07T07:04:00
Modified: 2017-06-07T07:04:00
wp_id: 762
-->

BootStrap 适合做什么
======

Bootstrap 适合做没有界面设计，只有功能或者草图，直接通过代码快速的生成一个可用的界面

Bootstrap 不适合

1. 已经有了良好的界面设计，包含了各种细节
2. 在已有的非 Bootstrap 的界面上进行改动的时候


# headers
add this to headers `<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">`

# grid system

## container
`container` class should be added to the root element where you would like to use bootstrap.

`container-fluid` is for full-width container.

## row

from the official documentation:

> * Content should be placed within columns, and only columns may be immediate children of rows.
> * Columns create gutters (gaps between column content) via **padding**. That padding is offset in rows for the first and last column via negative margin on `.rows`.
> * Grid classes apply to devices with screen widths greater than or equal to the breakpoint sizes, and override grid classes targeted at smaller devices. grid classes are `col-xs-*`, `col-sm-*`, `col-md-*`, `col-lg-*`.

|             | phone | tablet | desktop | large desktop|
|-------------|-------|--------|---------|--------------|
|Container width | None (auto) |750px |970px |1170px|
|Class prefix	|`.col-xs-`	|`.col-sm-`	|`.col-md-`	|`.col-lg-`|

The gutter width for bootstrap is `15px` for each column, `30px` between.

generally, you should use the `col-sm-N` family of classes. such that it applies for all devices except phones.

use `col-xs-offset-*` classes to offset the columns.

use `col-xs-pull-*` classes to pull column to left, and `push` to push to right.

# 安装

引入 CSS 和 JS 就好啦，不过限于国内的网络条件，可能做好还是下载到自己服务器吧。

```
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">

<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
```


# starter template

```
<!doctype html>
<html lang="en">
  <head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
<title>Hello, world!</title>
  </head>
  <body>
    <h1>Hello, world!</h1>
<!-- Optional JavaScript -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
  </body>
</html>

```
bootstrap 默认已经采用了 border-box 模式。如果需要使用 content-box 需要自己指定。
