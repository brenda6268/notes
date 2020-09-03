# 命令行压缩图片的工具

<!--
ID: 66709eeb-d988-4313-baf0-c820273020eb
Status: publish
Date: 2017-05-30T01:42:00
Modified: 2020-05-16T12:10:43
wp_id: 429
-->

加载速度对于网页的体验还是很重要的，而每个页面比较耗费带宽的资源就是图片了，所以在页面发布后对图像做适当的压缩是很有必要的。

常用的图片格式基本有三种：jpg, png 和 gif, 分别有不同的压缩工具

JPG 压缩建议使用 jpegoptim, 实测压缩比在 40% 左右，最常用的语法是

`jpegoptim -p -m<dd>  <imagefile>`

其中 -p 是保留 mtime 的意思，也可以用 --perserve, -m 后面跟两个数字表示，压缩的比例，一般用 90 即可，肉眼无法分辨，且能够压缩掉 40% 左右

png 压缩有两个选项，常规的 optipng 和另一个新一点 pngquant, 测试了一下，发现 optipng 速度慢而且压缩效率低，pngquant 则表现相当优秀，但是需要注意 pngquant 是有损压缩。

pngquant 的用法也简单粗暴，直接 pngquant <filename> 就好了，如果嫌压缩不够可以使用 pngquant <numColors> <filename>. 指定一个较少的色彩数。

gif 图像的压缩可以使用 gifsicle

`gifsicle -O2 old.gif -o new.gif`

另外需要注意的是，jpegoptim 默认覆盖原图像，pngquant 会生成新的图像，gifsicle 需要制定新图像的名字。

如果需要对一个目录下的所有文件都进行优化，可以配合 find 命令使用，比如

```
find . -name "*.jpg" -exec jpegoptim {} -m90 -p
find . -name "*.png" -exec pngquant {}
```

通过以上命令就可以把降低一些图片的体积
