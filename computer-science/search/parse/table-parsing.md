# 表格抽取研究

<!--
ID: 7ac3e8d9-18e0-46a2-a3eb-b1737fe5bee1
Status: draft
Date: 2020-07-08T19:45:45
Modified: 2020-07-08T19:45:45
wp_id: 1474
-->

不管是 HTML 网页还是扫描的 PDF，有好多重要的数据都是蕴含在表格中的。如果能够自动解析表格那么可以得到好多有用的数据集。

表格的解析分为三类，按难易程度分别为：

1. html 的表格解析
2. 文字 PDF 的表格解析
3. 图片以及扫描 PDF 中的表格解析

## html 中的表格解析

这一部分又分为两种：

1. 直接是 table 标签的表格。这种直接使用 pd.read_html 函数就可以了。
2. 不是 table 标签，而是使用 ul/li/div 等组成的。需要使用一定方法转换成 table，然后再使用 pd.read_html 解析。

https://stackoverflow.com/questions/22937650/pandas-reading-excel-with-merged-cells

## PDF 预处理工具

pdfminer。最常用的抽取 PDF 文字的工具
slate: https://github.com/timClicks/slate PDFMiner 的一个工具
pypdf2 用于合并 pdf 文件的 Python 工具
pikepdf：用于读取合并 PDF
pdfquery：用于查询读写 PDF

用于创建三明治 PDF 的库：

1. https://github.com/jbarlow83/OCRmyPDF
2. http://www.tobias-elze.de/pdfsandwich/
3. https://github.com/virantha/pypdfocr
4. https://github.com/LeoFCardoso/pdf2pdfocr

## 文字 PDF 的表格解析

首先尝试现有的包。

pdfplumber，基于 pdfminer，暂时先不看了

tabula-py，需要 JAVA。
文档：https://nbviewer.jupyter.org/github/chezou/tabula-py/blob/master/examples/tabula_example.ipynb

camelot，号称比其他的库都要好。 https://github.com/camelot-dev/camelot


## 图片型 PDF 的表格解析

首先需要生成三明治PDF，也就是在扫描的图片的上面叠加上OCR识别出来的文本信息。

自动抽取表格的一个例子：
源码：https://github.com/brian-yang/table-parser-opencv/blob/master/main.py
解释：https://answers.opencv.org/question/63847/how-to-extract-tables-from-an-image/

另一个针对手写表格的例子

https://github.com/KananVyas/BoxDetection

处理带有边界的表格的例子:

https://stackoverflow.com/questions/27969091/processing-an-image-of-a-table-to-get-data-from-it

又一个例子：

https://stackoverflow.com/questions/50829874/how-to-find-table-like-structure-in-image

第三方库

pdftabextract: https://datascience.blog.wzb.eu/2017/02/16/data-mining-ocr-pdfs-using-pdftabextract-to-liberate-tabular-data-from-scanned-documents/

### 使用 OpenCV 抽取




Here is the list of some Python Libraries could be used to handle PDF files

1. PDFMiner is a tool for extracting information from PDF documents. Unlike other PDF-related tools, it focuses entirely on getting and analyzing text data.
2. PyPDF2 is a pure-python PDF library capable of splitting, merging together, cropping, and transforming the pages of PDF files. It can also add custom data, viewing options, and passwords to PDF files. It can retrieve text and metadata from PDFs as well as merge entire files together.
3. Tabula-py is a simple Python wrapper of tabula-java, which can read the table of PDF. You can read tables from PDF and convert into pandas’ DataFrame. tabula-py also enables you to convert a PDF file into CSV/TSV/JSON file.
4. Slate is wrapper Implementation of PDFMiner
5. PDFQuery is a light wrapper around pdfminer, lxml and pyquery. It’s designed to reliably extract data from sets of PDFs with as little code as possible.
6. xpdf Python wrapper for xpdf (currently just the “pdftotext” utility)


https://edinburghhacklab.com/2013/09/probabalistic-scraping-of-plain-text-tables/