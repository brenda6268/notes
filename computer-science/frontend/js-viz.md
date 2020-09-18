# JavaScript 可视化库调研

<!--
ID: a07f5c2c-ae0c-4818-bdd3-7479d498fa0f
Status: publish
Date: 2020-05-28T14:09:32
Modified: 2020-05-28T14:09:32
wp_id: 1152
-->

核心关注指标：

0. 好看吗？
1. 支持多少数据，性能如何，内存占用如何？
2. 开发活跃度
3. 能否交互
4. 是否支持 react
5. 渲染后端是什么，基于 SVG 还是 canvas 还是 HTML？
6. License，GPL 的不能要
7. 支持绘制图形的种类

## 综合

1. [Vega](https://github.com/vega/vega) Vega 很全面，几乎包括了所有的图形样式。
2. [nivo](https://nivo.rocks/bar/canvas/) 基于 react 和 d3。支持的图形不少。
3. [echarts](https://github.com/apache/incubator-echarts) 百度出品，国内用的比较多，但是感觉有点丑。据说 bug 也比较多。

## 统计常用图

绝大多数的图还是画折线图这些的，大部分的库也是做这个的。

1. [recharts](http://recharts.org/en-US/) 基于 React 和 D3.js。使用 SVG，只支持 line chart，bar chart 这些比较常见的。
2. [reactviz](https://uber.github.io/react-vis/documentation/) 基于 react，Uber 出品，也是常见的统计图
3. [chartist](http://gionkunz.github.io/chartist-js/) 亮点是有动画，没有依赖，体积特别小。支持的图比较少
4. [nvd3](http://nvd3-community.github.io/nvd3/examples/site.html) 这个看起来确实不错，支持的图表类型一般，基于 d3.js。
5. [chart.js](https://github.com/chartjs/Chart.js) 支持的数量也比较少，主要是 line chart 和 bar chart. 这个可能是标星最多的了。
6. [xkcd 风格的图表](https://github.com/timqian/chart.xkcd)

以下为不推荐的库：

1. apexchart 似乎是 fusion chart 的一个开源版本。https://github.com/apexcharts/apexcharts.js
2. uvcharts.js 开发很不活跃，才 200 个星星
3. victory 没看出有什么特别吸引人的。
4. chartbuilder https://github.com/Quartz/Chartbuilder。好几年没有更新了。而且比较丑。
5. c3.js https://c3js.org/examples.html。基于 D3, 貌似图比较少。
6. toast https://ui.toast.com/。韩国的一个东西，还包含了日历。

## 图（Graph）

这里的图指的是计算机科学上的图，也就是由节点和边构成的结构。

1. sigma 用于绘制 graph 的 http://sigmajs.org/
2. cytoscape https://js.cytoscape.org/

## 金融

1. [Lightweight Charts](https://www.tradingview.com/lightweight-charts/)。比较小巧，适合绘制金融数据。
2. http://dygraphs.com/gallery/。这个貌似只是画线条图的
3. [uplot](https://github.com/leeoniya/uPlot)。特点是非常小，不支持任何交互。主要是画时间序列的。
10. [dc.js](https://github.com/dc-js/dc.js)。特点是支持 crossfilter。特别好看，不过支持的图不多。

## 其他

1. plotly, plotly 是一个 Python 和 JavaScript 的绘图库。
2. https://github.com/antvis/g2plot
3. https://github.com/antvis/G2
