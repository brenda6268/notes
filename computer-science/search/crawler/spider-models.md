# 废弃：Spider Models

<!--
ID: 518db613-2151-4f52-9f3b-1f50e8a33219
Status: draft
Date: 2017-05-30T04:13:00
Modified: 2020-05-16T11:59:42
wp_id: 459
-->

Basically, I think there are two kind of crawling, one is for search engine, there purpose is to archive the web, the other is for harvesting structured data from the web

Here we try to solve the problem: given one page/url and the sample data we want, how to crawl all of them.

our basic assumption is that each page with structured data is presented in some kind of a table. for crawling data from the web, this pattern applies for 90% of the web pages we are interested in:

* first, there is a hub page of a list of links to data pages, we call it *hub page*
* or we could get *a list of urls* of the data pages
* second, normally, we use xpath to locate the *data cells* we want on the data page, but there might be a list of data cells on each data page, we want to be able to crawl a list of them by a single xpath expression
* so, we mark some of the data cells of *one item*, and we calculate the *lca* of these data cells, we try to get the *class-based xpath expression* of the item, so we can select all the items by this xpath.
* then, we calculate the *relative path* between the item element and data cell element
* if we only have one item on each page(e.g. a blog post page), that would also be fine, because the item would be the document itself

to sum it up, 
hub page/list of urls -> data page -> mark cells -> calculate item xpath -> regenerate cell relative xpath -> crawl

one more thing, the whole process could be recursive, and our data page might be a hub page to more detailed data pages

PS:

* On one single page, there might be different sections, in each section, there might be different data, e.g. on a blog post page, there are post and a list of comments.
* There is also the problem of finding next page if the hub page or the data page is paginated, we have to find the next page by a regular expression
* The other problem is that the data might be in the js or ajax call, the data could be metadata or shown only when user acted in a specific way:
    a. We can use phantomjs or something to convert it back to normal page, might need record user behavior
    b. We use regular expression to yank out the data