# 构建最小版本的 Chrome


wp_id: 70
Status: publish
Date: 2019-06-15 15:04:01
Modified: 2020-05-16 10:59:54


<!-- wp:heading {"level":1} -->
<h1 id="构建最小版本的_chromium">构建最小版本的 Chromium</h1>
<!-- /wp:heading -->

<!-- wp:heading -->
<h2 id="为什么需要_chrome_浏览器渲染">为什么需要 Chrome 浏览器渲染</h2>
<!-- /wp:heading -->

<!-- wp:list {"ordered":true} -->
<ol><li> 动态 ajax 页面
</li><li> 页面编码异常或者结构过甚，lxml 无法解析
</li></ol>
<!-- /wp:list -->

<!-- wp:paragraph -->
<p>
dirty page examples:
</p>
<!-- /wp:paragraph -->

<!-- wp:list {"ordered":true} -->
<ol><li> 页面的 style 在 html 外面，并且有黏贴的 Word 文档。<a href="http://gzg2b.gzfinance.gov.cn/gzgpimp/portalsys/portal.do?method=pubinfoView&amp;&amp;info_id=-2316ce5816ab90783eb-720f&amp;&amp;porid=gsgg&amp;t_k=null" target="_blank" rel="noreferrer noopener">http://gzg2b.gzfinance.gov.cn/gzgpimp/portalsys/portal.do?method=pubinfoView&amp;&amp;info_id=-2316ce5816ab90783eb-720f&amp;&amp;porid=gsgg&amp;t_k=null</a>
</li><li> 有好多个 html 标签，并且编码不一致。<a href="http://www.be-bidding.com/gjdq/jingneng/show_zbdetail.jsp?projectcode=1180903010&amp;flag=3&amp;moreinfo=true" target="_blank" rel="noreferrer noopener">http://www.be-bidding.com/gjdq/jingneng/show_zbdetail.jsp?projectcode=1180903010&amp;flag=3&amp;moreinfo=true</a>
</li></ol>
<!-- /wp:list -->

<!-- wp:heading -->
<h2 id="优化方案">优化方案</h2>
<!-- /wp:heading -->

<!-- wp:list {"ordered":true} -->
<ol><li> 不加载图片和视频，但是保留占位
</li><li> 使用 proxy api 更改代理
</li><li> 禁用 H5 相关 <abbr title="">API</abbr>
</li><li> 删除 ICU 相关
</li></ol>
<!-- /wp:list -->

<!-- wp:heading -->
<h2 id="参考文献">参考文献</h2>
<!-- /wp:heading -->

<!-- wp:list {"ordered":true} -->
<ol><li> <a href="https://peter.sh/experiments/chromium-command-line-switches/" target="_blank" rel="noreferrer noopener">https://peter.sh/experiments/chromium-command-line-switches/</a>
</li><li> <a href="https://joydig.com/port-chromium-to-embedded-linux/" target="_blank" rel="noreferrer noopener">https://joydig.com/port-chromium-to-embedded-linux/</a>
</li><li> Android 上的 Chrome 裁剪，值得借鉴。<a href="https://blog.csdn.net/mogoweb/article/details/76653627" target="_blank" rel="noreferrer noopener">https://blog.csdn.net/mogoweb/article/details/76653627</a>
</li><li> 架构图 <a href="https://blog.csdn.net/mogoweb/article/details/76653627" target="_blank" rel="noreferrer noopener">https://blog.csdn.net/mogoweb/article/details/76653627</a>
</li><li> webkit 架构图 <a href="https://blog.csdn.net/a957666743/article/details/79702895" target="_blank" rel="noreferrer noopener">https://blog.csdn.net/a957666743/article/details/79702895</a>
</li><li> Chrome proxy <abbr title="">API</abbr> <a href="https://developer.chrome.com/extensions/proxy" target="_blank" rel="noreferrer noopener">https://developer.chrome.com/extensions/proxy</a>
</li><li> Chrome 嵌入式裁剪，直击底层 <a href="https://joydig.com/category/chromium/" target="_blank" rel="noreferrer noopener">https://joydig.com/category/chromium/</a>
</li><li> 官方构建教程 <a href="https://chromium.googlesource.com/chromium/src/+/master/docs/linux_build_instructions.md" target="_blank" rel="noreferrer noopener">https://chromium.googlesource.com/chromium/src/+/master/docs/linux_build_instructions.md</a>
</li><li> 编译选项<a href="https://blog.csdn.net/wanwuguicang/article/details/79751503" target="_blank" rel="noreferrer noopener">https://blog.csdn.net/wanwuguicang/article/details/79751503</a>
</li></ol>
<!-- /wp:list -->