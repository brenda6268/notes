# 使用 React-Bootstrap

<!--
ID: a4ea0b4e-6963-483f-9196-542c4398b0a2
Status: publish
Date: 2017-06-07T07:04:00
Modified: 2017-06-07T07:04:00
wp_id: 762
-->

## BootStrap 适合做什么

Bootstrap 适合做没有界面设计，只有功能或者草图，直接通过代码快速的生成一个可用的界面

Bootstrap 不适合:

1. 已经有了良好的界面设计，包含了各种细节
2. 在已有的非 Bootstrap 的界面上进行改动的时候

## 居中

- 文本居中可以使用 `.text-center` 属性.
- Col 居中可以使用 `{offset: 2, span: 8}` 这种形式.
- 块级元素可以采用 `.block-center` 属性.
- 不过还是设定 width, 然后 `margin: 0 auto` 更实用一点.


# grid system

## container

`container` class should be added to the root element where you would like to use bootstrap.

`container-fluid` is for full-width container.

## row

from the official documentation:

> * Content should be placed within columns, and only columns may be immediate children of rows.
> * Columns create gutters (gaps between column content) via **padding**. That padding is offset in rows for the first and last column via negative margin on `.rows`.
> * Grid classes apply to devices with screen widths greater than or equal to the breakpoint sizes, and override grid classes targeted at smaller devices. grid classes are `col-xs-*`, `col-sm-*`, `col-md-*`, `col-lg-*`.

|                 | phone       | tablet     | desktop    | large desktop |
| --------------- | ----------- | ---------- | ---------- | ------------- |
| Container width | None (auto) | 750px      | 970px      | 1170px        |
| Class prefix    | `.col-xs-`  | `.col-sm-` | `.col-md-` | `.col-lg-`    |

The gutter width for bootstrap is `15px` for each column, `30px` between.

generally, you should use the `col-sm-N` family of classes. such that it applies for all devices except phones.

use `col-xs-offset-*` classes to offset the columns.

use `col-xs-pull-*` classes to pull column to left, and `push` to push to right.


bootstrap 默认已经采用了 border-box 模式。如果需要使用 content-box 需要自己指定。
