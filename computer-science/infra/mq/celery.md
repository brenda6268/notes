Date: 2018-12-10

celery 中的队列
 
清空一个队列 celery -A proj purge

批量入队，使用 task.chunks

批量消费，使用 celery_batches

celery 的每一个 task 应该是幂等的

celery 不知道每一个函数是不是幂等的，所以默认情况下是直接 ack 了。可以使用 acks_late 来在任务完成之后再 ack。

celery 需要手工 retry：


当执行的worker进程被杀掉之后，celery 会直接 ack 掉任务，哪怕是设置了 acks_late，因为：
	1. 发生错误的进程可能会一直 hang 在那里
	2. 如果管理员主动关闭了，那么可能就是想删掉这个任务
可以使用task_reject_on_worker_lost 来禁用

可以读取和设置当前任务的 task_id
	- self.request.id
	- task.apply_async(args, kwargs, task_id='…')

可以使用 task_default_rate_limit 来设置频控

可以使用 task_annotations 来覆盖某个任务的属性

可以使用task_remote_tracebacks来获取任务执行的错误

序列化的问题


任务抛出异常之后为什么没有一直重试呢？

使用 Ofair，尤其是对于 IO 的应用

默认重试次数才是 3， 应该增加一些，并且增加重试的打点

使用 soft_time_limit 来

https://kombu.readthedocs.io/en/master/userguide/serialization.html#sending-raw-data-without-serialization
https://celery.readthedocs.io/en/latest/userguide/workers.html#max-tasks-per-child-setting
https://stackoverflow.com/questions/21365101/celery-worker-and-command-line-args
https://stackoverflow.com/questions/27423596/celery-transfer-command-line-arguments-to-task
http://docs.celeryproject.org/en/latest/userguide/extending.html#command-line-programs



