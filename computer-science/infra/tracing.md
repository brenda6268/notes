# Tracing


wp_id: 588
Status: draft
Date: 2018-06-22 04:37:00
Modified: 2020-05-16 11:09:09


Yifei's Notes

线程的每次执行，都视为一个trace, 因此在每次执行开始时，都start_span以创建一个
root span(也相应创建了一个新的trace). 每个span内部执行的多个操作，也建模为多个
子span(使用start_child_span创建)

https://wu-sheng.gitbooks.io/opentracing-io/content/
