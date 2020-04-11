# 关机了 cron job 怎么办，开机后还会再执行吗？

在回答标题的问题之前，我们先来看下 Cron 的实现。

Cron 是 *nix 系统中常见的有一个 daemon，用于定时执行任务。cron 的实现非常简单，以最常用的 vixie cron 为例，大概分为三步：

1. 每分钟读取 crontab 配置
2. 计算需要执行的任务
3. 执行任务，主进程执行或者开启一个 worker 进程执行

Cron 的实现每次都是重新加载 crontab，哪怕计算出来下次可执行时间是 30 分钟之后，也不会说 sleep(30)，这样做是为了能够在每次 crontab 变更的时候及时更新。

我们可以查看 vixie cron 的源码确认一下：

```c
/* first-time loading of tasks */
load_database(&database);
/* run tasks set to be carried out after the system rebooted */
run_reboot_jobs(&database);
/* make TargetTime the start of the next minute */
cron_sync();
while (true) {
    /* carry out tasks, then go to sleep until the TargetTime adjusted to take into account the time spent on the tasks */
    cron_sleep(); // 在这里调用了 do_command，也就是实际执行任务
    /* reread configuration */
    load_database(&database);
    /* collect tasks for given minute */
    cron_tick(&database);
/* reset TargetTime to the start of the next minute */
    TargetTime += 60;
}
```

do_command 函数在 fork 之后子进程中实际执行需要执行的任务，实际上在 worker 中还会进行一次 fork，以便 setuid 变成 session leader，这里就不再赘述了：

```c
switch (fork()) {
case -1:
    /*could not execute fork */
    break;
case 0:
    /* child process: just in case let’s try to acquire the main lock again */
    acquire_daemonlock(1);
    /* move on to deriving the job process */
    child_process(e, u);
    /* once it has completed, the child process shuts down */
    _exit(OK_EXIT);
    break;
default:
    /* parent process continues working */
    break;
}
```

cron 是没有运行记录的，并且每次都会重新加载 crontab，所以总体来说 cron 是一个无状态的服务。

在大多数情况下，这种简单的机制是非常高效且稳健的，但是考虑到一些复杂的场景也会有一些问题，包括本文标题中的问题：

1. 如果某个任务在下次触发的时候，上次运行还没有结束怎么办？

    这个问题其实也就是也就是并发的任务是多少。如果定义并发为 1，也就是同一个任务只能执行一个实例，那么当任务运行时间超过间隔的时候，可能会造成延迟，但是好处是不会超过系统负载。如果定义并发为 n，那么可能会有多个实例同时运行，也有可能会超过系统负载。总之，这个行为是未定义的，完全看 cron 的实现是怎么来的。

2. 当系统关机的时候有任务需要触发，开机后 cron 还会补充执行么？

    比如说，有个任务是「每天凌晨 3 点清理系统垃圾」，如果三点的时候恰好停电了，那么当系统重启之后还会执行这个任务吗？遗憾的是，因为 cron 是不记录任务执行的记录的，所以这个功能更不可实现了。要实现这个功能就需要记录上次任务执行时间，要有 job id，也就是要有执行日志。

3. 如果错过了好多次执行，那么补充执行的时候需要执行多少次呢？

    这个问题是上一个问题的一个衍生。还是举清理垃圾的例子，比如说系统停机五天，那么开机后实际上不用触发五次，只需要清理一次就可以了。

Unix 上传统的 cron daemon 没有考虑以上三个问题，也就是说错过就错过了，不会再执行。为了解决这个问题，又一个辅助工具被开发出来了——anacron, ana 是 anachronistic（时间错误） 的缩写。anacron 通过文件的时间戳来追踪任务的上次运行时间。具体的细节就不展开了，可以参考文章后面的参考文献。

总之，如果只有 cron，那么不会执行错过的任务，但是配合上 anacron，还是有机会执行错过的任务的。

定时执行任务是一个普遍存在的需求，除了在系统层面以外，多种不同的软件中都实现了，我们可以认为他们是广义的 cron。这些广义的 cron 大多考虑了这些问题，下面以 apscheduler 和 kubernetes 为例说明一下。

## apscheduler

apscheduler 是 Python 的一个库，用于周期性地触发单个任务调度，实际上我们完全可以用 apscheduler 来实现一个自己的 cron。

apscheduler 中的几个概念：

- triggers，触发的计算引擎，apscheduler 除了支持 cron 之外，还支持 date 和 interval 两种；
- job store，用于记录每次的运行结果，上次运行时间等，这样当有错过的任务时才能知道需要补充执行多少次。默认是记在内存里，不过也支持 redis, mongo, mysql;
- executor，执行任务的 worker，常用的有 ThreadPoolExecutor 和 ProcessPoolExecutor, 也就是线城池和进程池；
- scheduler, 把以上几个概念串联起来做调度。

