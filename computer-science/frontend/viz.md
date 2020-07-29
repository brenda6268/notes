# JavaScript 可视化库调研

<!--
ID: a07f5c2c-ae0c-4818-bdd3-7479d498fa0f
Status: draft
Date: 2020-05-28T14:09:32
Modified: 2020-05-28T14:09:32
wp_id: 1152
-->

1. 支持多少数据，性能如何，内存占用如何？
2. 开发活跃度
3. 能否交互
4. 是否支持 react
5. 渲染后端是什么，基于 SVG 还是 canvas 还是 HTML？
6. License，GPL 的不能要
7. 支持绘制图形的种类

# 综合

https://github.com/vega/vega

## recharts

基于 React 和 D3.js。使用 SVG。好像只支持 line chart？

https://github.com/recharts/recharts

## reactviz

基于 react，Uber 出品

https://uber.github.io/react-vis/documentation/getting-started/react-vis-in-codepen

## chartist

亮点是有动画

http://gionkunz.github.io/chartist-js/

nivo

基于 react 和 d3。支持的图形不少。

## nvd3

这个看起来确实不错，支持的图标比较丰富，基于 d3.js。http://nvd3-community.github.io/nvd3/examples/site.html

## chart.js

https://github.com/chartjs/Chart.js。支持的数量也比较少，主要是 line chart 和 bar chart.

## uvcharts.js

开发很不活跃，才200个星星

## victory

没看出有什么特别吸引人的。。

## apexchart

似乎是 fusion chart 的一个开源版本。https://github.com/apexcharts/apexcharts.js

## dc.js

https://github.com/dc-js/dc.js。特点是支持 crossfilter。特别好看，不过支持的图标不多。


## xkcd 风格的图标
https://github.com/timqian/chart.xkcd

## chartbuilder

https://github.com/Quartz/Chartbuilder。好几年没有更新了。而且比较丑。

# uplot

https://github.com/leeoniya/uPlot。特点是非常小，不支持任何交互。主要是画时间序列的。

## echarts

https://github.com/apache/incubator-echarts 百度出品，国内用的比较多，但是感觉有点丑。据说 bug 也比较多。

## c3.js

https://c3js.org/examples.html。基于 D3,貌似图比较少。

# toast

https://ui.toast.com/。韩国的一个东西，还包含了日历。

## 图

### sigma

用于绘制 graph 的

http://sigmajs.org/

### cytoscape

https://js.cytoscape.org/

# 金融

https://www.tradingview.com/lightweight-charts/。比较小巧，适合绘制金融数据。

http://dygraphs.com/gallery/。这个貌似只是画线条图的

# 其他

## plotly

plotly 是一个 Python 和 JavaScript 的绘图库。


https://github.com/antvis/g2plot

https://github.com/antvis/G2