# 如何识别验证码


wp_id: 451
Status: draft
Date: 2017-05-29 14:47:00
Modified: 2020-05-16 12:09:15


YN：对于验证码，还是直接找打码平台比较方便。

验证码识别大概有两种思路：

1. 人工识别，找打码平台
2. 机器识别
    1. OCR
    2. 深度学习

现在验证码识别的思路基本上是基于OCR的，也就是分三步走

1. 图片增强
2. 切图
3. 训练OCR对单个图片的特征（可选）
4. 识别单个图片为单个文字

存在的问题，切图是很难的一步，验证码已经添加了针对手段来增加难度

另一种思路就是不切图，利用神经网络来识别

使用 torch 的一个例子：

https://deepmlblog.wordpress.com/2016/01/03/how-to-break-a-captcha-system/

Reference

1. http://blog.csdn.net/monkeyduck/article/details/46932663
2. http://blog.tidyzq.com/shi-yong-opencvhe-tesseractshi-bie-zhong-da-jiao-wu-xi-tong-yan-zheng-ma/
3. http://xiaoxia.org/2011/05/31/boring-entry-the-fabled-verification-code-recognition-technology-learning-notes/