apscheduler 的使用也非常简单，直接看函数名大概就知道了。
```py
from apscheduler.schedulers.background import BackgroundScheduler

scheduler = BackgroundScheduler()
# scheduler.add_executor('processpool')  # 使用进程池，默认是线程池
# scheduler.add_job_store("redis")  # 使用 redis 作为 job store, 默认是内存

scheduler.add_job(
    myfunc,  # 要执行的函数
    trigger='cron',  # 触发机制
    id='my_job_id',  # job_id
    args=[],   # 执行函数的参数
    kwargs={},  # 执行函数的字典参数
    )
scheduler.remove_job('my_job_id')
scheduler.pause_job('my_job_id')
scheduler.resume_job('my_job_id')
scheduler.reschedule_job("my_job_id")  # 感觉叫 modify_job 更好一点。所有属性都可以改，除了 ID

scheduler.start()
scheduler.pause()
scheduler.resume()
scheduler.shutdown()
```

### apscheduler 如何处理上面的三个问题

1. 可以通过 `max_instances` 参数设置最大执行的实例个数；
2. 可以通过 `misfire_grace_time` 参数设置错过的任务的捞回时间，也就是在如果错过的时间不超过该值，就补充触发一次；
3. 可以通过 `coalesce` 参数设置当需要执行多次的时候是否合并为执行一次。

另外需要注意的一点是，apscheduler 并没有像传统的 vixie cron 一样每分钟都会唤醒一次，而是会休眠到最近的可执行任务需要触发的时候。同时为了能在休眠期间增加任务，每次调用 add_job 的时候会直接唤醒 scheduler。

在计算下次可运行时间的时候，apscheduler 会维护一个按照下次触发时间排序的队列，插入新任务会采用二分查找位置插入（不过我感觉用堆好一点啊……）。当使用其他的外部 job store 的时候则会利用这些数据库的不同机制，比如 redis 中就会使用 zset。

apscheduler 还支持添加 event listener 获取 job 的运行信息：

```py
def my_listener(event):
    if event.exception:
        print('The job crashed :(')
    else:
        print('The job worked :)')

scheduler.add_listener(my_listener, EVENT_JOB_EXECUTED | EVENT_JOB_ERROR)
```

## K8S 中的 cron job

在 kubernetes 中，除了 deployment 以外，我们也可以构建一次性或者定时运行的 job。定时任务也是按照 crontab 的格式来定义的。

```yaml
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: hello
spec:
  schedule: "*/1 * * * *"  # cron format
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: hello
            image: busybox
            args:
            - /bin/sh
            - -c
            - date; echo Hello from the Kubernetes cluster
          restartPolicy: OnFailure
```

在 K8S 中，我们可以通过 `.spec.concurrencyPolicy` 来控制最多有多少个实例运行。K8S 建议每个 cron job 最好是幂等的，以免并发执行造成不可预料的结果。可选参数为：

- Allow(default)，允许
- Forbid, 不允许
- Replace，干掉原来的，执行新的

当任务执行失败的时候，K8S 的行为非常令人迷惑，如果 `.spec.startingDeadlineSeconds` 没有设置的话，那么任务重试 100 次失败之后就彻底放弃了……WTF……关于这个具体实现不再赘述，可以参考后面的链接 9.

在现代的分布式系统中，除了定时任务之外，更重要的是不同的任务之间的执行次序和依赖关系，在后面的文章中，会介绍一下 airflow, luigi, argo 等工具的使用和实现。敬请期待。

PS. K8S 官方文档写得真是太烂了，典型的 over engineering。

## 参考资料

1. https://serverfault.com/questions/52335/job-scheduling-using-crontab-what-will-happen-when-computer-is-shutdown-during
2. https://apscheduler.readthedocs.io/en/latest/userguide.html
3. https://badootech.badoo.com/cron-in-linux-history-use-and-structure-70d938569b40
4. https://askubuntu.com/questions/848610/confused-about-relationship-between-cron-and-anacron
5. https://www.digitalocean.com/community/tutorials/how-to-schedule-routine-tasks-with-cron-and-anacron-on-a-vps
6. http://xiaorui.cc/archives/4228
7. https://kubernetes.io/docs/tasks/job/automated-tasks-with-cron-jobs/
8. https://medium.com/@hengfeng/what-does-kubernetes-cronjobs-startingdeadlineseconds-exactly-mean-cc2117f9795f
9. https://stackoverflow.com/questions/51065538/what-does-kubernetes-cronjobs-startingdeadlineseconds-exactly-mean