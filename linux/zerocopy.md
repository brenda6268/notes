在 Linux 中，通过使用 zendfile 实现零拷贝，从而提高 IO 性能。对比一下三种手段

## 使用 read/write 系统调用

这里至少会发生4次复制操作

1. 调用 read 系统调用，文件从硬盘拷到内存里，这里使用了 DMA（Direct Memory Access）
2. 系统把文件内容从内核复制到用户空间
3. 调用 write 系统调用，文件从用户空间复制到内核 socket buffer
4. 从 socket buffer 复制到驱动程序的空间中。

在这个过程中除了复制以外，系统调用也过多，在内核与用户空间之间切换也是有成本的。

## 使用 mmap 系统调用

使用 mmap 可以避免使用 read，从而避免了拷贝到用户空间。但是依然要三次复制：硬盘 -> 内核 -> socket -> driver

## 使用 sendfile 系统调用

1. 文件从硬盘中通过 DMA 直接复制到内核中，并且被关联到 socket buffer
2. 直接从内核中复制到驱动程序

实际上文件发生了两次复制，这里说的「零拷贝」指的是在内核中没有发生复制。硬件之间的复制是没法避免的。

## 参考资料

1. https://www.cnblogs.com/zlcxbb/p/6411568.html